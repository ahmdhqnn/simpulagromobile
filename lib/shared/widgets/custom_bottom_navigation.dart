import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class BottomNavItem extends StatelessWidget {
  final String iconPath;
  final String activeIconPath;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.iconPath,
    required this.activeIconPath,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            splashColor: AppColors.pill.withValues(alpha: 0.9),
            highlightColor: AppColors.pill.withValues(alpha: 0.75),
            hoverColor: AppColors.pill.withValues(alpha: 0.6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? AppColors.pill : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Center(
                child: SvgPicture.asset(
                  isActive ? activeIconPath : iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rw(0.051),
        0,
        context.rw(0.051),
        (bottomInset > 0 ? bottomInset + 14 : 24).toDouble(),
      ),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          // boxShadow: AppShadows.menu,
        ),
        child: Row(
          children: [
            _buildNavItem(
              index: 0,
              iconPath: 'assets/icons/home-outline-icon.svg',
              activeIconPath: 'assets/icons/home-filled-icon.svg',
            ),
            _buildNavItem(
              index: 1,
              iconPath: 'assets/icons/monitoring-outline-icon.svg',
              activeIconPath: 'assets/icons/monitoring-filled-icon.svg',
            ),
            _buildNavItem(
              index: 2,
              iconPath: 'assets/icons/plant-outline-icon.svg',
              activeIconPath: 'assets/icons/plant-filled-icon.svg',
            ),
            _buildNavItem(
              index: 3,
              iconPath: 'assets/icons/task-outline-icon.svg',
              activeIconPath: 'assets/icons/task-filled-icon.svg',
            ),
            _buildNavItem(
              index: 4,
              iconPath: 'assets/icons/forum-outline-icon.svg',
              activeIconPath: 'assets/icons/forum-filled-icon.svg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String activeIconPath,
  }) {
    final isActive = currentIndex == index;
    return Expanded(
      child: BottomNavItem(
        iconPath: iconPath,
        activeIconPath: activeIconPath,
        isActive: isActive,
        onTap: () => onTap(index),
      ),
    );
  }
}
