import 'package:flutter/material.dart';

/// Show confirmation dialog with consistent design
/// Returns true if user confirms, false if cancelled
Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Ya',
  String cancelText = 'Batal',
  Color? confirmColor,
  bool isDangerous = false,
}) async {
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
            cancelText,
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
            confirmText,
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
  return showConfirmationDialog(
    context,
    title: 'Hapus $itemName?',
    message: additionalMessage ?? 'Data yang dihapus tidak dapat dikembalikan.',
    confirmText: 'Hapus',
    cancelText: 'Batal',
    isDangerous: true,
  );
}
