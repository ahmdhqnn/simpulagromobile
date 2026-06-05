import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../data/models/monitoring_models.dart';
import '../utils/sensor_metadata_adapter.dart';
import 'monitoring_card_header_widget.dart';

/// Daily aggregation widget showing min, max, avg values
class DailyAggregationWidget extends StatelessWidget {
  final List<SensorDailyModel> data;
  final String title;
  final DateRange dateRange;
  final SensorMetadataAdapter metadataAdapter;

  const DailyAggregationWidget({
    super.key,
    required this.data,
    required this.metadataAdapter,
    this.title = 'Ringkasan Harian',
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

    return AppCardWidget.elevated(
      radius: AppRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.rw(0.041)),
            child: MonitoringCardHeaderWidget.icon(
              icon: Icons.summarize_outlined,
              title: title,
              description: _getDateRangeText(),
              background: AppColors.softGreen,
              tint: AppColors.primary,
              trailing: _SensorCountBadge(count: grouped.length),
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
                metadataAdapter: metadataAdapter,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppCardWidget.elevated(
      radius: AppRadius.lg,
      child: const MonitoringCardHeaderWidget.icon(
        icon: Icons.summarize_outlined,
        title: 'Ringkasan Harian',
        description: 'Belum ada data agregasi untuk rentang ini',
        background: AppColors.softGreen,
        tint: AppColors.primary,
      ),
    );
  }

  String _getDateRangeText() {
    switch (dateRange) {
      case DateRange.today:
        return 'Hari ini';
      case DateRange.week:
        return '7 hari terakhir';
      case DateRange.month:
        return '30 hari terakhir';
      case DateRange.custom:
        return 'Rentang custom';
    }
  }
}

class _SensorCountBadge extends StatelessWidget {
  final int count;

  const _SensorCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '$count sensor',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption(
          context,
          size: 11,
          color: AppColors.primary,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SensorAggregationItem extends StatelessWidget {
  final String sensorId;
  final List<SensorDailyModel> data;
  final SensorMetadataAdapter metadataAdapter;

  const _SensorAggregationItem({
    required this.sensorId,
    required this.data,
    required this.metadataAdapter,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate aggregations
    final values = data.map((d) => d.avgVal).whereType<double>().toList();
    final avg = values.isEmpty
        ? 0
        : values.reduce((a, b) => a + b) / values.length;
    final minValues = data.map((d) => d.minVal).whereType<double>().toList();
    final maxValues = data.map((d) => d.maxVal).whereType<double>().toList();
    final min = minValues.isEmpty
        ? 0
        : minValues.reduce((a, b) => a < b ? a : b);
    final max = maxValues.isEmpty
        ? 0
        : maxValues.reduce((a, b) => a > b ? a : b);
    final unit = metadataAdapter.unitFor(sensorId);
    final label = metadataAdapter.labelFor(sensorId);

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
                  label: 'Rata-rata',
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
            '${data.length} titik data',
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
