import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/plant_provider.dart';
import '../../../phase/presentation/screens/phase_list_screen.dart';
import '../../../phase/presentation/screens/gdd_tracking_screen.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsync = ref.watch(plantDetailProvider(plantId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tanaman'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit plant
            },
          ),
        ],
      ),
      body: plantAsync.when(
        data: (plant) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(plantDetailProvider(plantId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context, plant),
                const Gap(16),
                _buildGrowthCard(context, plant),
                const Gap(16),
                _buildInfoCard(context, plant),
                const Gap(16),
                _buildActionButtons(context, plant),
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
              const Gap(16),
              Text('Error: $error'),
              const Gap(16),
              ElevatedButton(
                onPressed: () => ref.invalidate(plantDetailProvider(plantId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, plant) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                plant.plantType?.icon ?? '🌱',
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    plant.plantType?.displayName ?? 'Unknown',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: plant.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      plant.statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: plant.isActive ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context, plant) {
    final hst = plant.hst ?? 0;
    final phase = plant.growthPhase ?? 'Unknown';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertumbuhan',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'HST',
                    '$hst',
                    'Hari Setelah Tanam',
                    Icons.calendar_today,
                    Colors.blue,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Fase',
                    phase,
                    'Fase Pertumbuhan',
                    Icons.eco,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, plant) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Tanaman',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            if (plant.plantSpecies != null) ...[
              _buildInfoRow(
                context,
                Icons.science,
                'Spesies',
                plant.plantSpecies!,
              ),
              const Gap(12),
            ],
            if (plant.plantDate != null) ...[
              _buildInfoRow(
                context,
                Icons.event,
                'Tanggal Tanam',
                _formatDate(plant.plantDate!),
              ),
              const Gap(12),
            ],
            if (plant.plantHarvest != null)
              _buildInfoRow(
                context,
                Icons.agriculture,
                plant.isHarvested ? 'Tanggal Panen' : 'Target Panen',
                _formatDate(plant.plantHarvest!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, plant) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhaseListScreen(
                    plantId: plant.plantId,
                    plantName: plant.displayName,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.timeline),
            label: const Text('Lihat Fase Pertumbuhan'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ),
        const Gap(12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GddTrackingScreen(
                    plantId: plant.plantId,
                    plantName: plant.displayName,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.thermostat),
            label: const Text('GDD Tracking'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ),
        if (plant.isActive && !plant.isHarvested) ...[
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showHarvestDialog(context, plant),
              icon: const Icon(Icons.agriculture),
              label: const Text('Tandai Sudah Panen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const Gap(8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
          const Gap(4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const Gap(12),
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
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showHarvestDialog(BuildContext context, plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Panen'),
        content: Text('Tandai tanaman "${plant.displayName}" sudah dipanen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Implement harvest functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tanaman berhasil ditandai sudah panen'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Sudah Panen'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
