import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../domain/entities/recommendation.dart';
import '../providers/recommendation_hub_provider.dart';

class RecommendationInfoCardWidget extends StatelessWidget {
  final Recommendation recommendation;
  final Set<RecommendationScope> sourceScopes;

  const RecommendationInfoCardWidget({
    super.key,
    required this.recommendation,
    this.sourceScopes = const {},
  });

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.commonInformation,
            style: AppTextStyles.cardTitle(context),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: _sourceIcon(_primaryScope),
            label: context.l10n.recommendationSourceLabel,
            value: _sourceTitle(context, _primaryScope),
          ),
          _InfoRow(
            icon: Icons.info_outline_rounded,
            label: 'Metode Analisis',
            value: _sourceDescription(context, _primaryScope, recommendation.createdAt),
          ),
          if (recommendation.siteName != null)
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: context.l10n.commonLocation,
              value: recommendation.siteName!,
            ),
          if (recommendation.plantName != null)
            _InfoRow(
              icon: Icons.eco_outlined,
              label: context.l10n.plantTitle,
              value: recommendation.plantName!,
            ),
          if (recommendation.confidenceScore != null)
            _InfoRow(
              icon: Icons.analytics_outlined,
              label: context.l10n.recommendationConfidenceLabel,
              value:
                  '${_confidenceLabel(context, recommendation.confidenceScore)} (${(recommendation.confidenceScore! * 100).toStringAsFixed(0)}%)',
            ),
          if (recommendation.createdAt != null)
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: context.l10n.commonCreatedAt,
              value: DateFormatter.formatDateTime(
                recommendation.createdAt!,
                locale: context.localeTag,
              ),
            ),
        ],
      ),
    );
  }

  RecommendationScope get _primaryScope {
    if (sourceScopes.contains(RecommendationScope.site)) {
      return RecommendationScope.site;
    }
    if (sourceScopes.contains(RecommendationScope.plant)) {
      return RecommendationScope.plant;
    }
    if (sourceScopes.contains(RecommendationScope.phase)) {
      return RecommendationScope.phase;
    }
    return RecommendationScope.all;
  }

  String _sourceTitle(BuildContext context, RecommendationScope scope) {
    return switch (scope) {
      RecommendationScope.site => 'Rekomendasi Aksi',
      RecommendationScope.plant => 'Rekomendasi Tanaman',
      RecommendationScope.phase => 'Rekomendasi Fase Aktif',
      RecommendationScope.all => 'Semua Rekomendasi',
    };
  }

  String _sourceDescription(
    BuildContext context,
    RecommendationScope scope,
    DateTime? createdAt,
  ) {
    final isToday = _isToday(createdAt);
    return switch (scope) {
      RecommendationScope.site => isToday
          ? 'Saran tindakan langsung berdasarkan kondisi terkini lahan Anda hari ini.'
          : 'Saran tindakan langsung berdasarkan kondisi terkini lahan Anda pada tanggal tersebut.',
      RecommendationScope.plant =>
        'Rekomendasi jenis tanaman yang paling cocok berdasarkan riwayat kondisi tanah seminggu terakhir.',
      RecommendationScope.phase =>
        'Panduan perawatan tanaman yang disesuaikan dengan usia dan fase pertumbuhan saat ini.',
      RecommendationScope.all => 'Semua saran dan panduan pertanian aktif untuk lahan Anda.',
    };
  }

  bool _isToday(DateTime? dateTime) {
    if (dateTime == null) return true;
    final now = DateTime.now();
    final local = dateTime.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  IconData _sourceIcon(RecommendationScope scope) {
    return switch (scope) {
      RecommendationScope.site => Icons.task_alt_rounded,
      RecommendationScope.plant => Icons.psychology_alt_outlined,
      RecommendationScope.phase => Icons.storage_rounded,
      RecommendationScope.all => Icons.layers_outlined,
    };
  }

  String _confidenceLabel(BuildContext context, double? score) {
    if (score == null) return context.l10n.recommendationConfidenceUnknown;
    if (score >= 0.8) return context.l10n.recommendationConfidenceVeryHigh;
    if (score >= 0.6) return context.l10n.commonHigh;
    if (score >= 0.4) return context.l10n.commonMedium;
    return context.l10n.commonLow;
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(0.012)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(11),
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(13),
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
