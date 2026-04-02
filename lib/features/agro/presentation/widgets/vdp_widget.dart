import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/agro_model.dart';

class VdpWidget extends StatelessWidget {
  final VdpModel? vdpData;

  const VdpWidget({super.key, this.vdpData});

  @override
  Widget build(BuildContext context) {
    if (vdpData == null) {
      return _buildEmptyState();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: AppColors.info,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VDP (Vapor Pressure Deficit)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Defisit Tekanan Uap',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(vdpData!.status),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    vdpData!.vdp?.toStringAsFixed(2) ?? '-',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _getVdpColor(vdpData!.vdp),
                    ),
                  ),
                  const Text(
                    'kPa',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildVdpIndicator(vdpData!.vdp),
            const SizedBox(height: 16),
            _buildVdpInfo(vdpData!.vdp),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    if (status == null) return const SizedBox.shrink();

    Color color;
    switch (status.toLowerCase()) {
      case 'optimal':
        color = AppColors.success;
        break;
      case 'low':
        color = AppColors.warning;
        break;
      case 'high':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildVdpIndicator(double? vdp) {
    if (vdp == null) return const SizedBox.shrink();

    // VDP ranges: 0-0.4 (Low), 0.4-1.2 (Optimal), 1.2+ (High)
    final percentage = (vdp / 2.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VDP Range',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.info,
                        AppColors.success,
                        AppColors.warning,
                        AppColors.error,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * percentage * 0.85,
                  top: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _getVdpColor(vdp), width: 3),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
            Text(
              '0.4',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
            Text(
              '1.2',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
            Text(
              '2.0+',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVdpInfo(double? vdp) {
    if (vdp == null) return const SizedBox.shrink();

    String title;
    String description;
    IconData icon;
    Color color;

    if (vdp < 0.4) {
      title = 'VDP Rendah';
      description =
          'Kelembaban tinggi, risiko penyakit meningkat. Pertimbangkan ventilasi.';
      icon = Icons.info_outline;
      color = AppColors.info;
    } else if (vdp <= 1.2) {
      title = 'VDP Optimal';
      description =
          'Kondisi ideal untuk pertumbuhan tanaman. Transpirasi normal.';
      icon = Icons.check_circle_outline;
      color = AppColors.success;
    } else if (vdp <= 1.6) {
      title = 'VDP Tinggi';
      description =
          'Kelembaban rendah, tanaman mulai stress. Pertimbangkan penyiraman.';
      icon = Icons.warning_amber_outlined;
      color = AppColors.warning;
    } else {
      title = 'VDP Sangat Tinggi';
      description =
          'Stress air tinggi! Segera lakukan penyiraman dan tingkatkan kelembaban.';
      icon = Icons.error_outline;
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'Data VDP tidak tersedia',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getVdpColor(double? vdp) {
    if (vdp == null) return AppColors.textSecondary;
    if (vdp < 0.4) return AppColors.info;
    if (vdp <= 1.2) return AppColors.success;
    if (vdp <= 1.6) return AppColors.warning;
    return AppColors.error;
  }
}
