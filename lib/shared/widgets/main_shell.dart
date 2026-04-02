import 'package:flutter/material.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:simpulagromobile/features/monitoring/presentation/screens/monitoring_screen.dart';
import 'package:simpulagromobile/features/plant/presentation/screens/plant_screen.dart';
import 'package:simpulagromobile/features/task/presentation/screens/task_list_screen.dart';
import 'package:simpulagromobile/shared/widgets/custom_bottom_navigation.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    MonitoringScreen(),
    PlantScreen(),
    TaskListScreen(),
    _PlaceholderScreen(title: 'Forum'),
  ];

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

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: AppColors.primary),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
