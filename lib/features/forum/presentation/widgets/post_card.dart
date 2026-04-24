import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/post.dart';

/// Post Card Widget
/// Reusable widget untuk menampilkan post
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
            // Header (User Info) - Outside white card
            _buildHeader(context),

            const SizedBox(height: 5),

            // White Card Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content
                  _buildContent(context),

                  const SizedBox(height: 5),

                  // Stats (Likes, Comments, Shares)
                  _buildStats(context),

                  const SizedBox(height: 7),

                  // Actions (Like, Comment, Share buttons)
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
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/user-outline-icon.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF1D1D1D),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),

        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.user.userName,
                style: const TextStyle(
                  color: Color(0xFF1D1D1D),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.83,
                ),
              ),
              Text(
                '${post.site?.siteName ?? 'Unknown Site'} - ${post.timeAgo}',
                style: const TextStyle(
                  color: Color(0xFF1D1D1D),
                  fontSize: 9,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w300,
                  height: 2.44,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text Content
        Text(
          post.postContent,
          style: const TextStyle(
            color: Color(0xFF1D1D1D),
            fontSize: 10,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.40,
          ),
        ),

        // Image (if exists)
        if (post.hasImage) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              post.postImage!,
              width: double.infinity,
              height: 131,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 131,
                color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.broken_image, size: 40),
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
        // Reaction indicators (colored circles)
        Row(
          children: [
            _buildReactionCircle(const Color(0xFFA75B5B)),
            _buildReactionCircle(const Color(0xFF32A527)),
            _buildReactionCircle(const Color(0xFFFF8181)),
            const SizedBox(width: 2),
            Text(
              '${post.likeCount}',
              style: const TextStyle(
                color: Color(0xFF1D1D1D),
                fontSize: 9,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w300,
                height: 1.56,
              ),
            ),
          ],
        ),

        // Comments & Shares count
        Row(
          children: [
            Text(
              '${post.commentCount} Comment',
              style: const TextStyle(
                color: Color(0xFF1D1D1D),
                fontSize: 9,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w300,
                height: 1.56,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '|',
                style: TextStyle(
                  color: Color(0xFF1D1D1D),
                  fontSize: 9,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w300,
                  height: 1.56,
                ),
              ),
            ),
            Text(
              '${post.shareCount} Share',
              style: const TextStyle(
                color: Color(0xFF1D1D1D),
                fontSize: 9,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w300,
                height: 1.56,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReactionCircle(Color color) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.only(left: -4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: post.isLiked
              ? 'assets/icons/like-filled-icon.svg'
              : 'assets/icons/like-outline-icon.svg',
          label: 'Like',
          onTap: onLike,
          isActive: post.isLiked,
        ),
        const SizedBox(width: 30),
        _buildActionButton(
          icon: 'assets/icons/comment-outline-icon.svg',
          label: 'Comment',
          onTap: onComment,
        ),
        const SizedBox(width: 30),
        _buildActionButton(
          icon: 'assets/icons/reshare-outline-icon.svg',
          label: 'Share',
          onTap: onShare,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              isActive ? const Color(0xFF32A527) : const Color(0xFF1D1D1D),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF32A527)
                  : const Color(0xFF1D1D1D),
              fontSize: 10,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              height: 1.40,
            ),
          ),
        ],
      ),
    );
  }
}
