import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/forum_provider.dart';
import '../widgets/post_card.dart';

class LikedPostsScreen extends ConsumerWidget {
  const LikedPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedPostsAsync = ref.watch(likedPostsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Postingan Disukai',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: likedPostsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.favorite_border,
              title: 'Belum ada postingan disukai',
              message: 'Like postingan untuk menyimpannya di sini',
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(likedPostsProvider);
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
                    ref.invalidate(likedPostsProvider);
                  },
                  onComment: () {
                    context.push('/forum/post/${post.postId}');
                  },
                  onShare: () => _sharePost(context, ref, post.postId),
                  onTap: () {
                    context.push('/forum/post/${post.postId}');
                  },
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
              onPressed: () => ref.invalidate(likedPostsProvider),
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

  Future<void> _sharePost(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) async {
    await ref.read(forumProvider.notifier).sharePost(postId);
    ref.invalidate(likedPostsProvider);
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
