import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/plant_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_form_fields.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/plant.dart';

class PlantFormScreen extends ConsumerStatefulWidget {
  final String? plantId;

  const PlantFormScreen({super.key, this.plantId});

  @override
  ConsumerState<PlantFormScreen> createState() => _PlantFormScreenState();
}

class _PlantFormScreenState extends ConsumerState<PlantFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _varietasIdController;

  CropType? _selectedCropType;
  DateTime? _plantDate;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _varietasIdController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _varietasIdController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.plantId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(plantFormProvider);

    if (isEditMode && !_isInitialized) {
      final plantAsync = ref.watch(
        utilitasPlantDetailProvider(widget.plantId!),
      );
      plantAsync.whenData((plant) {
        if (!_isInitialized) _initializeForm(plant);
      });

      if (plantAsync.isLoading) {
        return UtilitasFormScaffold(
          title: 'Memuat...',
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }
      if (plantAsync.hasError) {
        return UtilitasFormScaffold(
          title: 'Error',
          body: UtilitasErrorState(
            error: plantAsync.error!,
            onRetry: () =>
                ref.invalidate(utilitasPlantDetailProvider(widget.plantId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'plant:update' : 'plant:create';

    return PermissionGuardScreen(
      permission: permission,
      child: UtilitasFormScaffold(
        title: isEditMode ? 'Edit Tanaman' : 'Tambah Tanaman',
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? 'Menyimpan perubahan...'
            : 'Membuat tanaman...',
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              SizedBox(height: context.rh(0.01)),
              Text(
                isEditMode ? 'Edit Tanaman' : 'Tambah Tanaman',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(22),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1D1D1D),
                  height: 1.0,
                ),
              ),
              SizedBox(height: context.rh(0.014)),
              UtilitasSectionCard(
                title: 'Informasi Tanaman',
                child: Column(
                  children: [
                    if (isEditMode) ...[
                      UtilitasFormFields.buildField(
                        context,
                        controller: _idController,
                        label: 'Plant ID',
                        hint: 'ID dari server',
                        icon: Icons.tag,
                        enabled: false,
                      ),
                      SizedBox(height: context.rh(0.016)),
                    ],
                    UtilitasFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: 'Nama Tanaman',
                      hint: 'Contoh: Padi Sawah Blok A',
                      icon: Icons.grass,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama tanaman wajib diisi';
                        }
                        if (v.length < 3) {
                          return 'Minimal 3 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildDropdown<CropType>(
                      context,
                      value: _selectedCropType,
                      label: 'Jenis Tanaman *',
                      hint: 'Pilih jenis tanaman',
                      icon: Icons.eco,
                      items: const [
                        DropdownMenuItem(
                          value: CropType.padi,
                          child: Text('Padi'),
                        ),
                        DropdownMenuItem(
                          value: CropType.jagung,
                          child: Text('Jagung'),
                        ),
                        DropdownMenuItem(
                          value: CropType.kedelai,
                          child: Text('Kedelai'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _selectedCropType = v),
                      validator: (v) =>
                          v == null ? 'Jenis tanaman wajib dipilih' : null,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _varietasIdController,
                      label: 'Varietas ID',
                      hint: 'Contoh: VAR_001',
                      icon: Icons.science,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Varietas ID wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              UtilitasSectionCard(
                title: 'Tanggal Tanam',
                child: _buildDatePicker(context),
              ),
              SizedBox(height: context.rh(0.03)),

              UtilitasSubmitButton(
                label: isEditMode ? 'Simpan Perubahan' : 'Tambah Tanaman',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeForm(Plant plant) {
    _idController.text = plant.plantId;
    _nameController.text = plant.plantName ?? '';
    _varietasIdController.text = plant.varietasId ?? '';
    _selectedCropType = plant.plantType;
    _plantDate = plant.plantDate;
    _isInitialized = true;
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _plantDate != null
                    ? DateFormat('dd MMMM yyyy').format(_plantDate!)
                    : 'Pilih tanggal tanam',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  color: _plantDate != null
                      ? const Color(0xFF1D1D1D)
                      : const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _plantDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_plantDate == null) {
      SnackbarHelper.showError(context, 'Tanggal tanam wajib dipilih');
      return;
    }

    final plant = Plant(
      plantId: widget.plantId ?? '',
      plantName: _nameController.text.trim(),
      varietasId: _varietasIdController.text.trim(),
      plantType: _selectedCropType,
      plantDate: _plantDate,
    );

    final success = isEditMode
        ? await ref
              .read(plantFormProvider.notifier)
              .updatePlant(widget.plantId!, plant)
        : await ref.read(plantFormProvider.notifier).createPlant(plant);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? 'Tanaman berhasil diperbarui'
            : 'Tanaman berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(plantFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan tanaman');
    }
  }
}
