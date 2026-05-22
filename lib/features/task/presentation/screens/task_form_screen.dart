import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
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
        return _scaffold(child: _buildMissingSite());
      }

      final taskAsync = ref.watch(taskDetailProvider((siteId, widget.taskId!)));
      return taskAsync.when(
        loading: () => _scaffold(child: _buildLoading()),
        error: (e, _) =>
            _scaffold(child: _buildDetailError(siteId, e.toString())),
        data: (task) {
          _hydrateOnce(task);
          return _buildFormScaffold(siteId: siteId);
        },
      );
    }

    _selectedSite ??= ref.watch(selectedSiteProvider);
    return _buildFormScaffold(siteId: null);
  }

  Scaffold _scaffold({required Widget child}) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Tambah Task'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: child,
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildMissingSite() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.051)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 64,
              color: AppColors.warning,
            ),
            SizedBox(height: context.rh(0.02)),
            Text('Site belum dipilih', style: AppTextStyles.cardTitle(context)),
            SizedBox(height: context.rh(0.01)),
            Text(
              'Pilih site terlebih dahulu sebelum mengedit task.',
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

  Widget _buildDetailError(String siteId, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.051)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            SizedBox(height: context.rh(0.02)),
            Text('Gagal memuat task', style: AppTextStyles.cardTitle(context)),
            SizedBox(height: context.rh(0.01)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context, size: 13),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.invalidate(taskDetailProvider((siteId, widget.taskId!))),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
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

  Widget _buildFormScaffold({required String? siteId}) {
    return _scaffold(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.rw(0.041)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEditMode) ...[
                _sectionTitle('Site'),
                SizedBox(height: context.rh(0.01)),
                _buildSiteSelector(),
                SizedBox(height: context.rh(0.02)),
              ],
              _sectionTitle('Nama Task'),
              SizedBox(height: context.rh(0.01)),
              TextFormField(
                controller: _taskNameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama task',
                  prefixIcon: const Icon(Icons.task_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama task harus diisi';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: context.rh(0.02)),
              _sectionTitle('Deskripsi'),
              SizedBox(height: context.rh(0.01)),
              TextFormField(
                controller: _taskDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi task (opsional)',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: context.rh(0.02)),
              _sectionTitle('Jenis Task'),
              SizedBox(height: context.rh(0.01)),
              _buildTypeSelector(),
              SizedBox(height: context.rh(0.02)),
              _sectionTitle('Prioritas'),
              SizedBox(height: context.rh(0.01)),
              _buildPrioritySelector(),
              SizedBox(height: context.rh(0.02)),
              if (isEditMode) ...[
                _sectionTitle('Status'),
                SizedBox(height: context.rh(0.01)),
                _buildStatusSelector(),
                SizedBox(height: context.rh(0.02)),
              ],
              SizedBox(height: context.rh(0.01)),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          isEditMode ? 'Simpan Perubahan' : 'Tambah Task',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(height: context.rh(0.02)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: context.sp(13),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSiteSelector() {
    final sitesAsync = ref.watch(sitesProvider);
    return sitesAsync.when(
      loading: () => Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (e, _) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Text(
          'Gagal memuat site: $e',
          style: const TextStyle(color: AppColors.error),
        ),
      ),
      data: (sites) {
        if (sites.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Text('Belum ada site'),
          );
        }
        return InkWell(
          onTap: () => _showSitePicker(sites),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(Icons.place_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedSite?.siteName ?? 'Pilih Site',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w500,
                      color: _selectedSite == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSitePicker(List<Site> sites) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih Site',
                  style: AppTextStyles.cardTitle(ctx, 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sites.length,
              itemBuilder: (_, i) {
                final site = sites[i];
                final isSelected = _selectedSite?.siteId == site.siteId;
                return ListTile(
                  onTap: () {
                    setState(() => _selectedSite = site);
                    Navigator.pop(ctx);
                  },
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.place_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(site.siteName ?? site.siteId),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 20,
                        )
                      : null,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskType.values.map((type) {
        final isSelected = type == _selectedType;
        return ChoiceChip(
          label: Text(type.label),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedType = type),
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(12),
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
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
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flag,
                size: 16,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 4),
              Text(priority.label),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedPriority = priority),
          backgroundColor: color.withValues(alpha: 0.1),
          selectedColor: color,
          labelStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(12),
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : color,
          ),
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
        return ChoiceChip(
          label: Text(status.label),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedStatus = status),
          backgroundColor: color.withValues(alpha: 0.1),
          selectedColor: color,
          labelStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(12),
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : color,
          ),
        );
      }).toList(),
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
    final desc = _taskDescriptionController.text.trim();

    if (isEditMode) {
      final changes = <String, dynamic>{
        'task_name': _taskNameController.text.trim(),
        'task_desc': desc.isEmpty ? null : desc,
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
        taskDescription: desc.isEmpty ? null : desc,
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
    messenger.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
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
