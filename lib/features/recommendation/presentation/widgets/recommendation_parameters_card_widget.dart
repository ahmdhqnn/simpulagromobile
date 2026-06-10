import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../domain/entities/recommendation_bundle.dart';

class RecommendationParametersCardWidget extends StatelessWidget {
  final RecommendationBundle parameters;

  const RecommendationParametersCardWidget({
    super.key,
    required this.parameters,
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
            context.l10n.recommendationParametersTitle,
            style: AppTextStyles.cardTitle(context),
          ),
          const SizedBox(height: 12),
          if (parameters.npk != null) ...[
            _buildRow(
              context,
              context.l10n.recommendationNpkStatusLabel,
              parameters.npk!.status,
            ),
            _buildRow(
              context,
              context.l10n.recommendationNpkDoseLabel,
              _formatDose(context, parameters.npk!),
            ),
          ],
          if (parameters.ph != null) ...[
            _buildRow(
              context,
              context.l10n.recommendationPhStatusLabel,
              parameters.ph!.status,
            ),
            _buildRow(
              context,
              context.l10n.recommendationPhDoseLabel,
              _formatDose(context, parameters.ph!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDose(BuildContext context, RecommendationActionResult result) {
    if (result.dosisKgHa > 0) {
      return '${_formatNumber(result.dosisKgHa)} kg/ha';
    }

    final text = '${result.status} ${result.pesan}'.toLowerCase();
    if (text.contains('normal') ||
        text.contains('aman') ||
        text.contains('tidak diperlukan') ||
        text.contains('tidak perlu')) {
      return context.l10n.recommendationNoAdditionalDose;
    }

    return context.l10n.recommendationBackendDataUnavailable;
  }

  String _formatNumber(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  }
}
