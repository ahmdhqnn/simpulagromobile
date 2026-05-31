import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppCardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  const AppCardWidget({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = AppRadius.xl,
    this.color,
    this.boxShadow,
    this.border,
    this.height,
    this.width,
    this.onTap,
  });

  /// Card with subtle drop shadow, common for chart cards.
  const AppCardWidget.elevated({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.radius = AppRadius.xl,
    this.color,
    this.border,
    this.height,
    this.width,
    this.onTap,
  }) : boxShadow = AppShadows.card;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: boxShadow,
        border: border,
      ),
      child: child,
    );

    if (onTap == null) return container;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: container,
      ),
    );
  }
}
