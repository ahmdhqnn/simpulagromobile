import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../recommendation/domain/entities/recommendation.dart';
import '../../../recommendation/domain/entities/recommendation_bundle.dart';
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
      loading: () => const RecommendationOverviewListSkeleton(),
      error: (error, _) =>
          _buildErrorCard(context, toUiErrorMessage(error, context.l10n)),
    );
  }

  Widget _buildSiteCard(
    BuildContext context,
    WidgetRef ref,
    List<Recommendation> items,
  ) {
    return _buildOverviewCard(
      context: context,
      title: context.l10n.recommendationSiteTitle,
      subtitle: context.l10n.recommendationSiteSubtitle,
      description: context.l10n.recommendationSiteDescription,
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
      title: context.l10n.recommendationPlantTitle,
      subtitle: context.l10n.recommendationPlantSubtitle,
      description: context.l10n.recommendationPlantDescription,
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
        ? context.l10n.recommendationPhaseNoActive
        : [
            context.l10n.recommendationPhaseLabel(snapshot.phaseName!),
            if (snapshot.currentHst != null)
              context.l10n.recommendationHstLabel(snapshot.currentHst!),
          ].join(' • ');

    return _buildOverviewCard(
      context: context,
      title: context.l10n.recommendationPhaseTitle,
      subtitle: phaseLabel,
      description: context.l10n.recommendationPhaseDescription,
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
    final sortedItems = List<Recommendation>.from(items)
      ..sort((a, b) => b.priority.index.compareTo(a.priority.index));
    final latest = sortedItems.isEmpty ? null : sortedItems.first;
    final confidence = latest?.confidenceScore;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                SizedBox(width: context.rw(0.02)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: context.sp(22),
                          fontWeight: FontWeight.w300,
                          color: AppColors.textPrimary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.hint(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                _metricPill(
                  context,
                  context.l10n.commonTotal,
                  '${items.length}',
                  color.withValues(alpha: 0.1),
                  color,
                ),
                if (confidence != null) ...[
                  const SizedBox(width: 8),
                  _metricPill(
                    context,
                    context.l10n.recommendationConfidenceLabel,
                    '${(confidence * 100).round()}%',
                    AppColors.info.withValues(alpha: 0.1),
                    AppColors.info,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            if (latest != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      latest.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      latest.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.hint(context),
                    ),
                    if (latest.type == RecommendationType.npk && latest.parameters?.sensorData != null) ...[
                      const SizedBox(height: 10),
                      _buildCompactSensorRow(context, latest.parameters!.sensorData!),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          context.l10n.commonViewDetail,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: color,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.hint(context),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metricPill(
    BuildContext context,
    String label,
    String value,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(11),
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(11),
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSensorRow(BuildContext context, RecommendationSensorData sensorData) {
    Widget sensorBadge(String label, String value, Color dotColor) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '$label: ',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(11),
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(11),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    Color dotColor(num? value) {
      if (value == null || value == 0) return AppColors.textSecondary.withValues(alpha: 0.4);
      return AppColors.success;
    }

    String formatVal(num? val, String unit) {
      if (val == null) return '-';
      if (val % 1 == 0) return '${val.toInt()} $unit';
      return '${val.toStringAsFixed(1)} $unit';
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (sensorData.nitrogen != null)
          sensorBadge('N', formatVal(sensorData.nitrogen, 'mg/kg'), dotColor(sensorData.nitrogen)),
        if (sensorData.phosphorus != null)
          sensorBadge('P', formatVal(sensorData.phosphorus, 'mg/kg'), dotColor(sensorData.phosphorus)),
        if (sensorData.potassium != null)
          sensorBadge('K', formatVal(sensorData.potassium, 'mg/kg'), dotColor(sensorData.potassium)),
        if (sensorData.ph != null)
          sensorBadge('pH', formatVal(sensorData.ph, ''), sensorData.ph! >= 6.0 && sensorData.ph! <= 7.0 ? AppColors.success : AppColors.warning),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
