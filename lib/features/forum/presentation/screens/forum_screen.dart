import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
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
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
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
          itemBuilder: (_) => [
            _buildPopupItem(
              icon: Icons.article_outlined,
              label: 'Postingan Saya',
              value: 'my-posts',
            ),
            _buildPopupItem(
              icon: Icons.favorite_border,
              label: 'Disukai',
              value: 'liked-posts',
            ),
            _buildPopupItem(
              icon: Icons.chat_bubble_outline,
              label: 'Komentar Saya',
              value: 'my-comments',
            ),
          ],
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(29),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/more-icon.svg',
                width: 28,
                height: 28,
              ),
            ),
          ),
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
              onMorePressed: isOwnPost
                  ? () => _showPostOptions(context, post.postId)
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
      title: 'Belum ada postingan',
      message: 'Jadilah yang pertama membuat postingan di forum komunitas',
      action: ElevatedButton.icon(
        onPressed: () => _openCreatePost(context),
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

  PopupMenuItem<String> _buildPopupItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 13,
            ),
          ),
        ],
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
              'Gagal memuat postingan',
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

  void _showPostOptions(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
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
                  _confirmDelete(context, postId);
                },
              ),
            ],
          ),
        ),
      ),
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
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(forumProvider.notifier).deletePost(postId);
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

  void _showShareDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Bagikan Postingan',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          'Bagikan postingan ini ke teman atau komunitas Anda.',
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
              await ref.read(forumProvider.notifier).sharePost(postId);
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
            },
            child: Text(
              'Bagikan',
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
