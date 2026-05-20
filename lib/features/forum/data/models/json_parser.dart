/// Helper untuk parsing JSON yang robust terhadap berbagai format response API.
/// Mencegah error type casting saat field memiliki tipe data yang tidak sesuai
/// (misal: int dikirim sebagai String, bool dikirim sebagai "LIKE"/"DISLIKE", dll)
class JsonParser {
  /// Parse value menjadi String dengan fallback ke empty string.
  static String parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  /// Parse value menjadi nullable String.
  static String? parseStringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    final str = value.toString();
    return str.isEmpty ? null : str;
  }

  /// Parse value menjadi int. Handle: int, double, String numeric, null.
  static int parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is bool) return value ? 1 : 0;
    return defaultValue;
  }

  /// Parse value menjadi double. Handle: int, double, String numeric, null.
  static double parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Parse value menjadi bool. Handle:
  /// - bool: true/false
  /// - String: "LIKE", "true", "1", "yes" → true; "DISLIKE", "false", "0", "" → false
  /// - int: 1 → true, 0 → false
  /// - null → false
  static bool parseBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase().trim();
      if (lower.isEmpty) return defaultValue;
      return lower == 'like' ||
          lower == 'true' ||
          lower == '1' ||
          lower == 'yes' ||
          lower == 'y';
    }
    if (value is int) return value == 1;
    return defaultValue;
  }

  /// Parse value menjadi DateTime. Handle: String ISO, DateTime, null.
  static DateTime parseDateTime(dynamic value, {DateTime? defaultValue}) {
    if (value == null) return defaultValue ?? DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? defaultValue ?? DateTime.now();
    }
    if (value is int) {
      // Anggap epoch milliseconds jika besar, atau seconds jika kecil
      try {
        return DateTime.fromMillisecondsSinceEpoch(
          value > 9999999999 ? value : value * 1000,
        );
      } catch (_) {
        return defaultValue ?? DateTime.now();
      }
    }
    return defaultValue ?? DateTime.now();
  }

  /// Parse value menjadi nullable DateTime.
  static DateTime? parseDateTimeOrNull(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Parse `Map<String, dynamic>` dengan fallback ke empty map.
  static Map<String, dynamic> parseMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return {};
  }

  /// Parse nullable `Map<String, dynamic>`.
  static Map<String, dynamic>? parseMapOrNull(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return null;
  }

  /// Coba ambil value dari beberapa kemungkinan key (untuk handle variasi nama field API).
  /// Return value pertama yang non-null.
  static dynamic tryKeys(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key) && json[key] != null) {
        return json[key];
      }
    }
    return null;
  }
}
