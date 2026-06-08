import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../notes/presentation/widgets/site_notes_section_widget.dart';
import '../../domain/entities/site.dart';
import '../providers/site_provider.dart';

class SiteDetailScreen extends ConsumerStatefulWidget {
  final String siteId;

  const SiteDetailScreen({super.key, required this.siteId});

  @override
  ConsumerState<SiteDetailScreen> createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends ConsumerState<SiteDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final siteAsync = ref.watch(siteDetailProvider(widget.siteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Lokasi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'Invite Member',
            onPressed: () => context.push('/site/${widget.siteId}/invite'),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/site/${widget.siteId}/edit'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Catatan'),
          ],
        ),
      ),
      body: siteAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        data: (site) => TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(site: site, siteId: widget.siteId),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SiteNotesSectionWidget(siteId: widget.siteId),
            ),
          ],
        ),
        loading: () => const SiteDetailOverviewSkeleton(),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ErrorStateCardWidget(
              message: error.toString(),
              onRetry: () =>
                  ref.invalidate(siteDetailProvider(widget.siteId)),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  final Site site;
  final String siteId;

  const _OverviewTab({required this.site, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(siteDetailProvider(siteId));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context, site),
            const Gap(16),
            _buildFieldsCard(context, site),
            const Gap(16),
            _buildLocationCard(context, site),
            const Gap(16),
            _buildInfoCard(context, site),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldsCard(BuildContext context, Site site) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Site',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            _buildInfoRow(context, Icons.tag, 'Site ID', site.siteId),
            const Gap(8),
            _buildInfoRow(
              context,
              Icons.badge_outlined,
              'Nama',
              site.siteName ?? site.displayName,
            ),
            const Gap(8),
            _buildInfoRow(
              context,
              Icons.toggle_on,
              'Status',
              site.isActive ? 'Aktif (1)' : 'Tidak Aktif (0)',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Site site) {
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

  Widget _buildLocationCard(BuildContext context, Site site) {
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

  Widget _buildInfoCard(BuildContext context, Site site) {
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
