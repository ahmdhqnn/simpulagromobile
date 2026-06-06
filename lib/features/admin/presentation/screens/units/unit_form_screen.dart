import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/admin/domain/entities/unit.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

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
    final formState = ref.watch(adminUnitFormProvider);

    if (isEditMode && !_isInitialized) {
      final unitAsync = ref.watch(adminUnitDetailProvider(widget.unitId!));
      unitAsync.whenData((unit) {
        if (!_isInitialized) _initializeForm(unit);
      });

      if (unitAsync.isLoading) {
        return AdminFormScaffold(
          title: 'Memuat...',
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: FormCardSkeleton(fieldCount: 4),
          ),
        );
      }
      if (unitAsync.hasError) {
        return AdminFormScaffold(
          title: 'Error',
          body: AdminErrorState(
            error: unitAsync.error!,
            onRetry: () =>
                ref.invalidate(adminUnitDetailProvider(widget.unitId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'unit:update' : 'unit:create';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: isEditMode ? 'Edit Unit' : 'Tambah Unit',
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? 'Menyimpan perubahan...'
            : 'Membuat unit...',
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
                isEditMode ? 'Edit Unit' : 'Tambah Unit',
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
                title: 'Informasi Unit',
                child: Column(
                  children: [
                    AdminFormFields.buildField(
                      context,
                      controller: _idController,
                      label: 'Unit ID',
                      hint: 'Contoh: TEMP_C',
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Unit ID wajib diisi';
                        }
                        if (v.length < 2) {
                          return 'Minimal 2 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: 'Nama Unit',
                      hint: 'Contoh: Celsius',
                      icon: Icons.straighten,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama unit wajib diisi';
                        }
                        if (v.length < 2) {
                          return 'Minimal 2 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _symbolController,
                      label: 'Simbol',
                      hint: 'Contoh: °C',
                      icon: Icons.text_fields,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Simbol wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _descController,
                      label: 'Deskripsi',
                      hint: 'Contoh: Satuan suhu dalam derajat Celsius',
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              AdminSectionCard(
                title: 'Status',
                child: AdminFormFields.buildStatusToggle(
                  context,
                  label: 'Status Unit',
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              AdminSubmitButton(
                label: isEditMode ? 'Simpan Perubahan' : 'Tambah Unit',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

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
              .read(adminUnitFormProvider.notifier)
              .updateUnit(widget.unitId!, unit)
        : await ref.read(adminUnitFormProvider.notifier).createUnit(unit);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode ? 'Unit berhasil diperbarui' : 'Unit berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(adminUnitFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan unit');
    }
  }
}
