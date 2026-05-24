import 'package:dio/dio.dart';
import 'failures.dart';

/// Standardized mapper for converting DioException to Failure objects
/// Ensures consistent error handling across all datasources
class ExceptionMapper {
  /// Maps DioException to appropriate Failure type
  ///
  /// Handles:
  /// - Network errors (connection, timeout, etc.)
  /// - Server errors (4xx, 5xx status codes)
  /// - Validation errors
  /// - Unknown errors
  static Failure mapDioExceptionToFailure(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError => NetworkFailure(
        _getErrorMessage(exception) ??
            'Koneksi jaringan gagal. Periksa koneksi internet Anda.',
      ),

      DioExceptionType.badResponse => _mapBadResponseToFailure(exception),

      DioExceptionType.cancel => UnknownFailure(
        'Permintaan dibatalkan oleh pengguna',
      ),

      DioExceptionType.badCertificate => NetworkFailure(
        'Sertifikat keamanan tidak valid',
      ),

      DioExceptionType.unknown => UnknownFailure(
        _getErrorMessage(exception) ?? 'Terjadi kesalahan yang tidak diketahui',
      ),
    };
  }

  /// Maps HTTP status codes to specific Failure types
  static Failure _mapBadResponseToFailure(DioException exception) {
    final statusCode = exception.response?.statusCode ?? 0;
    final message =
        _extractErrorMessage(exception) ?? _getDefaultErrorMessage(statusCode);

    return switch (statusCode) {
      400 => ValidationFailure(message),
      401 => AuthFailure(message),
      403 => PermissionFailure(message),
      404 => NotFoundFailure(message),
      409 => ValidationFailure(message),
      500 ||
      502 ||
      503 ||
      504 => ServerFailure(message, statusCode: statusCode),
      _ => ServerFailure(message, statusCode: statusCode),
    };
  }

  /// Extracts error message from response body (if available)
  ///
  /// Handles common backend response formats:
  /// - {message: string}
  /// - {error: string}
  /// - {errors: [{message: string}]}
  /// - Plain string response
  static String? _extractErrorMessage(DioException exception) {
    try {
      final response = exception.response;
      if (response == null) return null;

      final data = response.data;

      if (data is Map<String, dynamic>) {
        // Check common message fields
        if (data.containsKey('message')) {
          final msg = data['message'];
          if (msg is String) return msg;
          if (msg is List && msg.isNotEmpty) return msg.join(', ');
        }

        if (data.containsKey('error')) {
          final err = data['error'];
          if (err is String) return err;
          if (err is Map && err.containsKey('message')) {
            final message = err['message'];
            if (message is String) return message;
            if (message is List && message.isNotEmpty) {
              return message.join(', ');
            }
          }
          if (err is List && err.isNotEmpty) return err.join(', ');
        }

        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is List && errors.isNotEmpty) {
            final first = errors.first;
            if (first is Map && first.containsKey('message')) {
              return first['message'];
            }
            if (first is String) return first;
          }
        }

        // Fallback: return stringified data
        return data.toString();
      }

      if (data is String && data.isNotEmpty) {
        return data;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Gets exception message if available
  static String? _getErrorMessage(DioException exception) {
    if (exception.message != null && exception.message!.isNotEmpty) {
      return exception.message;
    }
    if (exception.error != null) {
      return exception.error.toString();
    }
    return null;
  }

  /// Returns default error message for HTTP status code
  static String _getDefaultErrorMessage(int statusCode) {
    return switch (statusCode) {
      400 => 'Data yang dikirim tidak valid. Periksa kembali input Anda.',
      401 => 'Sesi Anda telah berakhir. Silakan login kembali.',
      403 => 'Anda tidak memiliki izin untuk mengakses resource ini.',
      404 => 'Resource yang diminta tidak ditemukan.',
      409 => 'Data yang Anda kirim konflik dengan data yang ada.',
      500 => 'Terjadi kesalahan di server. Silakan coba lagi nanti.',
      502 => 'Layanan tidak tersedia. Silakan coba lagi nanti.',
      503 => 'Server sedang dalam pemeliharaan. Silakan coba lagi nanti.',
      504 => 'Server tidak merespons. Silakan coba lagi nanti.',
      _ => 'Terjadi kesalahan. Silakan coba lagi nanti.',
    };
  }
}

/// Extension method for convenient mapping
extension DioExceptionMapperX on DioException {
  Failure toFailure() => ExceptionMapper.mapDioExceptionToFailure(this);
}
