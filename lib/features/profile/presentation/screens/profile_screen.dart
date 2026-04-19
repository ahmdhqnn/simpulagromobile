// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import 'settings_screen.dart';

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
                  _buildProfileAvatar(context, profile),
                  SizedBox(height: context.rh(0.024)),
                  _buildUserInfo(context, profile),
                  SizedBox(height: context.rh(0.024)),
                  _buildAccountInfoSection(context, profile),
                  SizedBox(height: context.rh(0.024)),
                  _buildForumManagementSection(context),
                  SizedBox(height: context.rh(0.024)),
                  _buildPermissionsSection(context, permissionsAsync),
                  SizedBox(height: context.rh(0.024)),
                  _buildSignoutButton(context, ref),
                  SizedBox(height: context.rh(0.04)),
                ],
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
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
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 58,
              height: 58,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SvgPicture.asset(
                'assets/icons/chevron-left-icon.svg',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            child: Container(
              width: 58,
              height: 58,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SvgPicture.asset(
                'assets/icons/setting-outline-icon.svg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, UserProfile profile) {
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
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(80),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserProfile profile) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFECF6FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            profile.roleName ?? 'User',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF42A5F5),
              height: 1.83,
            ),
          ),
        ),
        SizedBox(height: context.rh(0.004)),
        Text(
          profile.userName,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(22),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1D1D1D),
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfoSection(BuildContext context, UserProfile profile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Akun',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1D1D1D),
              height: 1.0,
            ),
          ),
          SizedBox(height: context.rh(0.014)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  context,
                  'assets/icons/mail-outline-icon.svg',
                  'Email',
                  profile.userEmail ?? '-',
                ),
                const SizedBox(height: 3),
                _buildInfoRow(
                  context,
                  'assets/icons/phone-outline-icon.svg',
                  'Telepon',
                  profile.userPhone ?? '-',
                ),
                const SizedBox(height: 3),
                _buildInfoRow(
                  context,
                  'assets/icons/date-outline-icon.svg',
                  'Bergabung',
                  _formatJoinDate(profile.userCreated),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String iconPath,
    String label,
    String value,
  ) {
    // Handle empty or whitespace-only strings
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
                  Color(0xFF1D1D1D),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D),
                  height: 1.57,
                ),
              ),
            ],
          ),
          Text(
            displayValue,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D),
              height: 1.83,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumManagementSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forum',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1D1D1D),
              height: 1.0,
            ),
          ),
          SizedBox(height: context.rh(0.014)),
          GestureDetector(
            onTap: () => context.push('/forum/my-posts'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF32A527).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/forum-filled-icon.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF32A527),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Postingan Saya',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D1D1D),
                            height: 1.57,
                          ),
                        ),
                        Text(
                          'Kelola postingan forum Anda',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF1D1D1D),
                            height: 1.83,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/chevron-right-icon.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1D1D1D),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          Text(
            'Hak Akses',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1D1D1D),
              height: 1.0,
            ),
          ),
          SizedBox(height: context.rh(0.014)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: permissionsAsync.when(
              data: (permissions) {
                if (permissions.isEmpty) {
                  return SizedBox(
                    height: 70,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/setting-outline-icon.svg',
                            width: 28,
                            height: 28,
                            colorFilter: ColorFilter.mode(
                              const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(height: context.rh(0.005)),
                          Text(
                            'Tidak ada hak akses',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(12),
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF1D1D1D),
                              height: 1.83,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: permissions.map((permission) {
                    final color = _getPermissionColor(permission);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _formatPermissionLabel(permission),
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w500,
                          color: color,
                          height: 1.83,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const SizedBox(
                height: 70,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (_, __) => SizedBox(
                height: 70,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 28,
                      ),
                      SizedBox(height: context.rh(0.005)),
                      Text(
                        'Gagal memuat hak akses',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w300,
                          color: AppColors.error,
                          height: 1.83,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPermissionColor(String permission) {
    // Assign colors based on permission type
    if (permission.contains('create')) {
      return const Color(0xFF4CAF50); // Green
    } else if (permission.contains('read') || permission.contains('view')) {
      return const Color(0xFF42A5F5); // Blue
    } else if (permission.contains('update') || permission.contains('edit')) {
      return const Color(0xFFFF9800); // Orange
    } else if (permission.contains('delete')) {
      return const Color(0xFFF44336); // Red
    } else if (permission.contains('manage') || permission.contains('admin')) {
      return const Color(0xFF9C27B0); // Purple
    }
    return const Color(0xFF757575);
  }

  String _formatPermissionLabel(String permission) {
    final parts = permission.split(':');
    if (parts.length == 2) {
      final module = _capitalizeFirst(parts[0]);
      final action = _capitalizeFirst(parts[1]);
      return '$module $action';
    }
    return _capitalizeFirst(permission);
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _formatJoinDate(DateTime? date) {
    if (date == null) return '-';
    try {
      return DateFormat('d/M/yyyy').format(date);
    } catch (e) {
      return '-';
    }
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
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              'Signout',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
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
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
            ),
          ),
        ],
      ),
    );
  }
}
