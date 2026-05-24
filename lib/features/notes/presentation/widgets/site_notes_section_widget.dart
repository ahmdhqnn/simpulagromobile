import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/site_note.dart';
import '../providers/notes_provider.dart';

/// Tab/section catatan di Site Detail
class SiteNotesSectionWidget extends ConsumerWidget {
  final String siteId;

  const SiteNotesSectionWidget({super.key, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(siteNotesBySiteProvider(siteId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _showCreateDialog(context, ref),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Catatan Baru'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: notesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return const Center(
                  child: Text('Belum ada catatan untuk site ini'),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(siteNotesBySiteProvider(siteId));
                },
                child: ListView.separated(
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => _NoteListTile(note: notes[i]),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Catatan Baru'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Isi catatan...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final success = await ref
        .read(createNoteProvider.notifier)
        .create(siteId, controller.text);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Catatan tersimpan' : 'Gagal menyimpan catatan'),
        ),
      );
    }
  }
}

class _NoteListTile extends StatelessWidget {
  final SiteNote note;

  const _NoteListTile({required this.note});

  @override
  Widget build(BuildContext context) {
    final date = note.createdAt;
    return ListTile(
      title: Text(note.noteContent),
      subtitle: Text(
        '${note.userId}${date != null ? ' · ${date.toLocal()}' : ''}',
      ),
      leading: const Icon(Icons.note_alt_outlined),
    );
  }
}
