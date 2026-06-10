import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../domain/entities/task.dart';
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
    final l10n = context.l10n;
    final hPad = context.rw(0.051);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(taskListProvider);

            await ref
                .read(taskListProvider.future)
                .catchError((Object _) => <Task>[]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    hPad,
                    context.rh(0.015),
                    hPad,
                    0,
                  ),
                  child: _buildHeader(context),
                ),
                SizedBox(height: context.rh(0.024)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: _buildStatsCards(context, stats),
                ),
                SizedBox(height: context.rh(0.012)),
                _buildFilterTabs(context, currentFilter, hPad),
                SizedBox(height: context.rh(0.012)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: filteredTasksAsync.when(
                    skipLoadingOnReload: true,
                    skipLoadingOnRefresh: true,
                    skipError: true,
                    loading: () => buildListSkeleton(count: 6, type: 'task'),
                    error: (error, _) => ErrorStateCardWidget(
                      message: error.toString(),
                      onRetry: () => ref.invalidate(taskListProvider),
                    ),
                    data: (tasks) {
                      if (tasks.isEmpty) {
                        return InfoStateWidget.svg(
                          svgIconPath: 'assets/icons/task-filled-icon.svg',
                          message: _getEmptyMessage(currentFilter, l10n),
                          height: 195,
                        );
                      }
                      return Column(
                        children: tasks
                            .map(
                              (task) => TaskCardWidget(
                                task: task,
                                onTap: () async {
                                  final result = await context.push<bool>(
                                    '/task/${task.taskId}',
                                  );
                                  if (result == true) {
                                    ref.invalidate(taskListProvider);
                                  }
                                },
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
                SizedBox(height: bottomNavigationContentSpace(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        CircularBackButtonWidget(
          onPressed: () async {
            final result = await context.push<bool>('/task/create');
            if (result == true) {
              ref.invalidate(taskListProvider);
            }
          },
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
            label: context.l10n.commonTotal,
            value: '${stats.total}',
            color: AppColors.softGreenAlt,
            iconColor: AppColors.primary,
            textColor: AppColors.primary,
          ),
          const SizedBox(width: 7),
          _TaskStatItem(
            icon: 'assets/icons/pending-outline-icon.svg',
            label: context.l10n.commonPending,
            value: '${stats.pending}',
            color: AppColors.softOrange,
            iconColor: AppColors.warning,
            textColor: AppColors.warning,
          ),
          const SizedBox(width: 7),
          _TaskStatItem(
            icon: 'assets/icons/total-task-outline-icon.svg',
            label: context.l10n.commonInProgress,
            value: '${stats.progress}',
            color: AppColors.softBlue,
            iconColor: AppColors.info,
            textColor: AppColors.info,
          ),
          const SizedBox(width: 7),
          _TaskStatItem(
            icon: 'assets/icons/check-task-outline-icon.svg',
            label: context.l10n.commonCompleted,
            value: '${stats.complite}',
            color: AppColors.softGreen,
            iconColor: AppColors.success,
            textColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(
    BuildContext context,
    TaskFilter currentFilter,
    double horizontalInset,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalInset),
        itemCount: TaskFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final filter = TaskFilter.values[index];
          return _FilterPill(
            label: filter.localizedLabel(context.l10n),
            isSelected: currentFilter == filter,
            onTap: () => ref.read(taskFilterProvider.notifier).state = filter,
          );
        },
      ),
    );
  }

  String _getEmptyMessage(TaskFilter filter, AppLocalizations l10n) {
    switch (filter) {
      case TaskFilter.all:
        return l10n.taskEmptyAll;
      case TaskFilter.pending:
        return l10n.taskEmptyPending;
      case TaskFilter.progress:
        return l10n.taskEmptyProgress;
      case TaskFilter.complite:
        return l10n.taskEmptyCompleted;
      case TaskFilter.failed:
        return l10n.taskEmptyFailed;
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
