import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../domain/entities/agro_entity.dart';
import '../providers/agro_provider.dart';
import '../widgets/vdp_widget.dart';
import '../widgets/gdd_widget.dart';
import '../widgets/etc_widget.dart';
import '../widgets/environmental_health_widget.dart';
import '../widgets/agro_recommendation_widget.dart';
import '../widgets/agro_phase_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../phase/domain/entities/phase.dart';
import '../../../recommendation/domain/entities/recommendation.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_provider.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../../l10n/app_localizations.dart';

class AgroIndicatorScreen extends ConsumerWidget {
  const AgroIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);

    if (siteId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, ref),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      AppLocalizations.of(context)!.agroSelectSiteMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final agroAsync = ref.watch(agroDataProvider);
    final healthAsync = ref.watch(agroEnvironmentalHealthProvider);

    final phaseAsync = ref.watch(currentPhaseProvider(siteId));
    final recommendationsAsync = ref.watch(
      recommendationsBySiteProvider(siteId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: agroAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => _buildLoadingState(context, ref),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (agroData) => LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => _refreshAgroData(ref),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, ref),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.rw(0.051),
                          ),
                          child: _buildAgroSections(
                            context,
                            agroData,
                            healthAsync,
                            recommendationsAsync,
                            phaseAsync,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _refreshAgroData(WidgetRef ref) async {
    ref.invalidate(agroDataProvider);
    ref.invalidate(agroEnvironmentalHealthProvider);
    final sid = ref.read(selectedSiteIdProvider);
    if (sid != null) {
      ref.invalidate(currentPhaseProvider(sid));
      ref.invalidate(recommendationsBySiteProvider(sid));
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildAgroSections(
    BuildContext context,
    AgroEntity agroData,
    AsyncValue<AgroEnvironmentalHealthEntity> healthAsync,
    AsyncValue<List<Recommendation>> recommendationsAsync,
    AsyncValue<Phase?> phaseAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        recommendationsAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (recommendations) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeaderWidget(title: l10n.agroActionRecommendationTitle),
                SizedBox(height: context.rh(0.014)),
                AgroRecommendationWidget(recommendations: recommendations),
                SizedBox(height: context.rh(0.024)),
              ],
            );
          },
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeaderWidget(title: l10n.agroActionRecommendationTitle),
              SizedBox(height: context.rh(0.014)),
              const AgroRecommendationCardSkeleton(),
              SizedBox(height: context.rh(0.024)),
            ],
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),

        phaseAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (phase) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeaderWidget(title: l10n.agroPlantingPhaseTitle),
                SizedBox(height: context.rh(0.014)),
                AgroPhaseWidget(phase: phase),
                SizedBox(height: context.rh(0.024)),
              ],
            );
          },
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeaderWidget(title: l10n.agroPlantingPhaseTitle),
              SizedBox(height: context.rh(0.014)),
              const AgroPhaseCardSkeleton(),
              SizedBox(height: context.rh(0.024)),
            ],
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),

        SectionHeaderWidget(title: l10n.healthSectionTitle),
        SizedBox(height: context.rh(0.014)),
        healthAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          data: (health) =>
              EnvironmentalHealthWidget(agroData: agroData, healthData: health),
          loading: () => const AgroEnvironmentalHealthCardSkeleton(),
          error: (error, _) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: AppColors.error,
              ),
            ),
          ),
        ),

        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroVdpTitle),
        SizedBox(height: context.rh(0.014)),
        VdpWidget(vdpData: agroData.vdp),

        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroGddTitle),
        SizedBox(height: context.rh(0.014)),
        GddWidget(gddData: agroData.gdd),

        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroEtcTitle),
        SizedBox(height: context.rh(0.014)),
        EtcWidget(etcData: agroData.etc),

        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroInformationTitle),
        SizedBox(height: context.rh(0.014)),
        _buildInfoCard(context),

        SizedBox(height: context.rh(0.02)),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
                  child: _buildLoadingSections(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSections(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(title: l10n.agroActionRecommendationTitle),
        SizedBox(height: context.rh(0.014)),
        const AgroRecommendationCardSkeleton(),
        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroPlantingPhaseTitle),
        SizedBox(height: context.rh(0.014)),
        const AgroPhaseCardSkeleton(),
        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.healthSectionTitle),
        SizedBox(height: context.rh(0.014)),
        const AgroEnvironmentalHealthCardSkeleton(),
        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroVdpTitle),
        SizedBox(height: context.rh(0.014)),
        const AgroVdpCardSkeleton(),
        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroGddTitle),
        SizedBox(height: context.rh(0.014)),
        const AgroGddCardSkeleton(),
        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroEtcTitle),
        SizedBox(height: context.rh(0.014)),
        const AgroEtcCardSkeleton(),
        SizedBox(height: context.rh(0.024)),

        SectionHeaderWidget(title: l10n.agroInformationTitle),
        SizedBox(height: context.rh(0.014)),
        const AgroInfoCardSkeleton(),
        SizedBox(height: context.rh(0.02)),
      ],
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
            onPressed: () => _refreshAgroData(ref),
            svgIconPath: 'assets/icons/arrow-rotate-left.svg',
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
                    AppLocalizations.of(context)!.commonLoadFailed,
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
                    child: Text(
                      AppLocalizations.of(context)!.retry,
                      style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.agroAboutTitle,
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
          _buildInfoItem(context, l10n.agroVdpTitle, l10n.agroVdpDescription),
          const SizedBox(height: 12),
          _buildInfoItem(context, l10n.agroGddTitle, l10n.agroGddDescription),
          const SizedBox(height: 12),
          _buildInfoItem(context, l10n.agroEtcTitle, l10n.agroEtcDescription),
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
