import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/site_provider.dart';
import '../../domain/entities/site.dart';

class SiteListScreen extends ConsumerWidget {
  const SiteListScreen({super.key, this.managementMode = false});

  final bool managementMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteListAsync = ref.watch(siteListProvider);

    if (managementMode) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.015),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularBackButtonWidget(onPressed: () => context.pop()),
                    CircularBackButtonWidget(
                      onPressed: () => context.push('/site/create'),
                      svgIconPath: 'assets/icons/plus-outline-icon.svg',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _SiteListBody(
                  siteListAsync: siteListAsync,
                  managementMode: true,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.siteListTitle),
        actions: [
          // Tombol tambah site — navigasi ke form
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/site/create'),
          ),
        ],
      ),
      body: _SiteListBody(siteListAsync: siteListAsync),
    );
  }
}

class _SiteListBody extends ConsumerWidget {
  const _SiteListBody({
    required this.siteListAsync,
    this.managementMode = false,
  });

  final AsyncValue<List<Site>> siteListAsync;
  final bool managementMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return siteListAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (sites) {
        if (sites.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(siteListProvider);
            },
            child: const _EmptyState(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(siteListProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sites.length + (managementMode ? 1 : 0),
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              if (managementMode && index == 0) {
                return Text(
                  context.l10n.siteTitle,
                  style: AppTextStyles.sectionTitle(context),
                );
              }
              final site = sites[index - (managementMode ? 1 : 0)];
              return _SiteCard(
                site: site,
                managementMode: managementMode,
                onTap: () {
                  if (managementMode) {
                    context.push('/site/${site.siteId}');
                  } else {
                    ref.read(selectedSiteProvider.notifier).selectSite(site);
                    Navigator.pop(context, site);
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => managementMode
          ? const SiteManagementListSkeleton()
          : buildListSkeleton(count: 6, type: 'site'),
      error: (error, stack) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(siteListProvider);
        },
        child: _ErrorState(
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
  final bool managementMode;

  const _SiteCard({
    required this.site,
    required this.onTap,
    this.managementMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (managementMode) {
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: _SiteCardContent(site: site),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _SiteCardContent(site: site),
        ),
      ),
    );
  }
}

class _SiteCardContent extends StatelessWidget {
  const _SiteCardContent({required this.site});

  final Site site;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (site.siteAddress != null) ...[
                    const Gap(4),
                    Text(
                      site.siteAddress!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.my_location, size: 14, color: Colors.blue),
                const Gap(6),
                Text(
                  '${site.siteLat?.toStringAsFixed(4)}, ${site.siteLon?.toStringAsFixed(4)}',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: Colors.grey[300]),
                  const Gap(16),
                  Text(
                    context.l10n.siteEmptyTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const Gap(8),
                  Text(
                    context.l10n.siteEmptyMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                  const Gap(16),
                  Text(
                    context.l10n.commonErrorTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const Gap(8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ),
                  const Gap(16),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
