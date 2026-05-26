import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../auth/token_manager.dart';

/// Service untuk upload gambar ke backend.
/// Mengirim file sebagai multipart/form-data ke endpoint upload.
class ImageUploadService {
  final Dio _dio;

  ImageUploadService(TokenManager tokenManager)
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.connectTimeout,
          receiveTimeout: ApiConfig.receiveTimeout,
          sendTimeout: const Duration(seconds: 60),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenManager.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: true,
          logPrint: (obj) => debugPrint('📤 Upload: $obj'),
        ),
      );
    }
  }

  /// Upload gambar sebagai multipart ke endpoint forum post.
  /// Mengembalikan path file lokal yang akan dikirim bersama form data.
  /// Backend menerima field 'image' sebagai file upload.
  Future<MultipartFile> prepareImageFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File gambar tidak ditemukan: $filePath');
    }

    final fileName = filePath.split('/').last.split('\\').last;
    final mimeType = _getMimeType(fileName);

    return MultipartFile.fromFile(
      filePath,
      filename: fileName,
      contentType: DioMediaType.parse(mimeType),
    );
  }

  String _getMimeType(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }
}
