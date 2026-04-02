import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class HistoryTab extends ConsumerStatefulWidget {
  const HistoryTab({super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab> {
  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(historyFilterProvider);
    final historyAsync = ref.watch(historyReadsProvider);
    final selectedParam = ref.watch(selectedSensorParamProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(historyReadsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.rw(0.051)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Filter Chips ──────────────────────────────
            _FilterRow(
              current: filter,
              onChanged: (f) =>
                  ref.read(historyFilterProvider.notifier).state = f,
            ),

            // ─── Date Range Picker ─────────────────────────
            if (filter == HistoryFilter.dateRange) ...[
              SizedBox(height: context.rh(0.015)),
              _DateRangePicker(),
            ],

            SizedBox(height: context.rh(0.02)),

            // ─── Param Selector ────────────────────────────
            historyAsync.when(
              data: (reads) {
                final params = reads.map((r) => r.dsId ?? '').toSet().toList();
                if (params.isEmpty) return const SizedBox.shrink();
                return _ParamSelector(
                  params: params,
                  selected: selectedParam ?? params.first,
                  onChanged: (p) =>
                      ref.read(selectedSensorParamProvider.notifier).state = p,
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            SizedBox(height: context.rh(0.02)),

            // ─── Chart ─────────────────────────────────────
            historyAsync.when(
              loading: () => _shimmerBox(context, 240),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(historyReadsProvider),
              ),
              data: (reads) {
                final params = reads.map((r) => r.dsId ?? '').toSet().toList();
                final param =
                    selectedParam ?? (params.isNotEmpty ? params.first : null);
                if (param == null || reads.isEmpty) {
                  return _EmptyCard(message: 'Belum ada data riwayat');
                }
                final filtered = reads.where((r) => r.dsId == param).toList()
                  ..sort(
                    (a, b) => (a.readDate ?? DateTime(0)).compareTo(
                      b.readDate ?? DateTime(0),
                    ),
                  );
                return _HistoryChart(reads: filtered, param: param);
              },
            ),

            SizedBox(height: context.rh(0.03)),

            // ─── Data Table ────────────────────────────────
            Text(
              'Data Riwayat',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(16),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.015)),
            historyAsync.when(
              loading: () => _shimmerBox(context, 200),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) {
                final params = reads.map((r) => r.dsId ?? '').toSet().toList();
                final param =
                    selectedParam ?? (params.isNotEmpty ? params.first : null);
                if (param == null) {
                  return _EmptyCard(message: 'Pilih parameter sensor');
                }
                final filtered = reads.where((r) => r.dsId == param).toList()
                  ..sort(
                    (a, b) => (b.readDate ?? DateTime(0)).compareTo(
                      a.readDate ?? DateTime(0),
                    ),
                  );
                return _DataTable(reads: filtered.take(50).toList());
              },
            ),

            SizedBox(height: context.rh(0.04)),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

// ─── Filter Row ───────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  final HistoryFilter current;
  final ValueChanged<HistoryFilter> onChanged;

  const _FilterRow({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final filters = [
      (HistoryFilter.sevenDay, '7 Hari'),
      (HistoryFilter.dateRange, 'Rentang Tanggal'),
      (HistoryFilter.plantingDate, 'Sejak Tanam'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = f.$1 == current;
          return GestureDetector(
            onTap: () => onChanged(f.$1),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              child: Text(
                f.$2,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Date Range Picker ────────────────────────────────────
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
          borderRadius: BorderRadius.circular(12),
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
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(10),
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
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

// ─── Param Selector ───────────────────────────────────────
class _ParamSelector extends StatelessWidget {
  final List<String> params;
  final String selected;
  final ValueChanged<String> onChanged;

  const _ParamSelector({
    required this.params,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: params.map((p) {
          final isSelected = p == selected;
          return GestureDetector(
            onTap: () => onChanged(p),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLight.withValues(alpha: 0.15)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryLight
                      : Colors.transparent,
                ),
              ),
              child: Text(
                SensorMeta.label(p),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(11),
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── History Chart ────────────────────────────────────────
class _HistoryChart extends StatelessWidget {
  final List<SensorReadModel> reads;
  final String param;

  const _HistoryChart({required this.reads, required this.param});

  Color get _color {
    switch (param) {
      case 'env_temp':
        return AppColors.temperature;
      case 'env_hum':
        return AppColors.humidity;
      case 'soil_nitro':
        return AppColors.nitrogen;
      case 'soil_phos':
        return AppColors.phosphorus;
      case 'soil_pot':
        return AppColors.potassium;
      case 'soil_ph':
        return AppColors.ph;
      default:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = reads.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.numericValue);
    }).toList();

    final step = reads.length > 6 ? (reads.length / 6).ceil() : 1;

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SensorMeta.label(param),
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.015)),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.divider, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: step.toDouble(),
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= reads.length) {
                          return const SizedBox.shrink();
                        }
                        final d = reads[idx].readDate;
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            d != null ? DateFormat('d/M').format(d) : '',
                            style: TextStyle(
                              fontSize: context.sp(9),
                              color: AppColors.textTertiary,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: _color,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _color.withValues(alpha: 0.12),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Table ───────────────────────────────────────────
class _DataTable extends StatelessWidget {
  final List<SensorReadModel> reads;
  const _DataTable({required this.reads});

  @override
  Widget build(BuildContext context) {
    if (reads.isEmpty) return _EmptyCard(message: 'Tidak ada data');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.041),
              vertical: context.rh(0.012),
            ),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Waktu',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  'Nilai',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...reads.asMap().entries.map((e) {
            final r = e.value;
            final isLast = e.key == reads.length - 1;
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.041),
                vertical: context.rh(0.012),
              ),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AppColors.divider),
                      ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      r.readDate != null
                          ? DateFormat('dd/MM HH:mm').format(r.readDate!)
                          : '-',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${r.readValue ?? '-'}${SensorMeta.unit(r.dsId ?? '')}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.061)),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(13),
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 28),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
