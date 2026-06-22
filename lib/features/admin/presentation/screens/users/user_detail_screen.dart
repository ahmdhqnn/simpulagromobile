import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/user_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_detail_widgets.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(adminUserDetailProvider(userId));
    final formState = ref.watch(adminUserFormProvider);

    return PermissionGuardScreen(
      permission: 'user:read',
      child: AdminScaffold(
        title: context.l10n.adminUsersTitle,
        action: userAsync.maybeWhen(
          data: (user) => _DetailActions(user: user),
          orElse: () => null,
        ),
        body: Stack(
          children: [
            userAsync.when(
              skipLoadingOnReload: true,
              data: (user) => _UserDetailBody(user: user),
              loading: () => const AdminUserDetailSkeleton(),
              error: (error, _) => AdminErrorState(
                error: error,
                onRetry: () => ref.invalidate(adminUserDetailProvider(userId)),
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

class _DetailActions extends ConsumerWidget {
  const _DetailActions({required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PermissionGuard(
          permission: 'user:update',
          child: AdminCircleActionButton(
            svgIconPath: 'assets/icons/edit-outline-icon.svg',
            onTap: () => context.push('/admin/users/${user.userId}/edit'),
          ),
        ),
        const SizedBox(width: 8),
        PermissionGuard(
          permission: 'user:delete',
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
      itemName: 'User "${user.userName}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(adminUserFormProvider.notifier)
        .deleteUser(user.userId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        context.l10n.adminDeleteSuccess('User'),
      );
      context.go('/admin/users');
      return;
    }

    final error = ref.read(adminUserFormProvider).error;
    SnackbarHelper.showError(
      context,
      error ?? context.l10n.adminDeleteFailed('User'),
    );
  }
}

class _UserDetailBody extends ConsumerWidget {
  const _UserDetailBody({required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleId = user.roleId;
    final permissionCountAsync = roleId == null || roleId.trim().isEmpty
        ? const AsyncValue<int>.data(0)
        : ref.watch(_userRolePermissionCountProvider(roleId));

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(adminUserDetailProvider(user.userId));
        if (roleId != null && roleId.trim().isNotEmpty) {
          ref.invalidate(_userRolePermissionCountProvider(roleId));
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.01),
        ),
        children: [
          AdminSectionCard(
            child: Column(
              children: [
                _AvatarHeader(user: user),
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  icon: Icons.tag_outlined,
                  label: context.l10n.adminUserIdLabel,
                  value: user.userId,
                ),
                _DetailRow(
                  icon: Icons.email_outlined,
                  label: context.l10n.adminEmailLabel,
                  value: user.userEmail ?? '-',
                ),
                _DetailRow(
                  icon: Icons.phone_outlined,
                  label: context.l10n.adminPhoneLabel,
                  value: user.userPhone ?? '-',
                ),
                _DetailRow(
                  icon: Icons.toggle_on_outlined,
                  label: context.l10n.commonStatus,
                  value: user.isActive
                      ? context.l10n.commonActive
                      : context.l10n.commonInactive,
                ),
                _DetailRow(
                  icon: Icons.admin_panel_settings_outlined,
                  label: context.l10n.adminRoleLabel,
                  value: _roleLabel(context, user.roleId),
                ),
                permissionCountAsync.when(
                  data: (count) => _DetailRow(
                    icon: Icons.lock_outline,
                    label: context.l10n.adminPermissionTitle,
                    value: count.toString(),
                    showDivider: false,
                  ),
                  loading: () =>
                      const AdminDetailRowSkeleton(showDivider: false),
                  error: (_, __) => _DetailRow(
                    icon: Icons.lock_outline,
                    label: context.l10n.adminPermissionTitle,
                    value: '0',
                    showDivider: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(BuildContext context, String? roleId) {
    return switch (roleId) {
      'ROLE001' => context.l10n.roleAdmin,
      'ROLE002' => context.l10n.roleUser,
      'ROLE003' => context.l10n.roleViewer,
      null || '' => '-',
      _ => roleId,
    };
  }
}

class _AvatarHeader extends StatelessWidget {
  const _AvatarHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: user.isActive
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.grey.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline,
            color: user.isActive ? AppColors.primary : Colors.grey,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.userName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.roleId ?? '-',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.45),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.08),
          ),
      ],
    );
  }
}

final _userRolePermissionCountProvider = FutureProvider.family<int, String>((
  ref,
  roleId,
) async {
  final permissions = await ref.watch(permissionsByRoleProvider(roleId).future);
  return permissions.length;
});
