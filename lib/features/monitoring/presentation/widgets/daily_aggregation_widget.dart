import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/monitoring_models.dart';

/// Daily aggregation widget showing min, max, avg values
class DailyAggregationWidget extends StatelessWidget {
  final List<SensorDailyModel> data;
  final String title;
  final DateRange dateRange;

  const DailyAggregationWidget({
    super.key,
    required this.data,
    this.title = 'Daily Summary',
    this.dateRange = DateRange.week,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyState(context);
    }

    // Group by sensor
    final grouped = <String, List<SensorDailyModel>>{};
    for (final item in data) {
      grouped.putIfAbsent(item.dsId, () => []).add(item);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.rw(0.041)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _getDateRangeText(),
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${grouped.length} sensors',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: grouped.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final entry = grouped.entries.elementAt(index);
              return _SensorAggregationItem(
                sensorId: entry.key,
                data: entry.value,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: AppColors.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada data agregasi',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getDateRangeText() {
    switch (dateRange) {
      case DateRange.today:
        return 'Today';
      case DateRange.week:
        return 'Last 7 days';
      case DateRange.month:
        return 'Last 30 days';
      case DateRange.custom:
        return 'Custom range';
    }
  }
}

class _SensorAggregationItem extends StatelessWidget {
  final String sensorId;
  final List<SensorDailyModel> data;

  const _SensorAggregationItem({required this.sensorId, required this.data});

  @override
  Widget build(BuildContext context) {
    // Calculate aggregations
    final values = data.map((d) => d.avgVal ?? 0).toList();
    final avg = values.isEmpty
        ? 0
        : values.reduce((a, b) => a + b) / values.length;
    final min = data.map((d) => d.minVal ?? 0).reduce((a, b) => a < b ? a : b);
    final max = data.map((d) => d.maxVal ?? 0).reduce((a, b) => a > b ? a : b);
    final unit = SensorMeta.unit(sensorId);
    final label = SensorMeta.label(sensorId);

    return Padding(
      padding: EdgeInsets.all(context.rw(0.041)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.01)),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Average',
                  value: avg.toStringAsFixed(1),
                  unit: unit,
                  color: AppColors.primary,
                  icon: Icons.show_chart,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: _StatCard(
                  label: 'Min',
                  value: min.toStringAsFixed(1),
                  unit: unit,
                  color: AppColors.info,
                  icon: Icons.arrow_downward,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: _StatCard(
                  label: 'Max',
                  value: max.toStringAsFixed(1),
                  unit: unit,
                  color: AppColors.warning,
                  icon: Icons.arrow_upward,
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(0.01)),
          Text(
            '${data.length} data points',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(10),
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.025)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(10),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(10),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum DateRange { today, week, month, custom }
