import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/section_header_widget.dart';
import '../../../data/models/monitoring_models.dart';
import '../monitoring_card_header_widget.dart';

class SensorByTypeCardWidget extends StatelessWidget {
  final List<DeviceModel> devices;
  final bool showHeader;

  const SensorByTypeCardWidget({
    super.key,
    required this.devices,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          const SectionHeaderWidget(title: 'Sensor Berdasarkan Jenis'),
          SizedBox(height: context.rh(0.015)),
        ],
        ...devices.map((d) => _ExpandableDeviceCard(device: d)),
      ],
    );
  }
}

class _ExpandableDeviceCard extends StatefulWidget {
  final DeviceModel device;
  const _ExpandableDeviceCard({required this.device});

  @override
  State<_ExpandableDeviceCard> createState() => _ExpandableDeviceCardState();
}

class _ExpandableDeviceCardState extends State<_ExpandableDeviceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.device;
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(0.012)),
      child: AppCardWidget.elevated(
        radius: AppRadius.lg,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MonitoringCardHeaderWidget.svg(
                  svgIconPath: 'assets/icons/device-filled-icon.svg',
                  title: d.devName ?? d.devId,
                  description: _deviceDescription(d),
                  background: AppColors.softGreenAlt,
                  tint: AppColors.primary,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _DeviceStatusBadge(active: d.isActive),
                      const SizedBox(width: 8),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.chevron_right_rounded,
                        size: 24,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_expanded) _buildSensorList(context, d),
          ],
        ),
      ),
    );
  }

  String _deviceDescription(DeviceModel device) {
    final parts = <String>[];
    final location = device.devLocation?.trim();
    if (location != null && location.isNotEmpty) parts.add(location);
    parts.add(
      device.sensors.isEmpty
          ? 'Belum ada sensor terdaftar'
          : '${device.sensors.length} sensor terdaftar',
    );
    return parts.join(' - ');
  }

  Widget _buildSensorList(BuildContext context, DeviceModel d) {
    if (d.sensors.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: context.rh(0.015)),
        child: Text(
          'Belum ada data sensor',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(12),
            color: AppColors.textPrimary.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.012),
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: d.sensors.map((s) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.rh(0.008)),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/sensor-icon.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.info,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: context.rw(0.025)),
                Expanded(
                  child: Text(
                    s.sensName ?? s.sensId,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(12),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  s.sensAddress ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(11),
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DeviceStatusBadge extends StatelessWidget {
  final bool active;

  const _DeviceStatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.success : AppColors.textTertiary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.softGreen : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        active ? 'Aktif' : 'Offline',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption(
          context,
          size: 11,
          color: color,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}
