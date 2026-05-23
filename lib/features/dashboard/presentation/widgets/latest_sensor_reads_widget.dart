import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

class LatestSensorReadsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reads;

  const LatestSensorReadsWidget({super.key, required this.reads});

  @override
  Widget build(BuildContext context) {
    if (reads.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reads.length > 5 ? 5 : reads.length, // Tampilkan maksimal 5 terbaru
        separatorBuilder: (context, index) => const Divider(
          color: AppColors.divider,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final read = reads[index];
          final dsId = read['ds_id']?.toString() ?? 'Unknown';
          final value = read['read_update_value']?.toString() ?? '0';
          final devId = read['dev_id']?.toString() ?? '';
          // Format date if needed, but for now we'll just show value and sensor
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.softBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/sensor-icon.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: context.rw(0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getSensorLabel(dsId),
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        devId,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$value ${_getSensorUnit(dsId)}',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getSensorLabel(String dsId) {
    switch (dsId) {
      case 'env_temp': return 'Suhu Lingkungan';
      case 'env_hum': return 'Kelembaban Lingkungan';
      case 'soil_nitro': return 'Nitrogen Tanah';
      case 'soil_phos': return 'Fosfor Tanah';
      case 'soil_pot': return 'Kalium Tanah';
      case 'soil_ph': return 'pH Tanah';
      case 'soil_hum': return 'Kelembaban Tanah';
      case 'soil_temp': return 'Suhu Tanah';
      case 'water_temp': return 'Suhu Air';
      case 'water_lvl': return 'Level Air';
      case 'light_lux': return 'Intensitas Cahaya';
      case 'rain_rate': return 'Curah Hujan';
      case 'wind_dir': return 'Arah Angin';
      case 'wind_spd': return 'Kecepatan Angin';
      default: return dsId;
    }
  }

  String _getSensorUnit(String dsId) {
    switch (dsId) {
      case 'env_temp': 
      case 'soil_temp':
      case 'water_temp': return '°C';
      case 'env_hum': 
      case 'soil_hum': return '%';
      case 'soil_nitro':
      case 'soil_phos':
      case 'soil_pot': return 'mg/kg';
      case 'water_lvl': return 'cm';
      case 'light_lux': return 'lux';
      case 'rain_rate': return 'mm/h';
      case 'wind_spd': return 'm/s';
      case 'wind_dir': return '°';
      case 'soil_ph': return '';
      default: return '';
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.sensors_off_outlined,
              size: 40,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada bacaan sensor',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
