import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../../monitoring/presentation/utils/sensor_metadata_adapter.dart';

class _StatusInfo {
  final String label;
  final List<Color> gradientColors;
  const _StatusInfo({required this.label, required this.gradientColors});
}

_StatusInfo _statusInfoFor(AppLocalizations l10n, double persentase) {
  if (persentase >= 80) {
    return _StatusInfo(
      label: l10n.commonOptimal,
      gradientColors: const [
        Color(0xFF72E85A),
        Color(0xFF4DC934),
        Color(0xFF2FA010),
      ],
    );
  } else if (persentase >= 60) {
    return _StatusInfo(
      label: l10n.commonFair,
      gradientColors: const [
        Color(0xFF72E85A),
        Color(0xFF4DC934),
        Color(0xFF2FA010),
      ],
    );
  } else if (persentase >= 40) {
    return _StatusInfo(
      label: l10n.commonPoor,
      gradientColors: const [
        Color(0xFFFFCC55),
        Color(0xFFFFAA22),
        Color(0xFFE07800),
      ],
    );
  } else {
    return _StatusInfo(
      label: l10n.commonCritical,
      gradientColors: const [
        Color(0xFFFF7A7A),
        Color(0xFFFF4444),
        Color(0xFFCC1111),
      ],
    );
  }
}

_StatusInfo _statusInfoForReadingStatus(
  AppLocalizations l10n,
  SensorReadingStatus status,
) {
  switch (status) {
    case SensorReadingStatus.optimal:
      return _StatusInfo(
        label: l10n.commonOptimal,
        gradientColors: const [
          Color(0xFF72E85A),
          Color(0xFF4DC934),
          Color(0xFF2FA010),
        ],
      );
    case SensorReadingStatus.warning:
      return _StatusInfo(
        label: l10n.commonWarning,
        gradientColors: const [
          Color(0xFFFFCC55),
          Color(0xFFFFAA22),
          Color(0xFFE07800),
        ],
      );
    case SensorReadingStatus.critical:
      return _StatusInfo(
        label: l10n.commonCritical,
        gradientColors: const [
          Color(0xFFFF7A7A),
          Color(0xFFFF4444),
          Color(0xFFCC1111),
        ],
      );
    case SensorReadingStatus.offline:
      return _StatusInfo(
        label: l10n.commonOffline,
        gradientColors: const [
          Color(0xFFBDBDBD),
          Color(0xFF9E9E9E),
          Color(0xFF757575),
        ],
      );
    case SensorReadingStatus.unknown:
      return _StatusInfo(
        label: l10n.commonActive,
        gradientColors: const [
          Color(0xFF72E85A),
          Color(0xFF4DC934),
          Color(0xFF2FA010),
        ],
      );
  }
}

class SensorStatusCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double persentase;
  final SensorReadingStatus? readingStatus;

  const SensorStatusCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.persentase,
    this.readingStatus,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    final status =
        readingStatus == null || readingStatus == SensorReadingStatus.unknown
        ? _statusInfoFor(context.l10n, persentase)
        : _statusInfoForReadingStatus(context.l10n, readingStatus!);

    final valueFontSize = (sw / 390 * 30).clamp(22.0, 36.0);
    final unitFontSize = (sw / 390 * 11).clamp(9.0, 14.0);
    final labelFontSize = (sw / 390 * 12).clamp(10.0, 14.0);
    final badgeFontSize = (sw / 390 * 11).clamp(9.0, 13.0);

    return Container(
      height: 201,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/cardsensor-image.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.sensors, size: 22),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: valueFontSize,
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        unit,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: unitFontSize,
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: labelFontSize,
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 34,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: status.gradientColors,
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.lg),
                bottomRight: Radius.circular(AppRadius.lg),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              status.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: badgeFontSize,
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                height: 1.0,
                shadows: const [
                  Shadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SensorStatusGrid extends StatefulWidget {
  final List<SensorHealthEntity> sensors;
  final SensorMetadataAdapter? metadataAdapter;
  final int defaultCount;

  const SensorStatusGrid({
    super.key,
    required this.sensors,
    this.metadataAdapter,
    this.defaultCount = 6,
  });

  @override
  State<SensorStatusGrid> createState() => _SensorStatusGridState();
}

class _SensorStatusGridState extends State<SensorStatusGrid> {
  bool _expanded = false;
  final SensorMetadataAdapter _fallbackAdapter = SensorMetadataAdapter(
    const [],
  );

  @override
  Widget build(BuildContext context) {
    final adapter = widget.metadataAdapter ?? _fallbackAdapter;
    final total = widget.sensors.length;
    final showCount = _expanded ? total : total.clamp(0, widget.defaultCount);
    final hasMore = total > widget.defaultCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.547,
          ),
          itemCount: showCount,
          itemBuilder: (context, i) {
            final sensor = widget.sensors[i];
            final numericValue = double.tryParse(sensor.readUpdateValue) ?? 0;
            final readingStatus = adapter.statusFor(
              dsId: sensor.dsId,
              devId: sensor.devId,
              value: numericValue,
            );
            return SensorStatusCard(
              label: adapter.labelFor(sensor.dsId, devId: sensor.devId),
              value: adapter.displayValueText(
                sensor.dsId,
                sensor.readUpdateValue,
                devId: sensor.devId,
              ),
              unit: adapter.unitFor(sensor.dsId, devId: sensor.devId),
              persentase: sensor.persentase,
              readingStatus: readingStatus,
            );
          },
        ),
        if (hasMore) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _expanded
                        ? context.l10n.commonHide
                        : context.l10n.dashboardShowOtherSensors(
                            total - widget.defaultCount,
                          ),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
