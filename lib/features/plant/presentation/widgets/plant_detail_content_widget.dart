import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';

class PlantHeaderCardWidget extends StatelessWidget {
  final dynamic plant;
  const PlantHeaderCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              plant.plantType?.icon ?? '🌱',
              style: const TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.displayName,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plant.plantType?.displayName ?? 'Unknown',
                  style: AppTextStyles.hint(context, size: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: plant.isCurrentPlanting
                        ? AppColors.success.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    plant.statusText,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.bold,
                      color: plant.isCurrentPlanting
                          ? AppColors.success
                          : Colors.grey,
                    ),
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

class PlantGrowthCardWidget extends StatelessWidget {
  final dynamic plant;
  const PlantGrowthCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final hst = plant.hst ?? 0;
    final phase = plant.growthPhase ?? 'Unknown';

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pertumbuhan', style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GrowthStat(
                  label: 'HST',
                  value: '$hst',
                  subtitle: 'Hari Setelah Tanam',
                  icon: Icons.calendar_today,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GrowthStat(
                  label: 'Fase',
                  value: phase,
                  subtitle: 'Fase Pertumbuhan',
                  icon: Icons.eco,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GrowthStat extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _GrowthStat({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(12),
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption(context, size: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PlantInfoCardWidget extends StatelessWidget {
  final dynamic plant;
  const PlantInfoCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Tanaman', style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 16),
          if (plant.plantSpecies != null) ...[
            _PlantInfoRow(
              icon: Icons.science,
              label: 'Spesies',
              value: plant.plantSpecies!,
            ),
            const SizedBox(height: 12),
          ],
          if (plant.plantDate != null) ...[
            _PlantInfoRow(
              icon: Icons.event,
              label: 'Tanggal Tanam',
              value: DateFormat('d/M/yyyy').format(plant.plantDate!),
            ),
            const SizedBox(height: 12),
          ],
          if (plant.plantHarvest != null)
            _PlantInfoRow(
              icon: Icons.agriculture,
              label: plant.isHarvested ? 'Tanggal Panen' : 'Target Panen',
              value: DateFormat('d/M/yyyy').format(plant.plantHarvest!),
            ),
        ],
      ),
    );
  }
}

class _PlantInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PlantInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textPrimary.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption(context, size: 12)),
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Action buttons for phase list, GDD tracking, and harvest.
class PlantActionButtonsWidget extends StatelessWidget {
  final dynamic plant;
  final VoidCallback onHarvest;

  const PlantActionButtonsWidget({
    super.key,
    required this.plant,
    required this.onHarvest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.push(
              '/phases/${plant.siteId ?? plant.plantId}/${Uri.encodeComponent(plant.displayName)}',
            ),
            icon: const Icon(Icons.timeline),
            label: Text(
              'Lihat Fase Pertumbuhan',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
        SizedBox(height: context.rh(0.014)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.push(
              '/gdd-tracking/${plant.siteId ?? plant.plantId}/${Uri.encodeComponent(plant.displayName)}',
            ),
            icon: const Icon(Icons.thermostat),
            label: Text(
              'GDD Tracking',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
        if (plant.isCurrentPlanting) ...[
          SizedBox(height: context.rh(0.014)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onHarvest,
              icon: const Icon(Icons.agriculture),
              label: Text(
                'Tandai Sudah Panen',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(14),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
