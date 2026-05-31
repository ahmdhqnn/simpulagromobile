import 'package:flutter/material.dart';

/// Lightweight responsive helper.
/// Usage: `context.sw` (screen width), `context.sh` (screen height),
/// `context.rw(0.05)` (5% of width), `context.rh(0.08)` (8% of height),
/// `context.sp(14)` (font size helper kept for migration compatibility).
extension ResponsiveContext on BuildContext {
  double get sw => MediaQuery.sizeOf(this).width;
  double get sh => MediaQuery.sizeOf(this).height;

  /// Percentage of screen width
  double rw(double percent) => sw * percent;

  /// Percentage of screen height
  double rh(double percent) => sh * percent;

  /// Do not scale text with viewport width; Flutter handles user text scaling.
  double sp(double size) => size;

  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
}
