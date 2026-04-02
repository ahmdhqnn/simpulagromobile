import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
  static final DateFormat _dateTimeFormat = DateFormat(
    'dd MMM yyyy HH:mm',
    'id_ID',
  );
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'id_ID');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _apiDateTimeFormat = DateFormat(
    'yyyy-MM-dd HH:mm:ss',
  );

  /// Format date to readable format (e.g., "15 Jan 2026")
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  /// Format datetime to readable format (e.g., "15 Jan 2026 14:30")
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return _dateTimeFormat.format(dateTime);
  }

  /// Format time only (e.g., "14:30")
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return _timeFormat.format(dateTime);
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
  static String getRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return '-';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  /// Calculate days since planting (HST - Hari Setelah Tanam)
  static int calculateHST(DateTime? plantDate) {
    if (plantDate == null) return 0;
    final now = DateTime.now();
    return now.difference(plantDate).inDays;
  }
}
