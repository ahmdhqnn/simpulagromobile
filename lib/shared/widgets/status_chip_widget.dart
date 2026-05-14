import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class StatusChipWidget extends StatelessWidget {
  final String label;
  final Color color;
  final double horizontalPadding;
  final double verticalPadding;
  final double radius;
  final double fontSize;

  const StatusChipWidget({
    super.key,
    required this.label,
    required this.color,
    this.horizontalPadding = 12,
    this.verticalPadding = 6,
    this.radius = AppRadius.xs,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(fontSize),
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
