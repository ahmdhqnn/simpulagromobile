import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recommendation.dart';
import '../providers/recommendation_provider.dart';

class RecommendationListScreen extends ConsumerWidget {
  const RecommendationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRecommendationsAsync = ref.watch(
      filteredRecommendationsProvider,
    );
    final filter = ref.watch(recommendationFilterProvider);
    final stats = ref.watch(recommendationStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, ref, filter),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsCard(stats),
          Expanded(
            child: filteredRecommendationsAsync.when(
              data: (recommendations) {
                if (recommendations.isEmpty) {
                  return _buildEmptyState(filter);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(recommendationListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      return _buildRecommendationCard(
                        context,
                        recommendations[index],
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(RecommendationStats stats) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', stats.total.toString(), AppColors.primary),
          _buildStatItem(
            'Menunggu',
            stats.pending.toString(),
            AppColors.warning,
          ),
          _buildStatItem(
            'Diterapkan',
            stats.applied.toString(),
            AppColors.success,
          ),
          _buildStatItem(
            'Prioritas',
            stats.highPriority.toString(),
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    Recommendation recommendation,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/recommendation/${recommendation.recommendationId}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    recommendation.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recommendation.type.label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPriorityBadge(recommendation.priority),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recommendation.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (recommendation.siteName != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      recommendation.siteName!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (recommendation.plantName != null) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.eco,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.plantName!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBadge(recommendation.status),
                  if (recommendation.confidenceScore != null)
                    Text(
                      'Confidence: ${recommendation.confidenceLevel}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(RecommendationPriority priority) {
    final color = _getPriorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(RecommendationStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
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
        return const Color(0xFFD32F2F);
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
        return const Color(0xFF757575);
    }
  }

  Widget _buildEmptyState(RecommendationFilter filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada rekomendasi',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            filter == RecommendationFilter.all
                ? 'Belum ada rekomendasi tersedia'
                : 'Tidak ada rekomendasi untuk filter ini',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(
    BuildContext context,
    WidgetRef ref,
    RecommendationFilter currentFilter,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Rekomendasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: RecommendationFilter.values.map((filter) {
            return RadioListTile<RecommendationFilter>(
              title: Text(filter.label),
              value: filter,
              groupValue: currentFilter,
              onChanged: (value) {
                if (value != null) {
                  ref.read(recommendationFilterProvider.notifier).state = value;
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
