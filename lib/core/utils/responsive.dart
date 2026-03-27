import 'package:flutter/material.dart';

/// Lightweight responsive helper.
/// Usage: `context.sw` (screen width), `context.sh` (screen height),
/// `context.rw(0.05)` (5% of width), `context.rh(0.08)` (8% of height),
/// `context.sp(14)` (scaled font size).
extension ResponsiveContext on BuildContext {
  double get sw => MediaQuery.sizeOf(this).width;
  double get sh => MediaQuery.sizeOf(this).height;

  /// Percentage of screen width
  double rw(double percent) => sw * percent;

  /// Percentage of screen height
  double rh(double percent) => sh * percent;

  /// Scale a font size relative to a 390px-wide baseline (iPhone 14 / Pixel 5)
  double sp(double size) => size * (sw / 390).clamp(0.8, 1.3);

  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
}
