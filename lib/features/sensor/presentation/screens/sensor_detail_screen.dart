import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/sensor_provider.dart';
import 'package:go_router/go_router.dart';

class SensorDetailScreen extends ConsumerWidget {
  final String siteId;
  final String sensorId;

  const SensorDetailScreen({
    super.key,
    required this.siteId,
    required this.sensorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorAsync = ref.watch(
      sensorDetailProvider((siteId: siteId, sensId: sensorId)),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Sensor',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1D),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1D1D1D)),
        actions: [
          sensorAsync.whenOrNull(
                data: (sensor) => IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(context, ref),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: sensorAsync.when(
        data: (sensor) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(
              sensorDetailProvider((siteId: siteId, sensId: sensorId)),
            );
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(context.rw(0.051)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: sensor.isActive
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _getSensorIcon(sensor.type),
                          size: 28,
                          color: sensor.isActive
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sensor.name,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(18),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1D1D1D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
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
                                  fontSize: context.sp(12),
                                  fontWeight: FontWeight.w600,
                                  color: sensor.isActive
                                      ? AppColors.success
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.rh(0.02)),

                // Information Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Tipe', sensor.typeDisplay),
                      _buildInfoRow(context, 'Satuan', sensor.unit),
                      if (sensor.description != null)
                        _buildInfoRow(
                          context,
                          'Deskripsi',
                          sensor.description!,
                        ),
                      _buildInfoRow(
                        context,
                        'Dibuat',
                        DateFormatter.formatDateTime(sensor.createdAt),
                      ),
                      _buildInfoRow(
                        context,
                        'Diperbarui',
                        DateFormatter.formatDateTime(sensor.updatedAt),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.rh(0.02)),

                // Delete Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteDialog(context, ref),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text(
                      'Hapus Sensor',
                      style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const DetailScreenSkeleton(infoRowCount: 5, hasDescription: true, headerHeight: 0),
        error: (error, stack) => Center(
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
                  onPressed: () => ref.invalidate(
                    sensorDetailProvider((siteId: siteId, sensId: sensorId)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1D1D1D),
              ),
            ),
          ),
        ],
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
      default:
        return Icons.sensors;
    }
  }

  void _navigateToEdit(BuildContext context, WidgetRef ref) {
    context.push('/site-sensor-edit/$siteId/$sensorId').then((_) {
      ref.invalidate(sensorDetailProvider((siteId: siteId, sensId: sensorId)));
    });
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Sensor',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus sensor ini? Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSensor(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteSensor(BuildContext context, WidgetRef ref) async {
    final formNotifier = ref.read(sensorFormProvider.notifier);
    final success = await formNotifier.deleteSensor(siteId, sensorId);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sensor berhasil dihapus',
            style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      final state = ref.read(sensorFormProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.error ?? 'Gagal menghapus sensor',
            style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
