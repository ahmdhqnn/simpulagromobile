import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../domain/entities/post.dart';
import '../providers/forum_provider.dart';
import '../widgets/forum_action_widgets.dart';
import '../widgets/post_card.dart';

class LikedPostsScreen extends ConsumerWidget {
  const LikedPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedPostsAsync = ref.watch(likedPostsProvider);

    return ForumActionScaffold(
      title: context.l10n.forumLikedPosts,
      trailing: CircularIconActionWidget(
        onPressed: () => ref.invalidate(likedPostsProvider),
        icon: Icons.refresh,
      ),
      body: likedPostsAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        data: (posts) {
          if (posts.isEmpty) {
            return ForumActionState(
              icon: Icons.favorite_border,
              title: context.l10n.forumLikedPostsEmptyTitle,
              message: context.l10n.forumLikedPostsEmptyMessage,
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
      onRefresh: () async => ref.invalidate(likedPostsProvider),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          hPad,
          0,
          hPad,
          context.rh(0.02) + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ForumActionSummaryCard(
                icon: Icons.favorite_border,
                title: context.l10n.forumLikedPostCount(posts.length),
                subtitle: context.l10n.forumLikedPostsSummary,
                color: AppColors.error,
                background: AppColors.softOrange,
              ),
            );
          }

          final post = posts[index - 1];
          return PostCard(
            post: post,
            onLike: () async {
              await ref.read(forumProvider.notifier).toggleLike(post.postId);
              ref.invalidate(likedPostsProvider);
            },
            onComment: () => context.push('/forum/post/${post.postId}'),
            onShare: () => _sharePost(context, ref, post.postId),
            onTap: () => context.push('/forum/post/${post.postId}'),
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
      title: context.l10n.forumLoadPostsFailed,
      message: error.toString().replaceAll('Exception: ', ''),
      action: ForumActionPrimaryButton(
        icon: Icons.refresh,
        label: context.l10n.commonRetry,
        onPressed: () => ref.invalidate(likedPostsProvider),
      ),
    );
  }

  Future<void> _sharePost(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) async {
    final l10n = context.l10n;
    await ref.read(forumProvider.notifier).sharePost(postId);
    ref.invalidate(likedPostsProvider);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.forumPostShared,
          style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
