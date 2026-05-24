import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import 'agro_indicator_button.dart';
import 'growth_phase_button.dart';

/// Card utama yang menampilkan gambar tanaman aktif beserta detail-nya.
/// Ditampilkan di [PlantScreen] saat ada tanaman yang sedang tumbuh.
/// Icon more (···) di pojok kanan atas membuka bottom sheet aksi:
///   - Edit Tanaman
///   - Panen Tanaman (hanya jika isCurrentPlanting)
///   - Delete Tanaman (hanya Admin)
class PlantDetailCard extends ConsumerWidget {
  final Plant plant;

  const PlantDetailCard({super.key, required this.plant});

  // ─── Plant image per crop type ─────────────────────────────────────────────

  String get _plantImage {
    // Semua tipe saat ini menggunakan aset yang sama.
    // Ganti per-case saat aset spesifik tersedia.
    return 'assets/images/padi-perkecambahan-image.png';
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlantCardHeader(onMoreTap: () => _showMoreActions(context, ref)),
          SizedBox(height: context.rh(0.03)),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _PlantImageSection(plant: plant, image: _plantImage),
                ),
                SizedBox(height: context.rh(0.02)),
                _PlantInfoSection(plant: plant),
                SizedBox(height: context.rh(0.02)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── More actions bottom sheet ─────────────────────────────────────────────

  void _showMoreActions(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.read(authProvider).isAdmin;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => _PlantActionsSheet(
        plant: plant,
        isAdmin: isAdmin,
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

  // ─── Harvest ───────────────────────────────────────────────────────────────

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

  // ─── Delete ────────────────────────────────────────────────────────────────

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

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

/// Header row: judul "Tanaman" + tombol more (···)
class _PlantCardHeader extends StatelessWidget {
  final VoidCallback onMoreTap;

  const _PlantCardHeader({required this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tanaman',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(28),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
        CircularBackButtonWidget(
          onPressed: onMoreTap,
          svgIconPath: 'assets/icons/more-icon.svg',
        ),
      ],
    );
  }
}

/// Area gambar tanaman dengan tombol Growth Phase & Agro Indicator
class _PlantImageSection extends StatelessWidget {
  final Plant plant;
  final String image;

  const _PlantImageSection({required this.plant, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Image.asset(image, fit: BoxFit.contain)),
        Positioned(right: 0, bottom: 0, child: const AgroIndicatorButton()),
        Positioned(
          left: 0,
          bottom: 0,
          child: GrowthPhaseButton(
            siteId: plant.siteId ?? '',
            plantName:
                plant.plantType?.displayName ?? plant.plantName ?? 'Tanaman',
          ),
        ),
      ],
    );
  }
}

/// Card info detail tanaman di bagian bawah
class _PlantInfoSection extends StatelessWidget {
  final Plant plant;

  const _PlantInfoSection({required this.plant});

  @override
  Widget build(BuildContext context) {
    final statusColor = plant.isHarvested
        ? Colors.orange
        : plant.isCurrentPlanting
        ? Colors.green
        : Colors.grey;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plant.displayName,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(22),
              fontWeight: FontWeight.w300,
              height: 1.0,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            plant.growthPhase ?? '-',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(12),
              height: 1.8,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: 'Jenis Tanaman',
            value: plant.plantType?.displayName ?? '-',
          ),
          _DetailRow(
            label: 'Tanggal Tanam',
            value: plant.plantDate != null
                ? DateFormat('dd MMM yyyy').format(plant.plantDate!)
                : '-',
          ),
          _DetailRow(
            label: 'HST',
            value: plant.hst != null ? '${plant.hst} Hari' : '-',
          ),
          _DetailRow(label: 'Fase Tumbuh', value: plant.growthPhase ?? '-'),
          _DetailRow(
            label: 'Status',
            value: plant.statusText,
            valueColor: statusColor,
          ),
          if (plant.isHarvested && plant.plantHarvest != null)
            _DetailRow(
              label: 'Tanggal Panen',
              value: DateFormat('dd MMM yyyy').format(plant.plantHarvest!),
            ),
        ],
      ),
    );
  }
}

/// Satu baris label–value di info card
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                fontWeight: FontWeight.w500,
                height: 1.8,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                height: 1.8,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet aksi tanaman (Edit / Panen / Delete)
class _PlantActionsSheet extends StatelessWidget {
  final Plant plant;
  final bool isAdmin;
  final VoidCallback onEdit;
  final VoidCallback? onHarvest;
  final VoidCallback? onDelete;

  const _PlantActionsSheet({
    required this.plant,
    required this.isAdmin,
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
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
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
          // Edit
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
          // Panen (hanya jika sedang tumbuh)
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
          // Delete (hanya Admin)
          if (onDelete != null)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                'Delete Tanaman',
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
