import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../phase/domain/entities/phase.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../recommendation/domain/entities/recommendation.dart';
import '../../../recommendation/presentation/providers/recommendation_hub_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_provider.dart';
import '../../domain/entities/plant.dart';
import '../utils/plant_phase_display.dart';

class PlantRecommendationCardsWidget extends ConsumerWidget {
  const PlantRecommendationCardsWidget({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = phaseSiteIdForPlant(plant);
    final plantKey = (siteId: siteId, plantId: plant.plantId);
    final plantRecommendations = ref.watch(
      recommendationsByPlantForSiteProvider(plantKey),
    );

    return Column(
      children: [
        plantRecommendations.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (items) => _RecommendationSectionCard(
            title: 'Rekomendasi Tanaman',
            subtitle: 'Tanaman aktif di site terpilih',
            description: 'Rekomendasi terbaru berbasis data tanaman aktif.',
            icon: Icons.eco_outlined,
            color: AppColors.success,
            items: _filterForPlant(items, plant),
            onViewAll: () => _openHub(context, ref, RecommendationScope.plant),
          ),
          loading: () =>
              const LoadingCardWidget(height: 210, radius: AppRadius.lg),
          error: (error, _) => _RecommendationErrorCard(
            title: 'Gagal memuat rekomendasi tanaman',
            message: toUiErrorMessage(error),
            icon: Icons.eco_outlined,
            color: AppColors.success,
            onRetry: () =>
                ref.invalidate(recommendationsByPlantForSiteProvider(plantKey)),
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
        title: 'Rekomendasi Fase',
        subtitle: plant.statusText,
        description: 'Rekomendasi fase tersedia untuk tanaman aktif.',
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
            title: 'Rekomendasi Fase',
            subtitle: 'Fase aktif belum tersedia',
            description: 'Belum ada fase aktif untuk tanaman ini.',
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
            title: 'Rekomendasi Fase',
            subtitle: _phaseSubtitle(phase, plant),
            description: 'Saran aksi spesifik sesuai fase pertumbuhan aktif.',
            icon: Icons.timeline_outlined,
            color: AppColors.info,
            items: items,
            onViewAll: () => _openHub(context, ref, RecommendationScope.phase),
          ),
          loading: () =>
              const LoadingCardWidget(height: 210, radius: AppRadius.lg),
          error: (error, _) => _RecommendationErrorCard(
            title: 'Gagal memuat rekomendasi fase',
            message: toUiErrorMessage(error),
            icon: Icons.timeline_outlined,
            color: AppColors.info,
            onRetry: () =>
                ref.invalidate(recommendationsBySitePhaseProvider(phaseKey)),
          ),
        );
      },
      loading: () => const LoadingCardWidget(height: 210, radius: AppRadius.lg),
      error: (error, _) => _RecommendationErrorCard(
        title: 'Gagal memuat fase aktif',
        message: toUiErrorMessage(error),
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
    final sortedItems = _sortRecommendations(items);
    final pendingCount = sortedItems
        .where((item) => item.status == RecommendationStatus.pending)
        .length;
    final latest = sortedItems.isEmpty ? null : sortedItems.first;

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
                label: 'Total',
                value: sortedItems.length.toString(),
                color: color,
              ),
              const SizedBox(width: 8),
              _MetricPill(
                label: 'Pending',
                value: pendingCount.toString(),
                color: AppColors.warning,
              ),
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
                        'Lihat Detail',
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
            tooltip: 'Coba lagi',
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

List<Recommendation> _filterForPlant(List<Recommendation> items, Plant plant) {
  final byPlantId = items
      .where((item) => _sameText(item.plantId, plant.plantId))
      .toList();
  if (byPlantId.isNotEmpty) return byPlantId;

  final byPlantName = items
      .where((item) => _sameText(item.plantName, plant.displayName))
      .toList();
  if (byPlantName.isNotEmpty) return byPlantName;

  return items;
}

List<Recommendation> _sortRecommendations(List<Recommendation> items) {
  final byId = <String, Recommendation>{};
  for (final item in items) {
    final id = item.recommendationId.trim();
    if (id.isEmpty) continue;
    final previous = byId[id];
    if (previous == null) {
      byId[id] = item;
      continue;
    }
    final previousDate =
        previous.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final currentDate =
        item.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (currentDate.isAfter(previousDate)) byId[id] = item;
  }

  final sorted = byId.values.toList()
    ..sort((left, right) {
      final leftDate = left.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rightDate =
          right.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return rightDate.compareTo(leftDate);
    });
  return sorted;
}

bool _sameText(String? left, String right) {
  final normalizedLeft = left?.trim().toLowerCase();
  if (normalizedLeft == null || normalizedLeft.isEmpty) return false;
  return normalizedLeft == right.trim().toLowerCase();
}

String _phaseSubtitle(Phase phase, Plant plant) {
  final hst = plant.hst ?? (phase.currentHst > 0 ? phase.currentHst : null);
  final range = 'HST ${phase.hstMin}-${phase.hstMax}';
  if (hst == null) return '${phase.phaseName} - $range';
  return '${phase.phaseName} - HST $hst';
}
