import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/app_localizations.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changePasswordTitle), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPasswordField(
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
                    const SizedBox(height: 16),
                    _buildPasswordField(
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
                    const SizedBox(height: 16),
                    _buildPasswordField(
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: changePasswordState.isLoading
                            ? null
                            : _submit,
                        child: changePasswordState.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.changePasswordSubmit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
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
