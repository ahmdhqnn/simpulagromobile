import 'package:flutter/material.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText ?? l10n.commonCancel,
            style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? (isDangerous ? Colors.red : null),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            confirmText ?? l10n.commonYes,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
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
