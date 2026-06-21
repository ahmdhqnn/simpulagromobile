import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/action_popup_menu_button.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
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
  final _scrollController = ScrollController();
  bool _isSendingComment = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(commentsProvider(widget.postId).notifier).loadComments();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.9) {
      ref.read(commentsProvider(widget.postId).notifier).loadMoreComments();
    }
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;
    final l10n = context.l10n;

    setState(() => _isSendingComment = true);

    try {
      await ref
          .read(commentsProvider(widget.postId).notifier)
          .addComment(content);
      _commentController.clear();
      _commentFocusNode.unfocus();
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(
          context,
          l10n.forumSendCommentFailed(
            e.toString().replaceAll('Exception: ', ''),
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
    final hPad = context.rw(0.051);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: postAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        data: (post) {
          final commentCount = _resolveCommentCount(post, commentsState);

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      ref.invalidate(postDetailProvider(widget.postId));
                      await ref
                          .read(commentsProvider(widget.postId).notifier)
                          .loadComments();
                    },
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
                            child: _buildTopBar(context, post, currentUserId),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: context.rh(0.024)),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            child: _buildPostContent(
                              context,
                              post,
                              commentCount,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: context.rh(0.012)),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            child: _buildCommentsHeader(context, commentCount),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: context.rh(0.012)),
                        ),
                        if (commentsState.isLoading &&
                            commentsState.comments.isEmpty)
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (_, __) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: context.rh(0.012),
                                  ),
                                  child: const PostCardSkeleton(
                                    hasImage: false,
                                  ),
                                ),
                                childCount: 2,
                              ),
                            ),
                          )
                        else if (commentsState.comments.isEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: hPad),
                              child: _buildEmptyComments(context),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final comment = commentsState.comments[index];
                                final canManage =
                                    comment.userId == currentUserId ||
                                    post.userId == currentUserId;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: context.rh(0.012),
                                  ),
                                  child: _buildCommentItem(
                                    context,
                                    comment,
                                    canManage,
                                  ),
                                );
                              }, childCount: commentsState.comments.length),
                            ),
                          ),
                        if (commentsState.isLoading &&
                            commentsState.comments.isNotEmpty)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: SimpleRowsCardSkeleton(
                                rowCount: 2,
                                rowHeight: 42,
                                iconSize: 32,
                              ),
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: context.rh(0.02)),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildCommentInput(context),
              ],
            ),
          );
        },
        loading: () => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, context.rh(0.015), hPad, 0),
                child: _buildTopBar(context, null, currentUserId),
              ),
              SizedBox(height: context.rh(0.024)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: const DetailScreenSkeleton(
                    infoRowCount: 3,
                    hasDescription: true,
                    headerHeight: 120,
                  ),
                ),
              ),
            ],
          ),
        ),
        error: (error, _) => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, context.rh(0.015), hPad, 0),
                child: _buildTopBar(context, null, currentUserId),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(context.rw(0.061)),
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
                          context.l10n.forumLoadPostsFailed,
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
                            context.l10n.commonRetry,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: context.sp(13),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _resolveCommentCount(Post post, CommentsState state) {
    if (state.totalCount > 0) return state.totalCount;
    if (!state.isLoading) return state.comments.length;
    return post.commentCount;
  }

  Widget _buildTopBar(BuildContext context, Post? post, String? currentUserId) {
    return Row(
      children: [
        CircularBackButtonWidget(onPressed: () => context.pop()),
        const Spacer(),
        if (post != null && post.userId == currentUserId)
          MorePopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                context.push('/forum/edit/${post.postId}');
              } else if (value == 'delete') {
                _confirmDelete(context, post.postId);
              }
            },
            items: [
              ActionPopupMenuItem(
                value: 'edit',
                icon: Icons.edit_outlined,
                label: context.l10n.commonEdit,
                iconColor: AppColors.textPrimary,
              ),
              ActionPopupMenuItem(
                value: 'delete',
                icon: Icons.delete_outline,
                label: context.l10n.commonDelete,
                iconColor: AppColors.error,
                labelColor: AppColors.error,
              ),
            ],
          )
        else
          const SizedBox(width: 58, height: 58),
      ],
    );
  }

  Widget _buildPostContent(BuildContext context, Post post, int commentCount) {
    final siteName = post.site?.siteName.trim() ?? '';
    final metaText = siteName.isEmpty
        ? post.timeAgo
        : '$siteName - ${post.timeAgo}';

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(
                context,
                name: post.user.userName,
                imageUrl: post.user.userAvatar,
                size: 44,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.userName,
                      style: AppTextStyles.label(
                        context,
                        size: 13,
                        weight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      metaText,
                      style: AppTextStyles.hint(context, size: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.02)),
          if (post.postTitle.trim().isNotEmpty) ...[
            Text(
              post.postTitle,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(20),
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            post.postContent,
            style: AppTextStyles.label(
              context,
              size: 13,
              weight: FontWeight.w400,
              height: 1.55,
            ),
          ),
          if (post.hasImage) ...[
            SizedBox(height: context.rh(0.018)),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Image.network(
                post.postImage!,
                width: double.infinity,
                height: context.rh(0.24),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: context.rh(0.24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    size: 44,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: context.rh(0.018)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                _buildMetricCell(
                  context,
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: context.l10n.forumLike,
                  value: post.likeCount,
                  color: post.isLiked ? AppColors.error : AppColors.textPrimary,
                ),
                _buildMetricDivider(),
                _buildMetricCell(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: context.l10n.forumComment,
                  value: commentCount,
                  color: AppColors.textPrimary,
                ),
                _buildMetricDivider(),
                _buildMetricCell(
                  context,
                  icon: Icons.share_outlined,
                  label: context.l10n.forumShare,
                  value: post.shareCount,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          SizedBox(height: context.rh(0.014)),
          Row(
            children: [
              Expanded(
                child: _buildPostActionChip(
                  context,
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: context.l10n.forumLike,
                  color: post.isLiked
                      ? AppColors.error
                      : AppColors.textSecondary,
                  onTap: () async {
                    await ref
                        .read(forumProvider.notifier)
                        .toggleLike(post.postId);
                    ref.invalidate(postDetailProvider(widget.postId));
                  },
                  onLongPress: () =>
                      _showReactionsSheet(context, ref, post.postId),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPostActionChip(
                  context,
                  icon: Icons.thumb_down_outlined,
                  label: context.l10n.forumDislike,
                  color: AppColors.textSecondary,
                  onTap: () async {
                    await ref
                        .read(forumProvider.notifier)
                        .toggleDislike(post.postId);
                    ref.invalidate(postDetailProvider(widget.postId));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPostActionChip(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: context.l10n.forumComment,
                  color: AppColors.textSecondary,
                  onTap: () => _commentFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPostActionChip(
                  context,
                  icon: Icons.share_outlined,
                  label: context.l10n.forumShare,
                  color: AppColors.textSecondary,
                  onTap: () => _handleShare(post.postId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(15),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption(context, size: 10)),
        ],
      ),
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      width: 1,
      height: 38,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildPostActionChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: SizedBox(
          height: 38,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    context,
                    size: 11,
                    color: color,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsHeader(BuildContext context, int count) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.041),
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.forumComment,
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
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.041),
        vertical: context.rh(0.04),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 44,
            color: AppColors.textPrimary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.forumNoCommentsTitle,
            style: AppTextStyles.label(
              context,
              size: 14,
              color: AppColors.textTertiary,
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.forumFirstCommentMessage,
            style: AppTextStyles.caption(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    Comment comment,
    bool canManage,
  ) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(
            context,
            name: comment.user.userName,
            imageUrl: comment.user.userAvatar,
            size: 36,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.user.userName,
                            style: AppTextStyles.label(
                              context,
                              size: 12,
                              weight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            comment.timeAgo,
                            style: AppTextStyles.hint(context, size: 10),
                          ),
                        ],
                      ),
                    ),
                    if (canManage)
                      MorePopupMenuButton<String>(
                        size: 32,
                        iconSize: 18,
                        backgroundColor: AppColors.surfaceVariant,
                        iconColor: AppColors.textSecondary,
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editComment(context, comment);
                          } else if (value == 'delete') {
                            _confirmDeleteComment(context, comment.commentId);
                          }
                        },
                        items: [
                          ActionPopupMenuItem(
                            value: 'edit',
                            icon: Icons.edit_outlined,
                            label: context.l10n.commonEdit,
                            iconColor: AppColors.textPrimary,
                          ),
                          ActionPopupMenuItem(
                            value: 'delete',
                            icon: Icons.delete_outline,
                            label: context.l10n.commonDelete,
                            iconColor: AppColors.error,
                            labelColor: AppColors.error,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  comment.commentContent,
                  style: AppTextStyles.label(
                    context,
                    size: 12,
                    weight: FontWeight.w400,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.rw(0.051),
        10,
        context.rw(0.051),
        10,
      ),
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
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
                    hintText: context.l10n.forumWriteComment,
                    hintStyle: AppTextStyles.hint(context, size: 13),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
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
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(
    BuildContext context, {
    required String name,
    required double size,
    String? imageUrl,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _buildAvatarFallback(context, name: name, size: size),
              ),
            )
          : _buildAvatarFallback(context, name: name, size: size),
    );
  }

  Widget _buildAvatarFallback(
    BuildContext context, {
    required String name,
    required double size,
  }) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty
        ? 'U'
        : trimmed.substring(0, 1).toUpperCase();

    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(size <= 36 ? 14 : 18),
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  void _showReactionsSheet(BuildContext context, WidgetRef ref, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final reactionsAsync = ref.watch(postReactionsProvider(postId));
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: reactionsAsync.when(
              data: (reactions) {
                if (reactions.isEmpty) {
                  return Text(context.l10n.forumNoReactions);
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.forumReactions,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...reactions.map(
                      (reaction) => ListTile(
                        dense: true,
                        title: Text(reaction.userName),
                        leading: const Icon(Icons.person_outline, size: 20),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SimpleRowsCardSkeleton(
                rowCount: 3,
                rowHeight: 40,
                iconSize: 32,
              ),
              error: (error, _) => Text('${context.l10n.commonError}: $error'),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String postId) {
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
          l10n.forumDeletePostConfirm,
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
              if (mounted) {
                // ignore: use_build_context_synchronously
                context.pop();
                // ignore: use_build_context_synchronously
                SnackbarHelper.showSuccess(context, l10n.forumPostDeleted);
              }
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

  Future<void> _editComment(BuildContext context, Comment comment) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: comment.commentContent);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          l10n.forumEditComment,
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final content = controller.text.trim();
    if (content.isEmpty) return;
    await ref
        .read(commentsProvider(widget.postId).notifier)
        .updateComment(comment.commentId, content);
    if (!context.mounted) return;
    SnackbarHelper.showSuccess(context, l10n.forumCommentUpdated);
  }

  void _confirmDeleteComment(BuildContext context, String commentId) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          l10n.forumDeleteComment,
          style: AppTextStyles.cardTitle(context, 16),
        ),
        content: Text(
          l10n.forumDeleteCommentConfirm,
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
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref
                  .read(commentsProvider(widget.postId).notifier)
                  .deleteComment(commentId);
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

  Future<void> _handleShare(String postId) async {
    final l10n = context.l10n;
    await ref.read(forumProvider.notifier).sharePost(postId);
    ref.invalidate(postDetailProvider(widget.postId));
    if (mounted) {
      SnackbarHelper.showSuccess(context, l10n.forumPostShared);
    }
  }
}
