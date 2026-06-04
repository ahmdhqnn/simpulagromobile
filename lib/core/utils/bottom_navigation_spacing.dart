import 'package:flutter/material.dart';

import 'responsive.dart';

double bottomNavigationContentSpace(BuildContext context) {
  final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
  final navBottomGap = bottomInset > 0 ? 14.0 : 24.0;
  return 60 + navBottomGap + context.rh(0.024);
}
