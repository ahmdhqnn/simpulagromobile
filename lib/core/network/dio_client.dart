import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../auth/token_manager.dart';

/// Callback dipanggil saat session benar-benar expired (refresh gagal)
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
              debugPrint('📡 $msg');
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

/// Interceptor yang menangani:
/// 1. Inject access token ke setiap request
/// 2. Proactive refresh jika token hampir expired
/// 3. Reactive refresh pada 401 response (silent retry)
class _AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  final VoidCallback _onSessionExpired;

  _AuthInterceptor(this._tokenManager, this._onSessionExpired);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for refresh endpoint to avoid loops
    if (options.path.contains('refresh') ||
        options.path.contains('login')) {
      handler.next(options);
      return;
    }

    // Proactive refresh: jika token hampir expired, refresh dulu
    final isExpired = await _tokenManager.isAccessTokenExpired();
    if (isExpired) {
      final refreshed = await _tokenManager.refreshAccessToken();
      if (!refreshed) {
        debugPrint('🔒 Proactive refresh failed — proceeding with old token');
      }
    }

    // Inject current access token
    final token = await _tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 for non-auth endpoints
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final requestPath = err.requestOptions.path;
    if (requestPath.contains('refresh') ||
        requestPath.contains('login')) {
      handler.next(err);
      return;
    }

    debugPrint('🔒 Got 401 on $requestPath — attempting silent refresh');

    // Attempt silent refresh
    final refreshed = await _tokenManager.refreshAccessToken();

    if (refreshed) {
      // Retry the original request with new token
      try {
        final token = await _tokenManager.getAccessToken();
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';

        final response = await Dio(
          BaseOptions(
            baseUrl: opts.baseUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
          ),
        ).fetch(opts);

        handler.resolve(response);
        return;
      } catch (retryError) {
        debugPrint('❌ Retry after refresh failed');
        if (retryError is DioException) {
          handler.next(retryError);
          return;
        }
      }
    }

    // Refresh failed — session is truly expired
    debugPrint('🔒 Session expired — triggering logout');
    _onSessionExpired();
    handler.next(err);
  }
}

/// Interceptor untuk retry otomatis saat timeout atau server error 5xx
class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  int _retryCount = 0;

  _RetryInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);

    if (shouldRetry && _retryCount < ApiConfig.maxRetries) {
      _retryCount++;
      debugPrint(
        '🔄 Retrying request ($_retryCount/${ApiConfig.maxRetries}): '
        '${err.requestOptions.path}',
      );

      await Future.delayed(
        Duration(seconds: ApiConfig.retryDelay.inSeconds * _retryCount),
      );

      try {
        final response = await _dio.fetch(err.requestOptions);
        _retryCount = 0;
        handler.resolve(response);
        return;
      } catch (e) {
        // Retry gagal, lanjut ke error handler
      }
    }

    _retryCount = 0;
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Don't retry if it was already handled by auth interceptor
    if (err.response?.statusCode == 401) return false;

    switch (err.type) {
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        return statusCode >= 500;
      default:
        return false;
    }
  }
}
