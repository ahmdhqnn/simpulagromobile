import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/locale_formatters.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/domain/entities/role.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/role_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_detail_widgets.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';

class RoleDetailScreen extends ConsumerWidget {
  const RoleDetailScreen({super.key, required this.roleId});

  final String roleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(adminRoleDetailProvider(roleId));
    final formState = ref.watch(adminRoleFormProvider);

    return PermissionGuardScreen(
      permission: 'role:read',
      child: AdminScaffold(
        title: context.l10n.adminRoleTitle,
        action: roleAsync.maybeWhen(
          data: (role) => _RoleActions(role: role),
          orElse: () => null,
        ),
        body: Stack(
          children: [
            roleAsync.when(
              skipLoadingOnReload: true,
              data: (role) => _RoleDetailBody(role: role),
              loading: () => const AdminDetailScreenSkeleton(),
              error: (error, _) => AdminErrorState(
                error: error,
                onRetry: () => ref.invalidate(adminRoleDetailProvider(roleId)),
              ),
            ),
            if (formState.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.25),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoleActions extends ConsumerWidget {
  const _RoleActions({required this.role});

  final Role role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PermissionGuard(
          permission: 'role:update',
          child: AdminCircleActionButton(
            svgIconPath: 'assets/icons/edit-outline-icon.svg',
            onTap: () => context.push('/admin/roles/${role.roleId}/edit'),
          ),
        ),
        const SizedBox(width: 8),
        PermissionGuard(
          permission: 'role:delete',
          child: AdminCircleActionButton(
            icon: Icons.delete_outline,
            color: AppColors.error,
            onTap: () => _confirmDelete(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: 'Role "${role.displayName}"',
      additionalMessage: context.l10n.adminRoleDeleteWarning,
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(adminRoleFormProvider.notifier)
        .deleteRole(role.roleId);
    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        context.l10n.adminDeleteSuccess(context.l10n.adminRoleTitle),
      );
      context.go('/admin/roles');
      return;
    }

    SnackbarHelper.showError(
      context,
      ref.read(adminRoleFormProvider).error ??
          context.l10n.adminDeleteFailed(context.l10n.adminRoleTitle),
    );
  }
}

class _RoleDetailBody extends ConsumerWidget {
  const _RoleDetailBody({required this.role});

  final Role role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionsAsync = ref.watch(permissionsByRoleProvider(role.roleId));

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(adminRoleDetailProvider(role.roleId));
        ref.invalidate(permissionsByRoleProvider(role.roleId));
        ref.invalidate(rolePermissionsProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.01),
        ),
        children: [
          AdminDetailHeaderCard(
            title: role.displayName,
            subtitle: role.roleId,
            icon: Icons.admin_panel_settings,
            iconColor: const Color(0xFF66BB6A),
            isActive: role.isActive,
            activeLabel: context.l10n.commonActive,
            inactiveLabel: context.l10n.commonInactive,
          ),
          SizedBox(height: context.rh(0.014)),
          AdminSectionCard(
            title: context.l10n.adminRoleInfoSection,
            child: Column(
              children: [
                AdminDetailRow(
                  icon: Icons.tag_outlined,
                  label: context.l10n.adminRoleIdLabel,
                  value: role.roleId,
                ),
                AdminDetailRow(
                  icon: Icons.description_outlined,
                  label: context.l10n.commonDescription,
                  value: role.roleDesc ?? '-',
                ),
                permissionsAsync.when(
                  data: (permissions) => AdminDetailRow(
                    icon: Icons.lock_outline,
                    label: context.l10n.adminPermissionTitle,
                    value: permissions.length.toString(),
                  ),
                  loading: () => AdminDetailRow(
                    icon: Icons.lock_outline,
                    label: context.l10n.adminPermissionTitle,
                    value: '...',
                  ),
                  error: (_, __) => AdminDetailRow(
                    icon: Icons.lock_outline,
                    label: context.l10n.adminPermissionTitle,
                    value: role.permissionCount.toString(),
                  ),
                ),
                AdminDetailRow(
                  icon: Icons.event_outlined,
                  label: 'Dibuat',
                  value: _date(context, role.roleCreated),
                ),
                AdminDetailRow(
                  icon: Icons.update_outlined,
                  label: 'Diubah',
                  value: _date(context, role.roleUpdate),
                  showDivider: false,
                ),
              ],
            ),
          ),
          SizedBox(height: context.rh(0.014)),
          AdminSectionCard(
            title: context.l10n.adminRolePermissionSection,
            child: permissionsAsync.when(
              data: (permissions) {
                if (permissions.isEmpty) {
                  return Text(
                    context.l10n.adminNoPermissionsMessage,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: AppColors.textSecondary,
                    ),
                  );
                }
                return Column(
                  children: List.generate(permissions.length, (index) {
                    final permission = permissions[index];
                    return AdminDetailRow(
                      icon: Icons.lock_outline,
                      label: permission.permName ?? permission.permId,
                      value: permission.permDesc ?? permission.permPage ?? '-',
                      showDivider: index != permissions.length - 1,
                    );
                  }),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  String _date(BuildContext context, DateTime? date) {
    if (date == null) return '-';
    return context.dateFormat('dd MMM yyyy HH:mm').format(date.toLocal());
  }
}
