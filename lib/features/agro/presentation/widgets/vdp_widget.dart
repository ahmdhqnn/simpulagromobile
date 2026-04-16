import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/agro_model.dart';

class VdpWidget extends StatelessWidget {
  final VdpModel? vdpData;

  const VdpWidget({super.key, this.vdpData});

  @override
  Widget build(BuildContext context) {
    if (vdpData == null) {
      return _buildEmptyState(context);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Color(0xFF42A5F5),
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VDP',
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
                      'Defisit Tekanan Uap',
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
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  vdpData!.vdp?.toStringAsFixed(2) ?? '-',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(48),
                    fontWeight: FontWeight.bold,
                    color: _getVdpColor(vdpData!.vdp),
                  ),
                ),
                Text(
                  'kPa',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(16),
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildVdpIndicator(context, vdpData!.vdp),
          const SizedBox(height: 16),
          _buildVdpInfo(context, vdpData!.vdp),
        ],
      ),
    );
  }

  Widget _buildVdpIndicator(BuildContext context, double? vdp) {
    if (vdp == null) return const SizedBox.shrink();

    final percentage = (vdp / 2.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VDP Range',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(12),
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(10),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            Text(
              '0.4',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(10),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            Text(
              '1.2',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(10),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            Text(
              '2.0+',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(10),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVdpInfo(BuildContext context, double? vdp) {
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
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 48,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Data VDP tidak tersedia',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getVdpColor(double? vdp) {
    if (vdp == null) return const Color(0xFF1D1D1D).withValues(alpha: 0.6);
    if (vdp < 0.4) return AppColors.info;
    if (vdp <= 1.2) return AppColors.success;
    if (vdp <= 1.6) return AppColors.warning;
    return AppColors.error;
  }
}
