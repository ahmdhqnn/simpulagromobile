import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../domain/entities/post.dart';
import '../providers/forum_provider.dart';
import '../widgets/forum_action_widgets.dart';
import '../widgets/post_card.dart';

class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPostsAsync = ref.watch(myPostsProvider);

    return ForumActionScaffold(
      title: 'Postingan Saya',
      floatingAction: CircularBackButtonWidget(
        onPressed: () => _openCreatePost(context, ref),
        svgIconPath: 'assets/icons/plus-outline-icon.svg',
      ),
      body: myPostsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return ForumActionState(
              icon: Icons.article_outlined,
              title: 'Belum ada postingan',
              message:
                  'Buat postingan pertama Anda untuk berbagi dengan komunitas.',
            );
          }

          return _buildPostList(context, ref, posts);
        },
        loading: () => _buildLoadingList(context),
        error: (error, _) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildPostList(BuildContext context, WidgetRef ref, List<Post> posts) {
    final hPad = context.rw(0.051);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(myPostsProvider),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          hPad,
          0,
          hPad,
          context.rh(0.02) + MediaQuery.paddingOf(context).bottom + 118,
        ),
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ForumActionSummaryCard(
                icon: Icons.article_outlined,
                title: '${posts.length} postingan',
                subtitle: 'Postingan yang Anda buat di forum komunitas.',
              ),
            );
          }

          final post = posts[index - 1];
          return PostCard(
            post: post,
            onLike: () async {
              await ref.read(forumProvider.notifier).toggleLike(post.postId);
              ref.invalidate(myPostsProvider);
            },
            onComment: () => context.push('/forum/post/${post.postId}'),
            onShare: () => _sharePost(context, ref, post.postId),
            onTap: () => context.push('/forum/post/${post.postId}'),
            onMorePressed: () => _showPostOptions(context, ref, post.postId),
          );
        },
      ),
    );
  }

  Widget _buildLoadingList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      itemCount: 4,
      itemBuilder: (_, __) => const PostCardSkeleton(hasImage: true),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return ForumActionState(
      icon: Icons.wifi_off_rounded,
      title: 'Gagal memuat postingan',
      message: error.toString().replaceAll('Exception: ', ''),
      action: ForumActionPrimaryButton(
        icon: Icons.refresh,
        label: 'Coba Lagi',
        onPressed: () => ref.invalidate(myPostsProvider),
      ),
    );
  }

  Future<void> _openCreatePost(BuildContext context, WidgetRef ref) async {
    await context.push('/forum/create');
    ref.invalidate(myPostsProvider);
  }

  void _showPostOptions(BuildContext context, WidgetRef ref, String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetCtx) => ForumActionBottomSheet(
        title: 'Kelola Postingan',
        children: [
          ForumActionSheetItem(
            icon: Icons.edit_outlined,
            iconColor: AppColors.primary,
            backgroundColor: AppColors.softGreen,
            label: 'Edit Postingan',
            onTap: () async {
              Navigator.pop(sheetCtx);
              await context.push('/forum/edit/$postId');
              ref.invalidate(myPostsProvider);
            },
          ),
          ForumActionSheetItem(
            icon: Icons.delete_outline,
            iconColor: AppColors.error,
            backgroundColor: AppColors.softOrange,
            label: 'Hapus Postingan',
            labelColor: AppColors.error,
            onTap: () {
              Navigator.pop(sheetCtx);
              _confirmDelete(context, ref, postId);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String postId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Hapus Postingan',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          'Postingan ini akan dihapus permanen.',
          style: AppTextStyles.label(
            context,
            size: 13,
            weight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await ref.read(forumProvider.notifier).deletePost(postId);
              ref.invalidate(myPostsProvider);
              if (!context.mounted) return;
              _showSnackBar(
                context,
                'Postingan berhasil dihapus',
                backgroundColor: AppColors.success,
              );
            },
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
  }

  Future<void> _sharePost(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) async {
    await ref.read(forumProvider.notifier).sharePost(postId);
    ref.invalidate(myPostsProvider);
    if (!context.mounted) return;
    _showSnackBar(
      context,
      'Postingan berhasil dibagikan',
      backgroundColor: AppColors.success,
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
