import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_elements.dart';
import '../../domain/entities/user_comment.dart';
import '../providers/forum_provider.dart';
import '../widgets/forum_action_widgets.dart';

class MyCommentsScreen extends ConsumerWidget {
  const MyCommentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myCommentsAsync = ref.watch(myCommentsProvider);

    return ForumActionScaffold(
      title: 'Komentar Saya',
      trailing: CircularIconActionWidget(
        onPressed: () => ref.invalidate(myCommentsProvider),
        icon: Icons.refresh,
      ),
      body: myCommentsAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        data: (comments) {
          if (comments.isEmpty) {
            return const ForumActionState(
              icon: Icons.chat_bubble_outline,
              title: 'Belum ada komentar',
              message: 'Komentar Anda pada postingan akan muncul di sini.',
            );
          }

          return _buildCommentList(context, ref, comments);
        },
        loading: () => _buildLoadingList(context),
        error: (error, _) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildCommentList(
    BuildContext context,
    WidgetRef ref,
    List<UserComment> comments,
  ) {
    final hPad = context.rw(0.051);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(myCommentsProvider),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          hPad,
          0,
          hPad,
          context.rh(0.02) + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: comments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ForumActionSummaryCard(
                icon: Icons.chat_bubble_outline,
                title: '${comments.length} komentar',
                subtitle: 'Komentar yang Anda tulis di postingan forum.',
                color: AppColors.info,
                background: AppColors.softBlue,
              ),
            );
          }

          return _CommentCard(comment: comments[index - 1]);
        },
      ),
    );
  }

  Widget _buildLoadingList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      itemCount: 5,
      itemBuilder: (_, __) => const _CommentCardSkeleton(),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return ForumActionState(
      icon: Icons.wifi_off_rounded,
      title: 'Gagal memuat komentar',
      message: error.toString().replaceAll('Exception: ', ''),
      action: ForumActionPrimaryButton(
        icon: Icons.refresh,
        label: 'Coba Lagi',
        onPressed: () => ref.invalidate(myCommentsProvider),
      ),
    );
  }
}

class _CommentCard extends ConsumerWidget {
  final UserComment comment;

  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/forum/post/${comment.forumId}'),
          onLongPress: () => _showActions(context, ref),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref),
                const SizedBox(height: 12),
                Text(
                  comment.commentContent,
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(13),
                    weight: FontWeight.w400,
                    height: 1.55,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(
            Icons.article_outlined,
            size: 22,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.postTitle.trim().isEmpty
                    ? 'Tanpa Judul'
                    : comment.postTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label(
                  context,
                  size: context.sp(13),
                  weight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ketuk untuk membuka postingan',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.hint(context, size: context.sp(10)),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Aksi komentar',
          onPressed: () => _showActions(context, ref),
          icon: const Icon(Icons.more_vert, size: 20),
          color: AppColors.textSecondary,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: AppColors.textPrimary.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            comment.timeAgo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption(context, size: context.sp(10)),
          ),
        ),
        if (comment.updatedAt != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'Diedit',
              style: AppTextStyles.caption(
                context,
                size: context.sp(9),
                weight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const Spacer(),
        Icon(
          Icons.chevron_right,
          size: 20,
          color: AppColors.textPrimary.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  void _showActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetCtx) => ForumActionBottomSheet(
        title: 'Kelola Komentar',
        children: [
          ForumActionSheetItem(
            icon: Icons.edit_outlined,
            iconColor: AppColors.primary,
            backgroundColor: AppColors.softGreen,
            label: 'Edit Komentar',
            onTap: () {
              Navigator.pop(sheetCtx);
              _editComment(context, ref);
            },
          ),
          ForumActionSheetItem(
            icon: Icons.delete_outline,
            iconColor: AppColors.error,
            backgroundColor: AppColors.softOrange,
            label: 'Hapus Komentar',
            labelColor: AppColors.error,
            onTap: () {
              Navigator.pop(sheetCtx);
              _deleteComment(context, ref);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _editComment(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: comment.commentContent);
    final updatedContent = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Edit Komentar',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            hintText: 'Tulis komentar',
            border: OutlineInputBorder(),
          ),
          style: AppTextStyles.label(
            context,
            size: 13,
            weight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final next = value.text.trim();
              final canSave =
                  next.isNotEmpty && next != comment.commentContent.trim();
              return TextButton(
                onPressed: canSave ? () => Navigator.pop(ctx, next) : null,
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: canSave ? AppColors.primary : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    controller.dispose();

    if (updatedContent == null || !context.mounted) return;

    final repo = ref.read(forumRepositoryProvider);
    final result = await repo.updateComment(
      commentId: comment.commentId,
      content: updatedContent,
    );
    if (!context.mounted) return;

    result.fold(
      (failure) => _showSnackBar(
        context,
        failure.message,
        backgroundColor: AppColors.error,
      ),
      (_) {
        ref.invalidate(myCommentsProvider);
        ref.invalidate(commentsProvider(comment.forumId));
        _showSnackBar(
          context,
          'Komentar diperbarui',
          backgroundColor: AppColors.success,
        );
      },
    );
  }

  Future<void> _deleteComment(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Hapus Komentar',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          'Komentar ini akan dihapus permanen.',
          style: AppTextStyles.label(
            context,
            size: 13,
            weight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Hapus',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final repo = ref.read(forumRepositoryProvider);
    final result = await repo.deleteCommentGlobal(comment.commentId);
    if (!context.mounted) return;

    result.fold(
      (failure) => _showSnackBar(
        context,
        failure.message,
        backgroundColor: AppColors.error,
      ),
      (_) {
        ref.invalidate(myCommentsProvider);
        ref.invalidate(postDetailProvider(comment.forumId));
        ref.invalidate(commentsProvider(comment.forumId));
        ref
            .read(forumProvider.notifier)
            .updateCommentCount(comment.forumId, -1);
        _showSnackBar(
          context,
          'Komentar dihapus',
          backgroundColor: AppColors.success,
        );
      },
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _CommentCardSkeleton extends StatelessWidget {
  const _CommentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCardWidget(
        radius: AppRadius.xl,
        padding: const EdgeInsets.all(14),
        child: SkeletonContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  SkeletonBox(
                    width: 42,
                    height: 42,
                    borderRadius: AppRadius.sm,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 160, height: 13),
                        SizedBox(height: 5),
                        SkeletonLine(width: 110, height: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  SkeletonCircle(size: 28),
                ],
              ),
              const SizedBox(height: 14),
              const SkeletonLine(width: double.infinity, height: 12),
              const SizedBox(height: 6),
              const SkeletonLine(width: double.infinity, height: 12),
              const SizedBox(height: 6),
              const SkeletonLine(width: 190, height: 12),
              const SizedBox(height: 14),
              const SkeletonLine(width: 86, height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
