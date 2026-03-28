import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../plant/domain/entities/plant.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../data/models/agro_model.dart';
import '../providers/agro_provider.dart';

class AgroIndicatorScreen extends ConsumerWidget {
  const AgroIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agroAsync = ref.watch(agroDataProvider);
    final plant = ref.watch(currentPlantProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: agroAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => _ErrorState(
            error: e.toString(),
            onRetry: () => ref.invalidate(agroDataProvider),
          ),
          data: (agro) => _AgroContent(agro: agro, plant: plant),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}

class _AgroContent extends StatelessWidget {
  final AgroModel agro;
  final Plant? plant;

  const _AgroContent({required this.agro, this.plant});

  @override
  Widget build(BuildContext context) {
    final latestEtc = agro.etc.isNotEmpty ? agro.etc.last : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _TopBar(),
          const SizedBox(height: 20),
          const Text(
            'Agro Indicator',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              color: Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _IndicatorCard(
                  title: 'VPD',
                  subtitle: 'Vapor Pressure Deficit',
                  value: agro.vdp?.vdp?.toStringAsFixed(2) ?? '0.00',
                  unit: 'kPa',
                  badge: agro.vdp?.status ?? '-',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _IndicatorCard(
                  title: 'Total GDD',
                  subtitle: 'Growing Degree Days',
                  value: agro.gdd?.totalGDD?.toStringAsFixed(1) ?? '0.0',
                  unit: '°C',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _IndicatorCard(
                  title: 'Growth Phase',
                  subtitle: plant?.growthPhase ?? '-',
                  value: '${plant?.hst ?? 0}',
                  unit: 'HST',
                  badge: plant != null
                      ? '${_daysToHarvest(plant!)} Days to Harvest'
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _IndicatorCard(
                  title: 'Water Needs',
                  subtitle: latestEtc != null
                      ? '${latestEtc.etc?.toStringAsFixed(2) ?? '0.00'} mm Kc ${latestEtc.kc?.toStringAsFixed(2) ?? '0.00'}'
                      : '-',
                  value: _totalWaterNeeds(agro.etc),
                  unit: 'Liter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _RecommendationsCard(agro: agro, plant: plant),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chart',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.tune, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _ChartCard(
            title: 'Growing Degree Days',
            subtitle: 'Daily heat accumulation for plant growth',
            child: _GddChart(data: agro.gdd?.daily ?? []),
            legendItems: const [
              _LegendItem(color: Color(0xFF90CAF9), label: 'GDD'),
              _LegendItem(color: Color(0xFF80CBC4), label: 'Temp Min (°C)'),
              _LegendItem(color: Color(0xFFFFCC80), label: 'Temp Max (°C)'),
            ],
          ),
          const SizedBox(height: 16),

          _ChartCard(
            title: 'Plant Evapotranspiration',
            subtitle: 'Water requirements based on ETc and crop coefficient',
            child: _EtcChart(data: agro.etc),
            legendItems: const [
              _LegendItem(color: Color(0xFF90CAF9), label: 'ETc (mm)'),
              _LegendItem(color: Color(0xFF80CBC4), label: 'Kc'),
              _LegendItem(color: Color(0xFFA5D6A7), label: 'Water Needs (mm)'),
            ],
          ),
          const SizedBox(height: 16),

          _ChartCard(
            title: 'Daily Climate Data',
            subtitle: 'Daily heat accumulation for plant growth',
            child: _ClimateChart(data: agro.etc),
            legendItems: const [
              _LegendItem(color: Color(0xFF90CAF9), label: 'RH Min(°C)'),
              _LegendItem(color: Color(0xFF80CBC4), label: 'RH Max(°C)'),
              _LegendItem(color: Color(0xFFFFCC80), label: 'Temp Min (°C)'),
              _LegendItem(color: Color(0xFFA5D6A7), label: 'Temp Max (°C)'),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  int _daysToHarvest(Plant p) {
    if (p.plantDate == null) return 0;

    final harvestDays = switch (p.plantType) {
      CropType.PADI => 120,
      CropType.JAGUNG => 90,
      CropType.KEDELAI => 85,
      null => 120,
    };
    final remaining = harvestDays - p.hst;
    return remaining < 0 ? 0 : remaining;
  }

  String _totalWaterNeeds(List<EtcDailyModel> etc) {
    if (etc.isEmpty) return '0';
    final total = etc.fold<double>(
      0,
      (sum, e) => sum + (e.waterNeeds ?? e.etc ?? 0),
    );
    if (total >= 1000) return '${(total / 1000).toStringAsFixed(1)}K';
    return total.toStringAsFixed(0);
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              Icons.chevron_left,
              size: 28,
              color: Color(0xFF1D1D1D),
            ),
          ),
        ),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Icon(
            Icons.more_horiz,
            size: 24,
            color: Color(0xFF1D1D1D),
          ),
        ),
      ],
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final String? badge;

  const _IndicatorCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1D),
            ),
          ),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 34,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1D),
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
              ),
            ],
          ),
          if (badge != null) ...[
            const SizedBox(height: 4),
            Text(
              badge!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                color: Color(0xFF8E8E8E),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  final AgroModel agro;
  final Plant? plant;

  const _RecommendationsCard({required this.agro, this.plant});

  @override
  Widget build(BuildContext context) {
    final latestEtc = agro.etc.isNotEmpty ? agro.etc.last : null;
    final harvestDays = plant != null ? _daysToHarvest(plant!) : 0;
    final harvestDate = plant?.plantDate != null
        ? DateFormat('dd MMM yyyy').format(
            plant!.plantDate!.add(Duration(days: _harvestTarget(plant!))),
          )
        : '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommendations',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w300,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Based on phase',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w300,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 12),
          _recRow(
            'ETc',
            '${latestEtc?.etc?.toStringAsFixed(2) ?? '0.00'} mm/days',
          ),
          _recRow(
            'Crop Coefficient',
            '${latestEtc?.kc?.toStringAsFixed(2) ?? '0.00'} Kc',
          ),
          _recRow('Harvest', '$harvestDays more days'),
          _recRow('Harvest Estimates', harvestDate),
        ],
      ),
    );
  }

  Widget _recRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              height: 1.8,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w300,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  int _daysToHarvest(Plant p) {
    final target = _harvestTarget(p);
    final remaining = target - p.hst;
    return remaining < 0 ? 0 : remaining;
  }

  int _harvestTarget(Plant p) => switch (p.plantType) {
    CropType.PADI => 120,
    CropType.JAGUNG => 90,
    CropType.KEDELAI => 85,
    null => 120,
  };
}

