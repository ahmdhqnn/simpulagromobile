import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/plant_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/device_sensors/async_dropdown_widget.dart';
import 'package:simpulagromobile/features/admin/domain/entities/plant.dart';
import 'package:simpulagromobile/features/varietas/domain/entities/varietas_item.dart';
import 'package:simpulagromobile/features/varietas/presentation/providers/varietas_provider.dart';

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
  String? _selectedVarietasId;
  DateTime? _plantDate;
  bool _useManualVarietasId = false;
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
    final formState = ref.watch(adminPlantFormProvider);
    final varietasAsync = ref.watch(varietasListProvider);
    _syncSelectedVarietas(varietasAsync.valueOrNull ?? const <VarietasItem>[]);

    if (isEditMode && !_isInitialized) {
      final plantAsync = ref.watch(adminPlantDetailProvider(widget.plantId!));
      plantAsync.whenData((plant) {
        if (!_isInitialized) _initializeForm(plant);
      });

      if (plantAsync.isLoading) {
        return AdminFormScaffold(
          title: 'Memuat...',
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }
      if (plantAsync.hasError) {
        return AdminFormScaffold(
          title: 'Error',
          body: AdminErrorState(
            error: plantAsync.error!,
            onRetry: () =>
                ref.invalidate(adminPlantDetailProvider(widget.plantId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'plant:update' : 'plant:create';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
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
              AdminSectionCard(
                title: 'Informasi Tanaman',
                child: Column(
                  children: [
                    if (isEditMode) ...[
                      AdminFormFields.buildField(
                        context,
                        controller: _idController,
                        label: 'Plant ID',
                        hint: 'ID dari server',
                        icon: Icons.tag,
                        enabled: false,
                      ),
                      SizedBox(height: context.rh(0.016)),
                    ],
                    AdminFormFields.buildField(
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
                    AdminFormFields.buildDropdown<CropType>(
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
                    _buildVarietasInput(context, varietasAsync),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              AdminSectionCard(
                title: 'Tanggal Tanam',
                child: _buildDatePicker(context),
              ),
              SizedBox(height: context.rh(0.03)),

              AdminSubmitButton(
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
    _selectedVarietasId = plant.varietasId?.trim();
    _selectedCropType = plant.plantType;
    _plantDate = plant.plantDate;
    _isInitialized = true;
  }

  Widget _buildVarietasInput(
    BuildContext context,
    AsyncValue<List<VarietasItem>> varietasAsync,
  ) {
    if (_useManualVarietasId) {
      return Column(
        children: [
          AdminFormFields.buildField(
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => _useManualVarietasId = false),
              child: const Text('Pilih dari daftar varietas'),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        AsyncDropdownWidget<VarietasItem, String>(
          async: varietasAsync.whenData(
            (items) => items.where((item) => item.isActive).toList(),
          ),
          value: _selectedVarietasId,
          label: 'Varietas *',
          hint: 'Pilih varietas dari backend',
          icon: Icons.science,
          itemBuilder: (items) => items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item.varietasId,
                  child: Text(item.displayName),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedVarietasId = value;
              _varietasIdController.text = value ?? '';
            });
          },
          validator: (value) {
            if ((value ?? '').trim().isEmpty) {
              return 'Varietas wajib dipilih';
            }
            return null;
          },
          errorMessage: 'Gagal memuat varietas. Gunakan input manual.',
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => setState(() => _useManualVarietasId = true),
            child: const Text('Input ID manual'),
          ),
        ),
      ],
    );
  }

  void _syncSelectedVarietas(List<VarietasItem> items) {
    if (items.isEmpty) return;
    final currentId = _varietasIdController.text.trim();
    if (currentId.isEmpty) return;

    final exists = items.any((item) => item.varietasId == currentId);
    if (!exists) {
      if (!_useManualVarietasId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _useManualVarietasId = true);
        });
      }
      return;
    }

    if (_selectedVarietasId == currentId) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _selectedVarietasId = currentId);
    });
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
    final varietasId = _resolveVarietasId();
    if (varietasId == null) {
      SnackbarHelper.showError(context, 'Varietas wajib diisi');
      return;
    }

    final plant = Plant(
      plantId: widget.plantId ?? '',
      plantName: _nameController.text.trim(),
      varietasId: varietasId,
      plantType: _selectedCropType,
      plantDate: _plantDate,
    );

    final success = isEditMode
        ? await ref
              .read(adminPlantFormProvider.notifier)
              .updatePlant(widget.plantId!, plant)
        : await ref.read(adminPlantFormProvider.notifier).createPlant(plant);

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
      final error = ref.read(adminPlantFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan tanaman');
    }
  }

  String? _resolveVarietasId() {
    final fromDropdown = _selectedVarietasId?.trim();
    if (!_useManualVarietasId &&
        fromDropdown != null &&
        fromDropdown.isNotEmpty) {
      return fromDropdown;
    }
    final fromInput = _varietasIdController.text.trim();
    if (fromInput.isEmpty) return null;
    return fromInput;
  }
}
