import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/role_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_form_fields.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_checkbox_group.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/role.dart';

class RoleFormScreen extends ConsumerStatefulWidget {
  final String? roleId;

  const RoleFormScreen({super.key, this.roleId});

  @override
  ConsumerState<RoleFormScreen> createState() => _RoleFormScreenState();
}

class _RoleFormScreenState extends ConsumerState<RoleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  int _status = 1;
  Set<String> _selectedPermissionIds = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.roleId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(roleFormProvider);

    if (isEditMode && !_isInitialized) {
      final roleAsync = ref.watch(utilitasRoleDetailProvider(widget.roleId!));
      roleAsync.whenData((role) {
        if (!_isInitialized) _initializeForm(role);
      });

      if (roleAsync.isLoading) {
        return UtilitasFormScaffold(
          title: 'Memuat...',
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }
      if (roleAsync.hasError) {
        return UtilitasFormScaffold(
          title: 'Error',
          body: UtilitasErrorState(
            error: roleAsync.error!,
            onRetry: () =>
                ref.invalidate(utilitasRoleDetailProvider(widget.roleId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'role:update' : 'role:create';

    return PermissionGuardScreen(
      permission: permission,
      child: UtilitasFormScaffold(
        title: isEditMode ? 'Edit Role' : 'Tambah Role',
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? 'Menyimpan perubahan...'
            : 'Membuat role...',
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
                isEditMode ? 'Edit Role' : 'Tambah Role',
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
                title: 'Informasi Role',
                child: Column(
                  children: [
                    UtilitasFormFields.buildField(
                      context,
                      controller: _idController,
                      label: 'Role ID',
                      hint: 'Contoh: ROLE001',
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Role ID wajib diisi';
                        if (v.length < 3) return 'Minimal 3 karakter';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: 'Nama Role',
                      hint: 'Contoh: Admin, Operator, Viewer',
                      icon: Icons.admin_panel_settings,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Nama role wajib diisi';
                        if (v.length < 3) return 'Minimal 3 karakter';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _descController,
                      label: 'Deskripsi',
                      hint: 'Contoh: Role untuk administrator sistem',
                      icon: Icons.description,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              UtilitasSectionCard(
                title: 'Status',
                child: UtilitasFormFields.buildStatusToggle(
                  context,
                  label: 'Status Role',
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              // ── Permissions ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Permissions',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D1D1D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_selectedPermissionIds.length} dipilih',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(11),
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.rh(0.006)),
                    Text(
                      'Pilih permissions yang dapat diakses oleh role ini',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: context.rh(0.016)),
                    PermissionCheckboxGroup(
                      selectedPermissionIds: _selectedPermissionIds,
                      onChanged: (newSelected) {
                        setState(() => _selectedPermissionIds = newSelected);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              UtilitasSubmitButton(
                label: isEditMode ? 'Simpan Perubahan' : 'Tambah Role',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeForm(Role role) {
    _idController.text = role.roleId;
    _nameController.text = role.roleName ?? '';
    _descController.text = role.roleDesc ?? '';
    _status = role.roleSts ?? 1;
    _selectedPermissionIds = role.permissions.map((p) => p.permId).toSet();
    _isInitialized = true;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final role = Role(
      roleId: _idController.text.trim(),
      roleName: _nameController.text.trim(),
      roleDesc: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      roleSts: _status,
    );

    final permissionIds = _selectedPermissionIds.toList();

    final success = isEditMode
        ? await ref
              .read(roleFormProvider.notifier)
              .updateRole(widget.roleId!, role, permissionIds)
        : await ref
              .read(roleFormProvider.notifier)
              .createRole(role, permissionIds);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode ? 'Role berhasil diperbarui' : 'Role berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(roleFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan role');
    }
  }
}
