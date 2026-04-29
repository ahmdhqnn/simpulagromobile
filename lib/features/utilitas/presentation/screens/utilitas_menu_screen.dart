import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.015),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/chevron-left-icon.svg',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                  // Spacer kanan (simetris)
                  const SizedBox(width: 58),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
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

            SizedBox(height: context.rh(0.02)),
          ],
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
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/chevron-left-icon.svg',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 58),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(context.rw(0.061)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.block,
                        size: context.rw(0.164).clamp(48.0, 72.0),
                        color: AppColors.error,
                      ),
                      SizedBox(height: context.rh(0.02)),
                      Text(
                        'Akses Ditolak',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(18),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                      SizedBox(height: context.rh(0.01)),
                      Text(
                        'Fitur Utilitas hanya dapat diakses oleh Admin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: context.rh(0.03)),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'Kembali',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(16),
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
