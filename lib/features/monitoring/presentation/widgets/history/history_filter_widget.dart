import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../providers/monitoring_provider.dart';

class HistoryFilterWidget extends ConsumerStatefulWidget {
  const HistoryFilterWidget({super.key});

  @override
  ConsumerState<HistoryFilterWidget> createState() =>
      _HistoryFilterWidgetState();
}

class _HistoryFilterWidgetState extends ConsumerState<HistoryFilterWidget> {
  bool _showMenu = false;

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(historyFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _FilterChipButton(
              label: _getFilterLabel(filter),
              onTap: () => setState(() => _showMenu = !_showMenu),
            ),
            GestureDetector(
              onTap: () => setState(() => _showMenu = !_showMenu),
              child: Container(
                width: 36,
                height: 36,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  'assets/icons/filter_icon.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ],
        ),
        if (_showMenu) ...[
          SizedBox(height: context.rh(0.012)),
          _FilterMenu(
            current: filter,
            onChanged: (f) {
              ref.read(historyFilterProvider.notifier).state = f;
              setState(() => _showMenu = false);
            },
          ),
        ],
        if (filter == HistoryFilter.singleDate) ...[
          SizedBox(height: context.rh(0.015)),
          const _SingleDatePicker(),
        ],
        if (filter == HistoryFilter.dateRange) ...[
          SizedBox(height: context.rh(0.015)),
          const _DateRangePicker(),
        ],
      ],
    );
  }

  String _getFilterLabel(HistoryFilter filter) {
    switch (filter) {
      case HistoryFilter.today:
        return 'Hari Ini';
      case HistoryFilter.singleDate:
        return 'Per Tanggal';
      case HistoryFilter.sevenDay:
        return '7 Hari';
      case HistoryFilter.dateRange:
        return 'Rentang Tanggal';
      case HistoryFilter.plantingDate:
        return 'Masa Tanam';
    }
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterChipButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.label(
              context,
              weight: FontWeight.w400,
              height: 1.83,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterMenu extends StatelessWidget {
  final HistoryFilter current;
  final ValueChanged<HistoryFilter> onChanged;

  const _FilterMenu({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final filters = [
      (HistoryFilter.today, 'Hari Ini'),
      (HistoryFilter.singleDate, 'Per Tanggal'),
      (HistoryFilter.sevenDay, '7 Hari'),
      (HistoryFilter.dateRange, 'Rentang Tanggal'),
      (HistoryFilter.plantingDate, 'Masa Tanam'),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: filters.map((f) {
          final isSelected = f.$1 == current;
          return InkWell(
            onTap: () => onChanged(f.$1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    f.$2,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SingleDatePicker extends ConsumerWidget {
  const _SingleDatePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(historySingleDateProvider);
    final fmt = DateFormat('dd MMM yyyy');

    return _DateButton(
      label: 'Tanggal',
      date: fmt.format(date),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: AppColors.primary),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          ref.read(historySingleDateProvider.notifier).state = picked;
          ref.invalidate(historyReadsProvider);
        }
      },
    );
  }
}

class _DateRangePicker extends ConsumerWidget {
  const _DateRangePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final start = ref.watch(historyStartDateProvider);
    final end = ref.watch(historyEndDateProvider);
    final fmt = DateFormat('dd MMM yyyy');

    return Row(
      children: [
        Expanded(
          child: _DateButton(
            label: 'Dari',
            date: fmt.format(start),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: start,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primary,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                ref.read(historyStartDateProvider.notifier).state = picked;
                ref.invalidate(historyReadsProvider);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateButton(
            label: 'Sampai',
            date: fmt.format(end),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: end,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primary,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                ref.read(historyEndDateProvider.notifier).state = picked;
                ref.invalidate(historyReadsProvider);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final String date;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption(
                    context,
                    size: 10,
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
