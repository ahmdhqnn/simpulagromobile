import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/monitoring_models.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.sensorName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Export button will be added here
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.rw(0.041)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart Type Selector
            _buildChartTypeSelector(),
            SizedBox(height: context.rh(0.02)),

            // Date Range Selector
            _buildDateRangeSelector(),
            SizedBox(height: context.rh(0.02)),

            // Main Chart
            _buildMainChart(),
            SizedBox(height: context.rh(0.03)),

            // Daily Aggregation
            Text(
              'Agregasi Harian',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(16),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.015)),
            _buildDailyAggregation(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTypeSelector() {
    return Row(
      children: [
        Text(
          'Tipe Chart:',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
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
                final isSelected = type == _selectedChartType;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_getChartTypeLabel(type)),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedChartType = type);
                    },
                    backgroundColor: AppColors.surfaceVariant,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Row(
      children: [
        Text(
          'Rentang:',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
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
                final isSelected = range == _selectedDateRange;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_getDateRangeLabel(range)),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedDateRange = range);
                    },
                    backgroundColor: AppColors.surfaceVariant,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainChart() {
    // Mock data for now
    final mockData = List.generate(
      20,
      (i) => SensorReadModel(
        readId: 'read_$i',
        dsId: widget.sensorId,
        readDate: DateTime.now().subtract(Duration(hours: 20 - i)),
        readValue: (20 + (i % 10) * 2).toString(),
        readSts: 1,
      ),
    );

    return SensorChartWidget(
      data: mockData,
      title: widget.sensorName,
      chartType: _selectedChartType,
    );
  }

  Widget _buildDailyAggregation() {
    // Mock data for now
    final mockData = List.generate(
      7,
      (i) => SensorDailyModel(
        day: DateTime.now().subtract(Duration(days: 7 - i)),
        devId: 'dev_001',
        dsId: widget.sensorId,
        avgVal: 25.0 + (i % 5) * 2,
        minVal: 20.0 + (i % 5),
        maxVal: 30.0 + (i % 5) * 2,
      ),
    );

    return DailyAggregationWidget(
      data: mockData,
      title: 'Agregasi 7 Hari Terakhir',
      dateRange: _selectedDateRange,
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
