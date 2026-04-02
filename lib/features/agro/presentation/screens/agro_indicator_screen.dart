import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/agro_provider.dart';
import '../widgets/vdp_widget.dart';
import '../widgets/gdd_widget.dart';
import '../widgets/etc_widget.dart';
import '../widgets/environmental_health_widget.dart';

class AgroIndicatorScreen extends ConsumerWidget {
  const AgroIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agroAsync = ref.watch(agroDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agro Indicator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(agroDataProvider),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: agroAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, ref, error),
        data: (agroData) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(agroDataProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Environmental Health Dashboard
                EnvironmentalHealthWidget(agroData: agroData),
                const SizedBox(height: 16),

                // VDP Widget
                VdpWidget(vdpData: agroData.vdp),
                const SizedBox(height: 16),

                // GDD Widget
                GddWidget(gddData: agroData.gdd),
                const SizedBox(height: 16),

                // ETC Widget
                EtcWidget(etcData: agroData.etc),
                const SizedBox(height: 16),

                // Info Card
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(agroDataProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tentang Agro Indicator',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'VDP (Vapor Pressure Deficit)',
              'Mengukur defisit tekanan uap air. Nilai optimal: 0.4-1.2 kPa. '
                  'VDP rendah (<0.4) meningkatkan risiko penyakit, VDP tinggi (>1.6) menyebabkan stress air.',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'GDD (Growing Degree Days)',
              'Akumulasi suhu yang diperlukan tanaman untuk tumbuh. '
                  'Digunakan untuk memprediksi fase pertumbuhan dan waktu panen.',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'ETC (Evapotranspiration)',
              'Kebutuhan air tanaman berdasarkan evaporasi dan transpirasi. '
                  'Membantu menentukan jadwal dan volume penyiraman yang optimal.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
