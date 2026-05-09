import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simpulagromobile/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:simpulagromobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:simpulagromobile/features/monitoring/presentation/screens/monitoring_screen.dart';
import 'package:simpulagromobile/features/plant/presentation/screens/plant_screen.dart';
import 'package:simpulagromobile/features/task/presentation/screens/task_list_screen.dart';
import 'package:simpulagromobile/features/forum/presentation/screens/forum_screen.dart';
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

    // Auto-select site pertama saat shell pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoSelectSite();
    });
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
      final now = DateTime.now();
      final lastResumed = _lastResumedAt;

      // Auto-reload jika app sudah di background lebih dari 5 menit
      if (lastResumed == null || now.difference(lastResumed).inMinutes >= 5) {
        _refreshCurrentTabData();
      }
      _lastResumedAt = now;
    } else if (state == AppLifecycleState.paused) {
      _lastResumedAt = DateTime.now();
    }
  }

  /// Auto-select site pertama jika belum ada yang dipilih
  Future<void> _autoSelectSite() async {
    final selectedSite = ref.read(selectedSiteProvider);
    if (selectedSite != null) return; // sudah ada

    try {
      final sites = await ref.read(siteListProvider.future);
      if (sites.isNotEmpty && mounted) {
        await ref.read(selectedSiteProvider.notifier).selectSite(sites.first);
      }
    } catch (_) {
      // Gagal load sites — biarkan user pilih manual
    }
  }

  /// Refresh data tab yang sedang aktif
  void _refreshCurrentTabData() {
    if (!mounted) return;

    switch (_currentIndex) {
      case 0: // Dashboard
        ref.invalidate(environmentalHealthProvider);
        ref.invalidate(deviceSummaryProvider);
        ref.invalidate(sensorSummaryProvider);
        ref.invalidate(plantSummaryProvider);
        ref.invalidate(latestSensorReadsProvider);
        break;
      case 1: // Monitoring — provider sudah autoDispose
        break;
      case 2: // Plant — provider sudah autoDispose
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen ke sites dan auto-select jika belum ada
    ref.listen(siteListProvider, (_, next) {
      next.whenData((sites) {
        ref.read(selectedSiteProvider.notifier).autoSelectFirstSite(sites);
      });
    });

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
