import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
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
            height: 80,
          );
        }
        return Column(children: notes.map((n) => _NoteTile(note: n)).toList());
      },
      loading: () => const CompactTextRowsSkeleton(rowCount: 3),
      error: (e, _) => InfoStateWidget.icon(
        icon: Icons.error_outline,
        message: toUiErrorMessage(e, context.l10n),
        height: 80,
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

    return Container(
      margin: EdgeInsets.only(bottom: context.rh(0.01)),
      padding: EdgeInsets.all(context.rw(0.04)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.noteContent,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: const Color(0xFF1D1D1D),
            ),
          ),
          if (dateStr.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${note.userId} - $dateStr',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(11),
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
