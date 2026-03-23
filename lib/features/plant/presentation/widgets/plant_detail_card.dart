import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/plant.dart';

class PlantDetailCard extends StatelessWidget {
  final Plant plant;

  const PlantDetailCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Header
          const Text(
            'Plants Overview',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              color: Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(height: 47),

          Center(
            child: Container(
              width: 350,
              height: 299,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildPlantImage(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.plantName ?? 'Plant',
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF1D1D1D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plant.growthPhase,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF1D1D1D),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: plant.isActive
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        plant.isActive ? 'Active' : 'Harvested',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: plant.isActive
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 16),

                _buildDetailRow(
                  'Types of Plants',
                  plant.plantType?.displayName ?? '-',
                ),
                _buildDetailRow('Varietas', plant.varietasId ?? '-'),
                _buildDetailRow(
                  'Planting Date',
                  plant.plantDate != null
                      ? DateFormat('dd MMMM yyyy').format(plant.plantDate!)
                      : '-',
                ),
                _buildDetailRow(
                  'HST',
                  '${plant.hst} Day${plant.hst != 1 ? 's' : ''}',
                ),
                _buildDetailRow('Growth Phase', plant.growthPhase),
                _buildDetailRow(
                  'Status',
                  plant.isActive ? 'Planting' : 'Harvested',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlantImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight.withOpacity(0.3),
            AppColors.primary.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(Icons.eco, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              plant.plantType?.displayName ?? 'Plant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D1D1D),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w300,
              color: Color(0xFF1D1D1D),
            ),
          ),
        ],
      ),
    );
  }
}
