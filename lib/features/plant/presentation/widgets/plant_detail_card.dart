import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/plant.dart';
import '../utils/plant_mutation_actions.dart';
import 'agro_indicator_button.dart';
import 'growth_phase_button.dart';
import 'plant_actions_sheet.dart';

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
      builder: (sheetCtx) => PlantActionsSheet(
        plant: plant,
        onEdit: () {
          Navigator.pop(sheetCtx);
          context.push('/plant/${plant.plantId}/edit');
        },
        onHarvest: plant.isCurrentPlanting
            ? () {
                Navigator.pop(sheetCtx);
                PlantMutationActions.confirmAndHarvest(
                  context,
                  ref,
                  plant: plant,
                );
              }
            : null,
        onDelete: isAdmin
            ? () {
                Navigator.pop(sheetCtx);
                PlantMutationActions.confirmAndDelete(
                  context,
                  ref,
                  plant: plant,
                );
              }
            : null,
      ),
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
          AppLocalizations.of(context)!.plantTitle,
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
        ? AppColors.warning
        : plant.isCurrentPlanting
        ? AppColors.success
        : AppColors.textTertiary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
