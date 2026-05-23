import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../phase/domain/entities/phase.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AgroPhaseWidget extends StatelessWidget {
  final Phase? phase;

  const AgroPhaseWidget({super.key, this.phase});

  @override
  Widget build(BuildContext context) {
    if (phase == null) {
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
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.eco,
                  color: Color(0xFF9C27B0),
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fase Pertumbuhan',
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
                      'Fase aktif tanaman saat ini',
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
          _buildPhaseCard(context),
          const SizedBox(height: 16),
          _buildProgressBars(context),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9C27B0).withValues(alpha: 0.1),
            const Color(0xFFE1BEE7).withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phase!.phaseName,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9C27B0),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${phase!.currentHst} HST',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            phase!.description,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBars(BuildContext context) {
    return Column(
      children: [
        _buildLinearProgress(
          context,
          label: 'Progress Waktu (HST)',
          current: '${phase!.currentHst}',
          total: '${phase!.endHst} Hari',
          percent: phase!.progressPercentage / 100,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        _buildLinearProgress(
          context,
          label: 'Progress GDD',
          current: phase!.currentGdd.toStringAsFixed(1),
          total: '${phase!.requiredGdd.toStringAsFixed(1)} °C',
          percent: phase!.gddProgressPercentage / 100,
          color: AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildLinearProgress(
    BuildContext context, {
    required String label,
    required String current,
    required String total,
    required double percent,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            Text(
              '$current / $total',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          lineHeight: 8.0,
          percent: percent.clamp(0.0, 1.0),
          backgroundColor: AppColors.divider,
          progressColor: color,
          barRadius: const Radius.circular(4),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.energy_savings_leaf_outlined,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Data fase pertumbuhan belum tersedia',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
