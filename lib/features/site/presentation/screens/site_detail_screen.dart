import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/site_provider.dart';
import 'site_form_screen.dart';

class SiteDetailScreen extends ConsumerWidget {
  final String siteId;

  const SiteDetailScreen({super.key, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteAsync = ref.watch(siteDetailProvider(siteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Lokasi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SiteFormScreen(siteId: siteId),
                ),
              );
            },
          ),
        ],
      ),
      body: siteAsync.when(
        data: (site) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(siteDetailProvider(siteId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context, site),
                const Gap(16),
                _buildLocationCard(context, site),
                const Gap(16),
                _buildInfoCard(context, site),
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
                onPressed: () => ref.invalidate(siteDetailProvider(siteId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, site) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: site.isActive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on,
                size: 32,
                color: site.isActive ? Colors.green : Colors.grey,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: site.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      site.isActive ? 'Aktif' : 'Tidak Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: site.isActive ? Colors.green : Colors.grey,
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

  Widget _buildLocationCard(BuildContext context, site) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Lokasi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            if (site.siteAddress != null) ...[
              _buildInfoRow(
                context,
                Icons.location_city,
                'Alamat',
                site.siteAddress!,
              ),
              const Gap(12),
            ],
            if (site.hasCoordinates) ...[
              _buildInfoRow(
                context,
                Icons.my_location,
                'Koordinat',
                '${site.siteLat?.toStringAsFixed(6)}, ${site.siteLon?.toStringAsFixed(6)}',
              ),
              const Gap(12),
            ],
            if (site.siteAlt != null)
              _buildInfoRow(
                context,
                Icons.terrain,
                'Ketinggian',
                '${site.siteAlt?.toStringAsFixed(1)} m',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, site) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Tambahan',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            if (site.siteCreated != null) ...[
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Dibuat',
                _formatDate(site.siteCreated!),
              ),
              const Gap(12),
            ],
            if (site.siteUpdate != null)
              _buildInfoRow(
                context,
                Icons.update,
                'Terakhir Diperbarui',
                _formatDate(site.siteUpdate!),
              ),
          ],
        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
              const Gap(2),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
