import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../../l10n/app_localizations.dart';

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
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (permissions) => _buildCard(context, permissions),
      loading: () => const ProfilePermissionsCardSkeleton(),
      error: (_, __) => _buildErrorState(context),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.commonLoadFailed,
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
                  l10n.profilePermissionsLoadError,
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
    final l10n = AppLocalizations.of(context)!;
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
                    l10n.profilePermissionsNoAccess,
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
                    l10n.profilePermissionsNoAccessDesc,
                    style: AppTextStyles.hint(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final grouped = _groupPermissions(permissions, l10n);
    final totalPermissions = grouped.values.fold<int>(
      0,
      (total, actions) => total + actions.length,
    );

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
                          l10n.profilePermissionsSystemAccess,
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
                          l10n.profilePermissionsCount(totalPermissions),
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
              width: double.infinity,
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

  Map<String, List<String>> _groupPermissions(
    List<String> permissions,
    AppLocalizations l10n,
  ) {
    final Map<String, List<String>> grouped = {};
    for (final permission in permissions) {
      final normalized = permission.trim();
      if (normalized.isEmpty) continue;

      final parts = normalized.split(':');
      if (parts.length == 2) {
        final module = parts[0].trim();
        final action = parts[1].trim();
        if (module.isEmpty || action.isEmpty) continue;
        grouped.putIfAbsent(module, () => []).add(action);
      } else {
        grouped.putIfAbsent(l10n.commonOther, () => []).add(normalized);
      }
    }

    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return {
      for (final entry in sortedEntries)
        entry.key: _sortActions(entry.value.toSet().toList()),
    };
  }

  List<String> _sortActions(List<String> actions) {
    const order = {
      'read': 0,
      'view': 1,
      'create': 2,
      'update': 3,
      'edit': 4,
      'delete': 5,
      'manage': 6,
      'admin': 7,
    };

    actions.sort((a, b) {
      final aOrder = order[a.toLowerCase()] ?? 99;
      final bOrder = order[b.toLowerCase()] ?? 99;
      if (aOrder != bOrder) return aOrder.compareTo(bOrder);
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return actions;
  }
}

class _PermissionGroup extends StatelessWidget {
  final String module;
  final List<String> actions;
  const _PermissionGroup({required this.module, required this.actions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatModule(module),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: actions.map((action) {
                final color = _actionColor(action);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                        _formatAction(action, l10n),
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
          ),
        ],
      ),
    );
  }

  String _formatModule(String text) {
    final normalized = text
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map(_capitalize)
        .join(' ');
    return normalized.isEmpty ? '-' : normalized;
  }

  String _formatAction(String text, AppLocalizations l10n) {
    switch (text.toLowerCase()) {
      case 'read':
      case 'view':
        return l10n.permissionActionRead;
      case 'create':
        return l10n.permissionActionCreate;
      case 'update':
      case 'edit':
        return l10n.permissionActionUpdate;
      case 'delete':
        return l10n.permissionActionDelete;
      case 'manage':
        return l10n.permissionActionManage;
      case 'admin':
        return l10n.roleAdmin;
      default:
        return _formatModule(text);
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

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
