import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../domain/entities/site_note.dart';
import '../providers/notes_provider.dart';

class LatestNotesCardWidget extends ConsumerWidget {
  const LatestNotesCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(latestNotesProvider);

    return notesAsync.when(
      data: (notes) {
        if (notes.isEmpty) {
          return InfoStateWidget.icon(
            icon: Icons.note_alt_outlined,
            message: 'Belum ada catatan untuk site ini',
            height: 80,
          );
        }
        return Column(
          children: notes.map((n) => _NoteTile(note: n)).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => InfoStateWidget.icon(
        icon: Icons.error_outline,
        message: e.toString(),
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
        ? '${date.day}/${date.month}/${date.year}'
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
              '${note.userId} · $dateStr',
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
