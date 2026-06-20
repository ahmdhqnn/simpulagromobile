import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/user_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/l10n/l10n.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListAsync = ref.watch(adminUserListProvider);

    return PermissionGuardScreen(
      permission: 'user:read',
      child: AdminScaffold(
        title: context.l10n.adminUsersTitle,
        action: PermissionGuard(
          permission: 'user:create',
          child: AdminAddButton(
            onTap: () => context.push('/admin/users/create'),
          ),
        ),
        body: userListAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (users) {
            if (users.isEmpty) {
              return AdminEmptyState(
                icon: Icons.people_outline,
                title: context.l10n.adminNoUsers,
                message: context.l10n.adminNoUsersMessage,
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(adminUserListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _UserCard(user: user),
                  );
                },
              ),
            );
          },
          loading: () => const AdminLoadingState(),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () => ref.invalidate(adminUserListProvider),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[
      AdminBadge(
        label: user.isAdmin ? 'Admin' : 'User',
        color: user.isAdmin ? const Color(0xFFEF5350) : const Color(0xFF42A5F5),
        icon: Icons.admin_panel_settings,
      ),
      if (user.userEmail != null)
        AdminBadge(
          label: user.userEmail!,
          color: Colors.purple,
          icon: Icons.email,
        ),
    ];

    return AdminListItem(
      title: user.userName,
      subtitle: context.l10n.adminIdPrefix(user.userId),
      icon: Icons.person,
      iconColor: user.isActive ? const Color(0xFFFFA726) : Colors.grey,
      isActive: user.isActive,
      onTap: () => context.push('/admin/users/${user.userId}'),
      badges: badges,
    );
  }
}
