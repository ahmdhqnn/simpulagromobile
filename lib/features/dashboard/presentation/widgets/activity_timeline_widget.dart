import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

/// Activity timeline widget for dashboard
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
          borderRadius: BorderRadius.circular(16),
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
                'Belum ada aktivitas',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                  color: AppColors.textSecondary,
                ),
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to full activity log
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
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
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (activity.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  activity.description!,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 4),
              Text(
                _formatTime(activity.timestamp),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(11),
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit yang lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam yang lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }
}

/// Activity item model
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

  // Mock data generator
  static List<ActivityItem> mockActivities() {
    return [
      ActivityItem(
        title: 'Task Selesai',
        description: 'Pemupukan NPK Tahap 1 telah diselesaikan',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        icon: Icons.check_circle,
        color: AppColors.success,
        type: ActivityType.taskCompleted,
      ),
      ActivityItem(
        title: 'Sensor Alert',
        description: 'Suhu terlalu tinggi (35°C)',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        icon: Icons.warning,
        color: AppColors.warning,
        type: ActivityType.alert,
      ),
      ActivityItem(
        title: 'Task Baru',
        description: 'Penyemprotan Pestisida ditambahkan',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        icon: Icons.add_task,
        color: AppColors.primary,
        type: ActivityType.taskCreated,
      ),
      ActivityItem(
        title: 'Data Sensor',
        description: 'Pembacaan sensor berhasil diperbarui',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        icon: Icons.sensors,
        color: AppColors.info,
        type: ActivityType.sensorUpdate,
      ),
      ActivityItem(
        title: 'Tanaman Diupdate',
        description: 'Data tanaman Padi IR64 diperbarui',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        icon: Icons.grass,
        color: AppColors.success,
        type: ActivityType.plantUpdate,
      ),
    ];
  }
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
