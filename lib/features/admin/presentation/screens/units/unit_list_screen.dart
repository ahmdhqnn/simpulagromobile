import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_list_item.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/unit.dart';
import 'package:simpulagromobile/l10n/l10n.dart';

class UnitListScreen extends ConsumerWidget {
  const UnitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitListAsync = ref.watch(adminUnitListProvider);

    return PermissionGuardScreen(
      permission: 'unit:read',
      child: AdminScaffold(
        title: context.l10n.adminUnitTitle,
        action: PermissionGuard(
          permission: 'unit:create',
          child: AdminAddButton(
            onTap: () => context.push('/admin/units/create'),
          ),
        ),
        body: unitListAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (units) {
            if (units.isEmpty) {
              return AdminEmptyState(
                icon: Icons.straighten_outlined,
                title: context.l10n.adminNoUnits,
                message: context.l10n.adminNoUnitsMessage,
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF1B5E20),
              onRefresh: () async {
                ref.invalidate(adminUnitListProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                itemCount: units.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: Text(
                        context.l10n.adminUnitTitle,
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
                  final unit = units[index - 1];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _UnitCard(unit: unit),
                  );
                },
              ),
            );
          },
          loading: () => const AdminLoadingState(),
          error: (error, _) => AdminErrorState(
            error: error,
            onRetry: () => ref.invalidate(adminUnitListProvider),
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
    return AdminListItem(
      title: unit.displayNameWithSymbol,
      subtitle: context.l10n.adminIdPrefix(unit.unitId),
      icon: Icons.straighten,
      iconColor: unit.isActive ? const Color(0xFFAB47BC) : Colors.grey,
      isActive: unit.isActive,
      onTap: () => _showOptions(context, ref),
      badges: [
        if (unit.unitSymbol != null)
          AdminBadge(
            label: unit.unitSymbol!,
            color: const Color(0xFFAB47BC),
            icon: Icons.text_fields,
          ),
        if (unit.unitDesc != null)
          AdminBadge(
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                unit.displayNameWithSymbol,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                context.l10n.adminUnitReadonlyMessage,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
