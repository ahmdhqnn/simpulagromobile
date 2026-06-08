import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/phase_provider.dart';

class PhaseListScreen extends ConsumerWidget {
  final String plantId;
  final String plantName;

  const PhaseListScreen({
    super.key,
    required this.plantId,
    required this.plantName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phasesAsync = ref.watch(phaseListProvider(plantId));
    final statsAsync = ref.watch(phaseStatsProvider(plantId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: phasesAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => _buildLoadingState(context, ref, l10n),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (phases) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(phaseListProvider(plantId));
              ref.invalidate(phaseStatsProvider(plantId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildScrollablePage(
              context,
              ref,
              content: _buildPhaseListContent(
                context,
                ref,
                phases,
                statsAsync,
                l10n,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollablePage(
    BuildContext context,
    WidgetRef ref, {
    required Widget content,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: _scrollMinHeight(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  double _scrollMinHeight(BuildContext context) {
    final safeArea = context.screenPadding.top + context.screenPadding.bottom;
    return (context.sh - safeArea).clamp(0.0, double.infinity);
  }

  Widget _buildLoadingState(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return _buildScrollablePage(
      context,
      ref,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.phaseGrowthTitle,
            style: AppTextStyles.sectionTitle(context, context.sp(22)),
          ),
          const SizedBox(height: AppSpacing.md),
          const PhaseStatsCardSkeleton(),
          const SizedBox(height: AppSpacing.sm),
          buildListSkeleton(count: 5, type: 'phase', padding: EdgeInsets.zero),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildPhaseListContent(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> phases,
    AsyncValue<Map<String, dynamic>> statsAsync,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.phaseGrowthTitle,
          style: AppTextStyles.sectionTitle(context, context.sp(22)),
        ),
        const SizedBox(height: AppSpacing.md),
        statsAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (stats) => _buildStatsCard(context, stats, l10n),
          loading: () => const PhaseStatsCardSkeleton(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (phases.isEmpty)
          _buildEmptyState(context, ref, l10n)
        else
          ...phases.map(
            (phase) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _buildPhaseCard(context, phase, l10n),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
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
            onPressed: () {
              ref.invalidate(phaseListProvider(plantId));
              ref.invalidate(phaseStatsProvider(plantId));
            },
            svgIconPath: 'assets/icons/arrow-rotate-left.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    final l10n = AppLocalizations.of(context)!;

    return _buildScrollablePage(
      context,
      ref,
      content: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.sh * 0.68),
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
              l10n.errorLoadData,
              style: AppTextStyles.cardTitle(context, context.sp(18)),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.hint(context, size: context.sp(14)),
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(phaseListProvider(plantId));
                ref.invalidate(phaseStatsProvider(plantId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              child: Text(
                l10n.retry,
                style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    Map<String, dynamic> stats,
    AppLocalizations l10n,
  ) {
    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadgeWidget.icon(
                icon: Icons.timeline,
                background: AppColors.softGreen,
                tint: AppColors.primary,
                size: 50,
                iconSize: 20,
                radius: AppRadius.sm,
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.phaseOverallProgressTitle,
                      style: AppTextStyles.sectionTitle(
                        context,
                        context.sp(22),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.phaseOverallProgressSubtitle,
                      style: AppTextStyles.label(context, size: context.sp(12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: stats['overallProgress'],
            minHeight: 8,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                l10n.phaseStatusCompleted,
                '${stats['completed']}',
                AppColors.success,
              ),
              _buildStatItem(
                context,
                l10n.phaseStatusActive,
                '${stats['active']}',
                AppColors.primary,
              ),
              _buildStatItem(
                context,
                l10n.phaseStatusUpcoming,
                '${stats['upcoming']}',
                AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.metric(
            context,
            size: context.sp(24),
            weight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption(context, size: context.sp(12)),
        ),
      ],
    );
  }

  Widget _buildPhaseCard(
    BuildContext context,
    dynamic phase,
    AppLocalizations l10n,
  ) {
    Color statusColor;
    IconData statusIcon;

    switch (phase.status) {
      case 'completed':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case 'active':
        statusColor = AppColors.primary;
        statusIcon = Icons.play_circle;
        break;
      default:
        statusColor = AppColors.warning;
        statusIcon = Icons.schedule;
    }

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      onTap: () {
        context.push(
          '/phase/${Uri.encodeComponent(phase.id)}?siteId=${Uri.encodeQueryComponent(plantId)}',
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadgeWidget.icon(
                icon: statusIcon,
                background: statusColor.withValues(alpha: 0.1),
                tint: statusColor,
                size: 50,
                iconSize: 20,
                radius: AppRadius.sm,
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase.phaseName,
                      style: AppTextStyles.sectionTitle(
                        context,
                        context.sp(22),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _phaseStatusLabel(phase.status, l10n),
                      style: AppTextStyles.label(
                        context,
                        size: context.sp(12),
                        weight: FontWeight.w300,
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
            style: AppTextStyles.hint(context, size: context.sp(13)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  context,
                  l10n.phaseHstLabel,
                  '${phase.hstMin}-${phase.hstMax}',
                  Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoChip(
                  context,
                  l10n.phaseDurationLabel,
                  l10n.phaseDaysValue('${phase.phaseDuration}'),
                  Icons.timer,
                ),
              ),
            ],
          ),
          if (phase.isActive || phase.isCompleted) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: phase.progress,
                minHeight: 8,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.phaseProgressDone(
                phase.progressPercentage.toStringAsFixed(0),
              ),
              style: AppTextStyles.label(
                context,
                size: context.sp(12),
                weight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _phaseStatusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'completed':
        return l10n.phaseStatusCompleted;
      case 'active':
        return l10n.phaseStatusActive;
      default:
        return l10n.phaseStatusUpcoming;
    }
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return AppCardWidget(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rh(0.06),
        horizontal: context.rw(0.051),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco_outlined,
            size: context.rw(0.164).clamp(48.0, 64.0),
            color: AppColors.textPrimary.withValues(alpha: 0.25),
          ),
          SizedBox(height: context.rh(0.02)),
          Text(
            l10n.phaseEmptyTitle,
            style: AppTextStyles.cardTitle(context, context.sp(16)),
          ),
          SizedBox(height: context.rh(0.01)),
          Text(
            l10n.phaseEmptyMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.hint(
              context,
              size: context.sp(13),
              height: 1.5,
            ),
          ),
          SizedBox(height: context.rh(0.025)),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(phaseListProvider(plantId));
              ref.invalidate(phaseStatsProvider(plantId));
            },
            icon: SvgPicture.asset(
              'assets/icons/arrow-rotate-left.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.surface,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              l10n.phaseReload,
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppColors.textPrimary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.hint(context, size: context.sp(11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.label(
              context,
              size: context.sp(13),
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
