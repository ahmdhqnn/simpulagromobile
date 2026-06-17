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

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(siteNotesBySiteProvider(siteId));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: createState.isLoading
                  ? null
                  : () => _showCreateDialog(context, ref),
              icon: createState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(Icons.add, size: 18),
              label: Text(context.l10n.notesNew),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.7),
                disabledForegroundColor: AppColors.textPrimary.withValues(
                  alpha: 0.45,
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          notesAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            skipError: true,
            data: (notes) {
              if (notes.isEmpty) {
                return InfoStateWidget.icon(
                  icon: Icons.note_alt_outlined,
                  message: context.l10n.notesEmptyForSite,
                  height: 180,
                  radius: AppRadius.lg,
                );
              }
              return AppCardWidget(
                width: double.infinity,
                radius: AppRadius.lg,
                padding: EdgeInsets.zero,
                child: Column(
                  children: List.generate(notes.length, (index) {
                    return Column(
                      children: [
                        _NoteListTile(note: notes[index]),
                        if (index != notes.length - 1)
                          const Divider(
                            color: AppColors.divider,
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  }),
                ),
              );
            },
            loading: () => const LatestNotesCardSkeleton(rowCount: 4),
            error: (e, _) => ErrorStateCardWidget(
              message: e.toString(),
              onRetry: () => ref.invalidate(siteNotesBySiteProvider(siteId)),
            ),
          ),
        ],
      ),
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
        : context.dateFormat('dd MMM yyyy HH:mm').format(date.toLocal());
    final title = note.noteTitle.trim().isEmpty
        ? note.noteContent
        : note.noteTitle;
    final desc = note.noteDesc.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              color: AppColors.textPrimary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
                if (note.userId.isNotEmpty || dateText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    [
                      if (note.userId.isNotEmpty) note.userId,
                      if (dateText.isNotEmpty) dateText,
                    ].join(' - '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary.withValues(alpha: 0.78),
                      height: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
