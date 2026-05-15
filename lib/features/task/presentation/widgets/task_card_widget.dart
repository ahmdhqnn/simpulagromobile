import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/task.dart';

class TaskCardWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCardWidget({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(task.taskStatus);
    final priorityColor = _getPriorityColor(task.taskPriority);

    return Container(
      margin: EdgeInsets.only(bottom: context.rh(0.012)),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: task.isOverdue
            ? Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: 2,
              )
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: context.rw(0.025)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.taskName,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.taskDescription != null) ...[
                        SizedBox(height: context.rh(0.005)),
                        Text(
                          task.taskDescription!,
                          style: AppTextStyles.hint(context, height: 1.5),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: context.rw(0.02)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    _getStatusLabel(task.taskStatus),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rh(0.015)),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _MetaChip(
                  icon: Icons.category_outlined,
                  label: task.taskType.label,
                  color: AppColors.primary,
                ),
                if (task.taskPriority != TaskPriority.medium)
                  _MetaChip(
                    icon: Icons.flag_outlined,
                    label: task.taskPriority.label,
                    color: priorityColor,
                  ),
                if (task.taskDueDate != null)
                  _MetaChip(
                    icon: task.isOverdue
                        ? Icons.warning_outlined
                        : Icons.calendar_today_outlined,
                    label: DateFormat('dd MMM yyyy').format(task.taskDueDate!),
                    color: task.isOverdue
                        ? AppColors.error
                        : task.isDueSoon
                        ? AppColors.warning
                        : AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                if (task.assignedToName != null)
                  _MetaChip(
                    icon: Icons.person_outline,
                    label: task.assignedToName!,
                    color: AppColors.info,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return AppColors.warning;
      case TaskStatus.inProgress:
        return AppColors.info;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.cancelled:
        return AppColors.error;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.urgent:
        return const Color(0xFFD32F2F);
    }
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Menunggu';
      case TaskStatus.inProgress:
        return 'Dikerjakan';
      case TaskStatus.completed:
        return 'Selesai';
      case TaskStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(11),
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
