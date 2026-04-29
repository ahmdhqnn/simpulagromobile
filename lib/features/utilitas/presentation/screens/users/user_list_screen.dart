import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/user_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListAsync = ref.watch(utilitasUserListProvider);

    return PermissionGuardScreen(
      permission: 'user:read',
      child: UtilitasScaffold(
        title: 'Users',
        action: PermissionGuard(
          permission: 'user:create',
          child: UtilitasAddButton(
            onTap: () => context.push('/utilitas/users/create'),
          ),
        ),
        body: userListAsync.when(
          data: (users) {
            if (users.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.people_outline,
                title: 'Belum ada user',
                message: 'Tambahkan user untuk mengakses sistem',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(utilitasUserListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: users.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: Text(
                        'Users',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(22),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1D1D1D),
                          height: 1.0,
                        ),
                      ),
                    );
                  }
                  final user = users[index - 1];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _UserCard(user: user),
                  );
                },
              ),
            );
          },
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(utilitasUserListProvider),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  final User user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = <Widget>[
      UtilitasBadge(
        label: user.isAdmin ? 'Admin' : 'User',
        color: user.isAdmin ? const Color(0xFFEF5350) : const Color(0xFF42A5F5),
        icon: Icons.admin_panel_settings,
      ),
      if (user.userEmail != null)
        UtilitasBadge(
          label: user.userEmail!,
          color: Colors.purple,
          icon: Icons.email,
        ),
    ];

    return UtilitasListItem(
      title: user.userName,
      subtitle: 'ID: ${user.userId}',
      icon: Icons.person,
      iconColor: user.isActive ? const Color(0xFFFFA726) : Colors.grey,
      isActive: user.isActive,
      onTap: () => _showOptions(context, ref),
      badges: badges,
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
                user.userName,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            PermissionGuard(
              permission: 'user:update',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/utilitas/users/${user.userId}/edit');
                },
              ),
            ),
            PermissionGuard(
              permission: 'user:delete',
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
      itemName: 'User "${user.userName}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(userFormProvider.notifier)
        .deleteUser(user.userId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'User berhasil dihapus');
    } else {
      final error = ref.read(userFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menghapus user');
    }
  }
}
