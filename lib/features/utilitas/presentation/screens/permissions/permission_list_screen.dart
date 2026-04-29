import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/permission_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/permission.dart';

class PermissionListScreen extends ConsumerWidget {
  const PermissionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(groupedPermissionsProvider);

    return PermissionGuardScreen(
      permission: 'role:read',
      child: UtilitasScaffold(
        title: 'Permission',
        onRefresh: () => ref.invalidate(groupedPermissionsProvider),
        body: groupedAsync.when(
          data: (grouped) {
            if (grouped.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.lock_outline,
                title: 'Belum ada permission',
                message: 'Tidak ada permission yang terdaftar',
              );
            }

            final totalCount = grouped.values.fold<int>(
              0,
              (sum, list) => sum + list.length,
            );

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                ref.invalidate(groupedPermissionsProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                children: [
                  SizedBox(height: context.rh(0.01)),
                  Text(
                    'Permission',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(22),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1D1D1D),
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: context.rh(0.014)),
                  _SummaryCard(
                    totalPermissions: totalCount,
                    totalGroups: grouped.length,
                  ),
                  SizedBox(height: context.rh(0.02)),
                  ...grouped.entries.map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: _PermissionGroupCard(
                        resource: entry.key,
                        permissions: entry.value,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(groupedPermissionsProvider),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalPermissions;
  final int totalGroups;

  const _SummaryCard({
    required this.totalPermissions,
    required this.totalGroups,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          SizedBox(width: context.rw(0.03)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$totalPermissions Total Permission',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$totalGroups Grup Resource',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PermissionGroupCard extends StatefulWidget {
  final String resource;
  final List<Permission> permissions;

  const _PermissionGroupCard({
    required this.resource,
    required this.permissions,
  });

  @override
  State<_PermissionGroupCard> createState() => _PermissionGroupCardState();
}

class _PermissionGroupCardState extends State<_PermissionGroupCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: AppColors.error,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: context.rw(0.03)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.resource.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D1D1D),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.permissions.length} permission',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w300,
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 4,
                    children: widget.permissions
                        .where((p) => p.action != null)
                        .map((p) => _ActionBadge(action: p.action!))
                        .toList(),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            ...widget.permissions.map(
              (perm) => _PermissionTile(permission: perm),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final Permission permission;

  const _PermissionTile({required this.permission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 62),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permission.displayName,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
                if (permission.permDesc != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    permission.permDesc!,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(12),
                      color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (permission.action != null)
            _ActionBadge(action: permission.action!),
        ],
      ),
    );
  }
}

class _ActionBadge extends StatelessWidget {
  final String action;

  const _ActionBadge({required this.action});

  Color get _color {
    switch (action) {
      case 'create':
        return Colors.green;
      case 'read':
        return Colors.blue;
      case 'update':
        return Colors.orange;
      case 'delete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        action,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: context.sp(10),
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
