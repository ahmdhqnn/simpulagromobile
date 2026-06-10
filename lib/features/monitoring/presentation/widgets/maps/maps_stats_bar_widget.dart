import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../../../shared/widgets/stat_item_widget.dart';
import '../../../data/models/monitoring_models.dart';

class MapsStatsBarWidget extends StatelessWidget {
  final List<DeviceModel> devices;
  final int totalSensors;

  const MapsStatsBarWidget({
    super.key,
    required this.devices,
    required this.totalSensors,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return InfoStateWidget.svg(
        svgIconPath: 'assets/icons/device-filled-icon.svg',
        message: context.l10n.monitoringNoDeviceStats,
        height: 70,
      );
    }

    final activeDevices = devices.where((d) => d.isActive).length;
    final displaySensors = totalSensors > 0
        ? totalSensors
        : devices.fold<int>(0, (sum, d) => sum + d.sensors.length);

    return AppCardWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItemWidget(
            svgIconPath: 'assets/icons/device-filled-icon.svg',
            label: context.l10n.deviceTitle,
            value: '${devices.length}',
            background: AppColors.softGreenAlt,
            iconTint: AppColors.primary,
            labelTopGap: 4,
          ),
          StatItemWidget(
            svgIconPath: 'assets/icons/sensor-icon.svg',
            label: context.l10n.sensorTitle,
            value: '$displaySensors',
            background: AppColors.softBlue,
            iconTint: AppColors.info,
            labelTopGap: 2,
          ),
          StatItemWidget(
            svgIconPath: 'assets/icons/check-icon.svg',
            label: context.l10n.commonActive,
            value: '$activeDevices',
            background: AppColors.softGreen,
            iconTint: AppColors.success,
            labelTopGap: 3,
          ),
        ],
      ),
    );
  }
}
