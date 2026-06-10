import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../dashboard/data/models/environmental_health_model.dart';
import '../../../data/models/monitoring_models.dart';
import '../../utils/sensor_metadata_adapter.dart';

class SensorStatusListWidget extends StatefulWidget {
  final List<SensorReadUpdate> reads;
  final EnvironmentalHealth? envHealth;
  final SensorMetadataAdapter metadataAdapter;

  const SensorStatusListWidget({
    super.key,
    required this.reads,
    this.envHealth,
    required this.metadataAdapter,
  });

  @override
  State<SensorStatusListWidget> createState() => _SensorStatusListWidgetState();
}

class _SensorStatusListWidgetState extends State<SensorStatusListWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final reads = widget.reads;
    final displayCount = _expanded
        ? reads.length
        : (reads.length > 3 ? 3 : reads.length);

    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: displayCount,
            separatorBuilder: (_, __) => Divider(
              height: 20,
              color: AppColors.textPrimary.withValues(alpha: 0.07),
            ),
            itemBuilder: (context, i) => _SensorRow(
              read: reads[i],
              envHealth: widget.envHealth,
              metadataAdapter: widget.metadataAdapter,
            ),
          ),
          if (reads.length > 3)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.center,
                child: Text(
                  _expanded
                      ? context.l10n.monitoringShowLess
                      : context.l10n.monitoringShowAllCount(reads.length),
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SensorRow extends StatelessWidget {
  final SensorReadUpdate read;
  final EnvironmentalHealth? envHealth;
  final SensorMetadataAdapter metadataAdapter;

  const _SensorRow({
    required this.read,
    this.envHealth,
    required this.metadataAdapter,
  });

  @override
  Widget build(BuildContext context) {
    final val = read.numericValue;
    final color = metadataAdapter.colorFor(read.dsId);
    final status = metadataAdapter.statusFor(
      dsId: read.dsId,
      devId: read.devId,
      value: val,
    );
    final statusLabel = metadataAdapter.statusLabel(status, context.l10n);

    double persentase = val > 0 ? 80.0 : 0.0;
    if (envHealth != null && envHealth!.sensors.isNotEmpty) {
      final match = envHealth!.sensors
          .where((s) => s.dsId == read.dsId)
          .firstOrNull;
      if (match != null) persentase = match.persentase;
    }

    final isOnline = val > 0;
    if (!isOnline) {
      persentase = 0;
    }

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(_iconFor(read.dsId), size: 18, color: color),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      metadataAdapter.labelFor(read.dsId, devId: read.devId),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(13),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${read.readUpdateValue ?? '-'}${metadataAdapter.unitFor(read.dsId, devId: read.devId)}',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: persentase / 100.0,
                  minHeight: 5,
                  backgroundColor: AppColors.textPrimary.withValues(
                    alpha: 0.07,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: context.rw(0.025)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isOnline
                ? _statusColor(status).withValues(alpha: 0.12)
                : AppColors.textPrimary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(10),
              fontWeight: FontWeight.w600,
              color: isOnline
                  ? _statusColor(status)
                  : AppColors.textPrimary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  Color _statusColor(SensorReadingStatus status) {
    switch (status) {
      case SensorReadingStatus.optimal:
        return AppColors.success;
      case SensorReadingStatus.warning:
        return AppColors.warning;
      case SensorReadingStatus.critical:
        return AppColors.error;
      case SensorReadingStatus.offline:
        return AppColors.textPrimary.withValues(alpha: 0.4);
      case SensorReadingStatus.unknown:
        return AppColors.info;
    }
  }

  IconData _iconFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
      case 'soil_temp':
        return Icons.thermostat_rounded;
      case 'env_hum':
      case 'soil_hum':
        return Icons.water_drop_rounded;
      case 'soil_nitro':
        return Icons.grass_rounded;
      case 'soil_phos':
        return Icons.science_rounded;
      case 'soil_pot':
        return Icons.diamond_rounded;
      case 'soil_ph':
        return Icons.speed_rounded;
      default:
        return Icons.sensors_rounded;
    }
  }
}
