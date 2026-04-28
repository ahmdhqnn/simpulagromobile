import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/shared/widgets/loading_overlay.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/plant_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/plant.dart';
import 'package:intl/intl.dart';

class PlantFormScreen extends ConsumerStatefulWidget {
  final String? plantId; // null = create, not null = edit

  const PlantFormScreen({super.key, this.plantId});

  @override
  ConsumerState<PlantFormScreen> createState() => _PlantFormScreenState();
}

class _PlantFormScreenState extends ConsumerState<PlantFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _speciesController;

  CropType? _selectedCropType;
  DateTime? _plantDate;
  int _status = 1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _speciesController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.plantId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(plantFormProvider);

    // Load plant data for edit mode
    if (isEditMode && !_isInitialized) {
      final plantAsync = ref.watch(
        utilitasPlantDetailProvider(widget.plantId!),
      );

      plantAsync.whenData((plant) {
        if (!_isInitialized) {
          _initializeForm(plant);
        }
      });

      if (plantAsync.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (plantAsync.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${plantAsync.error}')),
        );
      }
    }

    final permission = isEditMode ? 'plant:update' : 'plant:create';

    return PermissionGuardScreen(
      permission: permission,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Tanaman' : 'Tambah Tanaman'),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: formState.isLoading,
          message: isEditMode ? 'Menyimpan perubahan...' : 'Membuat tanaman...',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPlantIdField(),
                const Gap(16),
                _buildPlantNameField(),
                const Gap(16),
                _buildCropTypeDropdown(),
                const Gap(16),
                _buildSpeciesField(),
                const Gap(16),
                _buildPlantDatePicker(),
                const Gap(24),
                _buildStatusSwitch(),
                const Gap(32),
                _buildSubmitButton(),
                const Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initializeForm(Plant plant) {
    _idController.text = plant.plantId;
    _nameController.text = plant.plantName ?? '';
    _speciesController.text = plant.plantSpecies ?? '';
    _selectedCropType = plant.plantType;
    _plantDate = plant.plantDate;
    _status = plant.plantSts ?? 1;
    _isInitialized = true;
  }

  Widget _buildPlantIdField() {
    return TextFormField(
      controller: _idController,
      enabled: !isEditMode,
      decoration: InputDecoration(
        labelText: 'Plant ID *',
        hintText: 'Contoh: PLANT001',
        prefixIcon: const Icon(Icons.tag),
        filled: true,
        fillColor: isEditMode ? Colors.grey[100] : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Plant ID wajib diisi';
        }
        if (value.length < 3) {
          return 'Plant ID minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildPlantNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Tanaman *',
        hintText: 'Contoh: Padi Sawah Blok A',
        prefixIcon: Icon(Icons.grass),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama tanaman wajib diisi';
        }
        if (value.length < 3) {
          return 'Nama tanaman minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildCropTypeDropdown() {
    return DropdownButtonFormField<CropType>(
      value: _selectedCropType,
      decoration: const InputDecoration(
        labelText: 'Jenis Tanaman *',
        hintText: 'Pilih jenis tanaman',
        prefixIcon: Icon(Icons.eco),
      ),
      items: const [
        DropdownMenuItem(value: CropType.padi, child: Text('Padi')),
        DropdownMenuItem(value: CropType.jagung, child: Text('Jagung')),
        DropdownMenuItem(value: CropType.kedelai, child: Text('Kedelai')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCropType = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Jenis tanaman wajib dipilih';
        }
        return null;
      },
    );
  }

  Widget _buildSpeciesField() {
    return TextFormField(
      controller: _speciesController,
      decoration: const InputDecoration(
        labelText: 'Varietas',
        hintText: 'Contoh: IR64, Ciherang',
        prefixIcon: Icon(Icons.science),
      ),
    );
  }

  Widget _buildPlantDatePicker() {
    return InkWell(
      onTap: () => _selectPlantDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Tanggal Tanam *',
          hintText: 'Pilih tanggal tanam',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _plantDate != null
                  ? DateFormat('dd MMMM yyyy').format(_plantDate!)
                  : 'Pilih tanggal',
              style: TextStyle(
                color: _plantDate != null ? Colors.black : Colors.grey[600],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPlantDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1B5E20)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _plantDate = picked;
      });
    }
  }

  Widget _buildStatusSwitch() {
    return SwitchListTile(
      title: const Text('Status Tanaman'),
      subtitle: Text(_status == 1 ? 'Aktif' : 'Nonaktif'),
      value: _status == 1,
      onChanged: (value) {
        setState(() {
          _status = value ? 1 : 0;
        });
      },
      secondary: Icon(
        _status == 1 ? Icons.check_circle : Icons.cancel,
        color: _status == 1 ? Colors.green : Colors.grey,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _handleSubmit,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isEditMode ? 'Simpan Perubahan' : 'Tambah Tanaman',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_plantDate == null) {
      SnackbarHelper.showError(context, 'Tanggal tanam wajib dipilih');
      return;
    }

    // Create plant entity
    final plant = Plant(
      plantId: _idController.text.trim(),
      plantName: _nameController.text.trim(),
      plantType: _selectedCropType,
      plantSpecies: _speciesController.text.trim().isEmpty
          ? null
          : _speciesController.text.trim(),
      plantDate: _plantDate,
      plantSts: _status,
    );

    // Submit
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
