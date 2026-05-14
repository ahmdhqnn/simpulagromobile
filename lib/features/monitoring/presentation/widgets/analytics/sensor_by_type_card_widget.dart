import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../../shared/widgets/section_header_widget.dart';
import '../../../data/models/monitoring_models.dart';

class SensorByTypeCardWidget extends StatelessWidget {
  final List<DeviceModel> devices;
  const SensorByTypeCardWidget({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Sensor Berdasarkan Jenis'),
        SizedBox(height: context.rh(0.015)),
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
    return Container(
      margin: EdgeInsets.only(bottom: context.rh(0.012)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const IconBadgeWidget.svg(
                    svgIconPath: 'assets/icons/device-filled-icon.svg',
                    background: AppColors.softGreenAlt,
                    tint: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.devName ?? d.devId,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w300,
                            color: AppColors.textPrimary,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          d.devLocation ?? '-',
                          style: AppTextStyles.hint(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: d.isActive
                          ? AppColors.softGreen
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      d.isActive ? 'Aktif' : 'Offline',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w500,
                        color: d.isActive
                            ? AppColors.success
                            : AppColors.textTertiary,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    _expanded
                        ? 'assets/icons/chevron-down-icon.svg'
                        : 'assets/icons/chevron-right-icon.svg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) _buildSensorList(context, d),
        ],
      ),
    );
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
