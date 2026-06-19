import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';
import '../utils/sensor_metadata_adapter.dart';

class DailyRecapTab extends ConsumerWidget {
  const DailyRecapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final siteId = ref.watch(selectedSiteIdProvider);
    if (siteId == null) {
      return Center(child: Text(l10n.monitoringSelectSiteFirst));
    }

    final selectedDay = ref.watch(dailyByDayDateProvider);
    final todayAsync = ref.watch(dailyTodayProvider);
    final selectedToday = _isSameDay(selectedDay, DateTime.now());
    final byDayAsync = selectedToday
        ? todayAsync
        : ref.watch(dailyByDayProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);
    final fmt = context.dateFormat('dd MMM yyyy');

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await runSpacedInvalidations([
          () => ref.invalidate(dailyTodayProvider),
          if (!selectedToday) () => ref.invalidate(dailyByDayProvider),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          0,
          context.rw(0.051),
          bottomNavigationContentSpace(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeaderWidget(title: l10n.monitoringDailyTodaySection),
            SizedBox(height: context.rh(0.014)),
            todayAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              data: (items) => _DailyRecapList(
                items: items,
                metadataAdapter: metadataAdapter,
              ),
              loading: () => const DailyRecapListSkeleton(),
              error: (e, _) => ErrorStateCardWidget(
                message: toUiErrorMessage(e, l10n),
                onRetry: () => ref.invalidate(dailyTodayProvider),
              ),
            ),
            SizedBox(height: context.rh(0.024)),
            SectionHeaderWidget(title: l10n.monitoringDailyByDateSection),
            SizedBox(height: context.rh(0.01)),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDay,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  ref.read(dailyByDayDateProvider.notifier).state = picked;
                }
              },
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(fmt.format(selectedDay)),
            ),
            SizedBox(height: context.rh(0.014)),
            byDayAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              data: (items) => _DailyRecapList(
                items: items,
                metadataAdapter: metadataAdapter,
              ),
              loading: () => const DailyRecapListSkeleton(),
              error: (e, _) => ErrorStateCardWidget(
                message: toUiErrorMessage(e, l10n),
                onRetry: () => ref.invalidate(dailyByDayProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class _DailyRecapList extends StatefulWidget {
  final List<SensorDailyModel> items;
  final SensorMetadataAdapter metadataAdapter;

  const _DailyRecapList({required this.items, required this.metadataAdapter});

  @override
  State<_DailyRecapList> createState() => _DailyRecapListState();
}

class _DailyRecapListState extends State<_DailyRecapList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.items.isEmpty) {
      return InfoStateWidget.icon(
        icon: Icons.table_chart_outlined,
        message: l10n.monitoringDailyNoRecap,
        height: 100,
      );
    }

    final sorted = List<SensorDailyModel>.of(widget.items)
      ..sort((a, b) {
        final dayCompare = (b.day ?? DateTime(0)).compareTo(
          a.day ?? DateTime(0),
        );
        if (dayCompare != 0) return dayCompare;
        return a.dsId.compareTo(b.dsId);
      });
    final visibleCount = _expanded
        ? sorted.length
        : sorted.length.clamp(0, 8).toInt();

    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: visibleCount,
            separatorBuilder: (_, __) =>
                const Divider(height: 18, color: AppColors.divider),
            itemBuilder: (context, index) => _DailyRecapRow(
              item: sorted[index],
              metadataAdapter: widget.metadataAdapter,
            ),
          ),
          if (sorted.length > 8)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.lg),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Text(
                  _expanded
                      ? l10n.monitoringShowLess
                      : l10n.monitoringShowAllCount(sorted.length),
                  style: AppTextStyles.label(
                    context,
                    color: AppColors.primary,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DailyRecapRow extends StatelessWidget {
  final SensorDailyModel item;
  final SensorMetadataAdapter metadataAdapter;

  const _DailyRecapRow({required this.item, required this.metadataAdapter});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = metadataAdapter.colorFor(item.dsId);
    final date = item.day != null
        ? context.dateFormat('dd MMM yyyy').format(item.day!)
        : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(Icons.insights_rounded, color: color, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metadataAdapter.labelFor(item.dsId, devId: item.devId),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(
                      context,
                      size: 13,
                      weight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$date - ${item.devId.isEmpty ? '-' : item.devId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(context, size: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _RecapMetric(
                label: l10n.commonMin,
                value: _formatValue(item.minVal),
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _RecapMetric(
                label: l10n.commonAverage,
                value: _formatValue(item.avgVal),
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _RecapMetric(
                label: l10n.commonMax,
                value: _formatValue(item.maxVal),
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatValue(double? value) => metadataAdapter.formatNumberWithUnit(
    item.dsId,
    value,
    devId: item.devId,
    fractionDigits: 2,
  );
}

class _RecapMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _RecapMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: AppTextStyles.label(
                context,
                size: 12,
                color: color,
                weight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption(context, size: 9),
          ),
        ],
      ),
    );
  }
}
