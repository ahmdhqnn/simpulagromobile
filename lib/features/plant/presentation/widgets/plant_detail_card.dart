import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/plant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/responsive.dart';
import 'agro_indicator_button.dart';
import 'growth_phase_button.dart';

class PlantDetailCard extends StatelessWidget {
  final Plant plant;

  const PlantDetailCard({super.key, required this.plant});

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
                'Plant',
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
                  onPressed: () {
                    // TODO: Implement more menu
                  },
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
                        child: Image.asset(
                          'assets/images/padi-perkecambahan-image.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: const AgroIndicatorButton(),
                      ),

                      // Growth Phase Button
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: GrowthPhaseButton(
                          plantId: plant.plantId,
                          plantName:
                              plant.plantType?.displayName ??
                              plant.plantName ??
                              'Plant',
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
                      const Text(
                        "Plant’s Detail",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          height: 1,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        plant.growthPhase ?? 'N/A',
                        style: const TextStyle(fontSize: 12, height: 1.8),
                      ),

                      const SizedBox(height: 12),

                      _detailRow(
                        "Types of Plants",
                        plant.plantType?.displayName ?? "-",
                      ),
                      _detailRow(
                        "Planting Date",
                        plant.plantDate != null
                            ? DateFormat('dd MMM yyyy').format(plant.plantDate!)
                            : "-",
                      ),
                      _detailRow("HST", "${plant.hst ?? 0} Day"),
                      _detailRow("Growth Phase", plant.growthPhase ?? 'N/A'),
                      _detailRow(
                        "Status",
                        plant.isActive ? "Planting" : "Harvested",
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.8,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
