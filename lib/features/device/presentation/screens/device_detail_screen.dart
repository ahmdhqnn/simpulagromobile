import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/device_provider.dart';
import 'device_form_screen.dart';

class DeviceDetailScreen extends ConsumerWidget {
  final String siteId;
  final String devId;

  const DeviceDetailScreen({
    super.key,
    required this.siteId,
    required this.devId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceAsync = ref.watch(
      deviceDetailProvider((siteId: siteId, devId: devId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Perangkat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              deviceAsync.whenData((device) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DeviceFormScreen(siteId: siteId, device: device),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: deviceAsync.when(
        data: (device) => SingleChildScrollView(
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
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: device.isActive
                            ? Colors.green.shade100
                            : Colors.grey.shade300,
                        child: Icon(
                          Icons.router,
                          size: 32,
                          color: device.isActive ? Colors.green : Colors.grey,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.displayName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Gap(4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: device.isActive
                                    ? Colors.green.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                device.statusText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: device.isActive
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Perangkat',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Gap(16),
                      _buildInfoRow('ID Perangkat', device.devId),
                      _buildInfoRow('Lokasi', device.locationDisplay),
                      if (device.devNumberId != null)
                        _buildInfoRow('Nomor ID', device.devNumberId!),
                      if (device.devIp != null)
                        _buildInfoRow('IP Address', device.devIp!),
                      if (device.devPort != null)
                        _buildInfoRow('Port', device.devPort!),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // Coordinates Card
              if (device.hasCoordinates)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Koordinat',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Gap(16),
                        _buildInfoRow('Longitude', device.devLon.toString()),
                        _buildInfoRow('Latitude', device.devLat.toString()),
                        if (device.devAlt != null)
                          _buildInfoRow('Altitude', '${device.devAlt} m'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
