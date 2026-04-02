import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

/// Task overview widget for dashboard
class TaskOverviewWidget extends StatelessWidget {
  final int totalTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int completedTasks;
  final int overdueTasks;

  const TaskOverviewWidget({
    super.key,
    required this.totalTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.overdueTasks,
  });

  @override
  Widget build(BuildContext context) {
    final completionRate = totalTasks > 0
        ? (completedTasks / totalTasks) * 100
        : 0.0;

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
                'Ringkasan Task',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/tasks'),
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
          SizedBox(height: context.rh(0.015)),

          // Completion Rate
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tingkat Penyelesaian',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${completionRate.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(24),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(context.rw(0.03)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.task_alt, color: AppColors.primary, size: 32),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.02)),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate / 100,
              minHeight: 8,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: context.rh(0.02)),

          // Task Stats
          Row(
            children: [
              Expanded(
                child: _TaskStatItem(
                  label: 'Pending',
                  value: pendingTasks.toString(),
                  color: AppColors.warning,
                  icon: Icons.pending_actions,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: _TaskStatItem(
                  label: 'Dikerjakan',
                  value: inProgressTasks.toString(),
                  color: AppColors.info,
                  icon: Icons.play_circle,
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.015)),
          Row(
            children: [
              Expanded(
                child: _TaskStatItem(
                  label: 'Selesai',
                  value: completedTasks.toString(),
                  color: AppColors.success,
                  icon: Icons.check_circle,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: _TaskStatItem(
                  label: 'Terlambat',
                  value: overdueTasks.toString(),
                  color: AppColors.error,
                  icon: Icons.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _TaskStatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.03)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: context.rw(0.02)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(10),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