class _LegendItem {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final List<_LegendItem> legendItems;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.legendItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w300,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w300,
              height: 1.5,
              color: Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 180, child: child),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: legendItems
                .map(
                  (item) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _GddChart extends StatelessWidget {
  final List<GddDailyModel> data;

  const _GddChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _emptyChart();

    final spots = <String, List<FlSpot>>{
      'gdd': [],
      'tempMin': [],
      'tempMax': [],
    };

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      spots['gdd']!.add(FlSpot(i.toDouble(), d.gdd ?? 0));
      spots['tempMin']!.add(FlSpot(i.toDouble(), d.tempMin ?? 0));
      spots['tempMax']!.add(FlSpot(i.toDouble(), d.tempMax ?? 0));
    }

    return LineChart(
      LineChartData(
        gridData: _gridData(),
        titlesData: _titlesData(data.map((d) => d.day ?? '').toList()),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _lineBar(spots['gdd']!, const Color(0xFF90CAF9)),
          _lineBar(spots['tempMin']!, const Color(0xFF80CBC4)),
          _lineBar(spots['tempMax']!, const Color(0xFFFFCC80)),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.white,
          ),
        ),
      ),
    );
  }
}

class _EtcChart extends StatelessWidget {
  final List<EtcDailyModel> data;

  const _EtcChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _emptyChart();

    final spots = <String, List<FlSpot>>{'etc': [], 'kc': [], 'waterNeeds': []};

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      spots['etc']!.add(FlSpot(i.toDouble(), d.etc ?? 0));
      spots['kc']!.add(FlSpot(i.toDouble(), d.kc ?? 0));
      spots['waterNeeds']!.add(
        FlSpot(i.toDouble(), d.waterNeeds ?? d.etc ?? 0),
      );
    }

    return LineChart(
      LineChartData(
        gridData: _gridData(),
        titlesData: _titlesData(data.map((d) => d.day ?? '').toList()),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _lineBar(spots['etc']!, const Color(0xFF90CAF9)),
          _lineBar(spots['kc']!, const Color(0xFF80CBC4)),
          _lineBar(spots['waterNeeds']!, const Color(0xFFA5D6A7)),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ClimateChart extends StatelessWidget {
  final List<EtcDailyModel> data;

  const _ClimateChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _emptyChart();

    final spots = <String, List<FlSpot>>{
      'rhMin': [],
      'rhMax': [],
      'tempMin': [],
      'tempMax': [],
    };

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      spots['rhMin']!.add(FlSpot(i.toDouble(), d.rhMin ?? 0));
      spots['rhMax']!.add(FlSpot(i.toDouble(), d.rhMax ?? 0));
      spots['tempMin']!.add(FlSpot(i.toDouble(), d.tempMin ?? 0));
      spots['tempMax']!.add(FlSpot(i.toDouble(), d.tempMax ?? 0));
    }

    return LineChart(
      LineChartData(
        gridData: _gridData(),
        titlesData: _titlesData(data.map((d) => d.day ?? '').toList()),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _lineBar(spots['rhMin']!, const Color(0xFF90CAF9)),
          _lineBar(spots['rhMax']!, const Color(0xFF80CBC4)),
          _lineBar(spots['tempMin']!, const Color(0xFFFFCC80)),
          _lineBar(spots['tempMax']!, const Color(0xFFA5D6A7)),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget _emptyChart() {
  return const Center(
    child: Text(
      'Belum ada data',
      style: TextStyle(
        fontSize: 13,
        color: Color(0xFF8E8E8E),
        fontFamily: 'Plus Jakarta Sans',
      ),
    ),
  );
}

FlGridData _gridData() => FlGridData(
  show: true,
  drawVerticalLine: false,
  getDrawingHorizontalLine: (_) =>
      FlLine(color: const Color(0xFFEEEEEE), strokeWidth: 1),
);

FlTitlesData _titlesData(List<String> days) {
  // Show at most 5 labels evenly spaced
  final step = days.length > 5 ? (days.length / 5).ceil() : 1;
  return FlTitlesData(
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        interval: step.toDouble(),
        getTitlesWidget: (value, meta) {
          final idx = value.toInt();
          if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
          final raw = days[idx];
          String label = raw;
          try {
            final dt = DateTime.parse(raw);
            label = DateFormat('d/M').format(dt);
          } catch (_) {}
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF8E8E8E),
              ),
            ),
          );
        },
      ),
    ),
  );
}

LineChartBarData _lineBar(List<FlSpot> spots, Color color) {
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    color: color,
    barWidth: 2,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: true, color: color.withOpacity(0.15)),
  );
}
