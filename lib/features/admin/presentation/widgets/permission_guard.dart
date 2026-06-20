import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/l10n.dart';
import '../providers/permission_guard_provider.dart';
import 'admin_scaffold.dart';

class PermissionGuard extends ConsumerWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPermission = ref.watch(hasPermissionProvider(permission));

    if (hasPermission) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

class PermissionGuardScreen extends ConsumerWidget {
  final String permission;
  final Widget child;

  const PermissionGuardScreen({
    super.key,
    required this.permission,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(adminUserPermissionsProvider);

    if (permissions.contains(permission)) {
      return child;
    }
    return const _ForbiddenScreen();
  }
}

class _ForbiddenScreen extends StatelessWidget {
  const _ForbiddenScreen();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: context.l10n.adminAccessDeniedTitle,
      body: AdminEmptyState(
        icon: Icons.block,
        title: context.l10n.adminAccessDeniedTitle,
        message: context.l10n.adminNoPagePermissionMessage,
      ),
    );
  }
}
