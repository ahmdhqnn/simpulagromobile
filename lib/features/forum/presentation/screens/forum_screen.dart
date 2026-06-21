import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/action_popup_menu_button.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/forum_provider.dart';
import '../widgets/post_card.dart';

class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      ref.read(forumProvider.notifier).loadPosts(refresh: true);
      ref.read(forumProvider.notifier).startRealtime();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(forumProvider.notifier).stopRealtime();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(forumProvider.notifier).refreshPosts();
      ref.read(forumProvider.notifier).startRealtime();
    } else if (state == AppLifecycleState.paused) {
      ref.read(forumProvider.notifier).stopRealtime();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(forumProvider.notifier).loadPosts();
    }
  }

  Future<void> _refreshPosts() async {
    await ref.read(forumProvider.notifier).loadPosts(refresh: true);
  }

  Future<void> _openCreatePost(BuildContext context) async {
    await context.push('/forum/create');
    if (!mounted) return;
    await _refreshPosts();
  }

  double _floatingButtonBottom(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return (bottomInset > 0 ? bottomInset + 102 : 112).toDouble();
  }

  double _forumBottomContentSpace(BuildContext context) {
    return bottomNavigationContentSpace(context) + 86;
  }

  @override
  Widget build(BuildContext context) {
    final forumState = ref.watch(forumProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;
    final hPad = context.rw(0.051);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refreshPosts,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        hPad,
                        context.rh(0.015),
                        hPad,
                        0,
                      ),
                      child: _buildHeader(context),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: context.rh(0.024)),
                  ),
                  _buildBodySliver(
                    context,
                    forumState,
                    currentUser?.userId,
                    hPad,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: _forumBottomContentSpace(context)),
                  ),
                ],
              ),
            ),
            Positioned(
              right: hPad,
              bottom: _floatingButtonBottom(context),
              child: CircularBackButtonWidget(
                onPressed: () => _openCreatePost(context),
                svgIconPath: 'assets/icons/plus-outline-icon.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        MorePopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'my-posts':
                context.push('/forum/my-posts');
                break;
              case 'liked-posts':
                context.push('/forum/liked-posts');
                break;
              case 'my-comments':
                context.push('/forum/my-comments');
                break;
            }
          },
          items: [
            ActionPopupMenuItem(
              value: 'my-posts',
              icon: Icons.article_outlined,
              label: context.l10n.forumMyPosts,
            ),
            ActionPopupMenuItem(
              value: 'liked-posts',
              icon: Icons.favorite_border,
              label: context.l10n.forumLiked,
            ),
            ActionPopupMenuItem(
              value: 'my-comments',
              icon: Icons.chat_bubble_outline,
              label: context.l10n.forumMyComments,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBodySliver(
    BuildContext context,
    ForumState forumState,
    String? currentUserId,
    double horizontalPadding,
  ) {
    if (forumState.error != null && forumState.posts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildErrorState(context, forumState.error!),
      );
    }

    if (forumState.posts.isEmpty && !forumState.isLoading) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(context),
      );
    }

    if (forumState.posts.isEmpty && forumState.isLoading) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => const PostCardSkeleton(hasImage: true),
            childCount: 4,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == forumState.posts.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: PostCardSkeleton(hasImage: true),
              );
            }

            final post = forumState.posts[index];
            final isOwnPost = post.userId == currentUserId;

            return PostCard(
              post: post,
              onLike: () {
                ref.read(forumProvider.notifier).toggleLike(post.postId);
              },
              onComment: () {
                context.push('/forum/post/${post.postId}');
              },
              onShare: () => _showShareDialog(context, post.postId),
              onTap: () {
                context.push('/forum/post/${post.postId}');
              },
              trailing: isOwnPost
                  ? _buildPostMoreMenu(context, post.postId)
                  : null,
            );
          },
          childCount: forumState.posts.length + (forumState.isLoading ? 1 : 0),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.forum_outlined,
      title: context.l10n.forumNoPostsTitle,
      message: context.l10n.forumNoPostsMessage,
      action: ElevatedButton.icon(
        onPressed: () => _openCreatePost(context),
        icon: const Icon(Icons.add, size: 18),
        label: Text(
          context.l10n.forumCreatePost,
          style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
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

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: AppColors.textPrimary.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.forumLoadPostsFailed,
              style: AppTextStyles.cardTitle(context, 16),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(forumProvider.notifier).loadPosts(refresh: true),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                context.l10n.commonRetry,
                style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
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

  Widget _buildPostMoreMenu(BuildContext context, String postId) {
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
      onSelected: (value) {
        if (value == 'edit') {
          context.push('/forum/edit/$postId');
        } else if (value == 'delete') {
          _confirmDelete(context, postId);
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          context.l10n.forumDeletePost,
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          context.l10n.forumDeletePostConfirm,
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
              context.l10n.commonCancel,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(forumProvider.notifier).deletePost(postId);
              if (context.mounted) {
                SnackbarHelper.showSuccess(
                  context,
                  context.l10n.forumPostDeleted,
                );
              }
            },
            child: Text(
              context.l10n.commonDelete,
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

  void _showShareDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          context.l10n.forumSharePostTitle,
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          context.l10n.forumSharePostMessage,
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
              context.l10n.commonCancel,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final l10n = context.l10n;
              Navigator.pop(dialogCtx);
              await ref.read(forumProvider.notifier).sharePost(postId);
              if (context.mounted) {
                SnackbarHelper.showSuccess(
                  context,
                  l10n.forumPostShared,
                );
              }
            },
            child: Text(
              context.l10n.forumShare,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
