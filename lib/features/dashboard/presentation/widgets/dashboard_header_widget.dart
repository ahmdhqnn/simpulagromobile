import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../notification/presentation/providers/notification_provider.dart';

class DashboardHeaderWidget extends ConsumerWidget {
  final String userName;
  final String role;
  final VoidCallback onProfileTap;

  const DashboardHeaderWidget({
    super.key,
    required this.userName,
    required this.role,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        children: [
          CircularBackButtonWidget(
            onPressed: onProfileTap,
            svgIconPath: 'assets/icons/user-outline-icon.svg',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dashboardWelcomeUser(userName),
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Badge(
            isLabelVisible: unreadCount > 0,
            label: Text(
              '$unreadCount',
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.error,
            offset: const Offset(-2, 2),
            child: CircularBackButtonWidget(
              onPressed: () => context.push('/notifications'),
              svgIconPath: 'assets/icons/message-outline-icon.svg',
            ),
          ),
        ],
      ),
    );
  }
}
