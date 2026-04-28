import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/shared/widgets/loading_overlay.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/role_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
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
        if (!_isInitialized) {
          _initializeForm(role);
        }
      });

      if (roleAsync.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (roleAsync.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${roleAsync.error}')),
        );
      }
    }

    final permission = isEditMode ? 'role:update' : 'role:create';

    return PermissionGuardScreen(
      permission: permission,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Role' : 'Tambah Role'),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: formState.isLoading,
          message: isEditMode ? 'Menyimpan perubahan...' : 'Membuat role...',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildRoleIdField(),
                const Gap(16),
                _buildRoleNameField(),
                const Gap(16),
                _buildDescriptionField(),
                const Gap(24),
                _buildStatusSwitch(),
                const Gap(24),
                _buildPermissionsSection(),
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

  void _initializeForm(Role role) {
    _idController.text = role.roleId;
    _nameController.text = role.roleName ?? '';
    _descController.text = role.roleDesc ?? '';
    _status = role.roleSts ?? 1;
    _selectedPermissionIds = role.permissions.map((p) => p.permId).toSet();
    _isInitialized = true;
  }

  Widget _buildRoleIdField() {
    return TextFormField(
      controller: _idController,
      enabled: !isEditMode,
      decoration: InputDecoration(
        labelText: 'Role ID *',
        hintText: 'Contoh: ROLE001',
        prefixIcon: const Icon(Icons.tag),
        filled: true,
        fillColor: isEditMode ? Colors.grey[100] : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Role ID wajib diisi';
        }
        if (value.length < 3) {
          return 'Role ID minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildRoleNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Role *',
        hintText: 'Contoh: Admin, Operator, Viewer',
        prefixIcon: Icon(Icons.admin_panel_settings),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama role wajib diisi';
        }
        if (value.length < 3) {
          return 'Nama role minimal 3 karakter';
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
        hintText: 'Contoh: Role untuk administrator sistem',
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 2,
    );
  }

  Widget _buildStatusSwitch() {
    return SwitchListTile(
      title: const Text('Status Role'),
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

  Widget _buildPermissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Permissions',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${_selectedPermissionIds.length} dipilih',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const Gap(4),
        Text(
          'Pilih permissions yang dapat diakses oleh role ini',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const Gap(16),
        PermissionCheckboxGroup(
          selectedPermissionIds: _selectedPermissionIds,
          onChanged: (newSelected) {
            setState(() {
              _selectedPermissionIds = newSelected;
            });
          },
        ),
      ],
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
        isEditMode ? 'Simpan Perubahan' : 'Tambah Role',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
