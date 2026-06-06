import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/chart_detail_header_widget.dart';
import '../widgets/chart_type_selector_widget.dart';
import '../widgets/daily_aggregation_widget.dart';
import '../widgets/date_range_selector_widget.dart';
import '../widgets/sensor_chart_widget.dart';

class ChartDetailScreen extends ConsumerStatefulWidget {
  final String sensorId;
  final String sensorName;

  const ChartDetailScreen({
    super.key,
    required this.sensorId,
    required this.sensorName,
  });

  @override
  ConsumerState<ChartDetailScreen> createState() => _ChartDetailScreenState();
}

class _ChartDetailScreenState extends ConsumerState<ChartDetailScreen> {
  ChartType _selectedChartType = ChartType.line;
  DateRange _selectedDateRange = DateRange.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(historyReadsProvider);
    final dailyAsync = ref.watch(dailyReadsProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ChartDetailHeaderWidget(
              title: widget.sensorName,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  ref.invalidate(historyReadsProvider);
                  ref.invalidate(dailyReadsProvider);
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.rh(0.01)),
                      ChartTypeSelectorWidget(
                        selected: _selectedChartType,
                        onSelected: (t) =>
                            setState(() => _selectedChartType = t),
                      ),
                      SizedBox(height: context.rh(0.02)),
                      DateRangeSelectorWidget(
                        selected: _selectedDateRange,
                        onSelected: _onDateRangeSelected,
                      ),
                      SizedBox(height: context.rh(0.02)),

                      // Main Chart
                      historyAsync.when(
                        skipLoadingOnReload: true,
                        skipLoadingOnRefresh: true,
                        skipError: true,
                        loading: () => const ChartCardSkeleton(
                          chartHeight: 220,
                          hasSelector: false,
                        ),
                        error: (e, _) => ErrorStateCardWidget(
                          message: e.toString(),
                          onRetry: () {
                            ref.invalidate(historyReadsProvider);
                            ref.invalidate(dailyReadsProvider);
                          },
                        ),
                        data: (reads) {
                          final filtered = reads
                              .where((r) => r.dsId == widget.sensorId)
                              .toList();
                          if (filtered.isEmpty) {
                            return InfoStateWidget.icon(
                              icon: Icons.bar_chart_outlined,
                              message: l10n.monitoringChartNoSensorData,
                              height: 120,
                            );
                          }
                          return SensorChartWidget(
                            data: filtered,
                            title: widget.sensorName,
                            chartType: _selectedChartType,
                          );
                        },
                      ),

                      SizedBox(height: context.rh(0.024)),
                      SectionHeaderWidget(
                        title: l10n.monitoringChartDailyAggregation,
                      ),
                      SizedBox(height: context.rh(0.014)),

                      // Daily Aggregation
                      dailyAsync.when(
                        skipLoadingOnReload: true,
                        skipLoadingOnRefresh: true,
                        skipError: true,
                        loading: () => const ChartCardSkeleton(
                          chartHeight: 220,
                          hasStats: false,
                        ),
                        error: (e, _) => ErrorStateCardWidget(
                          message: e.toString(),
                          onRetry: () {
                            ref.invalidate(historyReadsProvider);
                            ref.invalidate(dailyReadsProvider);
                          },
                        ),
                        data: (dailyData) {
                          final filtered = dailyData
                              .where((d) => d.dsId == widget.sensorId)
                              .toList();
                          if (filtered.isEmpty) {
                            return InfoStateWidget.icon(
                              icon: Icons.bar_chart_outlined,
                              message: l10n.monitoringChartNoDailyAggregation,
                              height: 120,
                            );
                          }
                          return DailyAggregationWidget(
                            data: filtered,
                            metadataAdapter: metadataAdapter,
                            title: l10n.monitoringChartLast7DaysAggregation,
                            dateRange: _selectedDateRange,
                          );
                        },
                      ),

                      SizedBox(height: context.rh(0.02)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDateRangeSelected(DateRange range) {
    setState(() => _selectedDateRange = range);
    switch (range) {
      case DateRange.today:
        final today = DateTime.now();
        ref.read(historyStartDateProvider.notifier).state = DateTime(
          today.year,
          today.month,
          today.day,
        );
        ref.read(historyEndDateProvider.notifier).state = today;
        ref.read(historyFilterProvider.notifier).state =
            HistoryFilter.dateRange;
        break;
      case DateRange.week:
        ref.read(historyFilterProvider.notifier).state = HistoryFilter.sevenDay;
        break;
      case DateRange.month:
        ref.read(historyStartDateProvider.notifier).state = DateTime.now()
            .subtract(const Duration(days: 30));
        ref.read(historyEndDateProvider.notifier).state = DateTime.now();
        ref.read(historyFilterProvider.notifier).state =
            HistoryFilter.dateRange;
        break;
      case DateRange.custom:
        ref.read(historyFilterProvider.notifier).state =
            HistoryFilter.dateRange;
        break;
    }
  }
}
