import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../recommendation/domain/entities/recommendation.dart';
import '../../../recommendation/presentation/providers/recommendation_hub_provider.dart';

class DashboardRecommendationCard extends ConsumerWidget {
  const DashboardRecommendationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(recommendationHubDashboardSnapshotProvider);

    return snapshotAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (snapshot) => Column(
        children: [
          _buildSiteCard(context, ref, snapshot.siteItems),
          SizedBox(height: context.rh(0.012)),
          _buildPlantCard(context, ref, snapshot.plantItems),
          SizedBox(height: context.rh(0.012)),
          _buildPhaseCard(context, ref, snapshot.phaseSnapshot),
        ],
      ),
      loading: () => Column(
        children: [
          const LoadingCardWidget(height: 148),
          SizedBox(height: context.rh(0.012)),
          const LoadingCardWidget(height: 148),
          SizedBox(height: context.rh(0.012)),
          const LoadingCardWidget(height: 148),
        ],
      ),
      error: (error, _) => _buildErrorCard(context, toUiErrorMessage(error)),
    );
  }

  Widget _buildSiteCard(
    BuildContext context,
    WidgetRef ref,
    List<Recommendation> items,
  ) {
    return _buildOverviewCard(
      context: context,
      title: 'Rekomendasi Site',
      subtitle: 'Kondisi site terpilih dan kebutuhan tindakan',
      description: 'Analisis umum kondisi site dan kebutuhan tindakan.',
      icon: Icons.location_on_outlined,
      color: AppColors.primary,
      items: items,
      onTap: () =>
          _openRecommendationHub(context, ref, RecommendationScope.site),
    );
  }

  Widget _buildPlantCard(
    BuildContext context,
    WidgetRef ref,
    List<Recommendation> items,
  ) {
    return _buildOverviewCard(
      context: context,
      title: 'Rekomendasi Tanaman',
      subtitle: 'Tanaman aktif di site terpilih',
      description: 'Rekomendasi terbaru berbasis data tanaman aktif.',
      icon: Icons.eco_outlined,
      color: AppColors.success,
      items: items,
      onTap: () =>
          _openRecommendationHub(context, ref, RecommendationScope.plant),
    );
  }

  Widget _buildPhaseCard(
    BuildContext context,
    WidgetRef ref,
    RecommendationPhaseSnapshot snapshot,
  ) {
    final phaseLabel = snapshot.phaseName == null
        ? 'Belum ada fase aktif'
        : [
            'Fase: ${snapshot.phaseName}',
            if (snapshot.currentHst != null) 'HST ${snapshot.currentHst}',
          ].join(' • ');

    return _buildOverviewCard(
      context: context,
      title: 'Rekomendasi Fase',
      subtitle: phaseLabel,
      description: 'Saran aksi spesifik sesuai fase pertumbuhan aktif.',
      icon: Icons.timeline_outlined,
      color: AppColors.info,
      items: snapshot.items,
      onTap: () =>
          _openRecommendationHub(context, ref, RecommendationScope.phase),
    );
  }

  void _openRecommendationHub(
    BuildContext context,
    WidgetRef ref,
    RecommendationScope scope,
  ) {
    resetRecommendationHubFilters(ref, scope: scope);
    context.push('/recommendations?scope=${scope.queryValue}');
  }

  Widget _buildOverviewCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required List<Recommendation> items,
    required VoidCallback onTap,
  }) {
    final pending = items
        .where((item) => item.status == RecommendationStatus.pending)
        .length;
    final latest = items.isEmpty ? null : items.first;

    return AppCardWidget(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(context.rw(0.04)),
      border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadgeWidget.icon(
                icon: icon,
                background: color.withValues(alpha: 0.12),
                tint: color,
                radius: 10,
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle(context, 14)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(context),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
          SizedBox(height: context.rh(0.012)),
          Row(
            children: [
              _metricPill(context, 'Total ${items.length}', AppColors.primary),
              const SizedBox(width: 8),
              _metricPill(context, 'Pending $pending', AppColors.warning),
            ],
          ),
          SizedBox(height: context.rh(0.012)),
          Text(
            latest == null ? description : latest.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label(
              context,
              size: 13,
              weight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            latest == null ? 'Belum ada data rekomendasi.' : latest.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption(context, size: 12),
          ),
        ],
      ),
    );
  }

  Widget _metricPill(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption(
          context,
          size: 11,
          weight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return AppCardWidget(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.04)),
      radius: AppRadius.lg,
      border: Border.all(color: AppColors.error.withValues(alpha: 0.18)),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption(context, size: 12),
            ),
          ),
        ],
      ),
    );
  }
}
