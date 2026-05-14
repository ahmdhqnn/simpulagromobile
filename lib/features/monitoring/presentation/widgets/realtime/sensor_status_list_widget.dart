import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../dashboard/data/models/environmental_health_model.dart';
import '../../../data/models/monitoring_models.dart';

class SensorStatusListWidget extends StatefulWidget {
  final List<SensorReadUpdate> reads;
  final EnvironmentalHealth? envHealth;

  const SensorStatusListWidget({
    super.key,
    required this.reads,
    this.envHealth,
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
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
            itemBuilder: (context, i) =>
                _SensorRow(read: reads[i], envHealth: widget.envHealth),
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
                      ? 'Tampilkan Lebih Sedikit'
                      : 'Tampilkan Semua (${reads.length})',
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

  const _SensorRow({required this.read, this.envHealth});

  @override
  Widget build(BuildContext context) {
    final val = read.numericValue;
    final isOk = val > 0;
    final color = SensorMeta.color(read.dsId);

    double persentase = isOk ? 80.0 : 0.0;
    if (envHealth != null && envHealth!.sensors.isNotEmpty) {
      final match = envHealth!.sensors
          .where((s) => s.dsId == read.dsId)
          .firstOrNull;
      if (match != null) persentase = match.persentase;
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
                      SensorMeta.label(read.dsId),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(13),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${read.readUpdateValue ?? '-'}${SensorMeta.unit(read.dsId)}',
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
            color: isOk
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.textPrimary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isOk ? 'Aktif' : 'Offline',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(10),
              fontWeight: FontWeight.w600,
              color: isOk
                  ? AppColors.success
                  : AppColors.textPrimary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
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
