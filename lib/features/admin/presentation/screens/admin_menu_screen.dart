import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/admin_menu_card.dart';
import '../widgets/admin_scaffold.dart';
import '../providers/permission_guard_provider.dart';

class AdminMenuScreen extends ConsumerWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    if (!isAdmin) {
      return const _ForbiddenScreen();
    }

    final menuItems = [
      AdminMenuItem(
        title: context.l10n.siteTitle,
        iconPath: 'assets/icons/maps-dot-outline-icon.svg',
        onTap: () => context.push('/admin/sites'),
        color: AppColors.teal,
      ),
      AdminMenuItem(
        title: context.l10n.plantTitle,
        iconPath: 'assets/icons/plant-outline-icon.svg',
        onTap: () => context.push('/admin/plants'),
        color: AppColors.success,
      ),
      AdminMenuItem(
        title: context.l10n.sensorTitle,
        iconPath: 'assets/icons/monitoring-outline-icon.svg',
        onTap: () => context.push('/admin/sensors'),
        color: AppColors.info,
      ),
      AdminMenuItem(
        title: context.l10n.deviceTitle,
        iconPath: 'assets/icons/device-outline-icon.svg',
        onTap: () => context.push('/admin/devices'),
        color: AppColors.temperature,
      ),
      AdminMenuItem(
        title: context.l10n.adminUnitTitle,
        iconPath: 'assets/icons/indicator-outline-icon.svg',
        onTap: () => context.push('/admin/units'),
        color: AppColors.phosphorus,
      ),
      AdminMenuItem(
        title: context.l10n.adminDeviceSensorTitle,
        iconPath: 'assets/icons/monitoring-filled-icon.svg',
        onTap: () => context.push('/admin/device-sensors'),
        color: AppColors.ph,
      ),
      AdminMenuItem(
        title: context.l10n.adminUsersTitle,
        iconPath: 'assets/icons/profile-outline-icon.svg',
        onTap: () => context.push('/admin/users'),
        color: AppColors.warning,
      ),
      AdminMenuItem(
        title: context.l10n.adminRoleTitle,
        iconPath: 'assets/icons/role-outline-icon.svg',
        onTap: () => context.push('/admin/roles'),
        color: AppColors.accent,
      ),
    ];

    return AdminScaffold(
      title: context.l10n.monitoringTabAdmin,
      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          0,
          context.rw(0.051),
          context.rh(0.02),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: context.rw(0.04),
          mainAxisSpacing: context.rw(0.04),
          childAspectRatio: 1.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) => AdminMenuCard(item: menuItems[index]),
      ),
    );
  }
}

class _ForbiddenScreen extends StatelessWidget {
  const _ForbiddenScreen();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: context.l10n.monitoringTabAdmin,
      body: AdminEmptyState(
        icon: Icons.block,
        title: context.l10n.adminAccessDeniedTitle,
        message: context.l10n.adminFeatureOnlyMessage,
      ),
    );
  }
}
