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
import 'package:simpulagromobile/l10n/l10n.dart';

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
          title: context.l10n.adminLoadingTitle,
          body: const AdminFormScreenSkeleton(
            titleWidth: 158,
            sectionFieldCounts: [4, 2, 2],
          ),
        );
      }
      if (userAsync.hasError) {
        return AdminFormScaffold(
          title: context.l10n.commonErrorTitle,
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
        title: isEditMode
            ? context.l10n.adminEditUserTitle
            : context.l10n.adminAddUserTitle,
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? context.l10n.adminSavingChanges
            : context.l10n.adminCreatingUser,
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
                isEditMode
                    ? context.l10n.adminEditUserTitle
                    : context.l10n.adminAddUserTitle,
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
                title: context.l10n.adminAccountInfoSection,
                child: Column(
                  children: [
                    AdminFormFields.buildField(
                      context,
                      controller: _idController,
                      label: context.l10n.adminUserIdLabel,
                      hint: context.l10n.adminUserIdHint,
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminUserIdRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: context.l10n.adminFullNameLabel,
                      hint: context.l10n.adminFullNameHint,
                      icon: Icons.person,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminNameRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _emailController,
                      label: context.l10n.adminEmailLabel,
                      hint: context.l10n.adminEmailHint,
                      icon: Icons.email,
                      required: !isEditMode,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (!isEditMode && (v == null || v.trim().isEmpty)) {
                          return context.l10n.commonRequired;
                        }
                        if (v != null && v.trim().isNotEmpty) {
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(v.trim())) {
                            return context.l10n.adminEmailInvalid;
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _phoneController,
                      label: context.l10n.adminPhoneLabel,
                      hint: context.l10n.adminPhoneHint,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v != null && v.isNotEmpty) {
                          if (v.length < 10 || v.length > 15) {
                            return context.l10n.adminPhoneInvalid;
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
                  title: context.l10n.adminSecuritySection,
                  child: _buildPasswordField(context),
                ),
                SizedBox(height: context.rh(0.02)),
              ],

              AdminSectionCard(
                title: context.l10n.adminRoleStatusSection,
                child: Column(
                  children: [
                    if (!isEditMode) ...[
                      AdminFormFields.buildDropdown<String>(
                        context,
                        value: _selectedRoleId,
                        label: context.l10n.adminRoleLabel,
                        hint: context.l10n.adminSelectRoleHint,
                        icon: Icons.admin_panel_settings,
                        items: [
                          DropdownMenuItem(
                            value: 'ROLE001',
                            child: Text(context.l10n.roleAdmin),
                          ),
                          DropdownMenuItem(
                            value: 'ROLE002',
                            child: Text(context.l10n.roleUser),
                          ),
                          DropdownMenuItem(
                            value: 'ROLE003',
                            child: Text(context.l10n.roleViewer),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedRoleId = v),
                      ),
                      SizedBox(height: context.rh(0.016)),
                    ] else if (_selectedRoleId != null) ...[
                      _ReadOnlyInfoRow(
                        icon: Icons.admin_panel_settings,
                        label: context.l10n.adminRoleLabel,
                        value: _roleLabel(context, _selectedRoleId!),
                      ),
                      SizedBox(height: context.rh(0.016)),
                    ],
                    AdminFormFields.buildDropdown<String>(
                      context,
                      value: _status,
                      label: context.l10n.adminStatusSection,
                      hint: context.l10n.adminSelectStatusHint,
                      icon: Icons.toggle_on,
                      items: [
                        DropdownMenuItem(
                          value: 'active',
                          child: Text(context.l10n.commonActive),
                        ),
                        DropdownMenuItem(
                          value: 'inactive',
                          child: Text(context.l10n.commonInactive),
                        ),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? 'active'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              AdminSubmitButton(
                label: isEditMode
                    ? context.l10n.commonSaveChanges
                    : context.l10n.adminAddUserTitle,
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
    _status = _normalizeStatus(user.userSts) ?? 'active';
    _isInitialized = true;
  }

  String? _normalizeStatus(String? value) {
    if (value == null) return null;
    final text = value.trim().toLowerCase();
    if (text == '1') return 'active';
    if (text == '0') return 'inactive';
    return text;
  }

  String _roleLabel(BuildContext context, String roleId) {
    return switch (roleId) {
      'ROLE001' => context.l10n.roleAdmin,
      'ROLE002' => context.l10n.roleUser,
      'ROLE003' => context.l10n.roleViewer,
      _ => roleId,
    };
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
        labelText: '${context.l10n.adminPasswordLabel} *',
        hintText: context.l10n.adminPasswordHint,
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
          borderSide: BorderSide.none,
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
        if (v == null || v.isEmpty) return context.l10n.adminPasswordRequired;
        if (v.length < 6) return context.l10n.adminPasswordMinLength;
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
        isEditMode
            ? context.l10n.adminUpdateSuccess(context.l10n.roleUser)
            : context.l10n.adminCreateSuccess(context.l10n.roleUser),
      );
      context.pop();
    } else {
      final error = ref.read(adminUserFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.adminSaveFailed(context.l10n.roleUser),
      );
    }
  }
}

class _ReadOnlyInfoRow extends StatelessWidget {
  const _ReadOnlyInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
          ),
          SizedBox(width: context.rw(0.03)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
