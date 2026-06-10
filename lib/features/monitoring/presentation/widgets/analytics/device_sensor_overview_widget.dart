import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../data/models/monitoring_models.dart';

class DeviceSensorOverviewWidget extends StatelessWidget {
  final List<DeviceModel> devices;
  final int totalSensors;

  const DeviceSensorOverviewWidget({
    super.key,
    required this.devices,
    required this.totalSensors,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return InfoStateWidget.svg(
        svgIconPath: 'assets/icons/device-filled-icon.svg',
        message: context.l10n.monitoringNoDevicesAvailable,
        height: 74,
      );
    }

    final displaySensors = totalSensors > 0
        ? totalSensors
        : devices.fold<int>(0, (s, d) => s + d.sensors.length);

    return Row(
      children: [
        Expanded(
          child: AppCardWidget(
            radius: AppRadius.lg,
            child: Row(
              children: [
                const IconBadgeWidget.svg(
                  svgIconPath: 'assets/icons/device-filled-icon.svg',
                  background: AppColors.softGreenAlt,
                  tint: AppColors.primary,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${devices.length}',
                        style: AppTextStyles.metric(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.monitoringTotalDevice,
                        style: AppTextStyles.label(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: AppCardWidget(
            radius: AppRadius.lg,
            child: Row(
              children: [
                const IconBadgeWidget.svg(
                  svgIconPath: 'assets/icons/sensor-icon.svg',
                  background: AppColors.softBlue,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$displaySensors',
                        style: AppTextStyles.metric(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.monitoringTotalSensor,
                        style: AppTextStyles.label(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
