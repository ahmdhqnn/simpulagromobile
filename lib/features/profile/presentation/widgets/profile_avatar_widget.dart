import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/user_profile.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final UserProfile profile;
  const ProfileAvatarWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 210,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          profile.userName.isNotEmpty
              ? profile.userName.substring(0, 1).toUpperCase()
              : 'U',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(80),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
