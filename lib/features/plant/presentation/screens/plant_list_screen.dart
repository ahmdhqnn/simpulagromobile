import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';

/// Daftar semua tanaman untuk site yang dipilih.
/// Setiap card memiliki tombol more (⋮) dengan aksi:
///   - Edit Tanaman
///   - Panen Tanaman (hanya jika isCurrentPlanting)
///   - Hapus Tanaman (hanya Admin)
class PlantListScreen extends ConsumerWidget {
  const PlantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final plantsAsync = ref.watch(plantsProvider);

    if (siteId == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F0F0),
        body: Center(child: Text('Pilih lokasi terlebih dahulu')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: plantsAsync.when(
          loading: () => Column(
            children: [
              const _ListHeader(),
              Expanded(child: buildListSkeleton(count: 5, type: 'plant')),
            ],
          ),
          error: (error, _) => _ListErrorState(error: error),
          data: (plants) => plants.isEmpty
              ? const Column(
                  children: [
                    _ListHeader(),
                    Expanded(child: _EmptyState()),
                  ],
                )
              : _PlantList(plants: plants),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ListHeader extends StatelessWidget {
  const _ListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          CircularBackButtonWidget(
            onPressed: () => context.push('/plant/create'),
            svgIconPath: 'assets/icons/plus-outline-icon.svg',
          ),
        ],
      ),
    );
  }
}

// ─── List ─────────────────────────────────────────────────────────────────────

class _PlantList extends ConsumerWidget {
  final List<Plant> plants;

