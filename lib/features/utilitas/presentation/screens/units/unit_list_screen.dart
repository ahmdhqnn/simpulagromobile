import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/unit.dart';
import 'package:simpulagromobile/shared/widgets/confirmation_dialog.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';

class UnitListScreen extends ConsumerWidget {
  const UnitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitListAsync = ref.watch(utilitasUnitListProvider);

    return PermissionGuardScreen(
      permission: 'unit:read',
      child: UtilitasScaffold(
        title: 'Unit',
        action: PermissionGuard(
          permission: 'unit:create',
          child: UtilitasAddButton(
            onTap: () => context.push('/utilitas/units/create'),
          ),
        ),
        body: unitListAsync.when(
          data: (units) {
            if (units.isEmpty) {
              return const UtilitasEmptyState(
                icon: Icons.straighten_outlined,
                title: 'Belum ada unit',
                message: 'Tambahkan unit satuan untuk sensor',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(utilitasUnitListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: units.length,
                itemBuilder: (context, index) {
                  final unit = units[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _UnitCard(unit: unit),
                  );
                },
              ),
            );
          },
          loading: () => const UtilitasLoadingState(),
          error: (error, _) => UtilitasErrorState(
            error: error,
            onRetry: () => ref.invalidate(utilitasUnitListProvider),
          ),
        ),
      ),
    );
  }
}

class _UnitCard extends ConsumerWidget {
  final Unit unit;

  const _UnitCard({required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UtilitasListItem(
      title: unit.displayNameWithSymbol,
      subtitle: 'ID: ${unit.unitId}',
      icon: Icons.straighten,
      iconColor: unit.isActive ? const Color(0xFFAB47BC) : Colors.grey,
      isActive: unit.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        if (unit.unitSymbol != null)
          UtilitasBadge(
            label: unit.unitSymbol!,
            color: const Color(0xFFAB47BC),
            icon: Icons.text_fields,
          ),
        if (unit.unitDesc != null)
          UtilitasBadge(
            label: unit.unitDesc!,
            color: const Color(0xFF42A5F5),
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
                unit.displayNameWithSymbol,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            PermissionGuard(
              permission: 'unit:update',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/utilitas/units/${unit.unitId}/edit');
                },
              ),
            ),
            PermissionGuard(
              permission: 'unit:delete',
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
      itemName: 'Unit "${unit.displayNameWithSymbol}"',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(unitFormProvider.notifier)
        .deleteUnit(unit.unitId);

    if (!context.mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, 'Unit berhasil dihapus');
    } else {
      final error = ref.read(unitFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menghapus unit');
    }
  }
}
