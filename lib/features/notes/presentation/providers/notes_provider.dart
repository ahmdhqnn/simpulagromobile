import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/notes_remote_datasource.dart';
import '../../domain/entities/site_note.dart';

final notesRemoteDataSourceProvider = Provider<NotesRemoteDataSource>((ref) {
  return NotesRemoteDataSource(ref.watch(dioClientProvider).dio);
});

/// Daftar catatan untuk site terpilih
final siteNotesProvider = FutureProvider.autoDispose<List<SiteNote>>((
  ref,
) async {
  ref.cacheFor(dataCardCacheDuration);
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) {
    throw StateError('Pilih site terlebih dahulu');
  }
  final ds = ref.watch(notesRemoteDataSourceProvider);
  return ref.retryOnError(() async {
    final models = await ds.getNotes(siteId, page: 1, limit: 50);
    return models.map((m) => m.toEntity()).toList();
  });
});

/// Catatan per site (untuk Site Detail)
final siteNotesBySiteProvider = FutureProvider.autoDispose
    .family<List<SiteNote>, String>((ref, siteId) async {
      ref.cacheFor(dataCardCacheDuration);
      final ds = ref.watch(notesRemoteDataSourceProvider);
      return ref.retryOnError(() async {
        final models = await ds.getNotes(siteId, page: 1, limit: 50);
        return models.map((m) => m.toEntity()).toList();
      });
    });

/// 3 catatan terbaru untuk dashboard
final latestNotesProvider = FutureProvider.autoDispose<List<SiteNote>>((
  ref,
) async {
  ref.cacheFor(dataCardCacheDuration);
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) {
    throw StateError('Pilih site terlebih dahulu');
  }
  final ds = ref.watch(notesRemoteDataSourceProvider);
  final models = await ref.retryOnError(
    () => ds.getNotes(siteId, page: 1, limit: 3),
  );
  final notes = models.map((m) => m.toEntity()).toList();
  notes.sort((a, b) {
    final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bd.compareTo(ad);
  });
  return notes.take(3).toList();
});

class CreateNoteNotifier extends StateNotifier<AsyncValue<void>> {
  CreateNoteNotifier(this._ds, this._ref) : super(const AsyncData(null));

  final NotesRemoteDataSource _ds;
  final Ref _ref;

  Future<bool> create({
    required String siteId,
    required String title,
    required String desc,
  }) async {
    if (title.trim().isEmpty || desc.trim().isEmpty) return false;
    state = const AsyncLoading();
    try {
      await _ds.createNote(
        siteId: siteId,
        noteTitle: title.trim(),
        noteDesc: desc.trim(),
      );
      _ref.invalidate(siteNotesProvider);
      _ref.invalidate(siteNotesBySiteProvider(siteId));
      _ref.invalidate(latestNotesProvider);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final createNoteProvider =
    StateNotifierProvider<CreateNoteNotifier, AsyncValue<void>>((ref) {
      return CreateNoteNotifier(ref.watch(notesRemoteDataSourceProvider), ref);
    });
