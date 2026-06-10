import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';

class ActivityTimelineWidget extends StatelessWidget {
  final List<ActivityItem> activities;

  const ActivityTimelineWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Container(
        padding: EdgeInsets.all(context.rw(0.051)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.history_outlined,
                size: 48,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.dashboardNoActivities,
                style: AppTextStyles.caption(context, size: 13),
              ),
            ],
          ),
        ),
      );
    }

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
            children: [
              Text(
                context.l10n.dashboardRecentActivities,
                style: AppTextStyles.cardTitle(context, 14),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  context.l10n.commonViewAll,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.01)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 5 ? 5 : activities.length,
            separatorBuilder: (_, __) => SizedBox(height: context.rh(0.015)),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _ActivityItem(activity: activity);
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final ActivityItem activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(context.rw(0.02)),
          decoration: BoxDecoration(
            color: activity.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(activity.icon, size: 16, color: activity.color),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: AppTextStyles.label(
                  context,
                  size: 13,
                  weight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              if (activity.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  activity.description!,
                  style: AppTextStyles.caption(context, size: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 4),
              Text(
                _formatTime(context, activity.timestamp),
                style: AppTextStyles.caption(
                  context,
                  size: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    final l10n = context.l10n;

    if (diff.inMinutes < 1) {
      return l10n.timeJustNow;
    } else if (diff.inMinutes < 60) {
      return l10n.timeMinutesAgo(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return l10n.timeHoursAgo(diff.inHours);
    } else if (diff.inDays < 7) {
      return l10n.timeDaysAgo(diff.inDays);
    } else {
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }
}

class ActivityItem {
  final String title;
  final String? description;
  final DateTime timestamp;
  final IconData icon;
  final Color color;
  final ActivityType type;

  const ActivityItem({
    required this.title,
    this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
    required this.type,
  });
}

enum ActivityType {
  taskCreated,
  taskCompleted,
  taskUpdated,
  alert,
  sensorUpdate,
  plantUpdate,
  deviceUpdate,
}
