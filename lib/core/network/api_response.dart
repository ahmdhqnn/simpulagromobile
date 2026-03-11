/// Generic wrapper for API responses following the backend's standard format:
/// { "status": 200, "message": "...", "data": ... }
class ApiResponse<T> {
  final int status;
  final String message;
  final T? data;

  ApiResponse({required this.status, required this.message, this.data});

  bool get isSuccess => status >= 200 && status < 300;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }
}
