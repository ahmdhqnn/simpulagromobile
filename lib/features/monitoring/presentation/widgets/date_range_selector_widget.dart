import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import 'daily_aggregation_widget.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final DateRange selected;
  final ValueChanged<DateRange> onSelected;
  final String? title;

  const DateRangeSelectorWidget({
    super.key,
    required this.selected,
    required this.onSelected,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? context.l10n.monitoringRangeLabel;
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
                children: DateRange.values.map((range) {
                  final isSelected = range == selected;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _RangePill(
                      label: _label(context, range),
                      selected: isSelected,
                      onTap: () => onSelected(range),
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

  String _label(BuildContext context, DateRange range) {
    final l10n = context.l10n;
    switch (range) {
      case DateRange.today:
        return l10n.monitoringFilterToday;
      case DateRange.week:
        return l10n.monitoringFilterSevenDay;
      case DateRange.month:
        return l10n.monitoringFilterThirtyDay;
      case DateRange.custom:
        return l10n.monitoringFilterCustom;
    }
  }
}

class _RangePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangePill({
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
