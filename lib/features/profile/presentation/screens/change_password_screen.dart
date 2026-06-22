import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../admin/presentation/widgets/admin_form_fields.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final changePasswordState = ref.watch(changePasswordProvider);

    return AdminFormScaffold(
      title: l10n.changePasswordTitle,
      isLoading: changePasswordState.isLoading,
      loadingMessage: l10n.changePasswordSubmit,
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.rw(0.051),
            vertical: context.rh(0.01),
          ),
          children: [
            AdminSectionCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPasswordField(
                    context,
                    controller: _oldPasswordController,
                    label: l10n.changePasswordCurrentLabel,
                    hint: l10n.changePasswordCurrentHint,
                    obscureText: !_showOldPassword,
                    onToggleVisibility: () {
                      setState(() => _showOldPassword = !_showOldPassword);
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.changePasswordCurrentRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPasswordField(
                    context,
                    controller: _newPasswordController,
                    label: l10n.changePasswordNewLabel,
                    hint: l10n.changePasswordNewHint,
                    obscureText: !_showNewPassword,
                    onToggleVisibility: () {
                      setState(() => _showNewPassword = !_showNewPassword);
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.changePasswordNewRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPasswordField(
                    context,
                    controller: _confirmPasswordController,
                    label: l10n.changePasswordConfirmLabel,
                    hint: l10n.changePasswordConfirmHint,
                    obscureText: !_showConfirmPassword,
                    onToggleVisibility: () {
                      setState(
                        () => _showConfirmPassword = !_showConfirmPassword,
                      );
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.changePasswordConfirmRequired;
                      }
                      if (value != _newPasswordController.text) {
                        return l10n.changePasswordConfirmMismatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AdminSubmitButton(
              label: l10n.changePasswordSubmit,
              isLoading: changePasswordState.isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return AdminFormFields.buildField(
      context,
      controller: controller,
      label: label,
      hint: hint,
      icon: Icons.lock_outline,
      obscureText: obscureText,
      validator: validator,
      suffixIcon: IconButton(
        tooltip: obscureText ? 'Tampilkan password' : 'Sembunyikan password',
        onPressed: onToggleVisibility,
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: AppColors.textPrimary.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(changePasswordProvider.notifier)
        .submit(
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, l10n.changePasswordSuccess);
      Navigator.of(context).pop();
      return;
    }

    final state = ref.read(changePasswordProvider);
    final message = switch (state.errorType) {
      ChangePasswordErrorType.confirmMismatch =>
        l10n.changePasswordErrorConfirmMismatch,
      ChangePasswordErrorType.unauthorized =>
        l10n.changePasswordErrorUnauthorized,
      ChangePasswordErrorType.userNotFound =>
        l10n.changePasswordErrorUserNotFound,
      ChangePasswordErrorType.unknown ||
      null => state.message ?? l10n.changePasswordFailed,
    };
    SnackbarHelper.showError(context, message);
  }
}
