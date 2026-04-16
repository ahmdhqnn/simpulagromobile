import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
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
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: agroAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (agroData) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(agroDataProvider);
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
                        _SectionTitle('Kesehatan Lingkungan'),
                        SizedBox(height: context.rh(0.014)),
                        EnvironmentalHealthWidget(agroData: agroData),

                        SizedBox(height: context.rh(0.024)),

                        _SectionTitle('Vapor Pressure Deficit'),
                        SizedBox(height: context.rh(0.014)),
                        VdpWidget(vdpData: agroData.vdp),

                        SizedBox(height: context.rh(0.024)),

                        _SectionTitle('Growing Degree Days'),
                        SizedBox(height: context.rh(0.014)),
                        GddWidget(gddData: agroData.gdd),

                        SizedBox(height: context.rh(0.024)),

                        _SectionTitle('Evapotranspiration'),
                        SizedBox(height: context.rh(0.014)),
                        EtcWidget(etcData: agroData.etc),

                        SizedBox(height: context.rh(0.024)),

                        _SectionTitle('Informasi'),
                        SizedBox(height: context.rh(0.014)),
                        _buildInfoCard(context),

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
              onPressed: () => ref.invalidate(agroDataProvider),
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
                    onPressed: () => ref.invalidate(agroDataProvider),
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

  Widget _buildInfoCard(BuildContext context) {
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
              Text(
                'Tentang Agro Indicator',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            'VDP (Vapor Pressure Deficit)',
            'Mengukur defisit tekanan uap air. Nilai optimal: 0.4-1.2 kPa. '
                'VDP rendah (<0.4) meningkatkan risiko penyakit, VDP tinggi (>1.6) menyebabkan stress air.',
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            'GDD (Growing Degree Days)',
            'Akumulasi suhu yang diperlukan tanaman untuk tumbuh. '
                'Digunakan untuk memprediksi fase pertumbuhan dan waktu panen.',
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            'ETC (Evapotranspiration)',
            'Kebutuhan air tanaman berdasarkan evaporasi dan transpirasi. '
                'Membantu menentukan jadwal dan volume penyiraman yang optimal.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(12),
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(22),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1D1D1D),
        height: 1.0,
      ),
    );
  }
}
