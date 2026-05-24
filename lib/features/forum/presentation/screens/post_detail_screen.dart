import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../providers/forum_provider.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  bool _isSendingComment = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(commentsProvider(widget.postId).notifier).loadComments();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSendingComment = true);

    try {
      await ref
          .read(commentsProvider(widget.postId).notifier)
          .addComment(content);
      _commentController.clear();
      _commentFocusNode.unfocus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal mengirim komentar: ${e.toString().replaceAll('Exception: ', '')}',
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingComment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postDetailProvider(widget.postId));
    final commentsState = ref.watch(commentsProvider(widget.postId));
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.userId;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text(
          'Detail Postingan',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: postAsync.when(
        data: (post) => Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(postDetailProvider(widget.postId));
                  await ref
                      .read(commentsProvider(widget.postId).notifier)
                      .loadComments();
                },
                child: CustomScrollView(
                  slivers: [
                    // Post Content
                    SliverToBoxAdapter(
                      child: _buildPostContent(context, post, currentUserId),
                    ),

                    // Divider
                    SliverToBoxAdapter(
                      child: Container(
                        height: 8,
                        color: const Color(0xFFF0F0F0),
                      ),
                    ),

                    // Comments Header
                    SliverToBoxAdapter(
                      child: _buildCommentsHeader(
                        context,
                        commentsState.comments.length,
                      ),
                    ),

                    // Comments List
                    if (commentsState.isLoading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              PostCardSkeleton(hasImage: false),
                              PostCardSkeleton(hasImage: false),
                            ],
                          ),
                        ),
                      )
                    else if (commentsState.comments.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildEmptyComments(context),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final comment = commentsState.comments[index];
                            final isOwn = comment.userId == currentUserId || post.userId == currentUserId;
                            return _buildCommentItem(
                              context,
                              comment,
                              isOwn,
                            );
                          },
                          childCount: commentsState.comments.length,
                        ),
                      ),

                    // Bottom spacing
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ],
                ),
              ),
            ),

            // Comment Input
            _buildCommentInput(context),
          ],
        ),
        loading: () => const DetailScreenSkeleton(infoRowCount: 3, hasDescription: true, headerHeight: 0),
        error: (error, _) => Center(
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
                  'Gagal memuat postingan',
                  style: AppTextStyles.cardTitle(context, 16),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption(context),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.invalidate(postDetailProvider(widget.postId)),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(
                    'Coba Lagi',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                    ),
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
        ),
      ),
    );
  }

  Widget _buildPostContent(
    BuildContext context,
    Post post,
    String? currentUserId,
  ) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/user-outline-icon.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.userName,
                      style: AppTextStyles.label(
                        context,
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${post.site?.siteName ?? ''} • ${post.timeAgo}',
                      style: AppTextStyles.hint(context, size: 11),
                    ),
                  ],
                ),
              ),
              if (post.userId == currentUserId)
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.push('/forum/edit/${post.postId}');
                    } else if (value == 'delete') {
                      _confirmDelete(context, post.postId);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: AppColors.error,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Hapus',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          SizedBox(height: context.rh(0.02)),

          // Title
          if (post.postTitle.trim().isNotEmpty) ...[
            Text(
              post.postTitle,
              style: AppTextStyles.cardTitle(context, 16),
            ),
            const SizedBox(height: 8),
          ],

          // Content
          Text(
            post.postContent,
            style: AppTextStyles.label(
              context,
              size: 13,
              weight: FontWeight.w400,
              height: 1.6,
            ),
          ),

          // Image
          if (post.hasImage) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Image.network(
                post.postImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _buildStatItem(
                context,
                icon: post.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: '${post.likeCount}',
                color: post.isLiked ? AppColors.error : AppColors.textSecondary,
                onTap: () async {
                  await ref.read(forumProvider.notifier).toggleLike(post.postId);
                  ref.invalidate(postDetailProvider(widget.postId));
                },
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                context,
                icon: Icons.chat_bubble_outline,
                label: '${ref.watch(commentsProvider(widget.postId)).comments.length}',
                color: AppColors.textSecondary,
                onTap: () => _commentFocusNode.requestFocus(),
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                context,
                icon: Icons.share_outlined,
                label: '${post.shareCount}',
                color: AppColors.textSecondary,
                onTap: () => _handleShare(post.postId),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.label(
                context,
                size: 12,
                color: color,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsHeader(BuildContext context, int count) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: 12,
      ),
      child: Row(
        children: [
          Text(
            'Komentar',
            style: AppTextStyles.cardTitle(context, 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.label(
                context,
                size: 11,
                color: AppColors.primary,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyComments(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: AppColors.textPrimary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada komentar',
            style: AppTextStyles.label(
              context,
              size: 14,
              color: AppColors.textTertiary,
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Jadilah yang pertama berkomentar',
            style: AppTextStyles.caption(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    Comment comment,
    bool isOwn,
  ) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.softGreenAlt,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Center(
              child: Text(
                comment.user.userName.isNotEmpty
                    ? comment.user.userName[0].toUpperCase()
                    : '?',
                style: AppTextStyles.label(
                  context,
                  size: 13,
                  color: AppColors.primary,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user.userName,
                      style: AppTextStyles.label(
                        context,
                        size: 12,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.timeAgo,
                      style: AppTextStyles.hint(context, size: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.commentContent,
                  style: AppTextStyles.label(
                    context,
                    size: 12,
                    weight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Delete button (own comments only)
          if (isOwn)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 16,
                color: AppColors.textTertiary,
              ),
              onPressed: () => _confirmDeleteComment(
                context,
                comment.commentId,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(13),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tulis komentar...',
                    hintStyle: AppTextStyles.hint(context, size: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  maxLines: 3,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submitComment(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onTap: _isSendingComment ? null : _submitComment,
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: _isSendingComment
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
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
              if (mounted) {
                // ignore: use_build_context_synchronously
                context.pop();
                // ignore: use_build_context_synchronously
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

  void _confirmDeleteComment(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Hapus Komentar',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus komentar ini?',
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
              ref
                  .read(commentsProvider(widget.postId).notifier)
                  .deleteComment(commentId);
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

  Future<void> _handleShare(String postId) async {
    await ref.read(forumProvider.notifier).sharePost(postId);
    ref.invalidate(postDetailProvider(widget.postId));
    if (mounted) {
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
