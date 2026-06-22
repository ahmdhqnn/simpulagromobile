import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';
import '../../../admin/presentation/widgets/admin_form_fields.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final String? taskId;

  const TaskFormScreen({super.key, this.taskId});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();

  TaskType _selectedType = TaskType.monitoring;
  TaskStatus _selectedStatus = TaskStatus.pending;
  TaskPriority _selectedPriority = TaskPriority.medium;

  String? _editSiteId;

  bool _isSubmitting = false;
  bool _hydrated = false;

  bool get isEditMode => widget.taskId != null;

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  void _hydrateOnce(Task task) {
    if (_hydrated) return;
    _taskNameController.text = task.taskName;
    _taskDescriptionController.text = task.taskDescription ?? '';
    _selectedType = task.taskType;
    _selectedStatus = task.taskStatus;
    _selectedPriority = task.taskPriority;
    _hydrated = true;
  }

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      _editSiteId ??= ref.read(selectedSiteIdProvider);
      final siteId = _editSiteId;
      if (siteId == null) {
        return AdminFormScaffold(
          title: context.l10n.taskEditTitle,
          body: AdminEmptyState(
            icon: Icons.location_off_outlined,
            title: context.l10n.taskSiteRequiredForEditTitle,
            message: context.l10n.taskSiteRequiredForEditMessage,
          ),
        );
      }

      final taskAsync = ref.watch(taskDetailProvider((siteId, widget.taskId!)));
      
      return taskAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        loading: () => AdminFormScaffold(
          title: context.l10n.taskEditTitle,
          body: const AdminFormScreenSkeleton(
            titleWidth: 150,
            sectionFieldCounts: [4],
          ),
        ),
        error: (error, _) => AdminFormScaffold(
          title: context.l10n.taskEditTitle,
          body: AdminErrorState(
            error: error,
            onRetry: () =>
                ref.invalidate(taskDetailProvider((siteId, widget.taskId!))),
          ),
        ),
        data: (task) {
          _hydrateOnce(task);
          return _buildFormScaffold(siteLabel: null); // Edit doesn't need site selector
        },
      );
    }

    final selectedSite = ref.watch(selectedSiteProvider);

    if (selectedSite == null) {
      return AdminFormScaffold(
        title: context.l10n.taskAddTitle,
        body: AdminEmptyState(
          icon: Icons.location_off_outlined,
          title: context.l10n.forumSiteNotSelectedTitle,
          message: context.l10n.forumSelectActiveSiteBeforePosting,
        ),
      );
    }

    return _buildFormScaffold(siteLabel: selectedSite.displayName);
  }

  Widget _buildFormScaffold({required String? siteLabel}) {
    return AdminFormScaffold(
      title: isEditMode
          ? context.l10n.taskEditTitle
          : context.l10n.taskAddTitle,
      isLoading: _isSubmitting,
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.rw(0.051),
            vertical: context.rh(0.01),
          ),
          children: [
            AdminSectionCard(
              child: Column(
                children: [
                  if (siteLabel != null && !isEditMode) ...[
                    AdminFormFields.buildFieldShell(
                      context,
                      label: context.l10n.siteTitle,
                      child: Container(
                        height: context.rh(0.05).clamp(44.0, 48.0),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: context.rw(0.041)),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          siteLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label(
                            context,
                            size: context.sp(14),
                            weight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.rh(0.016)),
                  ],
                  AdminFormFields.buildField(
                    context,
                    controller: _taskNameController,
                    label: context.l10n.taskNameLabel,
                    hint: context.l10n.taskNameHint,
                    icon: Icons.assignment_outlined,
                    textInputAction: TextInputAction.next,
                    required: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.taskNameRequired;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.rh(0.016)),
                  AdminFormFields.buildField(
                    context,
                    controller: _taskDescriptionController,
                    label: context.l10n.commonDescription,
                    hint: context.l10n.taskDescriptionHint,
                    icon: Icons.description_outlined,
                    textInputAction: TextInputAction.newline,
                    maxLines: 4,
                  ),
                  SizedBox(height: context.rh(0.016)),
                  AdminFormFields.buildFieldShell(
                    context,
                    label: context.l10n.taskTypeLabel,
                    child: _buildTypeSelector(),
                  ),
                  SizedBox(height: context.rh(0.016)),
                  AdminFormFields.buildFieldShell(
                    context,
                    label: context.l10n.commonPriority,
                    child: _buildPrioritySelector(),
                  ),
                  if (isEditMode) ...[
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildFieldShell(
                      context,
                      label: context.l10n.commonStatus,
                      child: _buildStatusSelector(),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            AdminSubmitButton(
              label: isEditMode
                  ? context.l10n.commonSaveChanges
                  : context.l10n.taskAddTitle,
              onPressed: _handleSubmit,
            ),
            SizedBox(height: context.rh(0.04)),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
      children: TaskType.values.map((type) {
        final isSelected = type == _selectedType;
        return _buildChoiceChip(
          label: type.localizedLabel(context.l10n),
          isSelected: isSelected,
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primary,
          selectedTextColor: Colors.white,
          unselectedTextColor: AppColors.textSecondary,
          onTap: () => setState(() => _selectedType = type),
        );
      }).toList(),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
      children: TaskPriority.values.map((priority) {
        final isSelected = priority == _selectedPriority;
        final color = _priorityColor(priority);
        return _buildChoiceChip(
          label: priority.localizedLabel(context.l10n),
          isSelected: isSelected,
          backgroundColor: color.withValues(alpha: 0.12),
          selectedColor: color,
          selectedTextColor: Colors.white,
          unselectedTextColor: color,
          icon: Icons.flag,
          iconColor: isSelected ? Colors.white : color,
          onTap: () => setState(() => _selectedPriority = priority),
        );
      }).toList(),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
      children: TaskStatus.values.map((status) {
        final isSelected = status == _selectedStatus;
        final color = _statusColor(status);
        return _buildChoiceChip(
          label: status.localizedLabel(context.l10n),
          isSelected: isSelected,
          backgroundColor: color.withValues(alpha: 0.12),
          selectedColor: color,
          selectedTextColor: Colors.white,
          unselectedTextColor: color,
          onTap: () => setState(() => _selectedStatus = status),
        );
      }).toList(),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required Color backgroundColor,
    required Color selectedColor,
    required Color selectedTextColor,
    required Color unselectedTextColor,
    required VoidCallback onTap,
    IconData? icon,
    Color? iconColor,
  }) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.021),
        vertical: context.rh(0.003),
      ),
      labelStyle: AppTextStyles.label(
        context,
        size: context.sp(12),
        weight: FontWeight.w500,
        color: isSelected ? selectedTextColor : unselectedTextColor,
        height: 1.2,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final selectedSite = ref.read(selectedSiteProvider);
    if (!isEditMode && selectedSite == null) {
      _showError(messenger, l10n.siteSelectFirst);
      return;
    }

    final siteId = isEditMode ? _editSiteId : selectedSite?.siteId;
    if (siteId == null) {
      _showError(messenger, l10n.taskSiteIdMissing);
      return;
    }

    setState(() => _isSubmitting = true);

    final repository = ref.read(taskRepositoryProvider);
    final description = _taskDescriptionController.text.trim();

    if (isEditMode) {
      final changes = <String, dynamic>{
        'task_name': _taskNameController.text.trim(),
        'task_desc': description.isEmpty ? null : description,
        'task_type': _selectedType.apiValue,
        'task_sts': _selectedStatus.apiValue,
        'task_priority': _selectedPriority.apiValue,
      };
      final result = await repository.updateTask(
        siteId,
        widget.taskId!,
        changes,
      );
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      result.fold(
        (failure) =>
            _showError(messenger, l10n.taskUpdateFailure(failure.message)),
        (_) async {
          await refreshTaskCache(ref, siteId: siteId, taskId: widget.taskId!);
          if (!mounted) return;
          context.pop(true);
          _showSuccess(messenger, l10n.taskUpdateSuccess);
        },
      );
    } else {
      final task = Task(
        taskId: '',
        siteId: siteId,
        taskName: _taskNameController.text.trim(),
        taskDescription: description.isEmpty ? null : description,
        taskType: _selectedType,
        taskStatus: _selectedStatus,
        taskPriority: _selectedPriority,
      );
      final result = await repository.createTask(siteId, task);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      result.fold(
        (failure) =>
            _showError(messenger, l10n.taskCreateFailure(failure.message)),
        (_) async {
          await refreshTaskCache(ref, siteId: siteId);
          if (!mounted) return;
          context.pop(true);
          _showSuccess(messenger, l10n.taskCreateSuccess);
        },
      );
    }
  }

  void _showError(ScaffoldMessengerState messenger, String message) {
    SnackbarHelper.showError(context, message);
  }

  void _showSuccess(ScaffoldMessengerState messenger, String message) {
    SnackbarHelper.showSuccess(context, message);
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
    }
  }

  Color _statusColor(TaskStatus status) {
    switch (status) {
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
}
