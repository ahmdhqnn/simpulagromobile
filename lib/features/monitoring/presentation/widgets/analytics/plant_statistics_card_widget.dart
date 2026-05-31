import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../../../shared/widgets/stat_item_widget.dart';
import '../../../../plant/presentation/providers/plant_provider.dart';

class PlantStatisticsCardWidget extends ConsumerWidget {
  final dynamic plant;
  const PlantStatisticsCardWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (plant == null) {
      return const InfoStateWidget.svg(
        svgIconPath: 'assets/icons/plant-total-outline-icon.svg',
        message: 'Belum ada tanaman aktif',
        height: 73,
      );
    }

    final plantsAsync = ref.watch(plantsProvider);

    return plantsAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      loading: () => Container(
        height: 74,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
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
            label: 'Total',
            value: '$total',
            background: AppColors.softBlue,
            labelTopGap: 4,
          ),
          StatItemWidget(
            svgIconPath: 'assets/icons/plant-total-outline-icon.svg',
            label: 'Aktif',
            value: '$active',
            background: AppColors.softGreen,
            labelTopGap: 2,
          ),
          StatItemWidget(
            svgIconPath: 'assets/icons/check-total-icon.svg',
            label: 'Dipanen',
            value: '$harvested',
            background: AppColors.softGreenAlt,
            labelTopGap: 3,
          ),
        ],
      ),
    );
  }
}
