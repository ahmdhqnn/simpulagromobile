import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/phase_provider.dart';

class PhaseDetailScreen extends ConsumerWidget {
  final String phaseId;
  final String? siteId;

  const PhaseDetailScreen({super.key, required this.phaseId, this.siteId});

  PhaseDetailRequest get _detailRequest => (phaseId: phaseId, siteId: siteId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phaseAsync = ref.watch(enrichedPhaseDetailProvider(_detailRequest));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: phaseAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => _buildLoadingState(context, ref),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (phase) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              _refreshPhaseDetail(ref);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildScrollablePage(
              context,
              ref,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xs),
                  _buildHeaderCard(context, phase),
                  const SizedBox(height: AppSpacing.sm),
                  _buildProgressCard(context, phase),
                  const SizedBox(height: AppSpacing.sm),
                  _buildHstCard(context, phase),
                  const SizedBox(height: AppSpacing.lg),
                ],
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

  Widget _buildLoadingState(BuildContext context, WidgetRef ref) {
    return _buildScrollablePage(
      context,
      ref,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const PhaseDetailCardsSkeleton()],
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
            onPressed: () => _refreshPhaseDetail(ref),
            svgIconPath: 'assets/icons/arrow-rotate-left.svg',
          ),
        ],
      ),
    );
  }

  void _refreshPhaseDetail(WidgetRef ref) {
    final currentSiteId = siteId?.trim();
    if (currentSiteId != null && currentSiteId.isNotEmpty) {
      ref.invalidate(phaseListProvider(currentSiteId));
    }
    ref.invalidate(enrichedPhaseDetailProvider(_detailRequest));
    ref.invalidate(phaseDetailProvider(phaseId));
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
              onPressed: () => _refreshPhaseDetail(ref),
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

  Widget _buildHeaderCard(BuildContext context, phase) {
    final l10n = AppLocalizations.of(context)!;
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
                      l10n.phaseGrowthTitle,
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
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, phase) {
    final l10n = AppLocalizations.of(context)!;

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadgeWidget.icon(
                icon: Icons.trending_up,
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
                      l10n.phaseDetailProgressTitle,
                      style: AppTextStyles.sectionTitle(
                        context,
                        context.sp(22),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.phaseDetailProgressSubtitle,
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
            l10n.phaseProgressDone(phase.progressPercentage.toStringAsFixed(1)),
            style: AppTextStyles.metric(
              context,
              size: context.sp(24),
              weight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  l10n.phaseCurrentHstLabel,
                  '${phase.currentHst}',
                  Icons.today,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  l10n.phaseDurationLabel,
                  l10n.phaseDaysValue('${phase.phaseDuration}'),
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
                    l10n.phaseRemainingDaysLabel,
                    l10n.phaseDaysValue('${phase.remainingDays}'),
                    Icons.event_available,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    l10n.phaseTargetHstLabel,
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
    final l10n = AppLocalizations.of(context)!;

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadgeWidget.icon(
                icon: Icons.event,
                background: AppColors.softBlue,
                tint: AppColors.info,
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
                      l10n.phaseHstRangeTitle,
                      style: AppTextStyles.sectionTitle(
                        context,
                        context.sp(22),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.phaseHstRangeSubtitle,
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
          const SizedBox(height: 20),
          _buildTimelineItem(
            context,
            l10n.phaseTimelineStartLabel,
            '${l10n.phaseHstLabel} ${phase.hstMin}',
            l10n.phaseTimelineStartSubtitle,
            AppColors.success,
          ),
          const SizedBox(height: 16),
          _buildTimelineItem(
            context,
            l10n.phaseTimelineEndLabel,
            '${l10n.phaseHstLabel} ${phase.hstMax}',
            phase.isActive
                ? l10n.phaseDaysRemaining('${phase.remainingDays}')
                : phase.isCompleted
                ? l10n.phaseTimelineCompleted
                : l10n.phaseTimelineNotStarted,
            phase.isCompleted ? AppColors.success : AppColors.primary,
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
                style: AppTextStyles.hint(context, size: context.sp(12)),
              ),
              Text(
                value,
                style: AppTextStyles.label(
                  context,
                  size: context.sp(14),
                  weight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.hint(context, size: context.sp(12)),
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
        Icon(icon, color: AppColors.textPrimary.withValues(alpha: 0.6)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.hint(context, size: context.sp(12)),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.label(
            context,
            size: context.sp(16),
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
