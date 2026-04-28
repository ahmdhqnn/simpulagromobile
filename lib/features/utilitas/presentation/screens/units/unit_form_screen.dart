import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/shared/widgets/loading_overlay.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/unit.dart';

class UnitFormScreen extends ConsumerStatefulWidget {
  final String? unitId;

  const UnitFormScreen({super.key, this.unitId});

  @override
  ConsumerState<UnitFormScreen> createState() => _UnitFormScreenState();
}

class _UnitFormScreenState extends ConsumerState<UnitFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _symbolController;
  late final TextEditingController _descController;

  int _status = 1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _symbolController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _symbolController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.unitId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(unitFormProvider);

    if (isEditMode && !_isInitialized) {
      final unitAsync = ref.watch(utilitasUnitDetailProvider(widget.unitId!));

      unitAsync.whenData((unit) {
        if (!_isInitialized) {
          _initializeForm(unit);
        }
      });

      if (unitAsync.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (unitAsync.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${unitAsync.error}')),
        );
      }
    }

    final permission = isEditMode ? 'unit:update' : 'unit:create';

    return PermissionGuardScreen(
      permission: permission,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Unit' : 'Tambah Unit'),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: formState.isLoading,
          message: isEditMode ? 'Menyimpan perubahan...' : 'Membuat unit...',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildUnitIdField(),
                const Gap(16),
                _buildUnitNameField(),
                const Gap(16),
                _buildSymbolField(),
                const Gap(16),
                _buildDescriptionField(),
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

  void _initializeForm(Unit unit) {
    _idController.text = unit.unitId;
    _nameController.text = unit.unitName ?? '';
    _symbolController.text = unit.unitSymbol ?? '';
    _descController.text = unit.unitDesc ?? '';
    _status = unit.unitSts ?? 1;
    _isInitialized = true;
  }

  Widget _buildUnitIdField() {
    return TextFormField(
      controller: _idController,
      enabled: !isEditMode,
      decoration: InputDecoration(
        labelText: 'Unit ID *',
        hintText: 'Contoh: TEMP_C',
        prefixIcon: const Icon(Icons.tag),
        filled: true,
        fillColor: isEditMode ? Colors.grey[100] : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Unit ID wajib diisi';
        }
        if (value.length < 2) {
          return 'Unit ID minimal 2 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildUnitNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Unit *',
        hintText: 'Contoh: Celsius',
        prefixIcon: Icon(Icons.straighten),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama unit wajib diisi';
        }
        if (value.length < 2) {
          return 'Nama unit minimal 2 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildSymbolField() {
    return TextFormField(
      controller: _symbolController,
      decoration: const InputDecoration(
        labelText: 'Simbol *',
        hintText: 'Contoh: °C',
        prefixIcon: Icon(Icons.text_fields),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Simbol wajib diisi';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descController,
      decoration: const InputDecoration(
        labelText: 'Deskripsi',
        hintText: 'Contoh: Satuan suhu dalam derajat Celsius',
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
    );
  }

  Widget _buildStatusSwitch() {
    return SwitchListTile(
      title: const Text('Status Unit'),
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
        isEditMode ? 'Simpan Perubahan' : 'Tambah Unit',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final unit = Unit(
      unitId: _idController.text.trim(),
      unitName: _nameController.text.trim(),
      unitSymbol: _symbolController.text.trim(),
      unitDesc: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      unitSts: _status,
    );

    final success = isEditMode
        ? await ref
              .read(unitFormProvider.notifier)
              .updateUnit(widget.unitId!, unit)
        : await ref.read(unitFormProvider.notifier).createUnit(unit);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode ? 'Unit berhasil diperbarui' : 'Unit berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(unitFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan unit');
    }
  }
}
