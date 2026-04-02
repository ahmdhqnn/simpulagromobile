import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
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
      appBar: AppBar(
        title: Text('GDD Tracking\n$plantName'),
        centerTitle: true,
      ),
      body: phasesAsync.when(
        data: (phases) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(phaseListProvider(plantId));
            ref.invalidate(phaseStatsProvider(plantId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statsAsync.when(
                  data: (stats) => _buildSummaryCard(context, stats),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                _buildGddChart(context, phases),
                const SizedBox(height: 16),
                _buildPhaseTable(context, phases),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan GDD',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total GDD',
                  '${stats['totalGdd'].toStringAsFixed(0)}',
                  Colors.blue,
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGddChart(BuildContext context, List phases) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GDD per Fase',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
                            style: const TextStyle(fontSize: 10),
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
                                style: const TextStyle(fontSize: 10),
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
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseTable(BuildContext context, List phases) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail GDD per Fase',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[100]),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getPhaseColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'active':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
