import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../domain/entities/recommendation.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../providers/recommendation_automation_provider.dart';
import '../providers/recommendation_provider.dart';

/// Shell rekomendasi otomatis: Live, History, By Phase.
class RecommendationTabsScreen extends ConsumerStatefulWidget {
  const RecommendationTabsScreen({super.key});

  @override
  ConsumerState<RecommendationTabsScreen> createState() =>
      _RecommendationTabsScreenState();
}

class _RecommendationTabsScreenState
    extends ConsumerState<RecommendationTabsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    triggerRecommendationAutomationRefresh(ref);
    ref.invalidate(recommendationAllProvider);
    ref.invalidate(recommendationHistoryProvider);
    ref.invalidate(recommendationByPhaseProvider);
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      Tab(text: context.l10n.recommendationAllTab),
      Tab(text: context.l10n.recommendationHistoryTab),
      Tab(text: context.l10n.recommendationByPhaseTab),
    ];

    final views = <Widget>[
      const _LiveTab(),
      const _HistoryTab(),
      const _ByPhaseTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refreshAll,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.015),
                ),
                child: Row(
                  children: [
                    CircularBackButtonWidget(
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        context.l10n.recommendationTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.sp(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CircularIconActionWidget(
                      onPressed: _refreshAll,
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                tabs: tabs,
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: views),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveTab extends ConsumerWidget {
  const _LiveTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(recommendationAllProvider);
    return listAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (list) => _RecommendationSimpleList(recommendations: list),
      loading: () => const RecommendationListSkeleton(),
      error: (e, _) => Center(child: Text(toUiErrorMessage(e, context.l10n))),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(recommendationHistoryProvider);
    return historyAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (list) => _RecommendationSimpleList(recommendations: list),
      loading: () => const RecommendationListSkeleton(),
      error: (e, _) => Center(child: Text(toUiErrorMessage(e, context.l10n))),
    );
  }
}

class _ByPhaseTab extends ConsumerWidget {
  const _ByPhaseTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phasesAsync = ref.watch(phasesForSelectedSiteProvider);
    final selectedPhase = ref.watch(selectedPhaseIdForRecProvider);
    final recAsync = ref.watch(recommendationByPhaseProvider);

    return Column(
      children: [
        phasesAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (phases) => Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: selectedPhase,
              decoration: InputDecoration(
                labelText: context.l10n.recommendationSelectPhase,
                border: OutlineInputBorder(),
              ),
              items: phases
                  .map(
                    (p) =>
                        DropdownMenuItem(value: p.id, child: Text(p.phaseName)),
                  )
                  .toList(),
              onChanged: (v) {
                ref.read(selectedPhaseIdForRecProvider.notifier).state = v;
                ref.invalidate(recommendationByPhaseProvider);
              },
            ),
          ),
          loading: () => const DropdownFieldSkeleton(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        Expanded(
          child: selectedPhase == null
              ? Center(child: Text(context.l10n.recommendationSelectPhaseFirst))
              : recAsync.when(
                  skipLoadingOnReload: true,
                  skipLoadingOnRefresh: true,
                  skipError: true,
                  data: (list) =>
                      _RecommendationSimpleList(recommendations: list),
                  loading: () => const RecommendationListSkeleton(),
                  error: (e, _) => Center(child: Text(toUiErrorMessage(e, context.l10n))),
                ),
        ),
      ],
    );
  }
}

class _RecommendationSimpleList extends StatelessWidget {
  final List<Recommendation> recommendations;

  const _RecommendationSimpleList({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return Center(child: Text(context.l10n.recommendationNoData));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recommendations.length,
      itemBuilder: (_, i) {
        final r = recommendations[i];
        final priorityColor = _priorityColor(r.priority);
        final statusColor = _statusColor(r.status);
        final createdAt = r.createdAt;
        final dateText = createdAt == null
            ? null
            : context.dateFormat('dd/MM/yyyy').format(createdAt);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _typeIcon(r.type),
                      size: 18,
                      color: priorityColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      r.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _pill(r.priority.localizedLabel(context.l10n), priorityColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                r.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _pill(r.status.localizedLabel(context.l10n), statusColor),
                  const SizedBox(width: 8),
                  _pill(r.type.localizedLabel(context.l10n), AppColors.info),
                  const Spacer(),
                  if (dateText != null)
                    Text(
                      dateText,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(11),
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  IconData _typeIcon(RecommendationType type) {
    switch (type) {
      case RecommendationType.npk:
        return Icons.grass_rounded;
      case RecommendationType.ph:
        return Icons.science_outlined;
      case RecommendationType.watering:
        return Icons.water_drop_outlined;
      case RecommendationType.pestControl:
        return Icons.bug_report_outlined;
      case RecommendationType.harvesting:
        return Icons.agriculture_outlined;
      case RecommendationType.planting:
        return Icons.eco_outlined;
      case RecommendationType.general:
        return Icons.lightbulb_outline_rounded;
    }
  }

  Color _priorityColor(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.low:
        return AppColors.success;
      case RecommendationPriority.medium:
        return AppColors.warning;
      case RecommendationPriority.high:
        return AppColors.error;
      case RecommendationPriority.critical:
        return AppColors.errorDark;
    }
  }

  Color _statusColor(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.pending:
        return AppColors.warning;
      case RecommendationStatus.applied:
        return AppColors.success;
      case RecommendationStatus.dismissed:
        return AppColors.textSecondary;
      case RecommendationStatus.expired:
        return AppColors.muted;
    }
  }
}
