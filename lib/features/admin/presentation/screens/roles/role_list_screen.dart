import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_guard_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/role_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/role.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/shared/widgets/action_popup_menu_button.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class RoleListScreen extends ConsumerWidget {
  const RoleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleListAsync = ref.watch(adminRoleListProvider);
    final rolePermissionCounts = ref.watch(rolePermissionCountsProvider);

    return PermissionGuardScreen(
      permission: 'role:read',
      child: AdminScaffold(
        title: context.l10n.adminRoleTitle,
        action: PermissionGuard(
          permission: 'role:create',
          child: AdminAddButton(
            onTap: () => context.push('/admin/roles/create'),
          ),
        ),
        body: roleListAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (roles) {
            if (roles.isEmpty) {
              return RefreshIndicator(
                color: const Color(0xFF1B5E20),
                onRefresh: () async {
                  ref.invalidate(adminRoleListProvider);
                  ref.invalidate(rolePermissionsProvider);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rw(0.051),
                    vertical: context.rh(0.01),
                  ),
                  children: [
                    AdminEmptyState(
                      icon: Icons.admin_panel_settings_outlined,
                      title: context.l10n.adminNoRoles,
                      message: context.l10n.adminNoRolesMessage,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(adminRoleListProvider);
                ref.invalidate(rolePermissionsProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  final permissionCount =
                      rolePermissionCounts.asData?.value[role.roleId] ??
                      role.permissionCount;
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _RoleCard(
                      role: role,
                      permissionCount: permissionCount,
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const AdminLoadingState(),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () => ref.invalidate(adminRoleListProvider),
          ),
        ),
      ),
    );
  }
}

final rolePermissionCountsProvider = FutureProvider<Map<String, int>>((
  ref,
) async {
  final rows = await ref.watch(rolePermissionsProvider.future);
  return {
    for (final row in rows)
      if (row.roleId != null) row.roleId!: row.listPermission.length,
  };
});

class _RoleCard extends ConsumerWidget {
  final Role role;
  final int permissionCount;

  const _RoleCard({required this.role, required this.permissionCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canUpdate = ref.watch(hasPermissionProvider('role:update'));
    final canDelete = ref.watch(hasPermissionProvider('role:delete'));
    final items = <ActionPopupMenuItem<String>>[
      if (canUpdate)
        ActionPopupMenuItem(
          value: 'edit',
          icon: Icons.edit_outlined,
          label: context.l10n.commonEdit,
          iconColor: const Color(0xFF1D1D1D),
        ),
      if (canDelete)
        ActionPopupMenuItem(
          value: 'delete',
          icon: Icons.delete_outline,
          label: context.l10n.commonDelete,
          iconColor: Colors.red,
          labelColor: Colors.red,
        ),
    ];

    return AdminListItem(
      title: role.displayName,
      subtitle: context.l10n.adminIdPrefix(role.roleId),
      icon: Icons.admin_panel_settings,
      iconColor: role.isActive ? const Color(0xFF66BB6A) : Colors.grey,
      isActive: role.isActive,
      onTap: () => context.push('/admin/roles/${role.roleId}'),
      trailing: items.isEmpty ? null : _buildActionsMenu(context, ref, items),
      badges: [
        AdminBadge(
          label: context.l10n.adminPermissionBadge(permissionCount),
          color: const Color(0xFF42A5F5),
          icon: Icons.lock_outline,
        ),
        if (role.roleDesc != null)
          AdminBadge(
            label: role.roleDesc!,
            color: Colors.purple,
            icon: Icons.info_outline,
          ),
      ],
    );
  }

  Widget _buildActionsMenu(
    BuildContext context,
    WidgetRef ref,
    List<ActionPopupMenuItem<String>> items,
  ) {
    return MorePopupMenuButton<String>(
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      useSvgIcon: false,
      size: 40,
      iconSize: 22,
      backgroundColor: null,
      iconColor: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      items: items,
      onSelected: (value) {
        if (value == 'edit') {
          context.push('/admin/roles/${role.roleId}/edit');
        } else if (value == 'delete') {
          _confirmDelete(context, ref);
        }
      },
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
    } else {
      final error = ref.read(adminRoleFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.adminDeleteFailed(context.l10n.adminRoleTitle),
      );
    }
  }
}
