import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/forum_provider.dart';
import '../widgets/post_card.dart';

class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => ref.read(forumProvider.notifier).loadPosts(refresh: true),
    );

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, currentUser?.userName ?? 'User'),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(forumProvider.notifier)
                      .loadPosts(refresh: true);
                },
                child: forumState.error != null && forumState.posts.isEmpty
                    ? _buildErrorState(context)
                    : forumState.posts.isEmpty && !forumState.isLoading
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount:
                            forumState.posts.length +
                            (forumState.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == forumState.posts.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final post = forumState.posts[index];
                          final isOwnPost = post.userId == currentUser?.userId;

                          return PostCard(
                            post: post,
                            onLike: () {
                              ref
                                  .read(forumProvider.notifier)
                                  .toggleLike(post.postId);
                            },
                            onComment: () {
                              context.push('/forum/post/${post.postId}');
                            },
                            onShare: () {
                              _showShareDialog(context, post.postId);
                            },
                            onTap: () {
                              context.push('/forum/post/${post.postId}');
                            },
                            onMorePressed: isOwnPost
                                ? () => _showPostOptions(context, post.postId)
                                : null,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push('/forum/create');
            },
            borderRadius: BorderRadius.circular(32),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/plus-outline-icon.svg',
                width: 28,
                height: 28,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1D1D1D),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      color: const Color(0xFFF0F0F0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Forum',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(28),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D),
              height: 1.0,
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/more-icon.svg',
                width: 28,
                height: 28,
              ),
              onPressed: () => context.push('/forum/my-posts'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: context.rw(0.164).clamp(48.0, 72.0),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Gagal memuat postingan',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(16),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              ref.read(forumProvider).error ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: context.rh(0.025)),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(forumProvider.notifier).loadPosts(refresh: true),
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D503F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/forum-outline-icon.svg',
            width: 80,
            height: 80,
            colorFilter: const ColorFilter.mode(
              Color(0xFFCCCCCC),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada postingan',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jadilah yang pertama membuat postingan',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showPostOptions(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(
                'Edit Postingan',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              ),
              onTap: () {
                Navigator.pop(sheetCtx);
                context.push('/forum/edit/$postId');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Hapus Postingan',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Plus Jakarta Sans',
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
    );
  }

  void _confirmDelete(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Hapus Postingan',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus postingan ini?',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(forumProvider.notifier).deletePost(postId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Postingan berhasil dihapus',
                      style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Plus Jakarta Sans',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Bagikan Postingan',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        content: const Text(
          'Fitur share akan segera tersedia',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
            ),
          ),
        ],
      ),
    );
  }
}
