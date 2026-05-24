import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_list_item.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/unit.dart';

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
                itemCount: units.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.014)),
                      child: Text(
                        'Unit',
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
                'Data Unit bersifat read-only. Perubahan dan penghapusan unit tidak didukung oleh sistem backend saat ini.',
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
