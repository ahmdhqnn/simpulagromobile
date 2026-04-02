import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/sensor_provider.dart';
import 'sensor_detail_screen.dart';
import 'sensor_form_screen.dart';

class SensorListScreen extends ConsumerWidget {
  final String deviceId;
  final String deviceName;

  const SensorListScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorsAsync = ref.watch(sensorListProvider(deviceId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sensors'),
            Text(
              deviceName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: sensorsAsync.when(
        data: (sensors) {
          if (sensors.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.sensors_off,
              title: 'No sensors found',
              message: 'Add sensors to start monitoring',
              action: ElevatedButton.icon(
                onPressed: () => _navigateToForm(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Sensor'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(sensorListProvider(deviceId));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: sensor.isActive
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                      child: Icon(
                        _getSensorIcon(sensor.type),
                        color: sensor.isActive ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(sensor.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sensor.typeDisplay),
                        Text(
                          'Unit: ${sensor.unit}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        sensor.statusText,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: sensor.isActive
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                    ),
                    onTap: () => _navigateToDetail(context, sensor.id),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(sensorListProvider(deviceId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context, ref),
        child: const Icon(Icons.add),
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

  void _navigateToDetail(BuildContext context, String sensorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SensorDetailScreen(sensorId: sensorId),
      ),
    );
  }

  void _navigateToForm(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SensorFormScreen(deviceId: deviceId),
      ),
    ).then((_) {
      ref.invalidate(sensorListProvider(deviceId));
    });
  }
}
