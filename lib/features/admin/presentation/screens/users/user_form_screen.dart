import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/user_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

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
    final formState = ref.watch(adminUserFormProvider);

    if (isEditMode && !_isInitialized) {
      final userAsync = ref.watch(adminUserDetailProvider(widget.userId!));
      userAsync.whenData((user) {
        if (!_isInitialized) _initializeForm(user);
      });

      if (userAsync.isLoading) {
        return AdminFormScaffold(
          title: 'Memuat...',
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: FormCardSkeleton(fieldCount: 6),
          ),
        );
      }
      if (userAsync.hasError) {
        return AdminFormScaffold(
          title: 'Error',
          body: AdminErrorState(
            error: userAsync.error!,
            onRetry: () =>
                ref.invalidate(adminUserDetailProvider(widget.userId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'user:update' : 'user:create';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: isEditMode ? 'Edit User' : 'Tambah User',
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? 'Menyimpan perubahan...'
            : 'Membuat user...',
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
                isEditMode ? 'Edit User' : 'Tambah User',
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
                title: 'Informasi Akun',
                child: Column(
                  children: [
                    AdminFormFields.buildField(
                      context,
                      controller: _idController,
                      label: 'User ID',
                      hint: 'Contoh: USER001',
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'User ID wajib diisi';
                        }
                        if (v.length < 3) {
                          return 'Minimal 3 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: 'Nama Lengkap',
                      hint: 'Contoh: John Doe',
                      icon: Icons.person,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        if (v.length < 3) {
                          return 'Minimal 3 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Contoh: user@example.com',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v != null && v.isNotEmpty) {
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(v)) {
                            return 'Format email tidak valid';
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _phoneController,
                      label: 'No. Telepon',
                      hint: 'Contoh: 081234567890',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v != null && v.isNotEmpty) {
                          if (v.length < 10 || v.length > 15) {
                            return 'No. telepon tidak valid';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              if (!isEditMode) ...[
                AdminSectionCard(
                  title: 'Keamanan',
                  child: _buildPasswordField(context),
                ),
                SizedBox(height: context.rh(0.02)),
              ],

              AdminSectionCard(
                title: 'Role & Status',
                child: Column(
                  children: [
                    AdminFormFields.buildDropdown<String>(
                      context,
                      value: _selectedRoleId,
                      label: 'Role *',
                      hint: 'Pilih role',
                      icon: Icons.admin_panel_settings,
                      items: const [
                        DropdownMenuItem(
                          value: 'ROLE001',
                          child: Text('Admin'),
                        ),
                        DropdownMenuItem(value: 'ROLE002', child: Text('User')),
                        DropdownMenuItem(
                          value: 'ROLE003',
                          child: Text('Viewer'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _selectedRoleId = v),
                      validator: (v) => v == null ? 'Role wajib dipilih' : null,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildDropdown<String>(
                      context,
                      value: _status,
                      label: 'Status',
                      hint: 'Pilih status',
                      icon: Icons.toggle_on,
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Aktif')),
                        DropdownMenuItem(
                          value: 'inactive',
                          child: Text('Nonaktif'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? 'active'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              AdminSubmitButton(
                label: isEditMode ? 'Simpan Perubahan' : 'Tambah User',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
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

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(14),
        color: const Color(0xFF1D1D1D),
      ),
      decoration: InputDecoration(
        labelText: 'Password *',
        hintText: 'Minimal 6 karakter',
        prefixIcon: const Icon(Icons.lock, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.4),
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: context.sp(14),
          color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Password wajib diisi';
        if (v.length < 6) return 'Password minimal 6 karakter';
        return null;
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

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
              .read(adminUserFormProvider.notifier)
              .updateUser(widget.userId!, user)
        : await ref
              .read(adminUserFormProvider.notifier)
              .createUser(user, _passwordController.text.trim());

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode ? 'User berhasil diperbarui' : 'User berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(adminUserFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan user');
    }
  }
}
