import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/sensor_chart_widget.dart';
import '../widgets/daily_aggregation_widget.dart';

/// Detailed chart screen for a specific sensor
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
    // Ambil data dari provider yang sudah ada
    final historyAsync = ref.watch(historyReadsProvider);
    final dailyAsync = ref.watch(dailyReadsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
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
                      _buildChartTypeSelector(context),
                      SizedBox(height: context.rh(0.02)),
                      _buildDateRangeSelector(context),
                      SizedBox(height: context.rh(0.02)),

                      // Main Chart
                      historyAsync.when(
                        loading: () => _buildLoadingCard(context, 250),
                        error: (e, _) => _buildErrorCard(context, e.toString()),
                        data: (reads) {
                          // Filter data untuk sensor ini
                          final filtered = reads
                              .where((r) => r.dsId == widget.sensorId)
                              .toList();
                          if (filtered.isEmpty) {
                            return _buildEmptyCard(
                              context,
                              'Belum ada data untuk sensor ini',
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

                      Text(
                        'Agregasi Harian',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(22),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1D1D1D),
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: context.rh(0.014)),

                      // Daily Aggregation
                      dailyAsync.when(
                        loading: () => _buildLoadingCard(context, 200),
                        error: (e, _) => _buildErrorCard(context, e.toString()),
                        data: (dailyData) {
                          final filtered = dailyData
                              .where((d) => d.dsId == widget.sensorId)
                              .toList();
                          if (filtered.isEmpty) {
                            return _buildEmptyCard(
                              context,
                              'Belum ada data agregasi harian',
                            );
                          }
                          return DailyAggregationWidget(
                            data: filtered,
                            title: 'Agregasi 7 Hari Terakhir',
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/chevron-left-icon.svg',
                width: 28,
                height: 28,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          SizedBox(width: context.rw(0.03)),
          Expanded(
            child: Text(
              widget.sensorName,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(20),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTypeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(
            'Tipe Chart',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ChartType.values.map((type) {
                  final isSelected = type == _selectedChartType;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedChartType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getChartTypeLabel(type),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(
                                    0xFF1D1D1D,
                                  ).withValues(alpha: 0.7),
                          ),
                        ),
                      ),
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

  Widget _buildDateRangeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(
            'Rentang',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: DateRange.values.map((range) {
                  final isSelected = range == _selectedDateRange;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedDateRange = range);
                        // Update filter di monitoring provider
                        switch (range) {
                          case DateRange.today:
                            ref.read(historyFilterProvider.notifier).state =
                                HistoryFilter.sevenDay;
                            break;
                          case DateRange.week:
                            ref.read(historyFilterProvider.notifier).state =
                                HistoryFilter.sevenDay;
                            break;
                          case DateRange.month:
                            ref.read(historyFilterProvider.notifier).state =
                                HistoryFilter.dateRange;
                            break;
                          case DateRange.custom:
                            ref.read(historyFilterProvider.notifier).state =
                                HistoryFilter.dateRange;
                            break;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getDateRangeLabel(range),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(
                                    0xFF1D1D1D,
                                  ).withValues(alpha: 0.7),
                          ),
                        ),
                      ),
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

  Widget _buildLoadingCard(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 28),
          const SizedBox(height: 8),
          Text(
            error.replaceAll('Exception: ', ''),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              ref.invalidate(historyReadsProvider);
              ref.invalidate(dailyReadsProvider);
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text(
              'Coba Lagi',
              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String message) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 32,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.25),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getChartTypeLabel(ChartType type) {
    switch (type) {
      case ChartType.line:
        return 'Line';
      case ChartType.bar:
        return 'Bar';
      case ChartType.area:
        return 'Area';
    }
  }

  String _getDateRangeLabel(DateRange range) {
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
