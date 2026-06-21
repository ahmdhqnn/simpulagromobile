import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';

class ProfileForumCardWidget extends StatefulWidget {
  const ProfileForumCardWidget({super.key});

  @override
  State<ProfileForumCardWidget> createState() => _ProfileForumCardWidgetState();
}

class _ProfileForumCardWidgetState extends State<ProfileForumCardWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const IconBadgeWidget.svg(
                    svgIconPath: 'assets/icons/forum-filled-icon.svg',
                    background: AppColors.softBlue,
                    tint: AppColors.info,
                    radius: 10,
                  ),
                  SizedBox(width: context.rw(0.02)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.profileForumManagement,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w300,
                            color: AppColors.textPrimary,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          context.l10n.profileForumManagementSubtitle,
                          style: AppTextStyles.hint(context),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    _expanded
                        ? 'assets/icons/chevron-down-icon.svg'
                        : 'assets/icons/chevron-right-icon.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _ForumItem(
                    iconPath: 'assets/icons/comment-outline-icon.svg',
                    title: context.l10n.profileMyPosts,
                    subtitle: context.l10n.profileMyPostsSubtitle,
                    onTap: () => context.push('/forum/my-posts'),
                  ),
                  const SizedBox(height: 12),
                  _ForumItem(
                    iconPath: 'assets/icons/like-outline-icon.svg',
                    title: context.l10n.profileLikedPosts,
                    subtitle: context.l10n.profileLikedPostsSubtitle,
                    onTap: () => context.push('/forum/liked-posts'),
                  ),
                  const SizedBox(height: 12),
                  _ForumItem(
                    iconPath: 'assets/icons/message-outline-icon.svg',
                    title: context.l10n.profileMyComments,
                    subtitle: context.l10n.profileMyCommentsSubtitle,
                    onTap: () => context.push('/forum/my-comments'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ForumItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ForumItem({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.hint(context, size: 11)),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/chevron-right-icon.svg',
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
