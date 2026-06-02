import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/recommendation.dart';
import '../providers/recommendation_provider.dart';

class RecommendationListScreen extends ConsumerWidget {
  const RecommendationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredRecommendationsProvider);
    final filter = ref.watch(recommendationFilterProvider);
    final stats = ref.watch(recommendationStatsProvider);
    final siteId = ref.watch(selectedSiteIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, siteId),
            _buildStatsCard(context, stats),
            _buildFilterChips(context, ref, filter),
            Expanded(
              child: filteredAsync.when(
                skipLoadingOnReload: true,
                skipLoadingOnRefresh: true,
                skipError: true,
                data: (recommendations) {
                  if (recommendations.isEmpty) {
                    return _buildEmptyState(context, ref, filter, siteId);
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      ref.invalidate(recommendationListProvider);
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rw(0.051),
                        vertical: context.rh(0.01),
                      ),
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: context.rh(0.014)),
                          child: _buildRecommendationCard(
                            context,
                            recommendations[index],
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => buildListSkeleton(count: 6, type: 'plant'),
                error: (error, stack) => _buildErrorState(context, ref, error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String? siteId) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          Text(
            'Rekomendasi',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(20),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          CircularIconActionWidget(
            onPressed: () {
              ref.invalidate(recommendationListProvider);
              if (siteId != null) {
                ref.invalidate(recommendationsBySiteProvider(siteId));
              }
            },
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, RecommendationStats stats) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Total', stats.total, AppColors.primary),
          _buildStatDivider(),
          _buildStatItem(context, 'Menunggu', stats.pending, AppColors.warning),
          _buildStatDivider(),
          _buildStatItem(
            context,
            'Diterapkan',
            stats.applied,
            AppColors.success,
          ),
          _buildStatDivider(),
          _buildStatItem(
            context,
            'Prioritas',
            stats.highPriority,
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(24),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.hint(context)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 32, width: 1, color: AppColors.divider);
  }

  Widget _buildFilterChips(
    BuildContext context,
    WidgetRef ref,
    RecommendationFilter currentFilter,
  ) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.01),
        ),
        children: RecommendationFilter.values.map((filter) {
          final isSelected = filter == currentFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ref.read(recommendationFilterProvider.notifier).state = filter;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  filter.label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    Recommendation recommendation,
  ) {
    final priorityColor = _getPriorityColor(recommendation.priority);
    final statusColor = _getStatusColor(recommendation.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () {
          context.push('/recommendation/${recommendation.recommendationId}');
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    recommendation.type.icon,
                    style: TextStyle(fontSize: context.sp(24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(15),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          recommendation.type.label,
                          style: AppTextStyles.hint(context),
                        ),
                      ],
                    ),
                  ),
                  _buildBadge(
                    context,
                    recommendation.priority.label,
                    priorityColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recommendation.description,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(13),
                  color: AppColors.textPrimary.withValues(alpha: 0.7),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (recommendation.siteName != null ||
                  recommendation.plantName != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (recommendation.siteName != null) ...[
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.siteName!,
                        style: AppTextStyles.caption(context, size: 12),
                      ),
                    ],
                    if (recommendation.plantName != null) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.eco,
                        size: 14,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.plantName!,
                        style: AppTextStyles.caption(context, size: 12),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBadge(
                    context,
                    recommendation.status.label,
                    statusColor,
                  ),
                  if (recommendation.confidenceScore != null)
                    Text(
                      'Akurasi: ${recommendation.confidenceLevel}',
                      style: AppTextStyles.caption(context, size: 12),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(11),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref,
    RecommendationFilter filter,
    String? siteId,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: context.rw(0.164).clamp(48.0, 72.0),
              color: AppColors.textPrimary.withValues(alpha: 0.3),
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Tidak ada rekomendasi',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              filter == RecommendationFilter.all
                  ? 'Belum ada rekomendasi tersedia.\nPastikan sensor sudah aktif dan mengirim data.'
                  : 'Tidak ada rekomendasi untuk filter "${filter.label}".',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
                color: AppColors.textPrimary.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
            if (filter == RecommendationFilter.all && siteId != null) ...[
              SizedBox(height: context.rh(0.03)),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(recommendationListProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Muat Ulang',
                  style: TextStyle(fontFamily: AppTextStyles.fontFamily),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: context.rw(0.164).clamp(48.0, 72.0),
              color: AppColors.error,
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Gagal memuat rekomendasi',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error.toString().replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
                color: AppColors.textPrimary.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton(
              onPressed: () => ref.invalidate(recommendationListProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.low:
        return AppColors.success;
      case RecommendationPriority.medium:
        return AppColors.warning;
      case RecommendationPriority.high:
        return AppColors.error;
      case RecommendationPriority.critical:
        return AppColors.errorDark;
    }
  }

  Color _getStatusColor(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.pending:
        return AppColors.warning;
      case RecommendationStatus.applied:
        return AppColors.success;
      case RecommendationStatus.dismissed:
        return AppColors.textSecondary;
      case RecommendationStatus.expired:
        return AppColors.muted;
    }
  }
}
