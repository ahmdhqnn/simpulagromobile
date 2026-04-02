import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/device_provider.dart';
import 'device_detail_screen.dart';
import 'device_form_screen.dart';

class DeviceListScreen extends ConsumerWidget {
  final String siteId;
  final String siteName;

  const DeviceListScreen({
    super.key,
    required this.siteId,
    required this.siteName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceListAsync = ref.watch(deviceListProvider(siteId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perangkat IoT'),
            Text(siteName, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(deviceListProvider(siteId)),
          ),
        ],
      ),
      body: deviceListAsync.when(
        data: (devices) {
          if (devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.devices_other, size: 64, color: Colors.grey[400]),
                  const Gap(16),
                  Text(
                    'Belum ada perangkat',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  Text(
                    'Tambahkan perangkat IoT untuk memulai monitoring',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(deviceListProvider(siteId));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: devices.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (context, index) {
                final device = devices[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: device.isActive
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                      child: Icon(
                        Icons.router,
                        color: device.isActive ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(device.displayName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(4),
                        Text(device.locationDisplay),
                        if (device.devIp != null) ...[
                          const Gap(2),
                          Text(
                            'IP: ${device.devIp}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeviceDetailScreen(
                            siteId: siteId,
                            devId: device.devId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const Gap(16),
              Text(
                'Gagal memuat data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(deviceListProvider(siteId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DeviceFormScreen(siteId: siteId)),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Perangkat'),
      ),
    );
  }
}
