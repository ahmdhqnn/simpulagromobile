import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import 'sensor_chart_widget.dart';

class ChartTypeSelectorWidget extends StatelessWidget {
  final ChartType selected;
  final ValueChanged<ChartType> onSelected;
  final String? title;

  const ChartTypeSelectorWidget({
    super.key,
    required this.selected,
    required this.onSelected,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? context.l10n.monitoringChartTypeLabel;
    return AppCardWidget(
      radius: AppRadius.lg,
      child: Row(
        children: [
          Text(
            displayTitle,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ChartType.values.map((type) {
                  final isSelected = type == selected;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: _label(context, type),
                      selected: isSelected,
                      onTap: () => onSelected(type),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _label(BuildContext context, ChartType type) {
    final l10n = context.l10n;
    switch (type) {
      case ChartType.line:
        return l10n.monitoringChartTypeLine;
      case ChartType.bar:
        return l10n.monitoringChartTypeBar;
      case ChartType.area:
        return l10n.monitoringChartTypeArea;
    }
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(12),
            fontWeight: FontWeight.w500,
            color: selected
                ? Colors.white
                : AppColors.textPrimary.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
