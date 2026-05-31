import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
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

  void _refreshAll() {
    ref.invalidate(latestReadsProvider);
    ref.invalidate(todayReadsProvider);
    ref.invalidate(historyReadsProvider);
    ref.invalidate(devicesProvider);
    ref.invalidate(envHealthProvider);
    ref.invalidate(plantRecommendationProvider);
    ref.invalidate(dailyReadsProvider);
    ref.invalidate(dailyTodayProvider);
    ref.invalidate(dailyByDayProvider);
    ref.invalidate(monthlyReadsProvider);
    ref.invalidate(ongoingPlantProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final syncStatus = ref.watch(monitoringSyncStatusProvider);
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.015),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.monitoringTitle,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(28),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  CircularIconActionWidget(
                    onPressed: _refreshAll,
                    icon: Icons.refresh,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rw(0.051),
                0,
                context.rw(0.051),
                context.rh(0.012),
              ),
              child: _MonitoringSyncStatusBar(status: syncStatus),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: tabs.map((t) => Tab(text: t)).toList(),
            ),
            SizedBox(height: context.rh(0.01)),
            Expanded(
              child: TabBarView(
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
          ],
        ),
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
        border: Border.all(color: color.withValues(alpha: 0.18)),
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
          Text(
            subtitle,
            style: AppTextStyles.caption(
              context,
              size: 10,
              color: AppColors.textSecondary,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
