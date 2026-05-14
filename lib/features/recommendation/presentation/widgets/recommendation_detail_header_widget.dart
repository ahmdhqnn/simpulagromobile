import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';

class RecommendationDetailHeaderWidget extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const RecommendationDetailHeaderWidget({
    super.key,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: onBack),
          CircularIconActionWidget(onPressed: onRefresh, icon: Icons.refresh),
        ],
      ),
    );
  }
}
