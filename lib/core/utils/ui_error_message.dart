import '../../l10n/app_localizations.dart';
import '../error/failures.dart';

String toUiErrorMessage(
  Object error,
  AppLocalizations l10n, {
  String? fallback,
}) {
  final defaultFallback = fallback ?? l10n.errorLoadFailed;
  
  final raw = error is Failure ? error.message : error.toString();
  final singleLine = raw.split('\n').first.trim();
  final cleaned = singleLine
      .replaceAll('Exception: ', '')
      .replaceAll('StateError: ', '')
      .replaceAll('Bad state: ', '')
      .trim();

  if (cleaned.isEmpty) return defaultFallback;

  final text = cleaned.toLowerCase();
  if (text.contains('socket') ||
      text.contains('timeout') ||
      text.contains('connection') ||
      text.contains('network')) {
    return l10n.errorNetwork;
  }
  if (text.contains('database') ||
      text.contains('db ') ||
      text.contains('query') ||
      text.contains('server')) {
    return l10n.errorServer;
  }
  if (text.contains('unauthorized') || text.contains('token')) {
    return l10n.errorSessionExpired;
  }
  if (text.contains('tidak ditemukan') || text.contains('not found')) {
    return l10n.errorDataNotFound;
  }
  if (text.contains('type ') && text.contains('is not a subtype')) {
    return defaultFallback;
  }

  if (cleaned.length > 110) return defaultFallback;
  return cleaned;
}

