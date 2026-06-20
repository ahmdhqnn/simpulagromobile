import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';
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

    return AdminScaffold(
      title: context.l10n.siteDetailTitle,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularIconActionWidget(
            onPressed: () => context.push('/site/${widget.siteId}/invite'),
            svgIconPath: 'assets/icons/user-outline-icon.svg',
          ),
          const Gap(8),
          CircularIconActionWidget(
            onPressed: () => context.push('/site/${widget.siteId}/edit'),
            svgIconPath: 'assets/icons/edit-outline-icon.svg',
          ),
        ],
      ),
      headerContent: Padding(
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          0,
          context.rw(0.051),
          context.rh(0.014),
        ),
        child: siteAsync.maybeWhen(
          data: (_) => _TabSwitcher(controller: _tabController),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      body: siteAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        skipError: true,
        data: (site) => _SiteDetailBody(
          site: site,
          siteId: widget.siteId,
          tabController: _tabController,
        ),
        loading: () => const SiteDetailScreenSkeleton(),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(context.rw(0.051)),
            child: ErrorStateCardWidget(
              message: error.toString(),
              onRetry: () => ref.invalidate(siteDetailProvider(widget.siteId)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SiteDetailBody extends StatelessWidget {
  const _SiteDetailBody({
    required this.site,
    required this.siteId,
    required this.tabController,
  });

  final Site site;
  final String siteId;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _OverviewTab(site: site, siteId: siteId),
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.rw(0.051),
            0,
            context.rw(0.051),
            context.rh(0.02),
          ),
          child: SiteNotesSectionWidget(siteId: siteId),
        ),
      ],
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Row(
            children: [
              _TabPill(
                label: context.l10n.siteOverviewTab,
                isSelected: controller.index == 0,
                onTap: () => controller.animateTo(0),
              ),
              const Gap(4),
              _TabPill(
                label: context.l10n.siteNotesTab,
                isSelected: controller.index == 1,
                onTap: () => controller.animateTo(1),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFEFEF) : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.site, required this.siteId});

  final Site site;
  final String siteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(siteDetailProvider(siteId));
        await Future.delayed(const Duration(milliseconds: 300));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          0,
          context.rw(0.051),
          context.rh(0.024),
        ),
        children: [
          _HeaderCard(site: site),
          const Gap(14),
          _SiteDataCard(site: site),
          const Gap(14),
          _LocationCard(site: site),
          const Gap(14),
          _MetadataCard(site: site),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.site});

  final Site site;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: (site.isActive ? AppColors.success : Colors.grey)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: site.isActive ? AppColors.success : Colors.grey,
              size: 30,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.displayName,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Gap(6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(
                      icon: site.isActive
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      label: site.isActive
                          ? context.l10n.commonActive
                          : context.l10n.commonInactive,
                      color: site.isActive ? AppColors.success : Colors.grey,
                    ),
                    _Badge(
                      icon: Icons.tag_outlined,
                      label: site.siteId,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SiteDataCard extends StatelessWidget {
  const _SiteDataCard({required this.site});

  final Site site;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: context.l10n.siteDataTitle,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.tag_outlined,
            label: context.l10n.siteIdLabel,
            value: site.siteId,
          ),
          _Divider(),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: context.l10n.commonName,
            value: site.siteName ?? site.displayName,
          ),
          _Divider(),
          _InfoRow(
            icon: Icons.toggle_on_outlined,
            label: context.l10n.commonStatus,
            value: site.isActive
                ? '${context.l10n.commonActive} (1)'
                : '${context.l10n.commonInactive} (0)',
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.site});

  final Site site;

  @override
  Widget build(BuildContext context) {
    final coordinate = site.hasCoordinates
        ? '${site.siteLat?.toStringAsFixed(6)}, ${site.siteLon?.toStringAsFixed(6)}'
        : '-';

    return AdminSectionCard(
      title: context.l10n.siteLocationInfo,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.location_city_outlined,
            label: context.l10n.commonAddress,
            value: site.siteAddress?.trim().isNotEmpty == true
                ? site.siteAddress!
                : '-',
          ),
          _Divider(),
          _InfoRow(
            icon: Icons.my_location_outlined,
            label: context.l10n.commonCoordinates,
            value: coordinate,
          ),
          _Divider(),
          _InfoRow(
            icon: Icons.terrain_outlined,
            label: context.l10n.commonAltitude,
            value: site.siteAlt != null
                ? '${site.siteAlt?.toStringAsFixed(1)} m'
                : '-',
          ),
        ],
      ),
    );
  }
}

class _MetadataCard extends StatelessWidget {
  const _MetadataCard({required this.site});

  final Site site;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: context.l10n.siteAdditionalInfo,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: context.l10n.commonCreatedAt,
            value: _formatDate(context, site.siteCreated),
          ),
          _Divider(),
          _InfoRow(
            icon: Icons.update_outlined,
            label: context.l10n.commonUpdatedAt,
            value: _formatDate(context, site.siteUpdate),
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return '-';
    return context.dateFormat('dd MMM yyyy').format(date);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: AppColors.textSecondary),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Gap(3),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const Gap(6),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(11),
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: AppColors.textPrimary.withValues(alpha: 0.06),
    );
  }
}
