import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/l10n.dart';

/// Show confirmation dialog with consistent design
/// Returns true if user confirms, false if cancelled
Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  Color? confirmColor,
  bool isDangerous = false,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      backgroundColor: AppColors.surface,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w300,
          fontSize: 22,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(
            cancelText ?? l10n.commonCancel,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor:
                confirmColor ??
                (isDangerous ? AppColors.error : AppColors.primary),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          child: Text(
            confirmText ?? l10n.commonYes,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}

/// Show delete confirmation dialog
Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  required String itemName,
  String? additionalMessage,
}) async {
  final l10n = context.l10n;
  return showConfirmationDialog(
    context,
    title: l10n.commonDeleteTitle(itemName),
    message: additionalMessage ?? l10n.commonDeleteIrreversible,
    confirmText: l10n.commonDelete,
    cancelText: l10n.commonCancel,
    isDangerous: true,
  );
}
