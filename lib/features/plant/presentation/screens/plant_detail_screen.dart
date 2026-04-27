import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/plant_provider.dart';
import '../../../phase/presentation/screens/phase_list_screen.dart';
import '../../../phase/presentation/screens/gdd_tracking_screen.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsync = ref.watch(plantDetailProvider(plantId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: plantAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (plant) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(plantDetailProvider(plantId));
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
                        _buildHeaderCard(context, plant),
                        SizedBox(height: context.rh(0.024)),
                        _buildGrowthCard(context, plant),
                        SizedBox(height: context.rh(0.024)),
                        _buildInfoCard(context, plant),
                        SizedBox(height: context.rh(0.024)),
                        _buildActionButtons(context, plant),
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
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/chevron-left-icon.svg',
                width: 28,
                height: 28,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/more-icon.svg',
                width: 28,
                height: 28,
              ),
              onPressed: () {
                // Navigate to edit plant
              },
            ),
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
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1D1D),
                    ),
                  ),
                  SizedBox(height: context.rh(0.01)),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(14),
                      color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: context.rh(0.03)),
                  ElevatedButton(
                    onPressed: () =>
                        ref.invalidate(plantDetailProvider(plantId)),
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
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context, plant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              plant.plantType?.icon ?? '🌱',
              style: const TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.displayName,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plant.plantType?.displayName ?? 'Unknown',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: plant.isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    plant.statusText,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.bold,
                      color: plant.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context, plant) {
    final hst = plant.hst ?? 0;
    final phase = plant.growthPhase ?? 'Unknown';

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
          Text(
            'Pertumbuhan',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'HST',
                  '$hst',
                  'Hari Setelah Tanam',
                  Icons.calendar_today,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Fase',
                  phase,
                  'Fase Pertumbuhan',
                  Icons.eco,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, plant) {
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
          Text(
            'Informasi Tanaman',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(height: 16),
          if (plant.plantSpecies != null) ...[
            _buildInfoRow(
              context,
              Icons.science,
              'Spesies',
              plant.plantSpecies!,
            ),
            const SizedBox(height: 12),
          ],
          if (plant.plantDate != null) ...[
            _buildInfoRow(
              context,
              Icons.event,
              'Tanggal Tanam',
              _formatDate(plant.plantDate!),
            ),
            const SizedBox(height: 12),
          ],
          if (plant.plantHarvest != null)
            _buildInfoRow(
              context,
              Icons.agriculture,
              plant.isHarvested ? 'Tanggal Panen' : 'Target Panen',
              _formatDate(plant.plantHarvest!),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, plant) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhaseListScreen(
                    plantId: plant.plantId,
                    plantName: plant.displayName,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.timeline),
            label: Text(
              'Lihat Fase Pertumbuhan',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
        SizedBox(height: context.rh(0.014)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GddTrackingScreen(
                    plantId: plant.plantId,
                    plantName: plant.displayName,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.thermostat),
            label: Text(
              'GDD Tracking',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
        if (plant.isActive && !plant.isHarvested) ...[
          SizedBox(height: context.rh(0.014)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showHarvestDialog(context, plant),
              icon: const Icon(Icons.agriculture),
              label: Text(
                'Tandai Sudah Panen',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(10),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
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
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showHarvestDialog(BuildContext context, plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Konfirmasi Panen',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Tandai tanaman "${plant.displayName}" sudah dipanen?',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Implement harvest functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tanaman berhasil ditandai sudah panen',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(14),
                    ),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'Ya, Sudah Panen',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
