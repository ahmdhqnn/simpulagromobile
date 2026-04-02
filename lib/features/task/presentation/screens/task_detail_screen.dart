import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Task'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          taskAsync.whenOrNull(
                data: (task) => PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        context.push('/task/$taskId/edit');
                        break;
                      case 'delete':
                        _showDeleteDialog(context, ref, task);
                        break;
                      case 'complete':
                        _completeTask(context, ref, task);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (task.taskStatus != TaskStatus.completed)
                      const PopupMenuItem(
                        value: 'complete',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 20),
                            SizedBox(width: 12),
                            Text('Tandai Selesai'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: AppColors.error),
                          SizedBox(width: 12),
                          Text(
                            'Hapus',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: taskAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => _buildErrorState(context, error.toString()),
        data: (task) => _buildContent(context, task),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Task task) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.rw(0.041)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          _buildStatusCard(context, task),
          SizedBox(height: context.rh(0.02)),

          // Task Info Card
          _buildInfoCard(context, task),
          SizedBox(height: context.rh(0.02)),

          // Details Card
          _buildDetailsCard(context, task),
          SizedBox(height: context.rh(0.02)),

          // Notes Card
          if (task.notes != null) ...[
            _buildNotesCard(context, task),
            SizedBox(height: context.rh(0.02)),
          ],

          // Timeline Card
          _buildTimelineCard(context, task),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, Task task) {
    final statusColor = _getStatusColor(task.taskStatus);
    final priorityColor = _getPriorityColor(task.taskPriority);

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isOverdue
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.taskName,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(18),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (task.taskDescription != null) ...[
            SizedBox(height: context.rh(0.01)),
            Text(
              task.taskDescription!,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: context.rh(0.02)),
          Row(
            children: [
              Expanded(
                child: _StatusBadge(
                  label: 'Status',
                  value: task.taskStatus.label,
                  color: statusColor,
                ),
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: _StatusBadge(
                  label: 'Prioritas',
                  value: task.taskPriority.label,
                  color: priorityColor,
                ),
              ),
            ],
          ),
          if (task.isOverdue) ...[
            SizedBox(height: context.rh(0.015)),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Task ini sudah melewati batas waktu!',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (task.isDueSoon) ...[
            SizedBox(height: context.rh(0.015)),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Task ini akan jatuh tempo dalam 24 jam',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Task task) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Task',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.015)),
          _InfoRow(
            icon: Icons.category_outlined,
            label: 'Jenis Task',
            value: task.taskType.label,
          ),
          if (task.siteName != null)
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Site',
              value: task.siteName!,
            ),
          if (task.plantName != null)
            _InfoRow(
              icon: Icons.grass_outlined,
              label: 'Tanaman',
              value: task.plantName!,
            ),
          if (task.assignedToName != null)
            _InfoRow(
              icon: Icons.person_outline,
              label: 'Ditugaskan ke',
              value: task.assignedToName!,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, Task task) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Waktu',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.015)),
          if (task.taskDueDate != null)
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Batas Waktu',
              value: DateFormat(
                'dd MMMM yyyy, HH:mm',
              ).format(task.taskDueDate!),
              valueColor: task.isOverdue
                  ? AppColors.error
                  : task.isDueSoon
                  ? AppColors.warning
                  : null,
            ),
          if (task.taskCompletedDate != null)
            _InfoRow(
              icon: Icons.check_circle_outline,
              label: 'Selesai Pada',
              value: DateFormat(
                'dd MMMM yyyy, HH:mm',
              ).format(task.taskCompletedDate!),
              valueColor: AppColors.success,
            ),
          if (task.createdAt != null)
            _InfoRow(
              icon: Icons.add_circle_outline,
              label: 'Dibuat Pada',
              value: DateFormat('dd MMMM yyyy, HH:mm').format(task.createdAt!),
            ),
          if (task.updatedAt != null)
            _InfoRow(
              icon: Icons.update_outlined,
              label: 'Terakhir Diupdate',
              value: DateFormat('dd MMMM yyyy, HH:mm').format(task.updatedAt!),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, Task task) {
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
              const Icon(
                Icons.note_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Catatan',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.01)),
          Text(
            task.notes!,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context, Task task) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.015)),
          if (task.createdAt != null)
            _TimelineItem(
              icon: Icons.add_circle,
              title: 'Task Dibuat',
              date: task.createdAt!,
              isFirst: true,
            ),
          if (task.taskStatus == TaskStatus.inProgress)
            _TimelineItem(
              icon: Icons.play_circle,
              title: 'Task Sedang Dikerjakan',
              date: task.updatedAt ?? DateTime.now(),
            ),
          if (task.taskCompletedDate != null)
            _TimelineItem(
              icon: Icons.check_circle,
              title: 'Task Selesai',
              date: task.taskCompletedDate!,
              color: AppColors.success,
            ),
          if (task.taskDueDate != null &&
              task.taskStatus != TaskStatus.completed)
            _TimelineItem(
              icon: Icons.flag,
              title: 'Batas Waktu',
              date: task.taskDueDate!,
              color: task.isOverdue ? AppColors.error : AppColors.warning,
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.051)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Terjadi kesalahan',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Task'),
        content: Text(
          'Apakah Anda yakin ingin menghapus task "${task.taskName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final repository = ref.read(taskRepositoryProvider);
              final result = await repository.deleteTask(task.taskId);
              result.fold(
                (failure) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Gagal menghapus task: ${failure.message}',
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                (_) {
                  ref.invalidate(taskListProvider);
                  if (context.mounted) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task berhasil dihapus'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _completeTask(BuildContext context, WidgetRef ref, Task task) async {
    final repository = ref.read(taskRepositoryProvider);
    final result = await repository.completeTask(task.taskId);
    result.fold(
      (failure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyelesaikan task: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      (_) {
        ref.invalidate(taskListProvider);
        ref.invalidate(taskDetailProvider(task.taskId));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task berhasil diselesaikan'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
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
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(11),
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(0.012)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: context.rw(0.03)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(11),
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? AppColors.textPrimary,
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

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final DateTime date;
  final Color? color;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.date,
    this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(width: 2, height: 12, color: AppColors.divider),
            Icon(icon, size: 20, color: itemColor),
            if (!isLast)
              Container(width: 2, height: 12, color: AppColors.divider),
          ],
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: context.rh(0.015)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMMM yyyy, HH:mm').format(date),
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(11),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
