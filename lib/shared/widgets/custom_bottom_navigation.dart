import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 64,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF7F7F7) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: SvgPicture.asset(
            isActive ? activeIconPath : iconPath,
            width: 24,
            height: 24,
            colorFilter: isActive
                ? const ColorFilter.mode(Color(0xFF1D1D1D), BlendMode.srcIn)
                : const ColorFilter.mode(Color(0xFF1D1D1D), BlendMode.srcIn),
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
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String activeIconPath,
  }) {
    final isActive = currentIndex == index;
    return BottomNavItem(
      iconPath: iconPath,
      activeIconPath: activeIconPath,
      isActive: isActive,
      onTap: () => onTap(index),
    );
  }
}
