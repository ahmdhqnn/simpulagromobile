import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../plant/domain/entities/plant.dart';

class GrowthPhaseCardWidget extends StatelessWidget {
  final dynamic plant;
  const GrowthPhaseCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final phase = (plant?.growthPhase as String?) ?? '-';
    final plantDate = plant?.plantDate as DateTime?;
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
          Row(
            children: [
              const IconBadgeWidget.icon(
                icon: Icons.grass,
                background: Color(0xFFE3F2FD),
                tint: Color(0xFF1976D2),
                radius: 10,
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fase Pertumbuhan Saat Ini',
                      style: AppTextStyles.sectionTitle(context, 20),
                    ),
                    const SizedBox(height: 4),
                    Text(phase, style: AppTextStyles.hint(context)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(context, 'Types of Plants'),
                  _label(context, 'Planting Date'),
                  _label(context, 'HST'),
                  _label(context, 'Growth Phase'),
                  _label(context, 'Status'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _value(context, plantTypeDisplay),
                  _value(
                    context,
                    plantDate != null
                        ? DateFormat('dd MMM yyyy').format(plantDate)
                        : '-',
                  ),
                  _value(context, '$hst Hari'),
                  _value(context, phase),
                  _value(context, plant.statusText as String? ?? '-'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text) =>
      Text(text, style: AppTextStyles.label(context, weight: FontWeight.w500));

  Widget _value(BuildContext context, String text) =>
      Text(text, style: AppTextStyles.label(context, weight: FontWeight.w300));
}
