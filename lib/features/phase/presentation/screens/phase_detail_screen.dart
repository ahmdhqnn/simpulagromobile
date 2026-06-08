import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/phase_provider.dart';

class PhaseDetailScreen extends ConsumerWidget {
  final String phaseId;

  const PhaseDetailScreen({super.key, required this.phaseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phaseAsync = ref.watch(phaseDetailProvider(phaseId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: phaseAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => Column(
            children: [
              _buildHeader(context, ref),
              const Expanded(child: PhaseDetailContentSkeleton()),
            ],
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (phase) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(phaseDetailProvider(phaseId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              children: [
                _buildHeader(context, ref),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rw(0.051),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.rh(0.01)),
                        _buildHeaderCard(context, phase),
                        SizedBox(height: context.rh(0.024)),
                        _buildProgressCard(context, phase),
                        SizedBox(height: context.rh(0.024)),
                        _buildHstCard(context, phase),
                        SizedBox(height: context.rh(0.02)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          CircularIconActionWidget(
            onPressed: () => ref.invalidate(phaseDetailProvider(phaseId)),
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Column(
      children: [
        _buildHeader(context, ref),
        Expanded(
          child: Center(
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
                    'Gagal memuat data',
                    style: AppTextStyles.cardTitle(context, 18),
                  ),
                  SizedBox(height: context.rh(0.01)),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.hint(context, size: 14),
                  ),
                  SizedBox(height: context.rh(0.03)),
                  ElevatedButton(
                    onPressed: () =>
                        ref.invalidate(phaseDetailProvider(phaseId)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(fontFamily: AppTextStyles.fontFamily),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context, phase) {
    Color statusColor;
    IconData statusIcon;

    switch (phase.status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'active':
        statusColor = AppColors.primary;
        statusIcon = Icons.play_circle;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
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
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase.phaseName,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    // cropType menggantikan plantName yang tidak ada di API
                    Text(
                      phase.cropType,
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
          const SizedBox(height: 12),
          Text(
            phase.description,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, phase) {
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Fase',
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
                      'Phase Progress Tracking',
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
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: phase.progress,
              minHeight: 12,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${phase.progressPercentage.toStringAsFixed(1)}% selesai',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(24),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'HST Saat Ini',
                  '${phase.currentHst}',
                  Icons.today,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Durasi Fase',
                  '${phase.phaseDuration} hari',
                  Icons.timer,
                ),
              ),
            ],
          ),
          if (phase.isActive) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Sisa Hari',
                    '${phase.remainingDays} hari',
                    Icons.event_available,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Target HST',
                    '${phase.hstMax}',
                    Icons.flag,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHstCard(BuildContext context, phase) {
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
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.event, color: AppColors.info, size: 20),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rentang HST',
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
                      'Hari Setelah Tanam',
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
          _buildTimelineItem(
            context,
            'Mulai',
            'HST ${phase.hstMin}',
            'Awal fase',
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildTimelineItem(
            context,
            'Selesai',
            'HST ${phase.hstMax}',
            phase.isActive
                ? '~${phase.remainingDays} hari lagi'
                : phase.isCompleted
                ? 'Sudah selesai'
                : 'Belum dimulai',
            phase.isCompleted ? Colors.green : AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String label,
    String value,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1D1D1D).withValues(alpha: 0.6)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(12),
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(16),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1D1D),
          ),
        ),
      ],
    );
  }
}
