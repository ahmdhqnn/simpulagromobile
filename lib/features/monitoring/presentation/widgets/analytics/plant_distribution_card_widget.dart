import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../plant/domain/entities/plant.dart';

class PlantDistributionCardWidget extends StatelessWidget {
  final dynamic plant;
  const PlantDistributionCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final hst = (plant?.hst as int?) ?? 0;

    String plantTypeDisplay = '-';
    try {
      final plantType = plant?.plantType;
      if (plantType != null && plantType is CropType) {
        plantTypeDisplay = plantType.displayName.toUpperCase();
      }
    } catch (_) {
      plantTypeDisplay = '-';
    }

    return AppCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribusi Berdasarkan Jenis',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.softGreenAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: AppTextStyles.label(
                      context,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                plantTypeDisplay,
                style: AppTextStyles.label(context, weight: FontWeight.w500),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '100%',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.label(
                      context,
                      weight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Fase Pertumbuhan Rata-rata',
            style: AppTextStyles.label(context, weight: FontWeight.w300),
          ),
          const SizedBox(height: 1),
          Text(
            '$hst Days',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
