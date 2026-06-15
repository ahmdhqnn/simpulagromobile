import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../phase/domain/entities/phase.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../recommendation/domain/entities/recommendation.dart';
import '../../../recommendation/presentation/providers/recommendation_hub_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../utils/plant_phase_display.dart';

class PlantRecommendationCardsWidget extends ConsumerWidget {
  const PlantRecommendationCardsWidget({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSiteId = ref.watch(selectedSiteIdProvider);
    final siteId = phaseSiteIdForPlant(plant, fallbackSiteId: selectedSiteId);
    final plantRecommendations = ref.watch(
      plantRecommendationsBySiteProvider(siteId),
    );

    return Column(
      children: [
        plantRecommendations.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (items) => _RecommendationSectionCard(
            title: context.l10n.recommendationPlantTitle,
            subtitle: context.l10n.recommendationPlantSubtitle,
            description: context.l10n.recommendationPlantDescription,
            icon: Icons.eco_outlined,
            color: AppColors.success,
            items: items,
            onViewAll: () => _openHub(context, ref, RecommendationScope.plant),
          ),
          loading: () => const RecommendationOverviewCardSkeleton(),
          error: (error, _) => _RecommendationErrorCard(
            title: context.l10n.recommendationPlantLoadFailed,
            message: toUiErrorMessage(error, context.l10n),
            icon: Icons.eco_outlined,
            color: AppColors.success,
            onRetry: () =>
                ref.invalidate(plantRecommendationsBySiteProvider(siteId)),
          ),
        ),
        SizedBox(height: context.rh(0.012)),
        _buildPhaseSection(context, ref, siteId),
      ],
    );
  }

  Widget _buildPhaseSection(
    BuildContext context,
    WidgetRef ref,
    String siteId,
  ) {
    if (!plant.isCurrentPlanting) {
      return _RecommendationSectionCard(
        title: context.l10n.recommendationPhaseTitle,
        subtitle: plant.localizedStatus(context.l10n),
        description: context.l10n.recommendationPhaseAvailableForActivePlant,
        icon: Icons.timeline_outlined,
        color: AppColors.info,
        items: const <Recommendation>[],
        onViewAll: () => _openHub(context, ref, RecommendationScope.phase),
      );
    }

    final phaseAsync = ref.watch(currentPhaseProvider(siteId));
    return phaseAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (phase) {
        if (phase == null) {
          return _RecommendationSectionCard(
            title: context.l10n.recommendationPhaseTitle,
            subtitle: context.l10n.recommendationPhaseUnavailable,
            description: context.l10n.recommendationPhaseNoneForPlant,
            icon: Icons.timeline_outlined,
            color: AppColors.info,
            items: const <Recommendation>[],
            onViewAll: () => _openHub(context, ref, RecommendationScope.phase),
          );
        }

        final phaseKey = (siteId: siteId, phaseId: phase.id);
        final recommendations = ref.watch(
          recommendationsBySitePhaseProvider(phaseKey),
        );

        return recommendations.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (items) => _RecommendationSectionCard(
            title: context.l10n.recommendationPhaseTitle,
            subtitle: _phaseSubtitle(phase, plant, context.l10n),
            description: context.l10n.recommendationPhaseDescription,
            icon: Icons.timeline_outlined,
            color: AppColors.info,
            items: items,
            onViewAll: () => _openHub(context, ref, RecommendationScope.phase),
          ),
          loading: () => const RecommendationOverviewCardSkeleton(),
          error: (error, _) => _RecommendationErrorCard(
            title: context.l10n.recommendationPhaseLoadFailed,
            message: toUiErrorMessage(error, context.l10n),
            icon: Icons.timeline_outlined,
            color: AppColors.info,
            onRetry: () =>
                ref.invalidate(recommendationsBySitePhaseProvider(phaseKey)),
          ),
        );
      },
      loading: () => const RecommendationOverviewCardSkeleton(),
      error: (error, _) => _RecommendationErrorCard(
        title: context.l10n.recommendationActivePhaseLoadFailed,
        message: toUiErrorMessage(error, context.l10n),
        icon: Icons.timeline_outlined,
        color: AppColors.info,
        onRetry: () => ref.invalidate(currentPhaseProvider(siteId)),
      ),
    );
  }

  void _openHub(
    BuildContext context,
    WidgetRef ref,
    RecommendationScope scope,
  ) {
    resetRecommendationHubFilters(ref, scope: scope);
    context.push('/recommendations?scope=${scope.queryValue}');
  }
}

class _RecommendationSectionCard extends StatelessWidget {
  const _RecommendationSectionCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.items,
    required this.onViewAll,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<Recommendation> items;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final sortedItems = sortRecommendationOverviewItems(items);
    final latest = primaryRecommendationForOverview(items);
    final confidence = latest?.confidenceScore;

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      onTap: onViewAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadgeWidget.icon(
                icon: icon,
                background: color.withValues(alpha: 0.1),
                tint: color,
                size: 50,
                iconSize: 20,
                padding: const EdgeInsets.all(15),
                radius: AppRadius.xs,
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
              _MetricPill(
                label: context.l10n.commonTotal,
                value: sortedItems.length.toString(),
                color: color,
              ),
              if (confidence != null) ...[
                const SizedBox(width: 8),
                _MetricPill(
                  label: context.l10n.recommendationConfidenceLabel,
                  value: '${(confidence * 100).round()}%',
                  color: AppColors.info,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (latest != null)
            Container(
              width: double.infinity,
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
                      Icon(Icons.arrow_forward_rounded, color: color, size: 16),
                    ],
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
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
      ),
    );
  }
}

class _RecommendationErrorCard extends StatelessWidget {
  const _RecommendationErrorCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.onRetry,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      radius: AppRadius.lg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadgeWidget.icon(
            icon: icon,
            background: color.withValues(alpha: 0.12),
            tint: color,
            size: 38,
            iconSize: 18,
            padding: const EdgeInsets.all(10),
            radius: AppRadius.sm,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(context, context.sp(15)),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    context,
                    size: context.sp(12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: context.l10n.retry,
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            color: color,
            iconSize: 20,
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
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
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(11),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

String _phaseSubtitle(Phase phase, Plant plant, AppLocalizations l10n) {
  final hst = plant.hst ?? (phase.currentHst > 0 ? phase.currentHst : null);
  final range = l10n.recommendationHstRangeLabel(phase.hstMin, phase.hstMax);
  if (hst == null) return '${phase.phaseName} - $range';
  return '${phase.phaseName} - ${l10n.recommendationHstLabel(hst)}';
}
