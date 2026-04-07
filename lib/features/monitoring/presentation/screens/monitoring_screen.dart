import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/responsive.dart';
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
            // Fixed Header dengan More Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.015),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/more-icon.svg',
                        width: 28,
                        height: 28,
                      ),
                      onPressed: () {
                        // TODO: Implement more menu
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Custom Pill-Style Tab Navigation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rw(0.054)),
              child: SizedBox(
                height: 38,
                child: Row(
                  children: [
                    for (int index = 0; index < _tabs.length; index++) ...[
                      Flexible(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = index),
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

            // Tab Content
            Expanded(child: _tabWidgets[_selectedTabIndex]),
          ],
        ),
      ),
    );
  }
}
