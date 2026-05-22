import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/forum_provider.dart';
import '../widgets/post_card.dart';

class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPostsAsync = ref.watch(myPostsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Postingan Saya',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: myPostsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.article_outlined,
              title: 'Belum ada postingan',
              message: 'Buat postingan pertama Anda untuk berbagi dengan komunitas',
              action: ElevatedButton.icon(
                onPressed: () => context.push('/forum/create'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Buat Postingan',
                  style: TextStyle(fontFamily: AppTextStyles.fontFamily),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(myPostsProvider);
            },
            child: ListView.builder(
              padding: EdgeInsets.all(context.rw(0.051)),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  post: post,
                  onLike: () async {
                    await ref.read(forumProvider.notifier).toggleLike(post.postId);
                    ref.invalidate(myPostsProvider);
                  },
                  onComment: () {
                    context.push('/forum/post/${post.postId}');
                  },
                  onShare: () => _sharePost(context, ref, post.postId),
                  onTap: () {
                    context.push('/forum/post/${post.postId}');
                  },
                  onMorePressed: () =>
                      _showPostOptions(context, ref, post.postId),
                );
              },
            ),
          );
        },
        loading: () => ListView.builder(
          padding: EdgeInsets.all(context.rw(0.051)),
          itemCount: 4,
          itemBuilder: (_, __) => const PostCardSkeleton(hasImage: true),
        ),
        error: (error, _) => _buildErrorState(context, ref, error),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/forum/create'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.textPrimary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              error.toString().replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(myPostsProvider),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context, WidgetRef ref, String postId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.textPrimary,
                ),
                title: Text(
                  'Edit Postingan',
                  style: AppTextStyles.label(
                    context,
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  context.push('/forum/edit/$postId');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                ),
                title: Text(
                  'Hapus Postingan',
                  style: AppTextStyles.label(
                    context,
                    size: 14,
                    weight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _confirmDelete(context, ref, postId);
                },
              ),
            ],
          ),
        ),
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
          'Apakah Anda yakin ingin menghapus postingan ini?',
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
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Postingan berhasil dihapus',
                      style: TextStyle(fontFamily: AppTextStyles.fontFamily),
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
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
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Postingan berhasil dibagikan',
            style: TextStyle(fontFamily: AppTextStyles.fontFamily),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
