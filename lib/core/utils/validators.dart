class Validators {
  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validate required field
  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(
    String? value,
    int min, [
    String fieldName = 'Field',
  ]) {
    if (value == null || value.isEmpty) {
      return '$fieldName wajib diisi';
    }
    if (value.length < min) {
      return '$fieldName minimal $min karakter';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(
    String? value,
    int max, [
    String fieldName = 'Field',
  ]) {
    if (value != null && value.length > max) {
      return '$fieldName maksimal $max karakter';
    }
    return null;
  }

  /// Validate phone number (Indonesian format)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  /// Validate number
  static String? number(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName wajib diisi';
    }
    if (double.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }
    return null;
  }

  /// Validate number range
  static String? numberRange(
    String? value,
    double min,
    double max, [
    String fieldName = 'Field',
  ]) {
    if (value == null || value.isEmpty) {
      return '$fieldName wajib diisi';
    }
    final num = double.tryParse(value);
    if (num == null) {
      return '$fieldName harus berupa angka';
    }
    if (num < min || num > max) {
      return '$fieldName harus antara $min dan $max';
    }
    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  /// Validate password confirmation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }

  /// Validate IP address
  static String? ipAddress(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    if (!ipRegex.hasMatch(value)) {
      return 'Format IP address tidak valid';
    }
    return null;
  }

  /// Validate coordinates (latitude/longitude)
  static String? coordinate(String? value, String type) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final num = double.tryParse(value);
    if (num == null) {
      return '$type harus berupa angka';
    }
    if (type == 'Latitude' && (num < -90 || num > 90)) {
      return 'Latitude harus antara -90 dan 90';
    }
    if (type == 'Longitude' && (num < -180 || num > 180)) {
      return 'Longitude harus antara -180 dan 180';
    }
    return null;
  }
}
