import '../error/failures.dart';

String toUiErrorMessage(
  Object error, {
  String fallback = 'Terjadi kendala saat memuat data. Silakan coba lagi.',
}) {
  final raw = error is Failure ? error.message : error.toString();
  final singleLine = raw.split('\n').first.trim();
  final cleaned = singleLine
      .replaceAll('Exception: ', '')
      .replaceAll('StateError: ', '')
      .replaceAll('Bad state: ', '')
      .trim();

  if (cleaned.isEmpty) return fallback;

  final text = cleaned.toLowerCase();
  if (text.contains('socket') ||
      text.contains('timeout') ||
      text.contains('connection') ||
      text.contains('network')) {
    return 'Koneksi tidak stabil. Periksa internet Anda lalu coba lagi.';
  }
  if (text.contains('database') ||
      text.contains('db ') ||
      text.contains('query') ||
      text.contains('server')) {
    return 'Server belum bisa memuat data saat ini. Silakan coba lagi.';
  }
  if (text.contains('unauthorized') || text.contains('token')) {
    return 'Sesi Anda berakhir. Silakan login kembali.';
  }
  if (text.contains('tidak ditemukan') || text.contains('not found')) {
    return 'Data tidak ditemukan untuk site ini.';
  }
  if (text.contains('type ') && text.contains('is not a subtype')) {
    return fallback;
  }

  if (cleaned.length > 110) return fallback;
  return cleaned;
}
