import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

class QuickActionsWidget extends ConsumerWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      const _QuickActionConfig(
        svgIcon: 'assets/icons/monitoring-outline-icon.svg',
        label: 'Monitoring',
        bgColor: Color(0xFFFFF6E9),
        iconColor: Color(0xFFFFA929),
        tabIndex: 1,
      ),
      const _QuickActionConfig(
        svgIcon: 'assets/icons/plant-outline-icon.svg',
        label: 'Tanaman',
        bgColor: Color(0xFFEDF7EE),
        iconColor: AppColors.success,
        tabIndex: 2,
      ),
      const _QuickActionConfig(
        svgIcon: 'assets/icons/check-task-outline-icon.svg',
        label: 'Task',
        bgColor: Color(0xFFE8EFE9),
        iconColor: AppColors.primary,
        tabIndex: 3,
      ),
      const _QuickActionConfig(
        svgIcon: 'assets/icons/forum-outline-icon.svg',
        label: 'Forum',
        bgColor: Color(0xFFECF6FE),
        iconColor: AppColors.info,
        tabIndex: 4,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(actions.length * 2 - 1, (index) {
          if (index.isOdd) {
            return SizedBox(width: context.rw(0.025));
          }

          final item = actions[index ~/ 2];
          return _QuickActionItem(
            svgIcon: item.svgIcon,
            label: item.label,
            bgColor: item.bgColor,
            iconColor: item.iconColor,
            onTap: () => ref.read(mainShellTabIndexProvider.notifier).state =
                item.tabIndex,
          );
        }),
      ),
    );
  }
}

class _QuickActionConfig {
  final String svgIcon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final int tabIndex;

  const _QuickActionConfig({
    required this.svgIcon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.tabIndex,
  });
}

class _QuickActionItem extends StatelessWidget {
  final String svgIcon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.svgIcon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemWidth =
        (context.sw - context.rw(0.051) * 2 - 24 - context.rw(0.025) * 3) / 4;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth.clamp(60.0, 90.0),
        height: itemWidth.clamp(60.0, 90.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(11),
                fontWeight: FontWeight.w500,
                color: iconColor,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
