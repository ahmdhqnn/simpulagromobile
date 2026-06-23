import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../recommendation/domain/entities/recommendation.dart';
import '../../../recommendation/presentation/providers/recommendation_provider.dart';
import '../../../recommendation/presentation/widgets/recommendation_color_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/localized_labels.dart';

class AgroRecommendationWidget extends StatefulWidget {
  const AgroRecommendationWidget({super.key, required this.recommendations})
    : errorMessage = null,
      onRetry = null;

  const AgroRecommendationWidget.error({
    super.key,
    required String message,
    required this.onRetry,
  }) : recommendations = const <Recommendation>[],
       errorMessage = message;

  final List<Recommendation> recommendations;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  State<AgroRecommendationWidget> createState() =>
      _AgroRecommendationWidgetState();
}

class _AgroRecommendationWidgetState extends State<AgroRecommendationWidget> {
  static const int _collapsedRecommendationCount = 2;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.errorMessage != null) {
      return _buildErrorState(context, widget.errorMessage!, widget.onRetry);
    }

    final sortedRecommendations = sortRecommendationOverviewItems(
      widget.recommendations,
    );

    if (sortedRecommendations.isEmpty) {
      return _buildEmptyState(context);
    }

    final l10n = AppLocalizations.of(context)!;
    final visibleRecommendations = _expanded
        ? sortedRecommendations
        : sortedRecommendations.take(_collapsedRecommendationCount).toList();
    final hasMoreRecommendations =
        sortedRecommendations.length > _collapsedRecommendationCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFFFFC107),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: context.rw(0.02)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.recommendationSiteTitle,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF1D1D1D),
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          l10n.recommendationSiteSubtitle,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF1D1D1D),
                            height: 1.83,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...visibleRecommendations.map(
                (rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildRecommendationCard(context, rec),
                ),
              ),
            ],
          ),
        ),
        if (hasMoreRecommendations) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _expanded
                        ? l10n.commonHide
                        : l10n.monitoringShowAllCount(
                            sortedRecommendations.length,
                          ),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecommendationCard(BuildContext context, Recommendation rec) {
    final priorityColor = RecommendationColors.forPriority(rec.priority);
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: () => context.push('/recommendation/${rec.recommendationId}'),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: priorityColor.withValues(alpha: rec.hasError ? 0.08 : 0.05),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: rec.hasError
                ? Border.all(color: AppColors.warning.withValues(alpha: 0.36))
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      rec.priority.localizedLabel(l10n).toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(10),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rec.type.localizedLabel(l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  rec.hasError
                      ? const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppColors.warning,
                        )
                      : SvgPicture.asset(
                          'assets/icons/arrow-up-right-long-outline-icon.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                            priorityColor,
                            BlendMode.srcIn,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                rec.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                rec.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(13),
                  color: AppColors.textPrimary.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
              if (rec.actionItems != null && rec.actionItems!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rec.actionItems!
                        .take(3)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: priorityColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: context.sp(12),
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: AppColors.success.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.agroNoCriticalRecommendations,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    VoidCallback? onRetry,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.retry),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
