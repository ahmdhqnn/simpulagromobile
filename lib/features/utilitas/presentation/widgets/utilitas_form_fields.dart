import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

/// Reusable form field builder untuk semua form screens Utilitas
/// Konsisten dengan design system project
class UtilitasFormFields {
  /// Standard text field
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(14),
        color: const Color(0xFF1D1D1D),
      ),
      decoration: _decoration(
        context,
        label: required ? '$label *' : label,
        hint: hint,
        icon: icon,
        enabled: enabled,
      ),
      validator: validator,
    );
  }

  /// Status toggle row
  static Widget buildStatusToggle(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (value ? AppColors.success : Colors.grey).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            value ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: value ? AppColors.success : Colors.grey,
            size: 22,
          ),
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
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
              Text(
                value ? 'Aktif' : 'Nonaktif',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
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
    );
  }

  /// Coordinate row (lat + lon)
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
            label: 'Latitude',
            hint: '-7.7956',
            icon: Icons.my_location,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            validator: (v) {
              if (v != null && v.isNotEmpty) {
                final lat = double.tryParse(v);
                if (lat == null || lat < -90 || lat > 90) return 'Tidak valid';
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
            label: 'Longitude',
            hint: '110.3695',
            icon: Icons.location_on,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            validator: (v) {
              if (v != null && v.isNotEmpty) {
                final lon = double.tryParse(v);
                if (lon == null || lon < -180 || lon > 180)
                  return 'Tidak valid';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  /// Dropdown field
  static Widget buildDropdown<T>(
    BuildContext context, {
    required T? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(14),
        color: const Color(0xFF1D1D1D),
      ),
      decoration: _decoration(context, label: label, hint: hint, icon: icon),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  static InputDecoration _decoration(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: enabled
          ? AppColors.surfaceVariant
          : const Color(0xFF1D1D1D).withValues(alpha: 0.05),
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(14),
        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      ),
      hintStyle: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(13),
        color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
      ),
    );
  }
}
