import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../domain/entities/user_profile.dart';

class ProfileAccountInfoWidget extends StatelessWidget {
  final UserProfile profile;
  const ProfileAccountInfoWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderWidget(title: 'Informasi Akun'),
          SizedBox(height: context.rh(0.014)),
          AppCardWidget(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  iconPath: 'assets/icons/mail-outline-icon.svg',
                  label: 'Email',
                  value: profile.userEmail ?? '-',
                ),
                const SizedBox(height: 3),
                _InfoRow(
                  iconPath: 'assets/icons/phone-outline-icon.svg',
                  label: 'Telepon',
                  value: profile.userPhone ?? '-',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _InfoRow({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? '-' : value;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                  height: 1.57,
                ),
              ),
            ],
          ),
          Text(displayValue, style: AppTextStyles.hint(context)),
        ],
      ),
    );
  }
}
