import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../plant/presentation/providers/plant_provider.dart';
import '../providers/monitoring_provider.dart';
import '../tabs/admin_read_tab.dart';
import '../tabs/analytics_tab.dart';
import '../tabs/daily_recap_tab.dart';
import '../tabs/history_tab.dart';
import '../tabs/maps_tab.dart';
import '../tabs/monthly_recap_tab.dart';
import '../tabs/realtime_tab.dart';

class MonitoringScreen extends ConsumerStatefulWidget {
  const MonitoringScreen({super.key});

  @override
  ConsumerState<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends ConsumerState<MonitoringScreen>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 7;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshCurrentTab() async {
    switch (_tabController.index) {
      case 0:
        await runSpacedInvalidations([
          () => ref.invalidate(latestReadsProvider),
          () => ref.invalidate(todayReadsProvider),
          () => ref.invalidate(envHealthProvider),
          () => ref.invalidate(deviceSensorThresholdValuesProvider),
          () => ref.invalidate(ongoingPlantProvider),
        ]);
        break;
      case 1:
        await runSpacedInvalidations([
          () => ref.invalidate(historyReadsProvider),
          () => ref.invalidate(deviceSensorThresholdValuesProvider),
        ]);
        break;
      case 2:
        await runSpacedInvalidations([
          () => ref.invalidate(dailyTodayProvider),
          () => ref.invalidate(dailyByDayProvider),
        ]);
        break;
      case 3:
        await runSpacedInvalidations([
          () => ref.invalidate(monthlyReadsProvider),
          () => ref.invalidate(deviceSensorThresholdValuesProvider),
        ]);
        break;
      case 4:
        await runSpacedInvalidations([
          () => ref.invalidate(devicesProvider),
          () => ref.invalidate(monitoringSensorCountProvider),
        ]);
        break;
      case 5:
        await runSpacedInvalidations([
          () => ref.invalidate(envHealthProvider),
          () => ref.invalidate(plantRecommendationProvider),
          () => ref.invalidate(dailyReadsProvider),
          () => ref.invalidate(devicesProvider),
          () => ref.invalidate(monitoringSensorCountProvider),
          () => ref.invalidate(monthlyReadsProvider),
          () => ref.invalidate(deviceSensorThresholdValuesProvider),
          () => ref.invalidate(ongoingPlantProvider),
        ]);
        break;
      case 6:
        await runSpacedInvalidations([
          () => ref.invalidate(historyReadsProvider),
          () => ref.invalidate(dailyTodayProvider),
          () => ref.invalidate(dailyByDayProvider),
          () => ref.invalidate(dailyReadsProvider),
        ]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final syncStatus = ref.watch(monitoringSyncStatusProvider);
    final hPad = context.rw(0.051);
    final tabs = [
      l10n.monitoringTabRealtime,
      l10n.monitoringTabRawReads,
      l10n.monitoringTabDailyRecap,
      l10n.monitoringTabMonthlyRecap,
      l10n.monitoringTabMaps,
      l10n.monitoringTabAnalytics,
      l10n.monitoringTabAdmin,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      context.rh(0.015),
                      hPad,
                      0,
                    ),
                    child: Row(
                      children: [const Spacer(), _buildRefreshButton(context)],
                    ),
                  ),
                  SizedBox(height: context.rh(0.024)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: _MonitoringSyncStatusBar(status: syncStatus),
                  ),
                  SizedBox(height: context.rh(0.012)),
                  _buildTabChips(context, tabs, hPad),
                  SizedBox(height: context.rh(0.012)),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: const [
              RealtimeTab(),
              HistoryTab(),
              DailyRecapTab(),
              MonthlyRecapTab(),
              MapsTab(),
              AnalyticsTab(),
              AdminReadTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(29),
      ),
      child: IconButton(
        tooltip: l10n.monitoringRefreshActiveTab,
        onPressed: () {
          unawaited(_refreshCurrentTab());
        },
        icon: SvgPicture.asset(
          'assets/icons/arrow-rotate-left.svg',
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            AppColors.textPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildTabChips(
    BuildContext context,
    List<String> tabs,
    double horizontalInset,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: AnimatedBuilder(
        animation: _tabController.animation ?? _tabController,
        builder: (context, _) {
          var selectedIndex =
              (_tabController.animation?.value ??
                      _tabController.index.toDouble())
                  .round();
          if (selectedIndex < 0) selectedIndex = 0;
          if (selectedIndex >= tabs.length) selectedIndex = tabs.length - 1;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalInset),
            itemCount: tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 2),
            itemBuilder: (context, index) {
              final selected = index == selectedIndex;
              return GestureDetector(
                onTap: () => _tabController.animateTo(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w400,
                        height: 1.83,
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textPrimary.withValues(alpha: 0.50),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MonitoringSyncStatusBar extends StatelessWidget {
  const _MonitoringSyncStatusBar({required this.status});

  final MonitoringSyncStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stale = status.isStale;
    final enabled = status.autoRefreshEnabled;
    final color = stale
        ? AppColors.warning
        : enabled
        ? AppColors.primary
        : AppColors.textSecondary;
    final icon = stale
        ? Icons.sync_problem_rounded
        : enabled
        ? Icons.cloud_done_outlined
        : Icons.cloud_off_outlined;
    final title = status.lastUpdated == null
        ? l10n.monitoringSyncWaiting
        : l10n.monitoringSyncAt(
            context.dateFormat('HH:mm:ss').format(status.lastUpdated!),
          );
    final subtitle = enabled
        ? l10n.monitoringAutoRefreshEvery(status.refreshInterval.inSeconds)
        : l10n.monitoringAutoRefreshOff;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              stale ? '$title - ${l10n.monitoringSyncStale}' : title,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption(
                context,
                size: 11,
                color: AppColors.textPrimary,
                weight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.rw(0.34)),
            child: Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption(
                context,
                size: 10,
                color: AppColors.textSecondary,
                weight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
