import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/monitoring_provider.dart';
import '../tabs/analytics_tab.dart';
import '../tabs/history_tab.dart';
import '../tabs/maps_tab.dart';
import '../tabs/realtime_tab.dart';

class MonitoringScreen extends ConsumerStatefulWidget {
  const MonitoringScreen({super.key});

  @override
  ConsumerState<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends ConsumerState<MonitoringScreen> {
  int _selectedTabIndex = 0;

  static const _tabs = ['Realtime', 'History', 'Maps', 'Analytics'];

  static const _tabWidgets = [
    RealtimeTab(),
    HistoryTab(),
    MapsTab(),
    AnalyticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header dengan Title dan More Button
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
                    onPressed: () {
                      // Refresh semua data monitoring
                      ref.invalidate(latestReadsProvider);
                      ref.invalidate(todayReadsProvider);
                      ref.invalidate(logsProvider);
                      ref.invalidate(historyReadsProvider);
                      ref.invalidate(devicesProvider);
                      ref.invalidate(envHealthProvider);
                      ref.invalidate(plantRecommendationProvider);
                      ref.invalidate(dailyReadsProvider);
                      // Juga refresh site list
                      ref.invalidate(siteListProvider);
                    },
                    icon: Icons.more_horiz,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rw(0.054)),
              child: SizedBox(
                height: 38,
                child: Row(
                  children: [
                    for (int index = 0; index < _tabs.length; index++) ...[
                      Flexible(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedTabIndex = index),
                          child: Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedTabIndex == index
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                _tabs[index],
                                style: TextStyle(
                                  color: _selectedTabIndex == index
                                      ? Colors.black
                                      : Colors.black.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 1.83,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (index < _tabs.length - 1) const SizedBox(width: 2),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: context.rh(0.026)),

            Expanded(child: _tabWidgets[_selectedTabIndex]),
          ],
        ),
      ),
    );
  }
}
