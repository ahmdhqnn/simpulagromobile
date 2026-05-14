import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';

class IconBadgeWidget extends StatelessWidget {
  final double size;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final Color background;
  final double radius;

  final String? svgIconPath;
  final IconData? icon;
  final Color? tint;

  const IconBadgeWidget.svg({
    super.key,
    required String this.svgIconPath,
    required this.background,
    this.tint,
    this.size = 50,
    this.iconSize = 20,
    this.padding = const EdgeInsets.all(15),
    this.radius = AppRadius.sm,
  }) : icon = null;

  const IconBadgeWidget.icon({
    super.key,
    required IconData this.icon,
    required this.background,
    this.tint,
    this.size = 50,
    this.iconSize = 20,
    this.padding = const EdgeInsets.all(15),
    this.radius = AppRadius.sm,
  }) : svgIconPath = null;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (svgIconPath != null) {
      content = SvgPicture.asset(
        svgIconPath!,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
        colorFilter: tint == null
            ? null
            : ColorFilter.mode(tint!, BlendMode.srcIn),
      );
    } else {
      content = Icon(icon, color: tint, size: iconSize);
    }

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(child: content),
    );
  }
}
