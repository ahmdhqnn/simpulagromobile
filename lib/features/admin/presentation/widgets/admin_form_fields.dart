import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';

/// Reusable form field builder untuk semua form screens admin.
class AdminFormFields {
  static Widget buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    String? suffixText,
    Widget? suffixIcon,
    String? helperText,
    String? Function(String?)? validator,
  }) {
    assert(icon.codePoint >= 0);
    return buildFieldShell(
      context,
      label: label,
      required: required,
      helperText: helperText,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: obscureText ? 1 : maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(14),
          color: AppColors.textPrimary,
        ),
        decoration: inputDecoration(
          context,
          hintText: hint,
          enabled: enabled,
          suffixText: suffixText,
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }

  static Widget buildFieldShell(
    BuildContext context, {
    required String label,
    required Widget child,
    bool required = false,
    String? helperText,
  }) {
    final displayLabel = required && !label.trim().endsWith('*')
        ? '$label *'
        : label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayLabel,
          style: AppTextStyles.label(
            context,
            size: context.sp(14),
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(height: context.rh(0.01)),
        child,
        if (helperText != null && helperText.trim().isNotEmpty) ...[
          SizedBox(height: context.rh(0.006)),
          Text(
            helperText,
            style: AppTextStyles.caption(
              context,
              size: context.sp(11),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  static InputDecoration inputDecoration(
    BuildContext context, {
    String? hintText,
    bool enabled = true,
    String? suffixText,
    Widget? suffixIcon,
  }) {
    final borderRadius = BorderRadius.circular(AppRadius.pill);

    return InputDecoration(
      hintText: hintText == null || hintText.isEmpty ? null : hintText,
      hintStyle: AppTextStyles.hint(context, size: context.sp(14)),
      filled: true,
      fillColor: enabled
          ? AppColors.surfaceVariant
          : AppColors.textPrimary.withValues(alpha: 0.05),
      hoverColor: Colors.transparent,
      border: _cleanInputBorder(borderRadius),
      enabledBorder: _cleanInputBorder(borderRadius),
      focusedBorder: _cleanInputBorder(borderRadius),
      disabledBorder: _cleanInputBorder(borderRadius),
      errorBorder: _cleanInputBorder(borderRadius),
      focusedErrorBorder: _cleanInputBorder(borderRadius),
      suffixText: suffixText,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.rw(0.041),
        vertical: context.rh(0.012),
      ),
    );
  }

  static Widget buildDropdown<T>(
    BuildContext context, {
    required T? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
    bool enabled = true,
    bool required = false,
    String? helperText,
  }) {
    assert(icon.codePoint >= 0);
    return buildFieldShell(
      context,
      label: label,
      required: required,
      helperText: helperText,
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(14),
          color: AppColors.textPrimary,
        ),
        decoration: inputDecoration(context, hintText: hint, enabled: enabled),
        items: items,
        onChanged: enabled ? onChanged : null,
        validator: validator,
      ),
    );
  }

  static Widget buildStatusToggle(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.041),
        vertical: context.rh(0.008),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(14),
                    weight: FontWeight.w400,
                  ),
                ),
                Text(
                  value
                      ? context.l10n.commonActive
                      : context.l10n.commonInactive,
                  style: AppTextStyles.caption(
                    context,
                    size: context.sp(12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  static Widget buildCoordinateRow(
    BuildContext context, {
    required TextEditingController latController,
    required TextEditingController lonController,
  }) {
    return Row(
      children: [
        Expanded(
          child: buildField(
            context,
            controller: latController,
            label: context.l10n.commonLatitude,
            hint: '-7.7956',
            icon: Icons.my_location,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final lat = double.tryParse(value);
                if (lat == null || lat < -90 || lat > 90) {
                  return context.l10n.commonInvalid;
                }
              }
              return null;
            },
          ),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: buildField(
            context,
            controller: lonController,
            label: context.l10n.commonLongitude,
            hint: '110.3695',
            icon: Icons.location_on,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final lon = double.tryParse(value);
                if (lon == null || lon < -180 || lon > 180) {
                  return context.l10n.commonInvalid;
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  static OutlineInputBorder _cleanInputBorder(BorderRadius borderRadius) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    );
  }
}
