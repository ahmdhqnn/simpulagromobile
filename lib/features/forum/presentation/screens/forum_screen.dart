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
                child: forumState.posts.isEmpty && !forumState.isLoading
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
              onPressed: () {
                // TODO: Implement more menu
              },
            ),
          ),
        ],
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
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Postingan'),
              onTap: () {
                Navigator.pop(context);
                context.push('/forum/edit/$postId');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Hapus Postingan',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
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
      builder: (context) => AlertDialog(
        title: const Text('Hapus Postingan'),
        content: const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(forumProvider.notifier).deletePost(postId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Postingan berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bagikan Postingan'),
        content: const Text('Fitur share akan segera tersedia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
