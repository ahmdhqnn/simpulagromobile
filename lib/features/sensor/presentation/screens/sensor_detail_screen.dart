import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/sensor_provider.dart';
import 'sensor_form_screen.dart';

class SensorDetailScreen extends ConsumerWidget {
  final String sensorId;

  const SensorDetailScreen({super.key, required this.sensorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorAsync = ref.watch(sensorDetailProvider(sensorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Details'),
        actions: [
          sensorAsync.whenOrNull(
                data: (sensor) => IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(context, ref, sensor.id),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: sensorAsync.when(
        data: (sensor) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(sensorDetailProvider(sensorId));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          _getSensorIcon(sensor.type),
                          size: 48,
                          color: sensor.isActive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sensor.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(sensor.statusText),
                                backgroundColor: sensor.isActive
                                    ? Colors.green.shade100
                                    : Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Information Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Information',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Divider(),
                        _buildInfoRow(context, 'Type', sensor.typeDisplay),
                        _buildInfoRow(context, 'Unit', sensor.unit),
                        if (sensor.description != null)
                          _buildInfoRow(
                            context,
                            'Description',
                            sensor.description!,
                          ),
                        _buildInfoRow(
                          context,
                          'Created',
                          DateFormatter.formatDateTime(sensor.createdAt),
                        ),
                        _buildInfoRow(
                          context,
                          'Last Updated',
                          DateFormatter.formatDateTime(sensor.updatedAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteDialog(context, ref),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Sensor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(sensorDetailProvider(sensorId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSensorIcon(String type) {
    switch (type.toLowerCase()) {
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'soil_moisture':
        return Icons.grass;
      case 'ph':
        return Icons.science;
      case 'light':
        return Icons.wb_sunny;
      default:
        return Icons.sensors;
    }
  }

  void _navigateToEdit(BuildContext context, WidgetRef ref, String sensorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SensorFormScreen(sensorId: sensorId),
      ),
    ).then((_) {
      ref.invalidate(sensorDetailProvider(sensorId));
    });
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sensor'),
        content: const Text(
          'Are you sure you want to delete this sensor? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSensor(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteSensor(BuildContext context, WidgetRef ref) async {
    final formNotifier = ref.read(sensorFormProvider.notifier);
    await formNotifier.deleteSensor(sensorId);

    final state = ref.read(sensorFormProvider);
    state.when(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sensor deleted successfully')),
        );
        Navigator.pop(context);
      },
      loading: () {},
      error: (error, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
    );
  }
}
