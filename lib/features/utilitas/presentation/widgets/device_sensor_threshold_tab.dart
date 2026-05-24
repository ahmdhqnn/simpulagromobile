import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/device_sensor_provider.dart';

class DeviceSensorThresholdTab extends ConsumerWidget {
  const DeviceSensorThresholdTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valuesAsync = ref.watch(deviceSensorThresholdValuesProvider);

    return valuesAsync.when(
      data: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('Belum ada data threshold'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(deviceSensorThresholdValuesProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final row = rows[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    'ds: ${row['ds_id'] ?? '-'} · dev: ${row['dev_id'] ?? '-'}',
                  ),
                  subtitle: Text(
                    'sens: ${row['sens_id'] ?? '-'} · min: ${row['ds_min'] ?? row['min_val'] ?? '-'} · max: ${row['ds_max'] ?? row['max_val'] ?? '-'} · warn: ${row['ds_warn'] ?? '-'}',
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
