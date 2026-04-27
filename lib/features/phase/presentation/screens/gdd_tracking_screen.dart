import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/phase_provider.dart';

class GddTrackingScreen extends ConsumerWidget {
  final String plantId;
  final String plantName;

  const GddTrackingScreen({
    super.key,
    required this.plantId,
    required this.plantName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phasesAsync = ref.watch(phaseListProvider(plantId));
    final statsAsync = ref.watch(phaseStatsProvider(plantId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: phasesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (phases) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(phaseListProvider(plantId));
              ref.invalidate(phaseStatsProvider(plantId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              children: [
                _buildHeader(context, ref),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rw(0.051),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.rh(0.01)),
                        Text(
                          plantName,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1D1D1D),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: context.rh(0.014)),

                        statsAsync.when(
                          data: (stats) => _buildSummaryCard(context, stats),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),

                        SizedBox(height: context.rh(0.024)),
                        _buildGddChart(context, phases),

                        SizedBox(height: context.rh(0.024)),
                        _buildPhaseTable(context, phases),

                        SizedBox(height: context.rh(0.02)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/more-icon.svg',
                width: 28,
                height: 28,
              ),
              onPressed: () {
                ref.invalidate(phaseListProvider(plantId));
                ref.invalidate(phaseStatsProvider(plantId));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Column(
      children: [
        _buildHeader(context, ref),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(context.rw(0.061)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: context.rw(0.164).clamp(48.0, 72.0),
                    color: AppColors.error,
                  ),
                  SizedBox(height: context.rh(0.02)),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1D1D),
                    ),
                  ),
                  SizedBox(height: context.rh(0.01)),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(14),
                      color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: context.rh(0.03)),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(phaseListProvider(plantId));
                      ref.invalidate(phaseStatsProvider(plantId));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, Map<String, dynamic> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.thermostat,
                  color: AppColors.warning,
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan GDD',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'GDD Summary',
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
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Total GDD',
                '${stats['totalGdd'].toStringAsFixed(0)}',
                AppColors.primary,
              ),
              _buildStatItem(
                context,
                'Tercapai',
                '${stats['completedGdd'].toStringAsFixed(0)}',
                Colors.green,
              ),
              _buildStatItem(
                context,
                'Progress',
                '${(stats['overallProgress'] * 100).toStringAsFixed(0)}%',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(24),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(12),
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGddChart(BuildContext context, List phases) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bar_chart,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GDD per Fase',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'GDD by Phase',
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
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: phases.fold<double>(
                  0.0,
                  (max, p) => p.requiredGdd > max ? p.requiredGdd : max,
                ),
                barGroups: phases.asMap().entries.map((entry) {
                  final index = entry.key;
                  final phase = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: phase.currentGdd,
                        color: _getPhaseColor(phase.status),
                        width: 20,
                      ),
                      BarChartRodData(
                        toY: phase.requiredGdd,
                        color: Colors.grey[300]!,
                        width: 20,
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(10),
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.6),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < phases.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              phases[value.toInt()].phaseName,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(10),
                                color: const Color(
                                  0xFF1D1D1D,
                                ).withValues(alpha: 0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: AppColors.divider, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseTable(BuildContext context, List phases) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.table_chart,
                  color: AppColors.info,
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail GDD per Fase',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Detailed GDD by Phase',
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
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              border: TableBorder.all(color: AppColors.divider),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                  ),
                  children: [
                    _buildTableHeader(context, 'Fase'),
                    _buildTableHeader(context, 'Saat Ini'),
                    _buildTableHeader(context, 'Target'),
                    _buildTableHeader(context, '%'),
                  ],
                ),
                ...phases.map(
                  (phase) => TableRow(
                    children: [
                      _buildTableCell(context, phase.phaseName),
                      _buildTableCell(
                        context,
                        phase.currentGdd.toStringAsFixed(0),
                      ),
                      _buildTableCell(
                        context,
                        phase.requiredGdd.toStringAsFixed(0),
                      ),
                      _buildTableCell(
                        context,
                        '${phase.gddProgressPercentage.toStringAsFixed(0)}%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: context.sp(12),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1D1D1D),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: context.sp(12),
          color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getPhaseColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'active':
        return AppColors.primary;
      default:
        return Colors.orange;
    }
  }
}
