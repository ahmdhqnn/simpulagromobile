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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Ink(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
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
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final siteName = post.site?.siteName.trim() ?? '';
    final metaText = siteName.isEmpty
        ? post.timeAgo
        : '$siteName - ${post.timeAgo}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: post.user.userAvatar != null
              ? ClipOval(
                  child: Image.network(
                    post.user.userAvatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildAvatarFallback(context),
                  ),
                )
              : _buildAvatarFallback(context),
        ),
        const SizedBox(width: 8),
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
              Text(metaText, style: AppTextStyles.hint(context, size: 10)),
            ],
          ),
        ),
        if (onMorePressed != null)
          InkWell(
            onTap: onMorePressed,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                'assets/icons/more-icon.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarFallback(BuildContext context) {
    return Center(
      child: Text(
        _avatarInitial,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(18),
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  String get _avatarInitial {
    final trimmed = post.user.userName.trim();
    if (trimmed.isEmpty) return 'U';
    return trimmed.substring(0, 1).toUpperCase();
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
