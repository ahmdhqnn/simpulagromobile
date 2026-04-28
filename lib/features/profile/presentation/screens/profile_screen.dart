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
                  _buildUtilitasSection(context, ref),
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
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/chevron-left-icon.svg',
                width: 28,
                height: 28,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/setting-outline-icon.svg',
                width: 28,
                height: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
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

  Widget _buildUtilitasSection(BuildContext context, WidgetRef ref) {
    // Only show for Admin
    final authState = ref.watch(authProvider);
    if (!authState.isAdmin) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Utilitas',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(22),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1D1D1D),
              height: 1.0,
            ),
          ),
          SizedBox(height: context.rh(0.014)),
          InkWell(
            onTap: () => context.push('/utilitas'),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
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
                          'Utilitas',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF1D1D1D),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Kelola master data sistem',
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
          const _ForumCard(),
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
          _PermissionsCard(permissionsAsync: permissionsAsync),
        ],
      ),
    );
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

// Expandable Forum Card Widget
class _ForumCard extends StatefulWidget {
  const _ForumCard();

  @override
  State<_ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<_ForumCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECF6FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/forum-filled-icon.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF42A5F5),
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
                          'Forum Management',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF1D1D1D),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Kelola postingan dan komentar',
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
                    _expanded
                        ? 'assets/icons/chevron-down-icon.svg'
                        : 'assets/icons/chevron-right-icon.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildForumItem(
                    context,
                    'assets/icons/comment-outline-icon.svg',
                    'Postingan Saya',
                    'Lihat dan kelola postingan',
                    () {
                      // Navigate to my posts
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildForumItem(
                    context,
                    'assets/icons/like-outline-icon.svg',
                    'Postingan Disukai',
                    'Postingan yang Anda sukai',
                    () {
                      // Navigate to liked posts
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildForumItem(
                    context,
                    'assets/icons/message-outline-icon.svg',
                    'Komentar Saya',
                    'Lihat semua komentar',
                    () {
                      // Navigate to my comments
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildForumItem(
    BuildContext context,
    String iconPath,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1D1D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/chevron-right-icon.svg',
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// Expandable Permissions Card Widget
class _PermissionsCard extends StatefulWidget {
  final AsyncValue<List<String>> permissionsAsync;

  const _PermissionsCard({required this.permissionsAsync});

  @override
  State<_PermissionsCard> createState() => _PermissionsCardState();
}

class _PermissionsCardState extends State<_PermissionsCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.permissionsAsync.when(
      data: (permissions) => _buildPermissionsCard(context, permissions),
      loading: () => Container(
        height: 82,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (_, __) => Container(
        height: 82,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 20,
              ),
            ),
            SizedBox(width: context.rw(0.02)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gagal Memuat',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(22),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Tidak dapat memuat hak akses',
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
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsCard(BuildContext context, List<String> permissions) {
    if (permissions.isEmpty) {
      return Container(
        height: 82,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/icons/setting-outline-icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: context.rw(0.02)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tidak Ada Akses',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(22),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1D1D1D),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Belum ada hak akses tersedia',
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
          ],
        ),
      );
    }

    final groupedPermissions = _groupPermissions(permissions);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/setting-outline-icon.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
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
                          'Hak Akses Sistem',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF1D1D1D),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${permissions.length} Permission${permissions.length > 1 ? 's' : ''}',
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
                    _expanded
                        ? 'assets/icons/chevron-down-icon.svg'
                        : 'assets/icons/chevron-right-icon.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ...groupedPermissions.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPermissionGroup(
                        context,
                        entry.key,
                        entry.value,
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Map<String, List<String>> _groupPermissions(List<String> permissions) {
    final Map<String, List<String>> grouped = {};

    for (final permission in permissions) {
      final parts = permission.split(':');
      if (parts.length == 2) {
        final module = parts[0];
        final action = parts[1];

        if (!grouped.containsKey(module)) {
          grouped[module] = [];
        }
        grouped[module]!.add(action);
      }
    }

    return grouped;
  }

  Widget _buildPermissionGroup(
    BuildContext context,
    String module,
    List<String> actions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _capitalizeFirst(module),
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1D1D),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actions.map((action) {
            final actionColor = _getActionColor(action);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: actionColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: actionColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getActionIcon(action), size: 14, color: actionColor),
                  const SizedBox(width: 6),
                  Text(
                    _capitalizeFirst(action),
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: actionColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return Icons.add_circle_outline;
      case 'read':
      case 'view':
        return Icons.visibility_outlined;
      case 'update':
      case 'edit':
        return Icons.edit_outlined;
      case 'delete':
        return Icons.delete_outline;
      case 'manage':
      case 'admin':
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return const Color(0xFF4CAF50); // Green
      case 'read':
      case 'view':
        return const Color(0xFF42A5F5); // Blue
      case 'update':
      case 'edit':
        return const Color(0xFFFF9800); // Orange
      case 'delete':
        return const Color(0xFFF44336); // Red
      case 'manage':
      case 'admin':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF757575); // Grey
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
