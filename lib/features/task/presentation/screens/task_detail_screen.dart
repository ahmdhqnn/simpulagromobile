import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_detail_widgets.dart';

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
                  onSelected: (value) =>
                      _onMenuAction(context, ref, task, value),
                  itemBuilder: (_) => _buildMenuItems(task),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: taskAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => _buildErrorState(context, error.toString()),
        data: (task) => _buildContent(context, ref, task),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(Task task) {
    return [
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
            Text('Hapus', style: TextStyle(color: AppColors.error)),
          ],
        ),
      ),
    ];
  }

  void _onMenuAction(
    BuildContext context,
    WidgetRef ref,
    Task task,
    String value,
  ) {
    switch (value) {
      case 'edit':
        context.push('/task/$taskId/edit');
      case 'delete':
        _showDeleteDialog(context, ref, task);
      case 'complete':
        _completeTask(context, ref, task);
    }
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Task task) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.rw(0.041)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(context, task),
          SizedBox(height: context.rh(0.02)),
          _buildInfoCard(context, task),
          SizedBox(height: context.rh(0.02)),
          _buildDetailsCard(context, task),
          if (task.notes != null) ...[
            SizedBox(height: context.rh(0.02)),
            _buildNotesCard(context, task),
          ],
          SizedBox(height: context.rh(0.02)),
          _buildTimelineCard(context, task),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, Task task) {
    final statusColor = _statusColor(task.taskStatus);
    final priorityColor = _priorityColor(task.taskPriority);

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
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
            style: AppTextStyles.cardTitle(
              context,
              18,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          if (task.taskDescription != null) ...[
            SizedBox(height: context.rh(0.01)),
            Text(
              task.taskDescription!,
              style: AppTextStyles.caption(context, size: 13),
            ),
          ],
          SizedBox(height: context.rh(0.02)),
          Row(
            children: [
              Expanded(
                child: TaskStatusBadgeWidget(
                  label: 'Status',
                  value: task.taskStatus.label,
                  color: statusColor,
                ),
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: TaskStatusBadgeWidget(
                  label: 'Prioritas',
                  value: task.taskPriority.label,
                  color: priorityColor,
                ),
              ),
            ],
          ),
          if (task.isOverdue) ...[
            SizedBox(height: context.rh(0.015)),
            _WarningBanner(
              icon: Icons.warning,
              message: 'Task ini sudah melewati batas waktu!',
              color: AppColors.error,
            ),
          ] else if (task.isDueSoon) ...[
            SizedBox(height: context.rh(0.015)),
            _WarningBanner(
              icon: Icons.access_time,
              message: 'Task ini akan jatuh tempo dalam 24 jam',
              color: AppColors.warning,
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
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Task', style: AppTextStyles.cardTitle(context, 14)),
          SizedBox(height: context.rh(0.015)),
          TaskInfoRowWidget(
            icon: Icons.category_outlined,
            label: 'Jenis Task',
            value: task.taskType.label,
          ),
          if (task.siteName != null)
            TaskInfoRowWidget(
              icon: Icons.location_on_outlined,
              label: 'Site',
              value: task.siteName!,
            ),
          if (task.plantName != null)
            TaskInfoRowWidget(
              icon: Icons.grass_outlined,
              label: 'Tanaman',
              value: task.plantName!,
            ),
          if (task.assignedToName != null)
            TaskInfoRowWidget(
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
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Waktu', style: AppTextStyles.cardTitle(context, 14)),
          SizedBox(height: context.rh(0.015)),
          if (task.taskDueDate != null)
            TaskInfoRowWidget(
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
            TaskInfoRowWidget(
              icon: Icons.check_circle_outline,
              label: 'Selesai Pada',
              value: DateFormat(
                'dd MMMM yyyy, HH:mm',
              ).format(task.taskCompletedDate!),
              valueColor: AppColors.success,
            ),
          if (task.createdAt != null)
            TaskInfoRowWidget(
              icon: Icons.add_circle_outline,
              label: 'Dibuat Pada',
              value: DateFormat('dd MMMM yyyy, HH:mm').format(task.createdAt!),
            ),
          if (task.updatedAt != null)
            TaskInfoRowWidget(
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
        borderRadius: BorderRadius.circular(AppRadius.md),
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
              Text('Catatan', style: AppTextStyles.cardTitle(context, 14)),
            ],
          ),
          SizedBox(height: context.rh(0.01)),
          Text(task.notes!, style: AppTextStyles.caption(context, size: 13)),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context, Task task) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timeline', style: AppTextStyles.cardTitle(context, 14)),
          SizedBox(height: context.rh(0.015)),
          if (task.createdAt != null)
            TaskTimelineItemWidget(
              icon: Icons.add_circle,
              title: 'Task Dibuat',
              date: task.createdAt!,
              isFirst: true,
            ),
          if (task.taskStatus == TaskStatus.inProgress)
            TaskTimelineItemWidget(
              icon: Icons.play_circle,
              title: 'Task Sedang Dikerjakan',
              date: task.updatedAt ?? DateTime.now(),
            ),
          if (task.taskCompletedDate != null)
            TaskTimelineItemWidget(
              icon: Icons.check_circle,
              title: 'Task Selesai',
              date: task.taskCompletedDate!,
              color: AppColors.success,
            ),
          if (task.taskDueDate != null &&
              task.taskStatus != TaskStatus.completed)
            TaskTimelineItemWidget(
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
            Text('Terjadi kesalahan', style: AppTextStyles.cardTitle(context)),
            SizedBox(height: context.rh(0.01)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context, size: 13),
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

  Color _statusColor(TaskStatus s) {
    switch (s) {
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

  Color _priorityColor(TaskPriority p) {
    switch (p) {
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

class _WarningBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  const _WarningBanner({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
