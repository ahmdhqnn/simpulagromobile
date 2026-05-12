import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool _showFilterMenu = false;

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
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.015),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FilterChip(
                  label: _getFilterLabel(filter),
                  isSelected: true,
                  onTap: () =>
                      setState(() => _showFilterMenu = !_showFilterMenu),
                ),
                GestureDetector(
                  onTap: () =>
                      setState(() => _showFilterMenu = !_showFilterMenu),
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

            if (_showFilterMenu) ...[
              SizedBox(height: context.rh(0.012)),
              _FilterMenu(
                current: filter,
                onChanged: (f) {
                  ref.read(historyFilterProvider.notifier).state = f;
                  setState(() => _showFilterMenu = false);
                },
              ),
            ],

            if (filter == HistoryFilter.dateRange) ...[
              SizedBox(height: context.rh(0.015)),
              _DateRangePicker(),
            ],

            SizedBox(height: context.rh(0.024)),

            _SectionTitle('Grafik History'),
            SizedBox(height: context.rh(0.014)),

            historyAsync.when(
              loading: () => _shimmerCard(context, 195),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(historyReadsProvider),
              ),
              data: (reads) {
                final params = reads
                    .map((r) => r.dsId ?? '')
                    .where((s) => s.isNotEmpty)
                    .toSet()
                    .toList();
                final param =
                    selectedParam ?? (params.isNotEmpty ? params.first : null);
                if (param == null || reads.isEmpty) {
                  return _EmptyStateCard(
                    height: 195,
                    message: 'Belum ada data riwayat',
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (params.length > 1)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: params.map((p) {
                            final isSel = p == param;
                            final c = SensorMeta.color(p);
                            return GestureDetector(
                              onTap: () =>
                                  ref
                                          .read(
                                            selectedSensorParamProvider
                                                .notifier,
                                          )
                                          .state =
                                      p,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(
                                  right: 8,
                                  bottom: 12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: isSel ? c : c.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: isSel
                                      ? [
                                          BoxShadow(
                                            color: c.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  SensorMeta.shortLabel(p),
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: context.sp(11),
                                    fontWeight: FontWeight.w600,
                                    color: isSel ? Colors.white : c,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    Builder(
                      builder: (ctx) {
                        final filtered =
                            reads.where((r) => r.dsId == param).toList()..sort(
                              (a, b) => (a.readDate ?? DateTime(0)).compareTo(
                                b.readDate ?? DateTime(0),
                              ),
                            );
                        return _HistoryChart(reads: filtered, param: param);
                      },
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: context.rh(0.024)),

            historyAsync.when(
              loading: () => _shimmerCard(context, 60),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) {
                final params = reads.map((r) => r.dsId ?? '').toSet().toList();
                final param =
                    selectedParam ?? (params.isNotEmpty ? params.first : null);
                if (param == null) {
                  return _EmptyStateCard(
                    height: 60,
                    message: 'Pilih parameter sensor',
                  );
                }
                final filtered = reads.where((r) => r.dsId == param).toList()
                  ..sort(
                    (a, b) => (b.readDate ?? DateTime(0)).compareTo(
                      a.readDate ?? DateTime(0),
                    ),
                  );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle('Data Riwayat'),
                    SizedBox(height: context.rh(0.014)),
                    _DataTable(reads: filtered.take(50).toList()),
                  ],
                );
              },
            ),

            SizedBox(height: context.rh(0.02)),
          ],
        ),
      ),
    );
  }

  String _getFilterLabel(HistoryFilter filter) {
    switch (filter) {
      case HistoryFilter.sevenDay:
        return '7 Hari';
      case HistoryFilter.dateRange:
        return 'Rentang Tanggal';
      case HistoryFilter.plantingDate:
        return 'Sejak Tanam';
    }
  }

  Widget _shimmerCard(BuildContext context, double height) {
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
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

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
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w400,
              color: Colors.black,
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
      (HistoryFilter.sevenDay, '7 Hari'),
      (HistoryFilter.dateRange, 'Rentang Tanggal'),
      (HistoryFilter.plantingDate, 'Sejak Tanam'),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                      fontFamily: 'Plus Jakarta Sans',
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(22),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1D1D1D),
        height: 1.0,
      ),
    );
  }
}

class _HistoryChart extends StatelessWidget {
  final List<SensorReadModel> reads;
  final String param;

  const _HistoryChart({required this.reads, required this.param});

