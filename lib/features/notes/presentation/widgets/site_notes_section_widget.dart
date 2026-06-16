import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../domain/entities/site_note.dart';
import '../providers/notes_provider.dart';

/// Tab/section catatan di Site Detail.
class SiteNotesSectionWidget extends ConsumerWidget {
  final String siteId;

  const SiteNotesSectionWidget({super.key, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(siteNotesBySiteProvider(siteId));
    final createState = ref.watch(createNoteProvider);

    if (notesAsync.isLoading && !notesAsync.hasValue) {
      return const SiteNotesSectionSkeleton();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: createState.isLoading
                ? null
                : () => _showCreateDialog(context, ref),
            icon: createState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add, size: 18),
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
                return InfoStateWidget.icon(
                  icon: Icons.note_alt_outlined,
                  message: context.l10n.notesEmptyForSite,
                  height: 128,
                  radius: AppRadius.lg,
                );
              }
              return AppCardWidget(
                width: double.infinity,
                radius: AppRadius.lg,
                padding: EdgeInsets.zero,
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(siteNotesBySiteProvider(siteId));
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: notes.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: AppColors.divider,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (_, i) => _NoteListTile(note: notes[i]),
                  ),
                ),
              );
            },
            loading: () => const LatestNotesCardSkeleton(rowCount: 4),
            error: (e, _) => ErrorStateCardWidget(
              message: e.toString(),
              onRetry: () => ref.invalidate(siteNotesBySiteProvider(siteId)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final l10n = context.l10n;
    var title = '';
    var desc = '';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.notesNew),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  maxLength: 32,
                  autofocus: true,
                  onChanged: (value) => title = value,
                  decoration: InputDecoration(
                    labelText: l10n.forumPostTitleLabel,
                    border: const OutlineInputBorder(),
                    counterText: '',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return l10n.forumPostTitleRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 4,
                  onChanged: (value) => desc = value,
                  decoration: InputDecoration(
                    labelText: l10n.commonDescription,
                    hintText: l10n.notesContentHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.commonRequired;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );

    if (ok != true || !context.mounted) return;
    final success = await ref.read(createNoteProvider.notifier).create(
          siteId: siteId,
          title: title.trim(),
          desc: desc.trim(),
        );
    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, l10n.notesSaved);
      return;
    }

    final error = ref.read(createNoteProvider).error;
    SnackbarHelper.showError(
      context,
      _errorMessage(error) ?? l10n.notesSaveFailed,
    );
  }

  String? _errorMessage(Object? error) {
    final message = error?.toString().trim();
    if (message == null || message.isEmpty) return null;
    return message.replaceFirst(RegExp(r'^Exception:\s*'), '');
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
    final title = note.noteTitle.trim().isEmpty
        ? note.noteContent
        : note.noteTitle;
    final desc = note.noteDesc.trim();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title),
      subtitle: Text(
        [
          if (desc.isNotEmpty) desc,
          if (note.userId.isNotEmpty || dateText.isNotEmpty)
            '${note.userId}$dateText',
        ].join('\n'),
      ),
      leading: const Icon(Icons.note_alt_outlined),
    );
  }
}
