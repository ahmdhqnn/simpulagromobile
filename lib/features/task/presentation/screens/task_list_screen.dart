import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card_widget.dart';

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
          onRefresh: () async => ref.invalidate(taskListProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.015),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: context.rh(0.024)),
                _buildStatsCards(context, stats),
                SizedBox(height: context.rh(0.024)),
                _buildFilterTabs(context, currentFilter),
                SizedBox(height: context.rh(0.024)),
                filteredTasksAsync.when(
                  loading: () => const LoadingCardWidget(
                    height: 195,
                    radius: AppRadius.lg,
                  ),
                  error: (error, _) => ErrorStateCardWidget(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(taskListProvider),
                  ),
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return InfoStateWidget.svg(
                        svgIconPath: 'assets/icons/task-filled-icon.svg',
                        message: _getEmptyMessage(currentFilter),
                        height: 195,
                      );
                    }
                    return Column(
                      children: tasks
                          .map(
                            (task) => TaskCardWidget(
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Task',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(28),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
        CircularBackButtonWidget(
          onPressed: () => context.push('/task/create'),
          svgIconPath: 'assets/icons/plus-outline-icon.svg',
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context, TaskStats stats) {
    return Container(
      height: 115,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _TaskStatItem(
            icon: 'assets/icons/total-task-outline-icon.svg',
            label: 'Total',
            value: '${stats.total}',
            color: AppColors.softGreenAlt,
            iconColor: AppColors.primary,
            textColor: AppColors.primary,
          ),
          const SizedBox(width: 7),
          _TaskStatItem(
            icon: 'assets/icons/pending-outline-icon.svg',
            label: 'Menunggu',
            value: '${stats.pending}',
            color: AppColors.softOrange,
            iconColor: AppColors.warning,
            textColor: AppColors.warning,
          ),
          const SizedBox(width: 7),
          _TaskStatItem(
            icon: 'assets/icons/check-task-outline-icon.svg',
            label: 'Selesai',
            value: '${stats.completed}',
            color: AppColors.softGreen,
            iconColor: AppColors.success,
            textColor: AppColors.success,
          ),
          const SizedBox(width: 7),
          _TaskStatItem(
            icon: 'assets/icons/late-task-outline-icon.svg',
            label: 'terlambat',
            value: '${stats.overdue}',
            color: const Color(0xFFFDEEEE),
            iconColor: AppColors.error,
            textColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, TaskFilter currentFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterPill(
            label: 'Semua',
            isSelected: currentFilter == TaskFilter.all,
            onTap: () =>
                ref.read(taskFilterProvider.notifier).state = TaskFilter.all,
          ),
          const SizedBox(width: 2),
          _FilterPill(
            label: 'Menunggu',
            isSelected: currentFilter == TaskFilter.pending,
            onTap: () => ref.read(taskFilterProvider.notifier).state =
                TaskFilter.pending,
          ),
          const SizedBox(width: 2),
          _FilterPill(
            label: 'Dikerjakan',
            isSelected: currentFilter == TaskFilter.inProgress,
            onTap: () => ref.read(taskFilterProvider.notifier).state =
                TaskFilter.inProgress,
          ),
          const SizedBox(width: 2),
          _FilterPill(
            label: 'Selesai',
            isSelected: currentFilter == TaskFilter.completed,
            onTap: () => ref.read(taskFilterProvider.notifier).state =
                TaskFilter.completed,
          ),
        ],
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

class _TaskStatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final Color iconColor;
  final Color textColor;

  const _TaskStatItem({
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
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
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
                  ? AppColors.textPrimary
                  : AppColors.textPrimary.withValues(alpha: 0.5),
              fontSize: 12,
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w400,
              height: 1.83,
            ),
          ),
        ),
      ),
    );
  }
}
