import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import 'daily_aggregation_widget.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final DateRange selected;
  final ValueChanged<DateRange> onSelected;
  final String title;

  const DateRangeSelectorWidget({
    super.key,
    required this.selected,
    required this.onSelected,
    this.title = 'Rentang',
  });

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      radius: AppRadius.lg,
      child: Row(
        children: [
          Text(
            title,
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
                      label: _label(range),
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

  String _label(DateRange range) {
    switch (range) {
      case DateRange.today:
        return 'Hari Ini';
      case DateRange.week:
        return '7 Hari';
      case DateRange.month:
        return '30 Hari';
      case DateRange.custom:
        return 'Custom';
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
