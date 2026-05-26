import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
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

  @override
  Widget build(BuildContext context) {
    final forumState = ref.watch(forumProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await ref
                      .read(forumProvider.notifier)
                      .loadPosts(refresh: true);
                },
                child: _buildBody(context, forumState, currentUser?.userId),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/forum/create'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Forum', style: AppTextStyles.sectionTitle(context, 28)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
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
          ),
        ],
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

  Widget _buildBody(
    BuildContext context,
    ForumState forumState,
    String? currentUserId,
  ) {
    if (forumState.error != null && forumState.posts.isEmpty) {
      return _buildErrorState(context, forumState.error!);
    }

    if (forumState.posts.isEmpty && !forumState.isLoading) {
      return EmptyStateWidget(
        icon: Icons.forum_outlined,
        title: 'Belum ada postingan',
        message: 'Jadilah yang pertama membuat postingan di forum komunitas',
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

    if (forumState.posts.isEmpty && forumState.isLoading) {
      return ListView.builder(
        padding: EdgeInsets.all(context.rw(0.051)),
        itemCount: 4,
        itemBuilder: (_, __) => const PostCardSkeleton(hasImage: true),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(context.rw(0.051)),
      itemCount: forumState.posts.length + (forumState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == forumState.posts.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
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
