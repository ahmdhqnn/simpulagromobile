import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../data/models/monitoring_models.dart';

class PlantRecommendationCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const PlantRecommendationCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final recData = data['data'] as Map<String, dynamic>?;

    if (recData == null || recData.isEmpty) {
      return const InfoStateWidget.svg(
        svgIconPath: 'assets/icons/recomendation-filled-icon.svg',
        message: 'Belum ada rekomendasi untuk tanaman',
        height: 195,
      );
    }

    final recommendation = recData['recommendation'] as Map<String, dynamic>?;
    final plantName = recommendation?['plant'] as String? ?? '-';
    final confidence = (recommendation?['confidence'] as num?)?.toDouble();
    final sensorData = recData['sensor_data'] as Map<String, dynamic>?;

    return AppCardWidget(
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadgeWidget.svg(
                svgIconPath: 'assets/icons/recomendation-filled-icon.svg',
                background: Color(0xFFE8F5E9),
                tint: Color(0xFF4CAF50),
                padding: EdgeInsets.only(
                  top: 11,
                  left: 10,
                  right: 10,
                  bottom: 9,
                ),
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rekomendasi Tanaman',
                      style: AppTextStyles.caption(context),
                    ),
                    Text(
                      plantName,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (confidence != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(confidence * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          if (sensorData != null) ...[
            SizedBox(height: context.rh(0.015)),
            const Divider(color: AppColors.divider),
            SizedBox(height: context.rh(0.01)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sensorData.entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${SensorMeta.label(e.key)}: ${e.value}',
                    style: AppTextStyles.caption(context, size: 11),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
