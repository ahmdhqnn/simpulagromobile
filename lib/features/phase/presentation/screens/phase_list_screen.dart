import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/phase_provider.dart';
import 'phase_detail_screen.dart';

class PhaseListScreen extends ConsumerWidget {
  final String plantId;
  final String plantName;

  const PhaseListScreen({
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
        title: Text('Fase Pertumbuhan\n$plantName'),
        centerTitle: true,
      ),
      body: phasesAsync.when(
        data: (phases) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(phaseListProvider(plantId));
            ref.invalidate(phaseStatsProvider(plantId));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Statistics Card
              statsAsync.when(
                data: (stats) => _buildStatsCard(context, stats),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Phase List
              ...phases.map(
                (phase) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPhaseCard(context, phase),
                ),
              ),
            ],
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(phaseListProvider(plantId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Keseluruhan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: stats['overallProgress'],
              minHeight: 8,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Selesai',
                  '${stats['completed']}',
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  'Aktif',
                  '${stats['active']}',
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  'Mendatang',
                  '${stats['upcoming']}',
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
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildPhaseCard(BuildContext context, phase) {
    Color statusColor;
    IconData statusIcon;

    switch (phase.status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'active':
        statusColor = Colors.blue;
        statusIcon = Icons.play_circle;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
    }

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhaseDetailScreen(phaseId: phase.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      phase.phaseName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      phase.status == 'completed'
                          ? 'Selesai'
                          : phase.status == 'active'
                          ? 'Aktif'
                          : 'Mendatang',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                phase.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      context,
                      'HST',
                      '${phase.startHst}-${phase.endHst}',
                      Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      context,
                      'GDD',
                      '${phase.currentGdd.toStringAsFixed(0)}/${phase.requiredGdd.toStringAsFixed(0)}',
                      Icons.thermostat,
                    ),
                  ),
                ],
              ),
              if (phase.isActive || phase.isCompleted) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: phase.progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
                const SizedBox(height: 4),
                Text(
                  '${phase.progressPercentage.toStringAsFixed(0)}% selesai',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
