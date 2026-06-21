import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../domain/entities/notification.dart';
import '../providers/notification_provider.dart';
import '../../../../shared/widgets/action_popup_menu_button.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  String _getIconPath(NotificationType type) {
    switch (type) {
      case NotificationType.recommendation:
        return 'assets/icons/recomendation-filled-icon.svg';
      case NotificationType.deviceAlert:
        return 'assets/icons/warning-outline-icon.svg';
      case NotificationType.siteInvite:
        return 'assets/icons/home-outline-icon.svg';
      case NotificationType.taskAssignment:
        return 'assets/icons/task-outline-icon.svg';
      case NotificationType.forumInteraction:
        return 'assets/icons/forum-outline-icon.svg';
      case NotificationType.general:
        return 'assets/icons/message-outline-icon.svg';
    }
  }

  Color _getAccentColor(NotificationType type) {
    switch (type) {
      case NotificationType.recommendation:
        return AppColors.success;
      case NotificationType.deviceAlert:
        return AppColors.error;
      case NotificationType.siteInvite:
        return AppColors.primary;
      case NotificationType.taskAssignment:
        return AppColors.warning;
      case NotificationType.forumInteraction:
        return AppColors.info;
      case NotificationType.general:
        return AppColors.textPrimary;
    }
  }

  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final hPad = context.rw(0.051);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, context.rh(0.015), hPad, 16),
                child: Row(
                  children: [
                    CircularBackButtonWidget(onPressed: () => context.pop()),
                    const Spacer(),
                    if (notifications.isNotEmpty)
                      MorePopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'read_all') {
                            ref
                                .read(notificationProvider.notifier)
                                .markAllAsRead();
                          } else if (value == 'clear_all') {
                            ref.read(notificationProvider.notifier).clearAll();
                          }
                        },
                        items: const [
                          ActionPopupMenuItem(
                            value: 'read_all',
                            icon: Icons.mark_chat_read_outlined,
                            label: 'Tandai semua dibaca',
                            iconColor: AppColors.textSecondary,
                          ),
                          ActionPopupMenuItem(
                            value: 'clear_all',
                            icon: Icons.delete_outline,
                            label: 'Hapus semua',
                            iconColor: AppColors.error,
                            labelColor: AppColors.error,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (notifications.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Center(
                    child: InfoStateWidget.svg(
                      svgIconPath: 'assets/icons/message-outline-icon.svg',
                      message: 'Belum ada notifikasi saat ini.',
                      height: 200,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 48),
                sliver: SliverList.separated(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return _NotificationCard(
                      notification: notifications[index],
                      accentColor: _getAccentColor(notifications[index].type),
                      iconPath: _getIconPath(notifications[index].type),
                      timeLabel: _timeAgo(notifications[index].timestamp),
                      onTap: () {
                        ref
                            .read(notificationProvider.notifier)
                            .markAsRead(notifications[index].id);
                        final redirectPath = notifications[index].redirectPath;
                        if (redirectPath != null) {
                          context.push(redirectPath);
                        }
                      },
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.accentColor,
    required this.iconPath,
    required this.timeLabel,
    required this.onTap,
  });

  final AppNotification notification;
  final Color accentColor;
  final String iconPath;
  final String timeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.surface
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 5, color: accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            iconPath,
                            colorFilter: ColorFilter.mode(
                              accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: context.sp(14),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                notification.body,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: context.sp(12),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                timeLabel,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: context.sp(10),
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
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
}
