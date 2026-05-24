import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../site/presentation/providers/site_provider.dart';
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
  late final TabController _tabController;

  static const _tabs = [
    'Realtime',
    'Raw Reads',
    'Rekap Harian',
    'Rekap Bulan',
    'Maps',
    'Analytics',
    'Admin',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
    ref.invalidate(siteListProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
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
                    'Monitoring',
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
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
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
