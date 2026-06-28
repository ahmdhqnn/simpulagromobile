import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../domain/entities/site_note.dart';
import '../providers/notes_provider.dart';

class LatestNotesCardWidget extends ConsumerWidget {
  const LatestNotesCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(latestNotesProvider);

    return notesAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (notes) {
        if (notes.isEmpty) {
          return InfoStateWidget.icon(
            icon: Icons.note_alt_outlined,
            message: context.l10n.notesEmptyForSite,
            height: 104,
            radius: AppRadius.lg,
          );
        }
        final visibleNotes = notes.take(3).toList();
        return AppCardWidget(
          width: double.infinity,
          radius: AppRadius.lg,
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleNotes.length,
            separatorBuilder: (_, __) => const Divider(
              color: AppColors.divider,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (_, index) => _NoteTile(note: visibleNotes[index]),
          ),
        );
      },
      loading: () => const LatestNotesCardSkeleton(rowCount: 3),
      error: (e, _) => ErrorStateCardWidget(
        message: toUiErrorMessage(e, context.l10n),
        radius: AppRadius.lg,
        onRetry: () => ref.invalidate(latestNotesProvider),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final SiteNote note;

  const _NoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    final date = note.createdAt;
    final dateStr = date != null
        ? context.dateFormat('dd MMM yyyy').format(date)
        : '';
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softGreenAlt,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: context.rw(0.03)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(
                    context,
                    size: 14,
                    weight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(context, size: 11),
                  ),
                ],
                if (dateStr.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (note.userId.isNotEmpty) note.userId,
                      dateStr,
                    ].join(' - '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption2(context, size: 10),
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
