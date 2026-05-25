import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/plant.dart';
import '../utils/plant_mutation_actions.dart';
import 'agro_indicator_button_widget.dart';
import 'growth_phase_button_widget.dart';
import 'plant_actions_sheet_widget.dart';

class PlantDetailCard extends ConsumerWidget {
  final Plant plant;

  const PlantDetailCard({super.key, required this.plant});

  String get _plantImage {
    return 'assets/images/padi-perkecambahan-image.png';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.rh(0.015)),

            _PlantCardHeader(onMoreTap: () => _showMoreActions(context, ref)),

            SizedBox(height: context.rh(0.03)),

            Text(
              AppLocalizations.of(context)!.plantOverviewTitle,
              style: AppTextStyles.sectionTitle(context),
            ),

            SizedBox(height: context.rh(0.025)),

            _PlantImageSection(plant: plant, image: _plantImage),

            SizedBox(height: context.rh(0.02)),

            _PlantInfoSection(plant: plant),

            SizedBox(height: context.rh(0.02)),
          ],
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.read(authProvider).isAdmin;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => PlantActionsSheet(
        plant: plant,
        onEdit: () {
          Navigator.pop(sheetCtx);
          context.push('/plant/${plant.plantId}/edit');
        },
        onHarvest: plant.isCurrentPlanting
            ? () {
                Navigator.pop(sheetCtx);
                PlantMutationActions.confirmAndHarvest(
                  context,
                  ref,
                  plant: plant,
                );
              }
            : null,
        onDelete: isAdmin
            ? () {
                Navigator.pop(sheetCtx);
                PlantMutationActions.confirmAndDelete(
                  context,
                  ref,
                  plant: plant,
                );
              }
            : null,
      ),
    );
  }
}

class _PlantCardHeader extends StatelessWidget {
  final VoidCallback onMoreTap;

  const _PlantCardHeader({required this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircularBackButtonWidget(
          onPressed: onMoreTap,
          svgIconPath: 'assets/icons/more-icon.svg',
        ),
      ],
    );
  }
}

class _PlantImageSection extends StatelessWidget {
  final Plant plant;
  final String image;

  const _PlantImageSection({required this.plant, required this.image});

  @override
  Widget build(BuildContext context) {
    final imageAreaHeight = context.rh(0.355).clamp(220.0, 320.0);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: imageAreaHeight,
          child: Transform.scale(
            scale: 1.2,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Center(
                child: Text(
                  plant.plantType?.icon ?? '🌱',
                  style: TextStyle(fontSize: context.sp(80)),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: context.rh(0.015)),

        Row(
          children: [
            GrowthPhaseButton(
              siteId: plant.siteId ?? '',
              plantName:
                  plant.plantType?.displayName ?? plant.plantName ?? 'Tanaman',
            ),
            const Spacer(),
            const AgroIndicatorButton(),
          ],
        ),
      ],
    );
  }
}

class _PlantInfoSection extends StatelessWidget {
  final Plant plant;

  const _PlantInfoSection({required this.plant});

  @override
  Widget build(BuildContext context) {
    final statusColor = plant.isHarvested
        ? AppColors.warning
        : plant.isCurrentPlanting
        ? AppColors.success
        : AppColors.textTertiary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.038)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plant.displayName,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              height: 1.0,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.005)),
          Text(
            plant.growthPhase ?? '-',
            style: AppTextStyles.caption2(
              context,
              size: context.sp(12),
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: context.rh(0.018)),

          _DetailRow(
            label: AppLocalizations.of(context)!.plantTypeLabel,
            value: plant.plantType?.displayName ?? '-',
          ),
          _DetailRow(
            label: AppLocalizations.of(context)!.plantDateLabel,
            value: DateFormatter.formatDate(plant.plantDate),
          ),
          _DetailRow(
            label: AppLocalizations.of(context)!.plantHstLabel,
            value: plant.hst != null
                ? '${plant.hst} ${AppLocalizations.of(context)!.plantHstUnit}'
                : '-',
          ),
          _DetailRow(
            label: AppLocalizations.of(context)!.plantPhaseLabel,
            value: plant.growthPhase ?? '-',
          ),
          _DetailRow(
            label: AppLocalizations.of(context)!.plantStatusLabel,
            value: plant.statusText,
            valueColor: statusColor,
          ),
          if (plant.isHarvested && plant.plantHarvest != null)
            _DetailRow(
              label: AppLocalizations.of(context)!.plantHarvestDateLabel,
              value: DateFormatter.formatDate(plant.plantHarvest),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: (context.sw * 0.38).clamp(100.0, 140.0),
            child: Text(
              label,
              style: AppTextStyles.label(
                context,
                size: context.sp(12),
                weight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.label(
                context,
                size: context.sp(12),
                weight: FontWeight.w300,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
