import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final filteredTasksAsync = ref.watch(filteredTasksProvider);
    final currentFilter = ref.watch(taskFilterProvider);
    final stats = ref.watch(taskStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Task Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/task/create'),
            tooltip: 'Tambah Task',
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Cards
          _buildStatsCards(stats),

          // Filter Chips
          _buildFilterChips(currentFilter),

          // Task List
          Expanded(
            child: filteredTasksAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, stack) => _buildErrorState(error.toString()),
              data: (tasks) {
                if (tasks.isEmpty) {
                  return _buildEmptyState(currentFilter);
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    ref.invalidate(taskListProvider);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(context.rw(0.041)),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _TaskCard(
                        task: tasks[index],
                        onTap: () =>
                            context.push('/task/${tasks[index].taskId}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(TaskStats stats) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Total',
              value: stats.total.toString(),
              color: AppColors.primary,
              icon: Icons.task_alt,
            ),
          ),
          SizedBox(width: context.rw(0.025)),
          Expanded(
            child: _StatCard(
              label: 'Pending',
              value: stats.pending.toString(),
              color: AppColors.warning,
              icon: Icons.pending_actions,
            ),
          ),
          SizedBox(width: context.rw(0.025)),
          Expanded(
            child: _StatCard(
              label: 'Selesai',
              value: stats.completed.toString(),
              color: AppColors.success,
              icon: Icons.check_circle,
            ),
          ),
          SizedBox(width: context.rw(0.025)),
          Expanded(
            child: _StatCard(
              label: 'Terlambat',
              value: stats.overdue.toString(),
              color: AppColors.error,
              icon: Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(TaskFilter currentFilter) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.041),
        vertical: context.rh(0.01),
      ),
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TaskFilter.values.map((filter) {
            final isSelected = filter == currentFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter.label),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(taskFilterProvider.notifier).state = filter;
                },
                backgroundColor: AppColors.surfaceVariant,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(TaskFilter filter) {
    String message;
    switch (filter) {
      case TaskFilter.all:
        message = 'Belum ada task';
      case TaskFilter.pending:
        message = 'Tidak ada task yang menunggu';
      case TaskFilter.inProgress:
        message = 'Tidak ada task yang sedang dikerjakan';
      case TaskFilter.completed:
        message = 'Belum ada task yang selesai';
      case TaskFilter.overdue:
        message = 'Tidak ada task yang terlambat';
      case TaskFilter.dueSoon:
        message = 'Tidak ada task yang segera jatuh tempo';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_outlined,
            size: 80,
            color: AppColors.textTertiary.withValues(alpha: 0.5),
          ),
          SizedBox(height: context.rh(0.02)),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: context.rh(0.03)),
          ElevatedButton.icon(
            onPressed: () => context.push('/task/create'),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Task'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(0.1)),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: context.rh(0.03)),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(taskListProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: context.rh(0.005)),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(18),
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
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const _TaskCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.taskPriority);
    final statusColor = _getStatusColor(task.taskStatus);

    return Card(
      margin: EdgeInsets.only(bottom: context.rh(0.015)),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: task.isOverdue
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(context.rw(0.041)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Priority indicator
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: context.rw(0.03)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.taskName,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (task.taskDescription != null) ...[
                          SizedBox(height: context.rh(0.005)),
                          Text(
                            task.taskDescription!,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(12),
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.taskStatus.label,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(10),
                        fontWeight: FontWeight.w600,
                        color: statusColor,
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
                  // Task type
                  _InfoChip(
                    icon: Icons.category_outlined,
                    label: task.taskType.label,
                    color: AppColors.primary,
                  ),
                  // Priority
                  _InfoChip(
                    icon: Icons.flag_outlined,
                    label: task.taskPriority.label,
                    color: priorityColor,
                  ),
                  // Due date
                  if (task.taskDueDate != null)
                    _InfoChip(
                      icon: task.isOverdue
                          ? Icons.warning_outlined
                          : Icons.calendar_today_outlined,
                      label: DateFormat(
                        'dd MMM yyyy',
                      ).format(task.taskDueDate!),
                      color: task.isOverdue
                          ? AppColors.error
                          : task.isDueSoon
                          ? AppColors.warning
                          : AppColors.textSecondary,
                    ),
                  // Assigned to
                  if (task.assignedToName != null)
                    _InfoChip(
                      icon: Icons.person_outline,
                      label: task.assignedToName!,
                      color: AppColors.info,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
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
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(11),
            color: color,
          ),
        ),
      ],
    );
  }
}
