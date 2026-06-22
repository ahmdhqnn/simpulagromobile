import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
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
              onPressed: () => context.push('/site/$siteId/note/create'),
              icon: const Icon(Icons.add, size: 18),
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
