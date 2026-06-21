import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../task/presentation/providers/task_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_header_widget.dart';
import '../widgets/health_card_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/sensor_status_card.dart';
import '../widgets/site_selector_widget.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/task_overview_widget.dart';
import '../widgets/latest_sensor_reads_widget.dart';
import '../widgets/dashboard_daily_recap_card.dart';
import '../widgets/dashboard_recommendation_card.dart';
import '../../../notes/presentation/widgets/latest_notes_card_widget.dart';
import '../../../monitoring/presentation/providers/monitoring_provider.dart';
import '../../../notes/presentation/providers/notes_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_hub_provider.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _switchToMainTab(WidgetRef ref, int index) {
    ref.read(mainShellTabIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final sitesAsync = ref.watch(sitesProvider);
    final selectedSite = ref.watch(selectedSiteProvider);
    final healthAsync = ref.watch(environmentalHealthProvider);
    final dashboardSummaryAsync = ref.watch(dashboardSummaryProvider);
    final latestReadsAsync = ref.watch(latestSensorReadsProvider);
    final taskListAsync = ref.watch(taskListProvider);
    final taskStats = ref.watch(taskStatsProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);
    final isTaskStatsLoading =
        taskListAsync.isLoading && taskListAsync.valueOrNull == null;
    final horizontalPadding = context.rw(0.051);
    final sectionGap = context.rh(0.024);
    final contentGap = context.rh(0.012);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await runSpacedInvalidations([
              () => ref.invalidate(environmentalHealthProvider),
              () => ref.invalidate(dashboardSummaryProvider),
              () => ref.invalidate(latestSensorReadsProvider),
              () => ref.invalidate(sitesProvider),
              () => ref.invalidate(taskListProvider),
              () => ref.invalidate(latestNotesProvider),
              () => ref.invalidate(dailyTodayProvider),
            ]);
            await invalidateRecommendationHubDataSpaced(ref);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeaderWidget(
                  userName: authState.user?.userName ?? l10n.roleUser,
                  role: authState.isAdmin ? l10n.roleAdmin : l10n.roleUser,
                  onProfileTap: () => context.push('/profile'),
                ),
                SizedBox(height: sectionGap),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Site Selector
                      sitesAsync.when(
                        skipLoadingOnReload: true,
                        skipLoadingOnRefresh: true,
                        skipError: true,
                        data: (sites) {
                          return SiteSelectorWidget(
                            sites: sites,
                            selectedSite: selectedSite,
                            canSelectSite: authState.isAdmin,
                            onOpenDetail: selectedSite == null
                                ? null
                                : () => context.push(
                                    '/site/${selectedSite.siteId}',
                                  ),
                            onSiteSelected: (site) {
                              if (!authState.isAdmin) return;
                              ref
                                  .read(selectedSiteProvider.notifier)
                                  .selectSite(site);
                            },
                          );
                        },
                        loading: () => SiteSelectorSkeleton(
                          showSelector: authState.isAdmin,
                        ),
                        error: (e, _) => ErrorStateCardWidget(
                          message: l10n.errorLoadSite,
                          onRetry: () => ref.invalidate(sitesProvider),
                        ),
                      ),
                      SizedBox(height: sectionGap),

                      if (selectedSite == null)
                        InfoStateWidget.icon(
                          icon: Icons.agriculture_outlined,
                          message: l10n.emptySite,
                          height: 120,
                        )
                      else ...[
                        SectionHeaderWidget(title: l10n.healthSectionTitle),
                        SizedBox(height: contentGap),
                        healthAsync.when(
                          skipLoadingOnReload: true,
                          skipLoadingOnRefresh: true,
                          skipError: true,
                          data: (health) {
                            if (health == null) {
                              return InfoStateWidget.icon(
                                icon: Icons.inbox_outlined,
                                message: l10n.emptySite,
                                height: 100,
                              );
                            }
                            return HealthCardWidget(health: health);
                          },
                          loading: () => const HealthCardSkeleton(),
                          error: (e, _) => ErrorStateCardWidget(
                            message: l10n.errorLoadHealth,
                            onRetry: () =>
                                ref.invalidate(environmentalHealthProvider),
                          ),
                        ),
                        SizedBox(height: sectionGap),

                        SectionHeaderWidget(title: l10n.sensorSectionTitle),
                        SizedBox(height: contentGap),
                        healthAsync.when(
                          skipLoadingOnReload: true,
                          skipLoadingOnRefresh: true,
                          skipError: true,
                          data: (health) {
                            if (health == null || health.sensors.isEmpty) {
                              return InfoStateWidget.svg(
                                svgIconPath: 'assets/icons/sensor-icon.svg',
                                message: l10n.emptySensor,
                                height: 195,
                              );
                            }
                            return SensorStatusGrid(
                              sensors: health.sensors,
                              metadataAdapter: metadataAdapter,
                            );
                          },
                          loading: () => const SensorStatusGridSkeleton(),
                          error: (_, __) => InfoStateWidget.svg(
                            svgIconPath: 'assets/icons/sensor-icon.svg',
                            message: l10n.emptySensor,
                            height: 195,
                          ),
                        ),
                        SizedBox(height: sectionGap),

                        SectionHeaderWidget(
                          title: l10n.dashboardTodayDailyRecap,
                        ),
                        SizedBox(height: contentGap),
                        const DashboardDailyRecapCard(),
                        SizedBox(height: sectionGap),

                        SectionHeaderWidget(
                          title: l10n.dashboardLatestRecommendations,
                        ),
                        SizedBox(height: contentGap),
                        const DashboardRecommendationCard(),
                        SizedBox(height: sectionGap),

                        SectionHeaderWidget(
                          title: l10n.dashboardLatestActivity,
                        ),
                        SizedBox(height: contentGap),
                        latestReadsAsync.when(
                          skipLoadingOnReload: true,
                          skipLoadingOnRefresh: true,
                          skipError: true,
                          data: (reads) => LatestSensorReadsWidget(
                            reads: reads,
                            metadataAdapter: metadataAdapter,
                          ),
                          loading: () =>
                              const LatestSensorReadsSkeleton(rowCount: 5),
                          error: (_, __) => ErrorStateCardWidget(
                            message: l10n.dashboardActivityLoadFailed,
                            onRetry: () =>
                                ref.invalidate(latestSensorReadsProvider),
                          ),
                        ),
                        SizedBox(height: sectionGap),

                        SectionHeaderWidget(title: l10n.dashboardLatestNotes),
                        SizedBox(height: contentGap),
                        const LatestNotesCardWidget(),
                        SizedBox(height: sectionGap),

                        SectionHeaderWidget(title: l10n.summarySectionTitle),
                        SizedBox(height: contentGap),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if ((dashboardSummaryAsync.isLoading &&
                                    dashboardSummaryAsync.valueOrNull ==
                                        null) ||
                                isTaskStatsLoading) {
                              return SummaryGridSkeleton(
                                spacing: contentGap.clamp(8.0, 12.0),
                              );
                            }

                            final spacing = contentGap.clamp(8.0, 12.0);
                            final cardWidth =
                                (constraints.maxWidth - spacing) / 2;
                            final cardHeight = 90.0;

                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: cardWidth / cardHeight,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing,
                              children: [
                                SummaryCardWidget(
                                  title: l10n.deviceTitle,
                                  value: dashboardSummaryAsync.when(
                                    skipLoadingOnReload: true,
                                    skipLoadingOnRefresh: true,
                                    skipError: true,
                                    data: (s) =>
                                        s.deviceSummary?.total.toString() ??
                                        '-',
                                    loading: () => '...',
                                    error: (_, __) => '-',
                                  ),
                                  svgIcon:
                                      'assets/icons/device-outline-icon.svg',
                                  iconBgColor: AppColors.softGreenAlt,
                                  iconColor: AppColors.primary,
                                  onTap: () => _switchToMainTab(ref, 1),
                                ),
                                SummaryCardWidget(
                                  title: l10n.sensorTitle,
                                  value: dashboardSummaryAsync.when(
                                    skipLoadingOnReload: true,
                                    skipLoadingOnRefresh: true,
                                    skipError: true,
                                    data: (s) =>
                                        s.sensorSummary?.total.toString() ??
                                        '-',
                                    loading: () => '...',
                                    error: (_, __) => '-',
                                  ),
                                  svgIcon: 'assets/icons/sensor-icon.svg',
                                  iconBgColor: AppColors.softBlue,
                                  iconColor: AppColors.info,
                                  onTap: () => _switchToMainTab(ref, 1),
                                ),
                                SummaryCardWidget(
                                  title: l10n.plantTitle,
                                  value: dashboardSummaryAsync.when(
                                    skipLoadingOnReload: true,
                                    skipLoadingOnRefresh: true,
                                    skipError: true,
                                    data: (s) =>
                                        s.plantSummary?.active.toString() ??
                                        '-',
                                    loading: () => '...',
                                    error: (_, __) => '-',
                                  ),
                                  svgIcon:
                                      'assets/icons/plant-overview-outline-icon.svg',
                                  iconBgColor: AppColors.softGreen,
                                  iconColor: AppColors.success,
                                  onTap: () => _switchToMainTab(ref, 2),
                                ),
                                SummaryCardWidget(
                                  title: l10n.taskTitle,
                                  value: taskStats.total.toString(),
                                  svgIcon:
                                      'assets/icons/task-overview-outline-icon.svg',
                                  iconBgColor: AppColors.softOrange,
                                  iconColor: AppColors.warning,
                                  onTap: () {
                                    _switchToMainTab(ref, 3);
                                    ref.invalidate(taskListProvider);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: contentGap),

                        if (isTaskStatsLoading)
                          const TaskOverviewSkeleton()
                        else
                          TaskOverviewWidget(
                            totalTasks: taskStats.total,
                            completedTasks: taskStats.completed,
                          ),
                        SizedBox(height: sectionGap),

                        // Quick Actions
                        SectionHeaderWidget(
                          title: l10n.quickActionSectionTitle,
                        ),
                        SizedBox(height: contentGap),
                        const QuickActionsWidget(),
                      ],
                      SizedBox(height: bottomNavigationContentSpace(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
