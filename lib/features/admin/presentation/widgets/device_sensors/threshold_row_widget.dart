import 'package:flutter/material.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';

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
    assert(color != Colors.transparent || color == Colors.transparent);
    return AdminFormFields.buildField(
      context,
      controller: controller,
      label: label,
      hint: '',
      icon: icon,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
    );
  }
}
