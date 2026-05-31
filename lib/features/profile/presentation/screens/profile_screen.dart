// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_account_info_widget.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_forum_card_widget.dart';
import '../widgets/profile_permissions_card_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final permissionsAsync = ref.watch(userPermissionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(userProfileProvider);
              ref.invalidate(userPermissionsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: context.rh(0.022)),
                  _buildHeader(context, ref),
                  SizedBox(height: context.rh(0.022)),
                  ProfileAvatarWidget(profile: profile),
                  SizedBox(height: context.rh(0.024)),
                  _buildUserInfo(context, profile),
                  SizedBox(height: context.rh(0.024)),
                  ProfileAccountInfoWidget(profile: profile),
                  SizedBox(height: context.rh(0.024)),
                  _buildAdminSection(context, ref),
                  SizedBox(height: context.rh(0.024)),
                  _buildForumSection(context),
                  SizedBox(height: context.rh(0.024)),
                  _buildPermissionsSection(context, permissionsAsync),
                  SizedBox(height: context.rh(0.024)),
                  _buildSignoutButton(context, ref),
                  SizedBox(height: context.rh(0.04)),
                ],
              ),
            ),
          ),
          loading: () => Column(
            children: [
              SizedBox(height: context.rh(0.022)),
              _buildHeader(context, ref),
              const Expanded(
                child: DetailScreenSkeleton(infoRowCount: 4, hasDescription: false, headerHeight: 150),
              ),
            ],
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(userProfileProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          CircularIconActionWidget(
            onPressed: () => context.push('/settings'),
            icon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserProfile profile) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.softBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            profile.roleName ?? 'User',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.info,
              height: 1.83,
            ),
          ),
        ),
        SizedBox(height: context.rh(0.004)),
        Text(profile.userName, style: AppTextStyles.sectionTitle(context)),
      ],
    );
  }

  Widget _buildAdminSection(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    if (!authState.isAdmin) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderWidget(title: 'Admin'),
          SizedBox(height: context.rh(0.014)),
          InkWell(
            onTap: () => context.push('/admin'),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7043).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/setting-outline-icon.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF7043),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: context.rw(0.02)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w300,
                            color: AppColors.textPrimary,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Kelola data dan akses sistem',
                          style: AppTextStyles.hint(context),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/chevron-right-icon.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderWidget(title: 'Forum'),
          SizedBox(height: context.rh(0.014)),
          const ProfileForumCardWidget(),
        ],
      ),
    );
  }

  Widget _buildPermissionsSection(
    BuildContext context,
    AsyncValue<List<String>> permissionsAsync,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderWidget(title: 'Hak Akses'),
          SizedBox(height: context.rh(0.014)),
          ProfilePermissionsCardWidget(permissionsAsync: permissionsAsync),
        ],
      ),
    );
  }

  Widget _buildSignoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: GestureDetector(
        onTap: () => _showLogoutDialog(context, ref),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Center(
            child: Text(
              'Signout',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(18),
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.22,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: TextStyle(fontFamily: AppTextStyles.fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
          ),
        ],
      ),
    );
  }
}
