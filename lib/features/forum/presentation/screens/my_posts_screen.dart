import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/action_popup_menu_button.dart';
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
      title: context.l10n.forumMyPosts,
      floatingAction: CircularBackButtonWidget(
        onPressed: () => _openCreatePost(context, ref),
        svgIconPath: 'assets/icons/plus-outline-icon.svg',
      ),
      body: myPostsAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        data: (posts) {
          if (posts.isEmpty) {
            return ForumActionState(
              icon: Icons.article_outlined,
              title: context.l10n.forumNoPostsTitle,
              message: context.l10n.forumFirstPostMessage,
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
                title: context.l10n.forumPostCount(posts.length),
                subtitle: context.l10n.forumMyPostsSummary,
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
            trailing: _buildPostMoreMenu(context, ref, post.postId),
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
        onPressed: () => ref.invalidate(myPostsProvider),
      ),
    );
  }

  Future<void> _openCreatePost(BuildContext context, WidgetRef ref) async {
    await context.push('/forum/create');
    ref.invalidate(myPostsProvider);
  }

  Widget _buildPostMoreMenu(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) {
    return MorePopupMenuButton<String>(
      size: 32,
      iconSize: 20,
      backgroundColor: null,
      iconColor: AppColors.textSecondary,
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      items: [
        ActionPopupMenuItem(
          value: 'edit',
          icon: Icons.edit_outlined,
          label: context.l10n.forumEditPost,
          iconColor: AppColors.textPrimary,
        ),
        ActionPopupMenuItem(
          value: 'delete',
          icon: Icons.delete_outline,
          label: context.l10n.forumDeletePost,
          iconColor: AppColors.error,
          labelColor: AppColors.error,
        ),
      ],
      onSelected: (value) async {
        if (value == 'edit') {
          await context.push('/forum/edit/$postId');
          ref.invalidate(myPostsProvider);
        } else if (value == 'delete') {
          _confirmDelete(context, ref, postId);
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String postId) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          l10n.forumDeletePost,
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          l10n.forumDeletePostPermanent,
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
              l10n.commonCancel,
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
                l10n.forumPostDeleted,
                backgroundColor: AppColors.success,
              );
            },
            child: Text(
              l10n.commonDelete,
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
    final l10n = context.l10n;
    await ref.read(forumProvider.notifier).sharePost(postId);
    ref.invalidate(myPostsProvider);
    if (!context.mounted) return;
    _showSnackBar(
      context,
      l10n.forumPostShared,
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
