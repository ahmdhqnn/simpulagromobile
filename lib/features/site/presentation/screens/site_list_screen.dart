import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/site_provider.dart';
import '../../domain/entities/site.dart';

class SiteListScreen extends ConsumerWidget {
  const SiteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteListAsync = ref.watch(siteListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        actions: [
          // TODO: Add create site button for admin
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create site screen
            },
          ),
        ],
      ),
      body: siteListAsync.when(
        data: (sites) {
          if (sites.isEmpty) {
            return const _EmptyState();
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(siteListProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sites.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (context, index) {
                final site = sites[index];
                return _SiteCard(
                  site: site,
                  onTap: () {
                    ref.read(selectedSiteProvider.notifier).state = site;
                    Navigator.pop(context, site);
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(siteListProvider),
        ),
      ),
    );
  }
}

class _SiteCard extends StatelessWidget {
  final Site site;
  final VoidCallback onTap;

  const _SiteCard({required this.site, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: site.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: site.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.displayName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (site.siteAddress != null) ...[
                          const Gap(4),
                          Text(
                            site.siteAddress!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
              if (site.hasCoordinates) ...[
                const Gap(12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.my_location,
                        size: 14,
                        color: Colors.blue,
                      ),
                      const Gap(6),
                      Text(
                        '${site.siteLat?.toStringAsFixed(4)}, ${site.siteLon?.toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 80, color: Colors.grey[300]),
          const Gap(16),
          Text(
            'Belum ada lokasi',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const Gap(8),
          Text(
            'Tambahkan lokasi pertanian Anda',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const Gap(16),
          Text(
            'Terjadi Kesalahan',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ),
          const Gap(16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
