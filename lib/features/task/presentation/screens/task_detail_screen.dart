import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_detail_widgets.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final hPad = context.rw(0.051);
    if (siteId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, context.rh(0.015), hPad, 0),
                child: _buildTopBar(context),
              ),
              SizedBox(height: context.rh(0.024)),
              _buildErrorState(context, 'Pilih site terlebih dahulu', null),
            ],
          ),
        ),
      );
    }

    final taskAsync = ref.watch(taskDetailProvider((siteId, widget.taskId)));
    final task = taskAsync.maybeWhen(data: (data) => data, orElse: () => null);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(taskDetailProvider((siteId, widget.taskId)));

            try {
              await ref.read(
                taskDetailProvider((siteId, widget.taskId)).future,
              );
            } catch (_) {}
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, context.rh(0.015), hPad, 0),
                child: _buildTopBar(context, siteId: siteId, task: task),
              ),
              SizedBox(height: context.rh(0.024)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: taskAsync.when(
                  loading: () => const DetailScreenSkeleton(
                    infoRowCount: 6,
                    hasDescription: true,
                  ),
                  error: (error, _) =>
                      _buildErrorState(context, error.toString(), siteId),
                  data: (task) => _buildContent(context, task),
                ),
              ),
              SizedBox(height: context.rh(0.02)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, {String? siteId, Task? task}) {
    return Row(
      children: [
        CircularBackButtonWidget(onPressed: () => context.pop()),
        const Spacer(),
        if (siteId != null && task != null)
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            onSelected: (value) => _onMenuAction(context, siteId, task, value),
            itemBuilder: (_) => _buildMenuItems(task),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(29),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/more-icon.svg',
                  width: 28,
                  height: 28,
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 58, height: 58),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(Task task) {
    return [
      if (task.taskStatus != TaskStatus.complite)
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
      if (task.taskStatus == TaskStatus.pending)
        const PopupMenuItem(
          value: 'start',
          child: Row(
            children: [
              Icon(Icons.play_circle, size: 20),
              SizedBox(width: 12),
              Text('Mulai Kerjakan'),
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

  Future<void> _onMenuAction(
    BuildContext context,
    String siteId,
    Task task,
    String value,
  ) async {
    switch (value) {
      case 'edit':
        final updated = await context.push<bool>('/task/${widget.taskId}/edit');
        if (updated == true && context.mounted) {
          await refreshTaskCache(ref, siteId: siteId, taskId: widget.taskId);
        }
        break;
      case 'delete':
        _showDeleteDialog(context, siteId, task);
        break;
      case 'complete':
        _changeStatus(context, siteId, task, TaskStatus.complite);
        break;
      case 'start':
        _changeStatus(context, siteId, task, TaskStatus.progress);
        break;
    }
  }

  Widget _buildContent(BuildContext context, Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusCard(context, task),
        SizedBox(height: context.rh(0.02)),
        _buildInfoCard(context, task),
        SizedBox(height: context.rh(0.02)),
        _buildDetailsCard(context, task),
        SizedBox(height: context.rh(0.02)),
        _buildTimelineCard(context, task),
      ],
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.taskName,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          if (task.taskDescription != null &&
              task.taskDescription!.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(task.taskDescription!, style: AppTextStyles.hint(context)),
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
          if (task.siteId != null)
            TaskInfoRowWidget(
              icon: Icons.location_on_outlined,
              label: 'Site',
              value: task.siteId!,
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
          if (task.completedAt != null)
            TaskInfoRowWidget(
              icon: Icons.check_circle_outline,
              label: 'Selesai Pada',
              value: DateFormat(
                'dd MMMM yyyy, HH:mm',
              ).format(task.completedAt!),
              valueColor: AppColors.success,
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
          if (task.taskStatus == TaskStatus.progress)
            TaskTimelineItemWidget(
              icon: Icons.play_circle,
              title: 'Task Sedang Dikerjakan',
              date: task.updatedAt ?? DateTime.now(),
            ),
          if (task.taskStatus == TaskStatus.failed)
            TaskTimelineItemWidget(
              icon: Icons.cancel,
              title: 'Task Gagal',
              date: task.updatedAt ?? DateTime.now(),
              color: AppColors.error,
              isLast: true,
            ),
          if (task.completedAt != null)
            TaskTimelineItemWidget(
              icon: Icons.check_circle,
              title: 'Task Selesai',
              date: task.completedAt!,
              color: AppColors.success,
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, String? siteId) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                  ),
                ),
                if (siteId != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(
                      taskDetailProvider((siteId, widget.taskId)),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String siteId, Task task) {
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
              final messenger = ScaffoldMessenger.of(context);
              final repository = ref.read(taskRepositoryProvider);
              final result = await repository.deleteTask(siteId, task.taskId);
              if (!mounted) return;
              result.fold(
                (failure) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus task: ${failure.message}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                (_) async {
                  await refreshTaskCache(
                    ref,
                    siteId: siteId,
                    taskId: task.taskId,
                  );
                  if (context.mounted) {
                    context.pop(true);
                  }
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Task berhasil dihapus'),
                      backgroundColor: AppColors.success,
                    ),
                  );
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

  Future<void> _changeStatus(
    BuildContext context,
    String siteId,
    Task task,
    TaskStatus status,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(taskRepositoryProvider);
    final result = await repository.updateTaskStatus(
      siteId,
      task.taskId,
      status,
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui status: ${failure.message}'),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (_) async {
        await refreshTaskCache(ref, siteId: siteId, taskId: task.taskId);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Status diperbarui ke "${status.label}"'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  Color _statusColor(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending:
        return AppColors.warning;
      case TaskStatus.progress:
        return AppColors.info;
      case TaskStatus.complite:
        return AppColors.success;
      case TaskStatus.failed:
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
    }
  }
}
