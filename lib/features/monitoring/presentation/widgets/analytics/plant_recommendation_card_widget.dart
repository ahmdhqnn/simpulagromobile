import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../../recommendation/domain/entities/recommendation.dart';
import '../../../../recommendation/presentation/providers/recommendation_provider.dart';
import '../monitoring_card_header_widget.dart';

class PlantRecommendationCardWidget extends StatelessWidget {
  const PlantRecommendationCardWidget({
    super.key,
    required this.recommendations,
  });

  final List<Recommendation> recommendations;

  @override
  Widget build(BuildContext context) {
    final sortedItems = sortRecommendationOverviewItems(recommendations);
    final topItem = primaryRecommendationForOverview(recommendations);

    if (topItem == null) {
      return InfoStateWidget.svg(
        svgIconPath: 'assets/icons/recomendation-filled-icon.svg',
        message: context.l10n.monitoringPlantRecommendationEmpty,
        height: 195,
      );
    }

    final remainingItems = sortedItems
        .where((item) => item.recommendationId != topItem.recommendationId)
        .take(4)
        .toList(growable: false);

    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonitoringCardHeaderWidget.svg(
            svgIconPath: 'assets/icons/recomendation-filled-icon.svg',
            title: context.l10n.monitoringPlantRecommendationSection,
            description: context.l10n.recommendationPlantSubtitle,
            background: AppColors.softGreen,
            tint: AppColors.success,
            trailing: _CountBadge(
              label: context.l10n.monitoringRecommendationActionCount(
                sortedItems.length,
              ),
            ),
          ),
          SizedBox(height: context.rh(0.016)),
          _TopRecommendationPanel(recommendation: topItem),
          if (remainingItems.isNotEmpty) ...[
            SizedBox(height: context.rh(0.014)),
            ...remainingItems.map(
              (item) => _RecommendationRow(recommendation: item),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopRecommendationPanel extends StatelessWidget {
  const _TopRecommendationPanel({required this.recommendation});

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final confidence = recommendation.confidenceScore;
    final confidenceColor = _confidenceColor(confidence);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label(
                        context,
                        size: context.sp(14),
                        weight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.recommendationPlantTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(
                        context,
                        size: 11,
                        color: AppColors.success,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (confidence != null) ...[
                const SizedBox(width: 10),
                _ConfidenceBadge(
                  label: '${(confidence * 100).round()}%',
                  color: confidenceColor,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            recommendation.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption(
              context,
              size: 11,
              color: AppColors.textSecondary,
              weight: FontWeight.w500,
            ).copyWith(height: 1.45),
          ),
          if (confidence != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: confidence.clamp(0.0, 1.0).toDouble(),
                minHeight: 6,
                backgroundColor: confidenceColor.withValues(alpha: 0.14),
                valueColor: AlwaysStoppedAnimation<Color>(confidenceColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  const _RecommendationRow({required this.recommendation});

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final confidence = recommendation.confidenceScore;
    final color = _confidenceColor(confidence);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        recommendation.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label(
                          context,
                          size: 12,
                          weight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                    if (confidence != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${(confidence * 100).round()}%',
                        style: AppTextStyles.caption(
                          context,
                          size: 10,
                          color: color,
                          weight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  recommendation.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    context,
                    size: 11,
                    color: AppColors.textSecondary,
                    weight: FontWeight.w500,
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

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption(
          context,
          size: 11,
          color: AppColors.success,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption(
          context,
          size: 11,
          color: color,
          weight: FontWeight.w800,
        ),
      ),
    );
  }
}

Color _confidenceColor(double? confidence) {
  if (confidence == null) return AppColors.textSecondary;
  if (confidence >= 0.8) return AppColors.success;
  if (confidence >= 0.4) return AppColors.info;
  return AppColors.warning;
}
