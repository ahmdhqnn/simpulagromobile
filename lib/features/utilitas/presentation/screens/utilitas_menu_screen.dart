import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/utilitas_menu_card.dart';
import '../providers/permission_guard_provider.dart';

class UtilitasMenuScreen extends ConsumerWidget {
  const UtilitasMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    if (!isAdmin) {
      return const _ForbiddenScreen();
    }

    final menuItems = [
      UtilitasMenuItem(
        title: 'Tanaman',
        iconPath: 'assets/icons/plant-outline-icon.svg',
        onTap: () => context.push('/utilitas/plants'),
        color: const Color(0xFF4CAF50),
      ),
      UtilitasMenuItem(
        title: 'Sensor',
        iconPath: 'assets/icons/monitoring-outline-icon.svg',
        onTap: () => context.push('/utilitas/sensors'),
        color: const Color(0xFF42A5F5),
      ),
      UtilitasMenuItem(
        title: 'Device',
        iconPath: 'assets/icons/device-outline-icon.svg',
        onTap: () => context.push('/utilitas/devices'),
        color: const Color(0xFFFF7043),
      ),
      UtilitasMenuItem(
        title: 'Unit',
        iconPath: 'assets/icons/indicator-outline-icon.svg',
        onTap: () => context.push('/utilitas/units'),
        color: const Color(0xFFAB47BC),
      ),
      UtilitasMenuItem(
        title: 'Device Sensor',
        iconPath: 'assets/icons/monitoring-filled-icon.svg',
        onTap: () => context.push('/utilitas/device-sensors'),
        color: const Color(0xFF26C6DA),
      ),
      UtilitasMenuItem(
        title: 'Users',
        iconPath: 'assets/icons/profile-outline-icon.svg',
        onTap: () => context.push('/utilitas/users'),
        color: const Color(0xFFFFA726),
      ),
      UtilitasMenuItem(
        title: 'Role',
        iconPath: 'assets/icons/role-outline-icon.svg',
        onTap: () => context.push('/utilitas/roles'),
        color: const Color(0xFF66BB6A),
      ),
      UtilitasMenuItem(
        title: 'Permission',
        iconPath: 'assets/icons/permission-outline-icon.svg',
        onTap: () => context.push('/utilitas/permissions'),
        color: const Color(0xFFEF5350),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(title: const Text('Utilitas'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.rw(0.051)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: context.rw(0.04),
              mainAxisSpacing: context.rw(0.04),
              childAspectRatio: 1.0,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return UtilitasMenuCard(item: menuItems[index]);
            },
          ),
        ),
      ),
    );
  }
}

class _ForbiddenScreen extends StatelessWidget {
  const _ForbiddenScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akses Ditolak')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, size: 80, color: Colors.red[300]),
              const SizedBox(height: 24),
              Text(
                'Akses Ditolak',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fitur Utilitas hanya dapat diakses oleh Admin.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
