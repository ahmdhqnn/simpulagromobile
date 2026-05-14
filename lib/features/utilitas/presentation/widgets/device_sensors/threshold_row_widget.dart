import 'package:flutter/material.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';

class ThresholdRowWidget extends StatelessWidget {
  final TextEditingController leftController;
  final String leftLabel;
  final IconData leftIcon;
  final Color leftColor;

  final TextEditingController rightController;
  final String rightLabel;
  final IconData rightIcon;
  final Color rightColor;

  const ThresholdRowWidget({
    super.key,
    required this.leftController,
    required this.leftLabel,
    required this.leftIcon,
    required this.leftColor,
    required this.rightController,
    required this.rightLabel,
    required this.rightIcon,
    required this.rightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThresholdField(
            controller: leftController,
            label: leftLabel,
            icon: leftIcon,
            color: leftColor,
          ),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: _ThresholdField(
            controller: rightController,
            label: rightLabel,
            icon: rightIcon,
            color: rightColor,
          ),
        ),
      ],
    );
  }
}

class _ThresholdField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color color;

  const _ThresholdField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      style: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: context.sp(14),
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: color),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(12),
          color: AppColors.textPrimary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