  Color get _color {
    switch (param) {
      case 'env_temp':
        return const Color(0xFF4FC3F7);
      case 'env_hum':
        return const Color(0xFF81C784);
      case 'soil_nitro':
        return const Color(0xFFFFB74D);
      case 'soil_phos':
        return const Color(0xFFBA68C8);
      case 'soil_pot':
        return const Color(0xFFE57373);
      case 'soil_ph':
        return const Color(0xFF64B5F6);
      default:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reads.isEmpty) {
      return _EmptyStateCard(height: 195, message: 'Belum ada data riwayat');
    }

    final spots = reads
        .asMap()
        .entries
        .where((e) => e.value.numericValue > 0)
        .map((e) {
          return FlSpot(e.key.toDouble(), e.value.numericValue);
        })
        .toList();

    if (spots.isEmpty) {
      return _EmptyStateCard(height: 195, message: 'Data sensor tidak valid');
    }

    final values = reads
        .map((r) => r.numericValue)
        .where((v) => v > 0)
        .toList();
    final minVal = values.isNotEmpty
        ? values.reduce((a, b) => a < b ? a : b)
        : 0.0;
    final maxVal = values.isNotEmpty
        ? values.reduce((a, b) => a > b ? a : b)
        : 0.0;
    final avgVal = values.isNotEmpty
        ? values.reduce((a, b) => a + b) / values.length
        : 0.0;
    final unit = SensorMeta.unit(param);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.show_chart_rounded, color: _color, size: 22),
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SensorMeta.label(param),
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${reads.length} data · riwayat sensor',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(11),
                        color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(
                  label: 'Min',
                  value: '${minVal.toStringAsFixed(1)}$unit',
                  color: const Color(0xFF42A5F5),
                ),
                Container(width: 1, height: 28, color: const Color(0xFFE0E0E0)),
                _StatChip(
                  label: 'Rata-rata',
                  value: '${avgVal.toStringAsFixed(1)}$unit',
                  color: AppColors.primaryLight,
                ),
                Container(width: 1, height: 28, color: const Color(0xFFE0E0E0)),
                _StatChip(
                  label: 'Max',
                  value: '${maxVal.toStringAsFixed(1)}$unit',
                  color: const Color(0xFFFF7043),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: const Color(0xFFEEEEEE), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(0),
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(9),
                          color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                        ),
                      ),
                    ),
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
                      reservedSize: 30,
                      interval: (spots.length / 5).ceilToDouble().clamp(
                        1,
                        double.infinity,
                      ),
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= reads.length) {
                          return const SizedBox.shrink();
                        }
                        final d = reads[idx].readDate;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            d != null ? DateFormat('d/M').format(d) : '',
                            style: TextStyle(
                              fontSize: context.sp(9),
                              color: const Color(
                                0xFF1D1D1D,
                              ).withValues(alpha: 0.5),
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
                    curveSmoothness: 0.35,
                    color: _color,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: spots.length <= 20,
                      getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                        radius: 3.5,
                        color: _color,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _color.withValues(alpha: 0.25),
                          _color.withValues(alpha: 0.03),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipRoundedRadius: 10,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tooltipBorder: BorderSide(
                      color: _color.withValues(alpha: 0.3),
                    ),
                    getTooltipItems: (spots) => spots
                        .map(
                          (s) => LineTooltipItem(
                            '${s.y.toStringAsFixed(1)}$unit',
                            TextStyle(
                              color: _color,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                SensorMeta.label(param),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(10),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(13),
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(9),
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DataTable extends StatefulWidget {
  final List<SensorReadModel> reads;
  const _DataTable({required this.reads});

  @override
  State<_DataTable> createState() => _DataTableState();
}

class _DataTableState extends State<_DataTable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reads.isEmpty) {
      return _EmptyStateCard(height: 195, message: 'Tidak ada data');
    }

    final displayCount = _expanded
        ? widget.reads.length
        : (widget.reads.length > 5 ? 5 : widget.reads.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: displayCount,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.1),
            ),
            itemBuilder: (context, i) {
              final r = widget.reads[i];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: context.rh(0.008)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.readDate != null
                          ? DateFormat('dd/MM HH:mm').format(r.readDate!)
                          : '-',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(11),
                        color: const Color(0xFF1D1D1D),
                      ),
                    ),
                    Text(
                      '${r.readValue ?? '-'}${SensorMeta.unit(r.dsId ?? '')}',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1D1D),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (widget.reads.length > 5)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 12, top: context.rh(0.01)),
                alignment: Alignment.center,
                child: Text(
                  _expanded
                      ? 'Tampilkan Lebih Sedikit'
                      : 'Tampilkan Semua (${widget.reads.length})',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final double height;
  final String message;

  const _EmptyStateCard({required this.height, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 28,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
            ),
            SizedBox(height: context.rh(0.005)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
          ],
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
      height: 195,
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
