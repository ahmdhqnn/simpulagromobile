import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/shared/widgets/loading_overlay.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/user_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';

class UserFormScreen extends ConsumerStatefulWidget {
  final String? userId;

  const UserFormScreen({super.key, this.userId});

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  String? _selectedRoleId;
  String _status = 'active';
  bool _obscurePassword = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.userId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(userFormProvider);

    if (isEditMode && !_isInitialized) {
      final userAsync = ref.watch(utilitasUserDetailProvider(widget.userId!));

      userAsync.whenData((user) {
        if (!_isInitialized) {
          _initializeForm(user);
        }
      });

      if (userAsync.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (userAsync.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${userAsync.error}')),
        );
      }
    }

    final permission = isEditMode ? 'user:update' : 'user:create';

    return PermissionGuardScreen(
      permission: permission,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit User' : 'Tambah User'),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: formState.isLoading,
          message: isEditMode ? 'Menyimpan perubahan...' : 'Membuat user...',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildUserIdField(),
                const Gap(16),
                _buildUserNameField(),
                const Gap(16),
                _buildEmailField(),
                const Gap(16),
                _buildPhoneField(),
                const Gap(16),
                if (!isEditMode) ...[_buildPasswordField(), const Gap(16)],
                _buildRoleDropdown(),
                const Gap(16),
                _buildStatusDropdown(),
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

  void _initializeForm(User user) {
    _idController.text = user.userId;
    _nameController.text = user.userName;
    _emailController.text = user.userEmail ?? '';
    _phoneController.text = user.userPhone ?? '';
    _selectedRoleId = user.roleId;
    _status = user.userSts ?? 'active';
    _isInitialized = true;
  }

  Widget _buildUserIdField() {
    return TextFormField(
      controller: _idController,
      enabled: !isEditMode,
      decoration: InputDecoration(
        labelText: 'User ID *',
        hintText: 'Contoh: USER001',
        prefixIcon: const Icon(Icons.tag),
        filled: true,
        fillColor: isEditMode ? Colors.grey[100] : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'User ID wajib diisi';
        }
        if (value.length < 3) {
          return 'User ID minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildUserNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Lengkap *',
        hintText: 'Contoh: John Doe',
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama wajib diisi';
        }
        if (value.length < 3) {
          return 'Nama minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Contoh: user@example.com',
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Format email tidak valid';
          }
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'No. Telepon',
        hintText: 'Contoh: 081234567890',
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.length < 10 || value.length > 15) {
            return 'No. telepon tidak valid';
          }
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password *',
        hintText: 'Minimal 6 karakter',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password wajib diisi';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRoleId,
      decoration: const InputDecoration(
        labelText: 'Role *',
        hintText: 'Pilih role',
        prefixIcon: Icon(Icons.admin_panel_settings),
      ),
      items: const [
        DropdownMenuItem(value: 'ROLE001', child: Text('Admin')),
        DropdownMenuItem(value: 'ROLE002', child: Text('User')),
        DropdownMenuItem(value: 'ROLE003', child: Text('Viewer')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedRoleId = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Role wajib dipilih';
        }
        return null;
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(
        labelText: 'Status',
        prefixIcon: Icon(Icons.toggle_on),
      ),
      items: const [
        DropdownMenuItem(value: 'active', child: Text('Aktif')),
        DropdownMenuItem(value: 'inactive', child: Text('Nonaktif')),
      ],
      onChanged: (value) {
        setState(() {
          _status = value ?? 'active';
        });
      },
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
        isEditMode ? 'Simpan Perubahan' : 'Tambah User',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = User(
      userId: _idController.text.trim(),
      userName: _nameController.text.trim(),
      userEmail: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      userPhone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      userSts: _status,
      roleId: _selectedRoleId,
    );

    final success = isEditMode
        ? await ref
              .read(userFormProvider.notifier)
              .updateUser(widget.userId!, user)
        : await ref
              .read(userFormProvider.notifier)
              .createUser(user, _passwordController.text.trim());

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode ? 'User berhasil diperbarui' : 'User berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(userFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan user');
    }
  }
}
