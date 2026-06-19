import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../auth/token_manager.dart';
import '../config/api_config.dart';

typedef OnSessionExpired = void Function();

class DioClient {
  final Dio _dio;
  final TokenManager _tokenManager;
  OnSessionExpired? onSessionExpired;

  DioClient(this._tokenManager)
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.connectTimeout,
          receiveTimeout: ApiConfig.receiveTimeout,
          sendTimeout: ApiConfig.sendTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.addAll([
      _AuthInterceptor(_tokenManager, _handleSessionExpired),
      _RequestQueueInterceptor(maxConcurrent: ApiConfig.maxConcurrentRequests),
      _RetryInterceptor(_dio),
      if (kDebugMode)
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
          logPrint: (obj) {
            final msg = obj.toString();
            if (msg.contains('uri') ||
                msg.contains('statusCode') ||
                msg.contains('Error')) {
              debugPrint('HTTP $msg');
            }
          },
        ),
    ]);
  }

  Dio get dio => _dio;

  void _handleSessionExpired() {
    onSessionExpired?.call();
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  final VoidCallback _onSessionExpired;

  _AuthInterceptor(this._tokenManager, this._onSessionExpired);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('refresh') || options.path.contains('login')) {
      handler.next(options);
      return;
    }

    final isExpired = await _tokenManager.isAccessTokenExpired();
    if (isExpired) {
      final refreshed = await _tokenManager.refreshAccessToken();
      if (!refreshed) {
        debugPrint('Proactive token refresh failed; continuing request.');
      }
    }

    final token = await _tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final requestPath = err.requestOptions.path;
    if (requestPath.contains('refresh') || requestPath.contains('login')) {
      handler.next(err);
      return;
    }

    debugPrint('Got 401 on $requestPath; attempting silent refresh.');
    final refreshed = await _tokenManager.refreshAccessToken();

    if (refreshed) {
      try {
        final token = await _tokenManager.getAccessToken();
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';

        final response = await Dio(
          BaseOptions(
            baseUrl: opts.baseUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            sendTimeout: ApiConfig.sendTimeout,
          ),
        ).fetch(opts);

        handler.resolve(response);
        return;
      } catch (retryError) {
        debugPrint('Retry after token refresh failed.');
        if (retryError is DioException) {
          handler.next(retryError);
          return;
        }
      }
    }

    debugPrint('Session expired; triggering logout.');
    _onSessionExpired();
    handler.next(err);
  }
}

class _QueuedRequest {
  final RequestOptions options;
  final RequestInterceptorHandler handler;

  const _QueuedRequest(this.options, this.handler);
}

/// Keeps request bursts bounded for small backend instances.
class _RequestQueueInterceptor extends Interceptor {
  final int maxConcurrent;
  final Queue<_QueuedRequest> _queue = Queue<_QueuedRequest>();
  int _running = 0;

  _RequestQueueInterceptor({required this.maxConcurrent});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (maxConcurrent <= 0 || options.extra['skipRequestQueue'] == true) {
      handler.next(options);
      return;
    }

    final request = _QueuedRequest(options, handler);
    if (_running < maxConcurrent) {
      _start(request);
    } else {
      _queue.addLast(request);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _completeOne();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _completeOne();
    handler.next(err);
  }

  void _start(_QueuedRequest request) {
    _running++;
    request.handler.next(request.options);
  }

  void _completeOne() {
    if (_running > 0) _running--;
    if (_queue.isEmpty || _running >= maxConcurrent) return;

    final next = _queue.removeFirst();
    scheduleMicrotask(() => _start(next));
  }
}

class _RetryInterceptor extends Interceptor {
  static const _retryAttemptKey = 'retryAttempt';

  final Dio _dio;

  _RetryInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount =
        (err.requestOptions.extra[_retryAttemptKey] as int?) ?? 0;

    if (_shouldRetry(err) && retryCount < ApiConfig.maxRetries) {
      final nextRetry = retryCount + 1;
      err.requestOptions.extra[_retryAttemptKey] = nextRetry;
      debugPrint(
        'Retrying request ($nextRetry/${ApiConfig.maxRetries}): '
        '${err.requestOptions.path}',
      );

      await Future.delayed(_retryDelay(err, nextRetry));

      try {
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (retryError) {
        if (retryError is DioException) {
          handler.next(retryError);
          return;
        }
      }
    }

    handler.next(err);
  }

  Duration _retryDelay(DioException err, int attempt) {
    final retryAfter = err.response?.headers.value('retry-after');
    final retryAfterSeconds = retryAfter == null
        ? null
        : int.tryParse(retryAfter.trim());
    if (retryAfterSeconds != null && retryAfterSeconds > 0) {
      return Duration(seconds: retryAfterSeconds.clamp(1, 60));
    }

    final baseMs = ApiConfig.retryDelay.inMilliseconds * attempt;
    final jitterMs = 125 * attempt;
    return Duration(milliseconds: baseMs + jitterMs);
  }

  bool _shouldRetry(DioException err) {
    if (err.response?.statusCode == 401) return false;

    final method = err.requestOptions.method.toUpperCase();
    if (method != 'GET' && method != 'HEAD') return false;

    switch (err.type) {
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return true;
      default:
        break;
    }

    final statusCode = err.response?.statusCode;
    return statusCode == 429 ||
        statusCode == 502 ||
        statusCode == 503 ||
        statusCode == 504;
  }
}
