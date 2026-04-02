import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
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
  final _notesController = TextEditingController();

  TaskType _selectedType = TaskType.monitoring;
  TaskStatus _selectedStatus = TaskStatus.pending;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _selectedDueDate;
  bool _isLoading = false;

  bool get isEditMode => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadTaskData();
    }
  }

  void _loadTaskData() async {
    final taskAsync = ref.read(taskDetailProvider(widget.taskId!));
    taskAsync.whenData((task) {
      setState(() {
        _taskNameController.text = task.taskName;
        _taskDescriptionController.text = task.taskDescription ?? '';
        _notesController.text = task.notes ?? '';
        _selectedType = task.taskType;
        _selectedStatus = task.taskStatus;
        _selectedPriority = task.taskPriority;
        _selectedDueDate = task.taskDueDate;
      });
    });
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Tambah Task'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.rw(0.041)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Name
              _buildSectionTitle('Nama Task'),
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
                  if (value == null || value.isEmpty) {
                    return 'Nama task harus diisi';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: context.rh(0.02)),

              // Task Description
              _buildSectionTitle('Deskripsi'),
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

              // Task Type
              _buildSectionTitle('Jenis Task'),
              SizedBox(height: context.rh(0.01)),
              _buildTypeSelector(),
              SizedBox(height: context.rh(0.02)),

              // Priority
              _buildSectionTitle('Prioritas'),
              SizedBox(height: context.rh(0.01)),
              _buildPrioritySelector(),
              SizedBox(height: context.rh(0.02)),

              // Status (only in edit mode)
              if (isEditMode) ...[
                _buildSectionTitle('Status'),
                SizedBox(height: context.rh(0.01)),
                _buildStatusSelector(),
                SizedBox(height: context.rh(0.02)),
              ],

              // Due Date
              _buildSectionTitle('Batas Waktu'),
              SizedBox(height: context.rh(0.01)),
              _buildDueDatePicker(),
              SizedBox(height: context.rh(0.02)),

              // Notes
              _buildSectionTitle('Catatan'),
              SizedBox(height: context.rh(0.01)),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Tambahkan catatan (opsional)',
                  prefixIcon: const Icon(Icons.note_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                maxLines: 4,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: context.rh(0.03)),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
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
                            fontFamily: 'Plus Jakarta Sans',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(13),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
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
            fontFamily: 'Plus Jakarta Sans',
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
        final color = _getPriorityColor(priority);
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
            fontFamily: 'Plus Jakarta Sans',
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
        final color = _getStatusColor(status);
        return ChoiceChip(
          label: Text(status.label),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedStatus = status),
          backgroundColor: color.withValues(alpha: 0.1),
          selectedColor: color,
          labelStyle: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(12),
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDueDatePicker() {
    return InkWell(
      onTap: _selectDueDate,
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
            const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Batas Waktu',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedDueDate != null
                        ? DateFormat(
                            'dd MMMM yyyy, HH:mm',
                          ).format(_selectedDueDate!)
                        : 'Pilih tanggal dan waktu',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w500,
                      color: _selectedDueDate != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedDueDate != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => setState(() => _selectedDueDate = null),
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueDate ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: AppColors.primary),
            ),
            child: child!,
          );
        },
      );

      if (time != null && mounted) {
        setState(() {
          _selectedDueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final task = Task(
      taskId: widget.taskId ?? '',
      taskName: _taskNameController.text.trim(),
      taskDescription: _taskDescriptionController.text.trim().isEmpty
          ? null
          : _taskDescriptionController.text.trim(),
      taskType: _selectedType,
      taskStatus: _selectedStatus,
      taskPriority: _selectedPriority,
      taskDueDate: _selectedDueDate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final repository = ref.read(taskRepositoryProvider);
    final result = isEditMode
        ? await repository.updateTask(task)
        : await repository.createTask(task);

    if (mounted) {
      setState(() => _isLoading = false);

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode
                    ? 'Gagal mengupdate task: ${failure.message}'
                    : 'Gagal menambah task: ${failure.message}',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (task) {
          ref.invalidate(taskListProvider);
          if (isEditMode) {
            ref.invalidate(taskDetailProvider(widget.taskId!));
          }
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode
                    ? 'Task berhasil diupdate'
                    : 'Task berhasil ditambahkan',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        },
      );
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
