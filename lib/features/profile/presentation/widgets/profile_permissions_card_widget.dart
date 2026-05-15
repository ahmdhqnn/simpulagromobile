import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';

class ProfilePermissionsCardWidget extends StatefulWidget {
  final AsyncValue<List<String>> permissionsAsync;
  const ProfilePermissionsCardWidget({
    super.key,
    required this.permissionsAsync,
  });

  @override
  State<ProfilePermissionsCardWidget> createState() =>
      _ProfilePermissionsCardWidgetState();
}

class _ProfilePermissionsCardWidgetState
    extends State<ProfilePermissionsCardWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.permissionsAsync.when(
      data: (permissions) => _buildCard(context, permissions),
      loading: () => Container(
        height: 82,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (_, __) => _buildErrorState(context),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const IconBadgeWidget.icon(
            icon: Icons.error_outline,
            background: Color(0x1AEF5350),
            tint: AppColors.error,
            radius: 10,
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
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(22),
                    fontWeight: FontWeight.w300,
                    color: AppColors.textPrimary,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Tidak dapat memuat hak akses',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
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
    );
  }

  Widget _buildCard(BuildContext context, List<String> permissions) {
    if (permissions.isEmpty) {
      return Container(
        height: 82,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            IconBadgeWidget.svg(
              svgIconPath: 'assets/icons/setting-outline-icon.svg',
              background: AppColors.textPrimary.withValues(alpha: 0.05),
              tint: AppColors.textPrimary.withValues(alpha: 0.3),
              radius: 10,
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
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(22),
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Belum ada hak akses tersedia',
                    style: AppTextStyles.hint(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final grouped = _groupPermissions(permissions);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const IconBadgeWidget.svg(
                    svgIconPath: 'assets/icons/setting-outline-icon.svg',
                    background: Color(0x1A1B5E20),
                    tint: AppColors.primary,
                    radius: 10,
                  ),
                  SizedBox(width: context.rw(0.02)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hak Akses Sistem',
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
                          '${permissions.length} Permission${permissions.length > 1 ? 's' : ''}',
                          style: AppTextStyles.hint(context),
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
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ...grouped.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _PermissionGroup(
                        module: entry.key,
                        actions: entry.value,
                      ),
                    ),
                  ),
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
        grouped.putIfAbsent(parts[0], () => []).add(parts[1]);
      }
    }
    return grouped;
  }
}

class _PermissionGroup extends StatelessWidget {
  final String module;
  final List<String> actions;
  const _PermissionGroup({required this.module, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _capitalize(module),
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actions.map((action) {
            final color = _actionColor(action);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_actionIcon(action), size: 14, color: color),
                  const SizedBox(width: 6),
                  Text(
                    _capitalize(action),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: color,
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

  String _capitalize(String text) => text.isEmpty
      ? text
      : text[0].toUpperCase() + text.substring(1).toLowerCase();

  IconData _actionIcon(String action) {
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

  Color _actionColor(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return AppColors.success;
      case 'read':
      case 'view':
        return AppColors.info;
      case 'update':
      case 'edit':
        return AppColors.warning;
      case 'delete':
        return AppColors.error;
      case 'manage':
      case 'admin':
        return const Color(0xFF9C27B0);
      default:
        return AppColors.textTertiary;
    }
  }
}
