import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/permission.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/permission_provider.dart';

/// Widget untuk memilih permissions dalam form Role
/// Menampilkan permissions yang dikelompokkan berdasarkan resource
class PermissionCheckboxGroup extends ConsumerWidget {
  final Set<String> selectedPermissionIds;
  final ValueChanged<Set<String>> onChanged;

  const PermissionCheckboxGroup({
    super.key,
    required this.selectedPermissionIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(groupedPermissionsProvider);

    return groupedAsync.when(
      data: (grouped) {
        if (grouped.isEmpty) {
          return const Center(child: Text('Tidak ada permission tersedia'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: grouped.entries.map((entry) {
            return _PermissionGroup(
              resource: entry.key,
              permissions: entry.value,
              selectedIds: selectedPermissionIds,
              onChanged: onChanged,
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Center(
        child: Text(
          'Gagal memuat permissions: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class _PermissionGroup extends StatelessWidget {
  final String resource;
  final List<Permission> permissions;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;

  const _PermissionGroup({
    required this.resource,
    required this.permissions,
    required this.selectedIds,
    required this.onChanged,
  });

  bool get _allSelected =>
      permissions.every((p) => selectedIds.contains(p.permId));

  bool get _someSelected =>
      permissions.any((p) => selectedIds.contains(p.permId));

  void _toggleAll() {
    final newSelected = Set<String>.from(selectedIds);
    if (_allSelected) {
      for (final p in permissions) {
        newSelected.remove(p.permId);
      }
    } else {
      for (final p in permissions) {
        newSelected.add(p.permId);
      }
    }
    onChanged(newSelected);
  }

  void _toggleOne(Permission perm) {
    final newSelected = Set<String>.from(selectedIds);
    if (newSelected.contains(perm.permId)) {
      newSelected.remove(perm.permId);
    } else {
      newSelected.add(perm.permId);
    }
    onChanged(newSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group header with select-all
          InkWell(
            onTap: _toggleAll,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Checkbox(
                    value: _allSelected ? true : (_someSelected ? null : false),
                    tristate: true,
                    activeColor: AppColors.primary,
                    onChanged: (_) => _toggleAll(),
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      resource.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${permissions.where((p) => selectedIds.contains(p.permId)).length}/${permissions.length}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Individual permissions
          ...permissions.map((perm) {
            final isSelected = selectedIds.contains(perm.permId);
            return InkWell(
              onTap: () => _toggleOne(perm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      activeColor: AppColors.primary,
                      onChanged: (_) => _toggleOne(perm),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            perm.displayName,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (perm.permDesc != null) ...[
                            const Gap(2),
                            Text(
                              perm.permDesc!,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (perm.action != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _actionColor(
                            perm.action!,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          perm.action!,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _actionColor(perm.action!),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _actionColor(String action) {
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
}
