import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/sensor_provider.dart';
import 'sensor_detail_screen.dart';
import 'sensor_form_screen.dart';

class SensorListScreen extends ConsumerWidget {
  final String? siteId;
  final String? siteName;

  const SensorListScreen({super.key, this.siteId, this.siteName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gunakan siteId yang diberikan, atau fallback ke selectedSiteProvider
    final effectiveSiteId = siteId ?? ref.watch(selectedSiteIdProvider);
    final effectiveSiteName =
        siteName ?? ref.watch(selectedSiteProvider)?.siteName ?? 'Site';

    if (effectiveSiteId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sensor')),
        body: const Center(child: Text('Pilih site terlebih dahulu')),
      );
    }

    final sensorsAsync = ref.watch(sensorListProvider(effectiveSiteId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sensor',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1D),
              ),
            ),
            Text(
              effectiveSiteName,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                color: Color(0xFF1D1D1D),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1D1D1D)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(sensorListProvider(effectiveSiteId)),
          ),
        ],
      ),
      body: sensorsAsync.when(
        data: (sensors) {
          if (sensors.isEmpty) {
            return _buildEmptyState(context, ref, effectiveSiteId);
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(sensorListProvider(effectiveSiteId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              padding: EdgeInsets.all(context.rw(0.051)),
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: context.rh(0.014)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: sensor.isActive
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.grey.shade200,
                        child: Icon(
                          _getSensorIcon(sensor.type),
                          color: sensor.isActive
                              ? AppColors.primary
                              : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        sensor.name,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(15),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            sensor.typeDisplay,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(12),
                              color: const Color(
                                0xFF1D1D1D,
                              ).withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            'Satuan: ${sensor.unit}',
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
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: sensor.isActive
                              ? AppColors.success.withValues(alpha: 0.1)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sensor.statusText,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(11),
                            fontWeight: FontWeight.w600,
                            color: sensor.isActive
                                ? AppColors.success
                                : Colors.grey,
                          ),
                        ),
                      ),
                      onTap: () => _navigateToDetail(
                        context,
                        effectiveSiteId,
                        sensor.id,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => buildListSkeleton(count: 6),
        error: (error, stack) =>
            _buildErrorState(context, ref, effectiveSiteId, error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context, ref, effectiveSiteId),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Sensor',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, String siteId) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sensors_off,
              size: context.rw(0.164).clamp(48.0, 72.0),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Belum ada sensor',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              'Tambahkan sensor untuk mulai memantau kondisi lahan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton.icon(
              onPressed: () => _navigateToForm(context, ref, siteId),
              icon: const Icon(Icons.add),
              label: const Text(
                'Tambah Sensor',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    String siteId,
    Object error,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: context.rw(0.164).clamp(48.0, 72.0),
              color: AppColors.error,
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Gagal memuat sensor',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error.toString().replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton(
              onPressed: () => ref.invalidate(sensorListProvider(siteId)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSensorIcon(String type) {
    switch (type.toLowerCase()) {
      case 'temperature':
      case 'env_temp':
        return Icons.thermostat;
      case 'humidity':
      case 'env_hum':
        return Icons.water_drop;
      case 'soil_moisture':
      case 'soil_hum':
        return Icons.grass;
      case 'ph':
      case 'soil_ph':
        return Icons.science;
      case 'nitrogen':
      case 'soil_nitro':
        return Icons.eco;
      case 'phosphorus':
      case 'soil_phos':
        return Icons.biotech;
      case 'potassium':
      case 'soil_pot':
        return Icons.grain;
      case 'light':
        return Icons.wb_sunny;
      default:
        return Icons.sensors;
    }
  }

  void _navigateToDetail(BuildContext context, String siteId, String sensorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SensorDetailScreen(siteId: siteId, sensorId: sensorId),
      ),
    );
  }

  void _navigateToForm(BuildContext context, WidgetRef ref, String siteId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SensorFormScreen(siteId: siteId)),
    ).then((_) {
      ref.invalidate(sensorListProvider(siteId));
    });
  }
}
