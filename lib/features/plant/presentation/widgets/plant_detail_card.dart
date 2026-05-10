import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/plant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/responsive.dart';
import 'agro_indicator_button.dart';
import 'growth_phase_button.dart';

class PlantDetailCard extends StatelessWidget {
  final Plant plant;

  const PlantDetailCard({super.key, required this.plant});

  /// Gambar tanaman berdasarkan jenis crop
  String get _plantImage {
    switch (plant.plantType) {
      case CropType.JAGUNG:
        return 'assets/images/padi-perkecambahan-image.png';
      case CropType.KEDELAI:
        return 'assets/images/padi-perkecambahan-image.png';
      case CropType.PADI:
      default:
        return 'assets/images/padi-perkecambahan-image.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tanaman',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(28),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                  height: 1.0,
                ),
              ),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/more-icon.svg',
                    width: 28,
                    height: 28,
                  ),
                  onPressed: () => context.push('/plant/${plant.plantId}'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(_plantImage, fit: BoxFit.contain),
                      ),

                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: const AgroIndicatorButton(),
                      ),

                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: GrowthPhaseButton(
                          siteId: plant.siteId ?? '',
                          plantName:
                              plant.plantType?.displayName ??
                              plant.plantName ??
                              'Tanaman',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
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
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(22),
                          fontWeight: FontWeight.w300,
                          height: 1,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        plant.growthPhase ?? '-',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          height: 1.8,
                          color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _detailRow(
                        context,
                        "Jenis Tanaman",
                        plant.plantType?.displayName ?? "-",
                      ),
                      _detailRow(
                        context,
                        "Tanggal Tanam",
                        plant.plantDate != null
                            ? DateFormat('dd MMM yyyy').format(plant.plantDate!)
                            : "-",
                      ),
                      _detailRow(
                        context,
                        "HST",
                        plant.hst != null ? "${plant.hst} Hari" : "-",
                      ),
                      _detailRow(
                        context,
                        "Fase Tumbuh",
                        plant.growthPhase ?? '-',
                      ),
                      _detailRow(
                        context,
                        "Status",
                        plant.statusText,
                        valueColor: plant.isHarvested
                            ? Colors.orange
                            : plant.isActive
                            ? Colors.green
                            : Colors.grey,
                      ),
                      if (plant.isHarvested && plant.plantHarvest != null)
                        _detailRow(
                          context,
                          "Tanggal Panen",
                          DateFormat('dd MMM yyyy').format(plant.plantHarvest!),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w500,
                height: 1.8,
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                height: 1.8,
                color: valueColor ?? const Color(0xFF1D1D1D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
