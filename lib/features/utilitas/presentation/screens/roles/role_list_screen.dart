import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/role_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/role.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class RoleListScreen extends ConsumerWidget {
  const RoleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleListAsync = ref.watch(utilitasRoleListProvider);

    return PermissionGuardScreen(
      permission: 'role:read',
      child: UtilitasScaffold(
        title: 'Role',
        action: PermissionGuard(
          permission: 'role:create',
          child: UtilitasAddButton(
            onTap: () => context.push('/utilitas/roles/create'),
          ),
        ),
        body: roleListAsync.when(
          data: (roles) {
            if (roles.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Belum ada role',
                message: 'Tambahkan role untuk mengatur hak akses',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(utilitasRoleListProvider);
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
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _RoleCard(role: role),
                  );
                },
              ),
            );
          },
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(utilitasRoleListProvider),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends ConsumerWidget {
  final Role role;

  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UtilitasListItem(
      title: role.displayName,
      subtitle: 'ID: ${role.roleId}',
      icon: Icons.admin_panel_settings,
      iconColor: role.isActive ? const Color(0xFF66BB6A) : Colors.grey,
      isActive: role.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        UtilitasBadge(
          label: '${role.permissionCount} Permission',
          color: const Color(0xFF42A5F5),
          icon: Icons.lock_outline,
        ),
        if (role.roleDesc != null)
          UtilitasBadge(
            label: role.roleDesc!,
            color: Colors.purple,
            icon: Icons.info_outline,
          ),
      ],
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                role.displayName,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            PermissionGuard(
              permission: 'role:update',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/utilitas/roles/${role.roleId}/edit');
                },
              ),
            ),
            PermissionGuard(
              permission: 'role:delete',
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, ref);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: 'Role "${role.displayName}"',
      additionalMessage: 'Semua user dengan role ini akan kehilangan akses.',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(roleFormProvider.notifier)
        .deleteRole(role.roleId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'Role berhasil dihapus');
    } else {
      final error = ref.read(roleFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menghapus role');
    }
  }
}
