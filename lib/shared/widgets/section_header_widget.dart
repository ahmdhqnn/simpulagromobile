import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;
  final Widget? trailing;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.fontSize = 22,
    this.fontWeight = FontWeight.w400,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      title,
      style: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: context.sp(fontSize),
        fontWeight: fontWeight,
        color: AppColors.textPrimary,
        height: 1.0,
      ),
    );

    final content = trailing == null
        ? text
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: text),
              trailing!,
            ],
          );

    return Padding(padding: padding ?? EdgeInsets.zero, child: content);
  }
}
