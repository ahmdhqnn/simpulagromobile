import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(taskListProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.015),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Task',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(28),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1D1D),
                        height: 1.0,
                      ),
                    ),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/plus-outline-icon.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () => context.push('/task/create'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: context.rh(0.024)),

                // Statistics Cards
                _buildStatsCards(stats),

                SizedBox(height: context.rh(0.024)),

                // Filter Tabs
                _buildFilterTabs(currentFilter),

                SizedBox(height: context.rh(0.024)),

                // Task List
                filteredTasksAsync.when(
                  loading: () => _shimmerCard(context, 195),
                  error: (error, stack) => _ErrorCard(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(taskListProvider),
                  ),
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return _EmptyStateCard(
                        height: 195,
                        message: _getEmptyMessage(currentFilter),
                        iconPath: 'assets/icons/task-filled-icon.svg',
                      );
                    }
                    return Column(
                      children: tasks
                          .map(
                            (task) => _TaskCard(
                              task: task,
                              onTap: () => context.push('/task/${task.taskId}'),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),

                SizedBox(height: context.rh(0.02)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(TaskStats stats) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _StatItem(
            icon: 'assets/icons/total-task-outline-icon.svg',
            label: 'Total',
            value: '${stats.total}',
            color: const Color(0xFFE8EFE9),
            iconColor: const Color(0xFF1B5E20),
            textColor: const Color(0xFF1B5E20),
          ),
          const SizedBox(width: 7),
          _StatItem(
            icon: 'assets/icons/pending-outline-icon.svg',
            label: 'Pending',
            value: '${stats.pending}',
            color: const Color(0xFFFFF6E9),
            iconColor: const Color(0xFFFFA929),
            textColor: const Color(0xFFFFA929),
          ),
          const SizedBox(width: 7),
          _StatItem(
            icon: 'assets/icons/check-task-outline-icon.svg',
            label: 'Selesai',
            value: '${stats.completed}',
            color: const Color(0xFFEDF7EE),
            iconColor: const Color(0xFF4CAF50),
            textColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 7),
          _StatItem(
            icon: 'assets/icons/late-task-outline-icon.svg',
            label: 'terlambat',
            value: '${stats.overdue}',
            color: const Color(0xFFFDEEEE),
            iconColor: const Color(0xFFEF5350),
            textColor: const Color(0xFFEF5350),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(TaskFilter currentFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterTab(
            label: 'Semua',
            isSelected: currentFilter == TaskFilter.all,
            onTap: () =>
                ref.read(taskFilterProvider.notifier).state = TaskFilter.all,
          ),
          const SizedBox(width: 2),
          _FilterTab(
            label: 'Menunggu',
            isSelected: currentFilter == TaskFilter.pending,
            onTap: () => ref.read(taskFilterProvider.notifier).state =
                TaskFilter.pending,
          ),
          const SizedBox(width: 2),
          _FilterTab(
            label: 'Dikerjakan',
            isSelected: currentFilter == TaskFilter.inProgress,
            onTap: () => ref.read(taskFilterProvider.notifier).state =
                TaskFilter.inProgress,
          ),
          const SizedBox(width: 2),
          _FilterTab(
            label: 'Selesai',
            isSelected: currentFilter == TaskFilter.completed,
            onTap: () => ref.read(taskFilterProvider.notifier).state =
                TaskFilter.completed,
          ),
        ],
      ),
    );
  }

  Widget _shimmerCard(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  String _getEmptyMessage(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'Belum ada task';
      case TaskFilter.pending:
        return 'Tidak ada task yang menunggu';
      case TaskFilter.inProgress:
        return 'Tidak ada task yang sedang dikerjakan';
      case TaskFilter.completed:
        return 'Belum ada task yang selesai';
      case TaskFilter.overdue:
        return 'Tidak ada task yang terlambat';
      case TaskFilter.dueSoon:
        return 'Tidak ada task yang segera jatuh tempo';
    }
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final Color iconColor;
  final Color textColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.rh(0.012),
          horizontal: context.rw(0.01),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            SizedBox(height: context.rh(0.004)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: context.sp(20),
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
            SizedBox(height: context.rh(0.002)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: context.sp(11),
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF1D1D1D)
                  : const Color(0x7F1D1D1D),
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              height: 1.83,
            ),
          ),
        ),
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
    final statusColor = _getStatusColor(task.taskStatus);
    final priorityColor = _getPriorityColor(task.taskPriority);

    return Container(
      margin: EdgeInsets.only(bottom: context.rh(0.012)),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: task.isOverdue
            ? Border.all(
                color: const Color(0xFFEF5350).withValues(alpha: 0.3),
                width: 2,
              )
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority indicator bar
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
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                          height: 1.2,
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
                            fontWeight: FontWeight.w300,
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.6),
                            height: 1.5,
                          ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusLabel(task.taskStatus),
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
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

            // Task metadata
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                // Task type
                _MetaChip(
                  icon: Icons.category_outlined,
                  label: task.taskType.label,
                  color: AppColors.primary,
                ),
                // Priority
                if (task.taskPriority != TaskPriority.medium)
                  _MetaChip(
                    icon: Icons.flag_outlined,
                    label: task.taskPriority.label,
                    color: priorityColor,
                  ),
                // Due date
                if (task.taskDueDate != null)
                  _MetaChip(
                    icon: task.isOverdue
                        ? Icons.warning_outlined
                        : Icons.calendar_today_outlined,
                    label: DateFormat('dd MMM yyyy').format(task.taskDueDate!),
                    color: task.isOverdue
                        ? const Color(0xFFEF5350)
                        : task.isDueSoon
                        ? const Color(0xFFFFA929)
                        : const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                  ),
                // Assigned to
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
        return const Color(0xFFFFA929);
      case TaskStatus.inProgress:
        return const Color(0xFF42A5F5);
      case TaskStatus.completed:
        return const Color(0xFF4CAF50);
      case TaskStatus.cancelled:
        return const Color(0xFFEF5350);
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF4CAF50);
      case TaskPriority.medium:
        return const Color(0xFFFFA929);
      case TaskPriority.high:
        return const Color(0xFFEF5350);
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
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(11),
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final double height;
  final String message;
  final String? iconPath;

  const _EmptyStateCard({
    required this.height,
    required this.message,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath ?? 'assets/icons/task-filled-icon.svg',
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: context.rh(0.005)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 28),
          SizedBox(height: context.rh(0.01)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              color: AppColors.error,
            ),
          ),
          SizedBox(height: context.rh(0.01)),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Coba Lagi'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }
}
