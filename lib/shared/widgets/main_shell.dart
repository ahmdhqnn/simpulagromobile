import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simpulagromobile/core/providers/app_providers.dart';
import 'package:simpulagromobile/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:simpulagromobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:simpulagromobile/features/monitoring/presentation/providers/monitoring_provider.dart';
import 'package:simpulagromobile/features/monitoring/presentation/screens/monitoring_screen.dart';
import 'package:simpulagromobile/features/plant/presentation/screens/plant_screen.dart';
import 'package:simpulagromobile/features/task/presentation/screens/task_list_screen.dart';
import 'package:simpulagromobile/features/forum/presentation/screens/forum_screen.dart';
import 'package:simpulagromobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';
import 'package:simpulagromobile/shared/widgets/custom_bottom_navigation.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  DateTime? _lastResumedAt;

  static const _screens = [
    DashboardScreen(),
    MonitoringScreen(),
    PlantScreen(),
    TaskListScreen(),
    ForumScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (!ref.read(appAutoRefreshEnabledProvider)) return;

      final now = DateTime.now();
      final lastResumed = _lastResumedAt;
      final refreshInterval = ref.read(appRealtimeRefreshIntervalProvider);

      final shouldRefresh =
          lastResumed == null || now.difference(lastResumed) >= refreshInterval;

      if (shouldRefresh) {
        _refreshCurrentTabData();
      }
      _lastResumedAt = now;
    } else if (state == AppLifecycleState.paused) {
      _lastResumedAt = DateTime.now();
    }
  }

  void _refreshCurrentTabData() {
    if (!mounted) return;

    switch (_currentIndex) {
      case 0:
        ref.invalidate(siteListProvider);
        ref.invalidate(environmentalHealthProvider);
        ref.invalidate(deviceSummaryProvider);
        ref.invalidate(sensorSummaryProvider);
        ref.invalidate(plantSummaryProvider);
        ref.invalidate(latestSensorReadsProvider);
        break;
      case 1:
        ref.invalidate(latestReadsProvider);
        ref.invalidate(todayReadsProvider);
        ref.invalidate(envHealthProvider);
        ref.invalidate(dailyTodayProvider);
        ref.invalidate(monthlyReadsProvider);
        break;
      case 2:
        ref.invalidate(siteListProvider);
        break;
      case 3:
        break;
      case 4:
        ref.read(forumProvider.notifier).loadPosts(refresh: true);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
