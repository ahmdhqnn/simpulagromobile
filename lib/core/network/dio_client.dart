import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/secure_storage.dart';

/// Callback dipanggil saat token expired (401) — untuk trigger logout
typedef OnUnauthorized = void Function();

class DioClient {
  final Dio _dio;
  final SecureStorage _storage;
  OnUnauthorized? onUnauthorized;

  DioClient(this._storage)
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
      _AuthInterceptor(_storage, _handleUnauthorized),
      _RetryInterceptor(_dio),
      // Log hanya di debug mode
      if (kDebugMode)
        LogInterceptor(
          requestBody: false, // jangan log body — bisa berisi password
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
          logPrint: (obj) {
            final msg = obj.toString();
            // Filter hanya URL dan status code
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

  void _handleUnauthorized() {
    onUnauthorized?.call();
  }
}

/// Interceptor untuk inject JWT token ke setiap request
class _AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  final VoidCallback _onUnauthorized;

  _AuthInterceptor(this._storage, this._onUnauthorized);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      debugPrint('🔒 Session expired — triggering logout');
      _onUnauthorized();
    }
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
        '🔄 Retrying request (${_retryCount}/${ApiConfig.maxRetries}): '
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
    switch (err.type) {
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        // Retry untuk 5xx server errors, tapi bukan 4xx client errors
        return statusCode >= 500;
      default:
        return false;
    }
  }
}