  const _PlantList({required this.plants});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await refreshPlantCache(ref);
      },
      child: Column(
        children: [
          const _ListHeader(),
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.01),
              ),
              itemCount: plants.length,
              separatorBuilder: (_, __) => SizedBox(height: context.rh(0.014)),
              itemBuilder: (_, index) => _PlantCard(plant: plants[index]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Plant card ───────────────────────────────────────────────────────────────

class _PlantCard extends ConsumerWidget {
  final Plant plant;

  const _PlantCard({required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(plant);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () => context.push('/plant/${plant.plantId}'),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardTopRow(
                plant: plant,
                statusColor: statusColor,
                onMoreTap: () => _showActions(context, ref),
              ),
              const SizedBox(height: 16),
              _CardChipRow(plant: plant),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(Plant p) {
    if (p.isHarvested) return Colors.orange;
    if (p.isCurrentPlanting) return Colors.green;
    return Colors.grey;
  }

  // ─── Actions bottom sheet ──────────────────────────────────────────────────

  void _showActions(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.read(authProvider).isAdmin;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => _PlantActionsSheet(
        plant: plant,
        onEdit: () {
          Navigator.pop(sheetCtx);
          context.push('/plant/${plant.plantId}/edit');
        },
        onHarvest: plant.isCurrentPlanting
            ? () {
                Navigator.pop(sheetCtx);
                _confirmHarvest(context, ref);
              }
            : null,
        onDelete: isAdmin
            ? () {
                Navigator.pop(sheetCtx);
                _confirmDelete(context, ref);
              }
            : null,
      ),
    );
  }

  Future<void> _confirmHarvest(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Panen Tanaman?',
      message:
          '"${plant.displayName}" akan ditandai sebagai sudah dipanen. Aksi ini tidak dapat dibatalkan.',
      confirmText: 'Ya, Panen',
      confirmColor: Colors.orange,
    );
    if (!confirmed || !context.mounted) return;

    final siteId = plant.siteId ?? ref.read(selectedSiteIdProvider);
    if (siteId == null) {
      SnackbarHelper.showError(context, 'Site tidak valid');
      return;
    }

    final result = await ref.read(harvestPlantUseCaseProvider)(
      siteId,
      plant.plantId,
    );
    if (!context.mounted) return;

    await result.fold<Future<void>>(
      (f) async =>
          SnackbarHelper.showError(context, 'Gagal panen: ${f.message}'),
      (_) async {
        await refreshPlantCache(ref, plantId: plant.plantId);
        if (!context.mounted) return;
        SnackbarHelper.showSuccess(
          context,
          '"${plant.displayName}" berhasil ditandai sudah panen',
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: 'Tanaman',
      additionalMessage:
          '"${plant.displayName}" akan dihapus secara permanen. Aksi ini tidak dapat dibatalkan.',
    );
    if (!confirmed || !context.mounted) return;

    final siteId = plant.siteId ?? ref.read(selectedSiteIdProvider);
    if (siteId == null) {
      SnackbarHelper.showError(context, 'Site tidak valid');
      return;
    }

    final result = await ref.read(deletePlantUseCaseProvider)(
      siteId,
      plant.plantId,
    );
    if (!context.mounted) return;

    await result.fold<Future<void>>(
      (f) async =>
          SnackbarHelper.showError(context, 'Gagal hapus: ${f.message}'),
      (_) async {
        await refreshPlantCache(
          ref,
          plantId: plant.plantId,
          refreshDetail: false,
        );
        if (!context.mounted) return;
        SnackbarHelper.showSuccess(
          context,
          '"${plant.displayName}" berhasil dihapus',
        );
      },
    );
  }
}

// ─── Card sub-widgets ─────────────────────────────────────────────────────────

class _CardTopRow extends StatelessWidget {
  final Plant plant;
  final Color statusColor;
  final VoidCallback onMoreTap;

  const _CardTopRow({
    required this.plant,
    required this.statusColor,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon crop type
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            plant.plantType?.icon ?? '🌱',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 12),
        // Nama & tipe
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.displayName,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                plant.plantType?.displayName ?? 'Unknown',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        // More button
        IconButton(
          tooltip: 'Aksi tanaman',
          onPressed: onMoreTap,
          icon: const Icon(Icons.more_vert),
          color: AppColors.textPrimary.withValues(alpha: 0.7),
        ),
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            plant.statusText,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(12),
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardChipRow extends StatelessWidget {
  final Plant plant;

  const _CardChipRow({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoChip(
            label: 'HST',
            value: '${plant.hst ?? 0} hari',
            icon: Icons.calendar_today,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _InfoChip(
            label: 'Fase',
            value: plant.growthPhase ?? 'Unknown',
            icon: Icons.eco,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(10),
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Actions sheet (shared) ───────────────────────────────────────────────────

/// Bottom sheet aksi tanaman — digunakan di [_PlantCard] dan [PlantDetailCard].
class _PlantActionsSheet extends StatelessWidget {
  final Plant plant;
  final VoidCallback onEdit;
  final VoidCallback? onHarvest;
  final VoidCallback? onDelete;

  const _PlantActionsSheet({
    required this.plant,
    required this.onEdit,
    this.onHarvest,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                plant.displayName,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
            title: Text(
              'Edit Tanaman',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(14),
              ),
            ),
            onTap: onEdit,
          ),
          if (onHarvest != null)
            ListTile(
              leading: const Icon(Icons.agriculture, color: Colors.orange),
              title: Text(
                'Panen Tanaman',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(14),
                  color: Colors.orange,
                ),
              ),
              onTap: onHarvest,
            ),
          if (onDelete != null)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                'Hapus Tanaman',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(14),
                  color: Colors.red,
                ),
              ),
              onTap: onDelete,
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Empty & Error states ─────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco,
            size: context.rw(0.205).clamp(60.0, 80.0),
            color: AppColors.textPrimary.withValues(alpha: 0.3),
          ),
          SizedBox(height: context.rh(0.02)),
          Text(
            'Belum ada tanaman',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: context.rh(0.01)),
          Text(
            'Tambahkan tanaman pertama Anda',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(14),
              color: AppColors.textPrimary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListErrorState extends ConsumerWidget {
  final Object error;

  const _ListErrorState({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const _ListHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(context.rw(0.061)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: context.rw(0.164).clamp(48.0, 72.0),
                    color: AppColors.error,
                  ),
                  SizedBox(height: context.rh(0.02)),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.rh(0.01)),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(14),
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: context.rh(0.03)),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(plantsProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: Text(
                      'Coba Lagi',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
