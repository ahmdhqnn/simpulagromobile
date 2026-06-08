import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_elements.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/domain/entities/site.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

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
  Site? _selectedSite;

  String? _editSiteId;

  bool _isSubmitting = false;
  bool _hydrated = false;

  bool get isEditMode => widget.taskId != null;
  String get _screenTitle => isEditMode ? 'Edit Task' : 'Tambah Task';

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
        return _buildScreenShell(
          child: _buildMessageCard(
            icon: Icons.location_off_outlined,
            iconColor: AppColors.warning,
            title: 'Site belum dipilih',
            description: 'Pilih site terlebih dahulu sebelum mengedit task.',
            actionLabel: 'Kembali',
            onAction: () => context.pop(),
          ),
        );
      }

      final taskAsync = ref.watch(taskDetailProvider((siteId, widget.taskId!)));
      return taskAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        loading: () => _buildScreenShell(child: _buildLoadingCard()),
        error: (error, _) => _buildScreenShell(
          child: _buildMessageCard(
            icon: Icons.error_outline,
            iconColor: AppColors.error,
            title: 'Gagal memuat task',
            description: error.toString(),
            actionLabel: 'Coba Lagi',
            onAction: () =>
                ref.invalidate(taskDetailProvider((siteId, widget.taskId!))),
          ),
        ),
        data: (task) {
          _hydrateOnce(task);
          return _buildScreenShell(child: _buildFormCard());
        },
      );
    }

    _selectedSite ??= ref.watch(selectedSiteProvider);
    return _buildScreenShell(child: _buildFormCard());
  }

  Widget _buildScreenShell({required Widget child}) {
    final hPad = context.rw(0.051);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.rh(0.015)),
                _buildTopBar(),
                SizedBox(height: context.rh(0.03)),
                Text(_screenTitle, style: AppTextStyles.sectionTitle(context)),
                SizedBox(height: context.rh(0.03)),
                child,
                SizedBox(
                  height:
                      context.rh(0.02) + MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: CircularBackButtonWidget(onPressed: () => context.pop()),
    );
  }

  Widget _buildLoadingCard() =>
      const FormCardSkeleton(fieldCount: 5, hasLargeField: true);

  Widget _buildMessageCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: context.rw(0.143).clamp(52.0, 60.0),
            color: iconColor,
          ),
          SizedBox(height: context.rh(0.02)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.cardTitle(context, context.sp(16)),
          ),
          SizedBox(height: context.rh(0.01)),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption(context, size: context.sp(13)),
          ),
          SizedBox(height: context.rh(0.03)),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            child: Text(
              actionLabel,
              style: AppTextStyles.label(
                context,
                size: context.sp(14),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isEditMode) ...[
              _FormField(label: 'Site', child: _buildSiteSelector()),
              SizedBox(height: context.rh(0.025)),
            ],
            _FormField(
              label: 'Nama Task',
              child: _buildTextField(
                controller: _taskNameController,
                hintText: 'Masukkan nama task',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama task harus diisi';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: context.rh(0.025)),
            _FormField(
              label: 'Deskripsi',
              child: _buildTextField(
                controller: _taskDescriptionController,
                hintText: 'Tambahkan deskripsi task',
                maxLines: 4,
                textInputAction: TextInputAction.newline,
              ),
            ),
            SizedBox(height: context.rh(0.025)),
            _FormField(label: 'Jenis Task', child: _buildTypeSelector()),
            SizedBox(height: context.rh(0.025)),
            _FormField(label: 'Prioritas', child: _buildPrioritySelector()),
            if (isEditMode) ...[
              SizedBox(height: context.rh(0.025)),
              _FormField(label: 'Status', child: _buildStatusSelector()),
            ],
            SizedBox(height: context.rh(0.037)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleActionButton(
                  svgPath: 'assets/icons/close-icon.svg',
                  onTap: () => context.pop(),
                ),
                _CircleActionButton(
                  svgPath: 'assets/icons/check-icon.svg',
                  onTap: _isSubmitting ? null : _handleSubmit,
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputAction? textInputAction,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final isMultiline = maxLines > 1;
    final borderRadius = BorderRadius.circular(
      isMultiline ? AppRadius.xl : AppRadius.pill,
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      textInputAction: textInputAction,
      style: AppTextStyles.label(
        context,
        size: context.sp(14),
        weight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hint(context, size: context.sp(14)),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        hoverColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rw(0.041),
          vertical: isMultiline ? context.rh(0.016) : context.rh(0.012),
        ),
      ),
    );
  }

  Widget _buildSiteSelector() {
    final sitesAsync = ref.watch(sitesProvider);

    return sitesAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      loading: () => Container(
        height: context.rh(0.05).clamp(44.0, 48.0),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: const SkeletonContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SkeletonLine(width: 140, height: 13),
            ),
          ),
        ),
      ),
      error: (error, _) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.rw(0.036)),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Text(
          'Gagal memuat site: $error',
          style: AppTextStyles.label(
            context,
            size: context.sp(12),
            color: AppColors.error,
          ),
        ),
      ),
      data: (sites) {
        if (sites.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.rw(0.036)),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(
              'Belum ada site',
              style: AppTextStyles.label(
                context,
                size: context.sp(13),
                weight: FontWeight.w400,
              ),
            ),
          );
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showSitePicker(sites),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: context.rh(0.05).clamp(44.0, 48.0),
              padding: EdgeInsets.symmetric(horizontal: context.rw(0.041)),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedSite?.siteName ?? 'Pilih site',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (_selectedSite == null
                                  ? AppTextStyles.hint(
                                      context,
                                      size: context.sp(14),
                                    )
                                  : AppTextStyles.label(
                                      context,
                                      size: context.sp(14),
                                      weight: FontWeight.w400,
                                    ))
                              .copyWith(height: 1),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textPrimary,
                    size: context.sp(22),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSitePicker(List<Site> sites) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih Site',
                  style: AppTextStyles.cardTitle(sheetContext, 16),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: context.rh(0.55)),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sites.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final site = sites[index];
                      final isSelected = _selectedSite?.siteId == site.siteId;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          onTap: () {
                            setState(() => _selectedSite = site);
                            Navigator.of(sheetContext).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.surfaceVariant
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    site.siteName ?? site.siteId,
                                    style: AppTextStyles.label(
                                      sheetContext,
                                      size: context.sp(14),
                                      weight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskType.values.map((type) {
        final isSelected = type == _selectedType;
        return _buildChoiceChip(
          label: type.label,
          isSelected: isSelected,
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primary,
          selectedTextColor: Colors.white,
          unselectedTextColor: AppColors.textSecondary,
          onTap: () => setState(() => _selectedType = type),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskPriority.values.map((priority) {
        final isSelected = priority == _selectedPriority;
        final color = _priorityColor(priority);
        return _buildChoiceChip(
          label: priority.label,
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
    );
  }

  Widget _buildStatusSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskStatus.values.map((status) {
        final isSelected = status == _selectedStatus;
        final color = _statusColor(status);
        return _buildChoiceChip(
          label: status.label,
          isSelected: isSelected,
          backgroundColor: color.withValues(alpha: 0.12),
          selectedColor: color,
          selectedTextColor: Colors.white,
          unselectedTextColor: color,
          onTap: () => setState(() => _selectedStatus = status),
        );
      }).toList(),
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

    if (!isEditMode && _selectedSite == null) {
      _showError(messenger, 'Pilih site terlebih dahulu');
      return;
    }

    final siteId = isEditMode ? _editSiteId : _selectedSite?.siteId;
    if (siteId == null) {
      _showError(messenger, 'Site ID tidak ditemukan');
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
            _showError(messenger, 'Gagal mengupdate task: ${failure.message}'),
        (_) async {
          await refreshTaskCache(ref, siteId: siteId, taskId: widget.taskId!);
          if (!mounted) return;
          context.pop(true);
          _showSuccess(messenger, 'Task berhasil diupdate');
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
            _showError(messenger, 'Gagal menambah task: ${failure.message}'),
        (_) async {
          await refreshTaskCache(ref, siteId: siteId);
          if (!mounted) return;
          context.pop(true);
          _showSuccess(messenger, 'Task berhasil ditambahkan');
        },
      );
    }
  }

  void _showError(ScaffoldMessengerState messenger, String message) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(ScaffoldMessengerState messenger, String message) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label(
            context,
            size: context.sp(14),
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(height: context.rh(0.01)),
        child,
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback? onTap;
  final bool isLoading;

  const _CircleActionButton({
    required this.svgPath,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.rw(0.128).clamp(48.0, 56.0);
    final iconSize = context.rw(0.062).clamp(22.0, 28.0);
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.surfaceVariant.withValues(alpha: 0.5)
              : AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textPrimary,
                  ),
                )
              : SvgPicture.asset(
                  svgPath,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(
                    isDisabled
                        ? AppColors.textPrimary.withValues(alpha: 0.3)
                        : AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
        ),
      ),
    );
  }
}
