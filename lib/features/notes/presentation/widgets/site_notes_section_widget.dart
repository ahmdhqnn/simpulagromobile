import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
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
            label: Text(context.l10n.notesNew),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: notesAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            skipError: true,
            data: (notes) {
              if (notes.isEmpty) {
                return Center(child: Text(context.l10n.notesEmptyForSite));
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
            loading: () => const SimpleRowsCardSkeleton(
              rowCount: 5,
              iconSize: 36,
              rowHeight: 44,
            ),
            error: (e, _) =>
                Center(child: Text('${context.l10n.commonError}: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.notesNew),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: l10n.notesContentHint,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonSave),
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
          content: Text(success ? l10n.notesSaved : l10n.notesSaveFailed),
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
    final dateText = date == null
        ? ''
        : ' - ${context.dateFormat('dd MMM yyyy HH:mm').format(date.toLocal())}';
    return ListTile(
      title: Text(note.noteContent),
      subtitle: Text('${note.userId}$dateText'),
      leading: const Icon(Icons.note_alt_outlined),
    );
  }
}
