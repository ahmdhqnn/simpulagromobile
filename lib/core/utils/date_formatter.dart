import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _apiDateTimeFormat = DateFormat(
    'yyyy-MM-dd HH:mm:ss',
  );

  /// Format date to readable format (e.g., "15 Jan 2026")
  static String formatDate(DateTime? date, {String locale = 'id_ID'}) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy', locale).format(date);
  }

  /// Format datetime to readable format (e.g., "15 Jan 2026 14:30")
  static String formatDateTime(DateTime? dateTime, {String locale = 'id_ID'}) {
    if (dateTime == null) return '-';
    return DateFormat('dd MMM yyyy HH:mm', locale).format(dateTime);
  }

  /// Format time only (e.g., "14:30")
  static String formatTime(DateTime? dateTime, {String locale = 'id_ID'}) {
    if (dateTime == null) return '-';
    return DateFormat('HH:mm', locale).format(dateTime);
  }

  /// Format date for API (e.g., "2026-01-15")
  static String formatApiDate(DateTime date) {
    return _apiDateFormat.format(date);
  }

  /// Format datetime for API (e.g., "2026-01-15 14:30:00")
  static String formatApiDateTime(DateTime dateTime) {
    return _apiDateTimeFormat.format(dateTime);
  }

  /// Parse API date string to DateTime
  static DateTime? parseApiDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return _apiDateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse API datetime string to DateTime
  static DateTime? parseApiDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return null;
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time (e.g., "2 jam yang lalu")
  static String getRelativeTime(DateTime? dateTime, {String locale = 'id'}) {
    if (dateTime == null) return '-';

    final isEnglish = locale.toLowerCase().startsWith('en');
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final count = (difference.inDays / 365).floor();
      return isEnglish ? '$count years ago' : '$count tahun yang lalu';
    } else if (difference.inDays > 30) {
      final count = (difference.inDays / 30).floor();
      return isEnglish ? '$count months ago' : '$count bulan yang lalu';
    } else if (difference.inDays > 0) {
      return isEnglish
          ? '${difference.inDays} days ago'
          : '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return isEnglish
          ? '${difference.inHours} hours ago'
          : '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return isEnglish
          ? '${difference.inMinutes} minutes ago'
          : '${difference.inMinutes} menit yang lalu';
    } else {
      return isEnglish ? 'Just now' : 'Baru saja';
    }
  }

  /// Calculate days since planting (HST - Hari Setelah Tanam)
  static int calculateHST(DateTime? plantDate) {
    if (plantDate == null) return 0;
    final now = DateTime.now();
    return now.difference(plantDate).inDays;
  }
}
