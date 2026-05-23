import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
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
import '../../../../l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final sitesAsync = ref.watch(sitesProvider);
    final selectedSite = ref.watch(selectedSiteProvider);
    final healthAsync = ref.watch(environmentalHealthProvider);
    final deviceSummaryAsync = ref.watch(deviceSummaryProvider);
    final sensorSummaryAsync = ref.watch(sensorSummaryProvider);
    final plantSummaryAsync = ref.watch(plantSummaryProvider);
    final latestReadsAsync = ref.watch(latestSensorReadsProvider);
    final taskStats = ref.watch(taskStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(environmentalHealthProvider);
            ref.invalidate(deviceSummaryProvider);
            ref.invalidate(sensorSummaryProvider);
            ref.invalidate(plantSummaryProvider);
            ref.invalidate(latestSensorReadsProvider);
            ref.invalidate(sitesProvider);
            ref.invalidate(taskListProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeaderWidget(
                  userName: authState.user?.userName ?? 'User',
                  role: authState.isAdmin ? 'Admin' : 'User',
                  onProfileTap: () => context.push('/profile'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Site Selector
                      sitesAsync.when(
                        data: (sites) {
                          return SiteSelectorWidget(
                            sites: sites,
                            selectedSite: selectedSite,
                            onSiteSelected: (site) => ref
                                .read(selectedSiteProvider.notifier)
                                .selectSite(site),
                          );
                        },
                        loading: () => LoadingCardWidget(
                          height: context.rh(0.07).clamp(52.0, 72.0),
                        ),
                        error: (e, _) => ErrorStateCardWidget(
                          message: l10n.errorLoadSite,
                          onRetry: () => ref.invalidate(sitesProvider),
                        ),
                      ),
                      SizedBox(height: context.rh(0.024)),

                      SectionHeaderWidget(title: l10n.healthSectionTitle),
                      SizedBox(height: context.rh(0.014)),
                      healthAsync.when(
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
                        loading: () => LoadingCardWidget(
                          height: context.rh(0.3).clamp(220.0, 280.0),
                        ),
                        error: (e, _) => ErrorStateCardWidget(
                          message: l10n.errorLoadHealth,
                          onRetry: () =>
                              ref.invalidate(environmentalHealthProvider),
                        ),
                      ),
                      SizedBox(height: context.rh(0.024)),

                      SectionHeaderWidget(title: l10n.sensorSectionTitle),
                      SizedBox(height: context.rh(0.014)),
                      healthAsync.when(
                        data: (health) {
                          if (health == null || health.sensors.isEmpty) {
                            return InfoStateWidget.svg(
                              svgIconPath: 'assets/icons/sensor-icon.svg',
                              message: l10n.emptySensor,
                              height: 195,
                            );
                          }
                          return SensorStatusGrid(sensors: health.sensors);
                        },
                        loading: () => LoadingCardWidget(
                          height: context.rh(0.25).clamp(180.0, 240.0),
                        ),
                        error: (_, __) => InfoStateWidget.svg(
                          svgIconPath: 'assets/icons/sensor-icon.svg',
                          message: l10n.emptySensor,
                          height: 195,
                        ),
                      ),
                      SizedBox(height: context.rh(0.024)),

                      const SectionHeaderWidget(title: 'Aktivitas Terbaru'),
                      SizedBox(height: context.rh(0.014)),
                      latestReadsAsync.when(
                        data: (reads) => LatestSensorReadsWidget(reads: reads),
                        loading: () => LoadingCardWidget(
                          height: context.rh(0.2).clamp(120.0, 180.0),
                        ),
                        error: (_, __) => ErrorStateCardWidget(
                          message: 'Gagal memuat aktivitas',
                          onRetry: () => ref.invalidate(latestSensorReadsProvider),
                        ),
                      ),
                      SizedBox(height: context.rh(0.024)),

                      SectionHeaderWidget(title: l10n.summarySectionTitle),
                      SizedBox(height: context.rh(0.014)),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1.6,
                        crossAxisSpacing: context.rw(0.025),
                        mainAxisSpacing: context.rw(0.025),
                        children: [
                          SummaryCardWidget(
                            title: l10n.deviceTitle,
                            value: deviceSummaryAsync.when(
                              data: (d) => d?.total.toString() ?? '0',
                              loading: () => '...',
                              error: (_, __) => '-',
                            ),
                            svgIcon: 'assets/icons/device-outline-icon.svg',
                            iconBgColor: AppColors.softGreenAlt,
                            iconColor: AppColors.primary,
                            onTap: () {},
                          ),
                          SummaryCardWidget(
                            title: l10n.sensorTitle,
                            value: sensorSummaryAsync.when(
                              data: (s) => s?.total.toString() ?? '0',
                              loading: () => '...',
                              error: (_, __) => '-',
                            ),
                            svgIcon: 'assets/icons/sensor-icon.svg',
                            iconBgColor: AppColors.softBlue,
                            iconColor: AppColors.info,
                            onTap: () {},
                          ),
                          SummaryCardWidget(
                            title: l10n.plantTitle,
                            value: plantSummaryAsync.when(
                              data: (p) => p?.active.toString() ?? '0',
                              loading: () => '...',
                              error: (_, __) => '-',
                            ),
                            svgIcon: 'assets/icons/plant-outline-icon.svg',
                            iconBgColor: AppColors.softGreen,
                            iconColor: AppColors.success,
                            onTap: () {},
                          ),
                          SummaryCardWidget(
                            title: l10n.taskTitle,
                            value: taskStats.total.toString(),
                            svgIcon: 'assets/icons/check-task-outline-icon.svg',
                            iconBgColor: AppColors.softOrange,
                            iconColor: AppColors.warning,
                            onTap: () async {
                              await context.push('/tasks');
                              ref.invalidate(taskListProvider);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: context.rh(0.024)),

                      SectionHeaderWidget(title: l10n.taskSummarySectionTitle),
                      SizedBox(height: context.rh(0.014)),
                      TaskOverviewWidget(
                        totalTasks: taskStats.total,
                        completedTasks: taskStats.completed,
                      ),
                      SizedBox(height: context.rh(0.024)),

                      // Quick Actions
                      SectionHeaderWidget(title: l10n.quickActionSectionTitle),
                      SizedBox(height: context.rh(0.014)),
                      const QuickActionsWidget(),
                      SizedBox(height: context.rh(0.04)),
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
