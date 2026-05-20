import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContent(context),
                  const SizedBox(height: 10),
                  _buildStats(context),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 10),
                  _buildActions(context),
                ],
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
        // Avatar
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: post.user.userAvatar != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Image.network(
                    post.user.userAvatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildAvatarFallback(context),
                  ),
                )
              : _buildAvatarFallback(context),
        ),
        const SizedBox(width: 8),

        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.user.userName,
                style: AppTextStyles.label(
                  context,
                  size: 12,
                  weight: FontWeight.w600,
                ),
              ),
              Text(
                '${post.site?.siteName ?? ''} • ${post.timeAgo}',
                style: AppTextStyles.hint(context, size: 10),
              ),
            ],
          ),
        ),

        // More button
        if (onMorePressed != null)
          InkWell(
            onTap: onMorePressed,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.more_horiz,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarFallback(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/user-outline-icon.svg',
        width: 18,
        height: 18,
        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        if (post.postTitle.trim().isNotEmpty) ...[
          Text(
            post.postTitle,
            style: AppTextStyles.label(
              context,
              size: 13,
              weight: FontWeight.w600,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
        ],

        // Content text
        Text(
          post.postContent,
          style: AppTextStyles.label(
            context,
            size: 12,
            weight: FontWeight.w400,
            height: 1.5,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),

        // Image
        if (post.hasImage) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.network(
              post.postImage!,
              width: double.infinity,
              height: context.rh(0.18),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: context.rh(0.18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.broken_image_outlined,
                  size: 36,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Like count
        Row(
          children: [
            Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              size: 14,
              color: post.isLiked ? AppColors.error : AppColors.textTertiary,
            ),
            const SizedBox(width: 4),
            Text(
              '${post.likeCount} suka',
              style: AppTextStyles.caption(context, size: 10),
            ),
          ],
        ),

        // Comments & Shares count
        Row(
          children: [
            Text(
              '${post.commentCount} komentar',
              style: AppTextStyles.caption(context, size: 10),
            ),
            const SizedBox(width: 8),
            Text(
              '${post.shareCount} bagikan',
              style: AppTextStyles.caption(context, size: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          context,
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          label: 'Suka',
          color: post.isLiked ? AppColors.error : AppColors.textSecondary,
          onTap: onLike,
        ),
        _buildActionButton(
          context,
          icon: Icons.chat_bubble_outline,
          label: 'Komentar',
          color: AppColors.textSecondary,
          onTap: onComment,
        ),
        _buildActionButton(
          context,
          icon: Icons.share_outlined,
          label: 'Bagikan',
          color: AppColors.textSecondary,
          onTap: onShare,
        ),
      ],
    );
  }

  Widget _buildActionButton(
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption(
                context,
                size: 11,
                color: color,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
