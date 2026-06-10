import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../../../shared/widgets/skeleton_loaders.dart';
import '../../../../../shared/widgets/stat_item_widget.dart';
import '../../../../plant/presentation/providers/plant_provider.dart';

class PlantStatisticsCardWidget extends ConsumerWidget {
  final dynamic plant;
  const PlantStatisticsCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (plant == null) {
      return InfoStateWidget.svg(
        svgIconPath: 'assets/icons/plant-total-outline-icon.svg',
        message: context.l10n.monitoringNoActivePlantTitle,
        height: 73,
      );
    }

    final plantsAsync = ref.watch(plantsProvider);

    return plantsAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      loading: () => const CompactStatsCardSkeleton(),
      error: (_, __) => _buildCard(
        context,
        total: 1,
        active: plant.isActive ? 1 : 0,
        harvested: plant.isHarvested ? 1 : 0,
      ),
      data: (plants) {
        final total = plants.length;
        final active = plants.where((p) => p.isActive).length;
        final harvested = plants.where((p) => p.isHarvested).length;
        return _buildCard(
          context,
          total: total,
          active: active,
          harvested: harvested,
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required int total,
    required int active,
    required int harvested,
  }) {
    return AppCardWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItemWidget(
            svgIconPath: 'assets/icons/tag-total-outline-icon.svg',
            label: context.l10n.commonTotal,
            value: '$total',
            background: AppColors.softBlue,
            labelTopGap: 4,
          ),
          StatItemWidget(
            svgIconPath: 'assets/icons/plant-total-outline-icon.svg',
            label: context.l10n.commonActive,
            value: '$active',
            background: AppColors.softGreen,
            labelTopGap: 2,
          ),
          StatItemWidget(
            svgIconPath: 'assets/icons/check-total-icon.svg',
            label: context.l10n.plantStatusHarvested,
            value: '$harvested',
            background: AppColors.softGreenAlt,
            labelTopGap: 3,
          ),
        ],
      ),
    );
  }
}
