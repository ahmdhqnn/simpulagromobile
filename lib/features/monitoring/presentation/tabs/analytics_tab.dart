import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../plant/domain/entities/plant.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envAsync = ref.watch(envHealthProvider);
    final plantRecAsync = ref.watch(plantRecommendationProvider);
    final dailyAsync = ref.watch(dailyReadsProvider);
    final devicesAsync = ref.watch(devicesProvider);
    final plant = ref.watch(currentPlantProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(envHealthProvider);
        ref.invalidate(plantRecommendationProvider);
        ref.invalidate(dailyReadsProvider);
        ref.invalidate(devicesProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.rw(0.051)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Overview',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(22),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1D1D),
                height: 1.0,
              ),
            ),
            SizedBox(height: context.rh(0.015)),
            envAsync.when(
              loading: () => _shimmer(context, 166),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(envHealthProvider),
              ),
              data: (health) => _EnvironmentalHealthCard(health: health),
            ),

            SizedBox(height: context.rh(0.025)),

            envAsync.whenOrNull(
                  data: (health) {
                    final total = health['total_sensors'] ?? 0;
                    if (total == 0) {
                      return Column(
                        children: [
                          _ActionRequiredCard(),
                          SizedBox(height: context.rh(0.025)),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ) ??
                const SizedBox.shrink(),

            Text(
              'Statistik Tanaman',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(22),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1D1D),
                height: 1.0,
              ),
            ),
            SizedBox(height: context.rh(0.015)),
            _PlantStatisticsCard(plant: plant),

            SizedBox(height: context.rh(0.025)),

            if (plant != null) ...[
              _GrowthPhaseCard(plant: plant),
              SizedBox(height: context.rh(0.025)),
              _PlantDistributionCard(plant: plant),
              SizedBox(height: context.rh(0.025)),
            ],

            Text(
              'Rekomendasi Tanaman',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(22),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1D1D),
                height: 1.0,
              ),
            ),
            SizedBox(height: context.rh(0.015)),
            plantRecAsync.when(
              loading: () => _shimmer(context, 195),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(plantRecommendationProvider),
              ),
              data: (rec) => _PlantRecommendationCard(data: rec),
            ),

            SizedBox(height: context.rh(0.025)),

            Text(
              'Perangkat & Sensor Overview',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(22),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1D1D),
                height: 1.0,
              ),
            ),
            SizedBox(height: context.rh(0.015)),
            devicesAsync.when(
              loading: () => _shimmer(context, 74),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => _DeviceSensorOverviewCards(devices: devices),
            ),

            SizedBox(height: context.rh(0.015)),

            devicesAsync.when(
              loading: () => _shimmer(context, 98),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => _SensorByTypeCard(devices: devices),
            ),

            SizedBox(height: context.rh(0.025)),

            Text(
              'Analisis Sensor Harian',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(22),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1D1D),
                height: 1.0,
              ),
            ),
            SizedBox(height: context.rh(0.015)),
            dailyAsync.when(
              loading: () => _shimmer(context, 290),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(dailyReadsProvider),
              ),
              data: (daily) => _DailySensorChart(data: daily),
            ),

            SizedBox(height: context.rh(0.04)),
          ],
        ),
      ),
    );
  }

  Widget _shimmer(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _EnvironmentalHealthCard extends StatelessWidget {
  final Map<String, dynamic> health;
  const _EnvironmentalHealthCard({required this.health});

  @override
  Widget build(BuildContext context) {
    final overall = (health['overall_health'] as num?)?.toDouble() ?? 0;
    final total = health['total_sensors'] ?? 0;

    Color healthColor;
    String healthLabel;
    if (overall == 0) {
      healthColor = AppColors.warning;
      healthLabel = 'Setup Required';
    } else if (overall >= 80) {
      healthColor = AppColors.success;
      healthLabel = 'Sangat Baik';
    } else if (overall >= 60) {
      healthColor = AppColors.primaryLight;
      healthLabel = 'Baik';
    } else if (overall >= 40) {
      healthColor = AppColors.warning;
      healthLabel = 'Cukup';
    } else {
      healthColor = AppColors.error;
      healthLabel = 'Perlu Perhatian';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Environmental Health',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'Environmental Score',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1.83,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      overall.toStringAsFixed(0),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(44),
                        fontWeight: FontWeight.w500,
                        color: healthColor,
                        height: 0.50,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/100',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w400,
                        color: healthColor,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  healthLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: healthColor,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/warning-outline-icon.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.error,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$total Sensor tersedia, ${total == 0 ? 'Silahkan konfigurasi untuk menghasilkan monitoring.' : 'Monitoring berjalan normal.'}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(9),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1D1D1D),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRequiredCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Tindakan Diperlukan',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(22),
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF1D1D1D),
                    height: 1,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/icons/recomendation-action-outline-icon.svg',
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    AppColors.warning,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '0 Sensor Tersedia, belum ada konfigurasi\nSilahkan konfigurasi sensor untuk mulai monitoring',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlantRecommendationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _PlantRecommendationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final recData = data['data'] as Map<String, dynamic>?;

    if (recData == null || recData.isEmpty) {
      return Container(
        height: 195,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/recomendation-filled-icon.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: context.rh(0.005)),
              Text(
                'Belum ada rekomendasi untuk tanaman',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D),
                  height: 1.83,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final recommendation = recData['recommendation'] as Map<String, dynamic>?;
    final plantName = recommendation?['plant'] as String? ?? '-';
    final confidence = (recommendation?['confidence'] as num?)?.toDouble();
    final sensorData = recData['sensor_data'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(
                  top: 11,
                  left: 10,
                  right: 10,
                  bottom: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/recomendation-filled-icon.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF4CAF50),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.rw(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rekomendasi Tanaman',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      plantName,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D1D1D),
                      ),
                    ),
                  ],
                ),
              ),
              if (confidence != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(confidence * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          if (sensorData != null) ...[
            SizedBox(height: context.rh(0.015)),
            const Divider(color: AppColors.divider),
            SizedBox(height: context.rh(0.01)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sensorData.entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${SensorMeta.label(e.key)}: ${e.value}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlantStatisticsCard extends StatelessWidget {
  final dynamic plant;
  const _PlantStatisticsCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    if (plant == null) {
      return _EmptyCard(
        message: 'Belum ada tanaman aktif',
        iconPath: 'assets/icons/plant-total-outline-icon.svg',
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
            icon: 'assets/icons/tag-total-outline-icon.svg',
            label: 'Total',
            value: '1',
            color: const Color(0xFFECF6FE),
            spacing: 4,
          ),
          _StatItem(
            icon: 'assets/icons/plant-total-outline-icon.svg',
            label: 'Aktif',
            value: '1',
            color: const Color(0xFFEDF7EE),
            spacing: 2,
          ),
          _StatItem(
            icon: 'assets/icons/check-total-icon.svg',
            label: 'Dipanen',
            value: '0',
            color: const Color(0xFFE8EFE9),
            spacing: 3,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final double spacing;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.only(
            top: 11,
            left: 10,
            right: 10,
            bottom: 9,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1D),
                height: 1.0,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GrowthPhaseCard extends StatelessWidget {
  final dynamic plant;
  const _GrowthPhaseCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    final phase = (plant?.growthPhase as String?) ?? '-';
    final plantDate = plant?.plantDate as DateTime?;
    final hst = (plant?.hst as int?) ?? 0;

    String plantTypeDisplay = '-';
    try {
      final plantType = plant?.plantType;
      if (plantType != null && plantType is CropType) {
        plantTypeDisplay = plantType.displayName.toUpperCase();
      }
    } catch (e) {
      plantTypeDisplay = '-';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fase Pertumbuhan Saat Ini',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            phase,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1.83,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Types of Plants',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    'Planting Date',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    'HST',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    'Growth Phase',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    'Status',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plantTypeDisplay,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    plantDate != null
                        ? DateFormat('dd MMM yyyy').format(plantDate)
                        : '-',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    '$hst Hari',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    phase,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                  Text(
                    'Planting',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlantDistributionCard extends StatelessWidget {
  final dynamic plant;
  const _PlantDistributionCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    final hst = (plant?.hst as int?) ?? 0;

    String plantTypeDisplay = '-';
    try {
      final plantType = plant?.plantType;
      if (plantType != null && plantType is CropType) {
        plantTypeDisplay = plantType.displayName.toUpperCase();
      }
    } catch (e) {
      plantTypeDisplay = '-';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribusi Berdasarkan Jenis',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EFE9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.83,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                plantTypeDisplay,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1D1D),
                  height: 1.83,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '100%',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.83,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Fase Pertumbuhan Rata-rata',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1.83,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '$hst Days',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceSensorOverviewCards extends StatelessWidget {
  final List<DeviceModel> devices;
  const _DeviceSensorOverviewCards({required this.devices});

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return Container(
        height: 74,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/device-filled-icon.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: context.rh(0.005)),
              Text(
                'Belum ada perangkat tersedia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D),
                  height: 1.83,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final totalSensors = devices.fold<int>(0, (s, d) => s + d.sensors.length);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EFE9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/device-filled-icon.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1B5E20),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${devices.length}',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(22),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1D1D),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Device Total',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1D1D),
                          height: 1.83,
                        ),
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
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECF6FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/sensor-icon.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalSensors',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(22),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1D1D),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sensor Total',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1D1D),
                          height: 1.83,
                        ),
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

class _SensorByTypeCard extends StatefulWidget {
  final List<DeviceModel> devices;
  const _SensorByTypeCard({required this.devices});

  @override
  State<_SensorByTypeCard> createState() => _SensorByTypeCardState();
}

class _SensorByTypeCardState extends State<_SensorByTypeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.devices.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstDevice = widget.devices.first;
    final isActive = firstDevice.isActive;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sensor Berdasarkan Jenis',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(22),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 11,
                          left: 10,
                          right: 10,
                          bottom: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EFE9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/device-filled-icon.svg',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF1B5E20),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstDevice.devName ?? firstDevice.devId,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(22),
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF1D1D1D),
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              firstDevice.devLocation ?? '-',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(12),
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF1D1D1D),
                                height: 1.83,
                              ),
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
                          color: isActive
                              ? const Color(0xFFEDF7EE)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isActive ? 'Aktif' : 'Offline',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w500,
                            color: isActive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF9E9E9E),
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
                ],
              ),
            ),
          ),
          if (_expanded && firstDevice.sensors.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.012),
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Column(
                children: firstDevice.sensors.map((s) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: context.rh(0.008)),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/sensor-icon.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF42A5F5),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: context.rw(0.025)),
                        Expanded(
                          child: Text(
                            s.sensName ?? s.sensId,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(12),
                              color: const Color(0xFF1D1D1D),
                            ),
                          ),
                        ),
                        Text(
                          s.sensAddress ?? '',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(11),
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _DailySensorChart extends StatefulWidget {
  final List<SensorDailyModel> data;
  const _DailySensorChart({required this.data});

  @override
  State<_DailySensorChart> createState() => _DailySensorChartState();
}

class _DailySensorChartState extends State<_DailySensorChart> {
  String _selected = 'env_temp';

  List<String> get _params => widget.data.map((d) => d.dsId).toSet().toList();

  @override
  void initState() {
    super.initState();
    final p = _params;
    if (p.isNotEmpty && !p.contains(_selected)) _selected = p.first;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analisis Sensor Harian',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(22),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D),
                height: 1,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Statistik Sensor Hari Ini  ${DateFormat('dd.MM.yy').format(DateTime.now())}',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 218,
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/sensor-icon.svg',
                      width: 28,
                      height: 28,
                      colorFilter: ColorFilter.mode(
                        const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: context.rh(0.005)),
                    Text(
                      'Tidak ada data sensor yang tersedia untuk hari ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1.83,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final filtered = widget.data.where((d) => d.dsId == _selected).toList()
      ..sort((a, b) => (a.day ?? DateTime(0)).compareTo(b.day ?? DateTime(0)));

    final avgSpots = filtered
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.avgVal ?? 0))
        .toList();
    final minSpots = filtered
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.minVal ?? 0))
        .toList();
    final maxSpots = filtered
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.maxVal ?? 0))
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _params.map((p) {
                final isSel = p == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = p),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSel
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSel
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF4CAF50,
                                ).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      SensorMeta.label(p),
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(11),
                        fontWeight: FontWeight.w600,
                        color: isSel ? Colors.white : const Color(0xFF757575),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: context.rh(0.02)),
          if (filtered.isEmpty)
            const Center(
              child: Text(
                'Belum ada data harian',
                style: TextStyle(color: Color(0xFF9E9E9E)),
              ),
            )
          else
            Container(
              height: 200,
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: const Color(0xFFE0E0E0), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: (filtered.length / 5).ceilToDouble().clamp(
                          1,
                          double.infinity,
                        ),
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= filtered.length) {
                            return const SizedBox.shrink();
                          }
                          final d = filtered[idx].day;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              d != null ? DateFormat('d/M').format(d) : '',
                              style: TextStyle(
                                fontSize: context.sp(10),
                                color: const Color(0xFF757575),
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _bar(avgSpots, const Color(0xFF4CAF50)),
                    _bar(minSpots, const Color(0xFF42A5F5)),
                    _bar(maxSpots, const Color(0xFFFF9800)),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.white,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipBorder: const BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          return LineTooltipItem(
                            spot.y.toStringAsFixed(1),
                            const TextStyle(
                              color: Color(0xFF1D1D1D),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  minY: 0,
                ),
              ),
            ),
          SizedBox(height: context.rh(0.015)),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _legend(const Color(0xFF4CAF50), 'Rata-rata'),
              _legend(const Color(0xFF42A5F5), 'Min'),
              _legend(const Color(0xFFFF9800), 'Max'),
            ],
          ),
        ],
      ),
    );
  }

  LineChartBarData _bar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final String? iconPath;
  const _EmptyCard({required this.message, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath ?? 'assets/icons/plant-total-outline-icon.svg',
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: context.rh(0.005)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 28),
          SizedBox(height: context.rh(0.01)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              color: AppColors.error,
            ),
          ),
          SizedBox(height: context.rh(0.01)),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
