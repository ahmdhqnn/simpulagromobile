import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../domain/entities/recommendation_bundle.dart';

class NpkNutrientDetail {
  final String label;
  final String name;
  final String status;
  final double? value;
  final String action;

  NpkNutrientDetail({
    required this.label,
    required this.name,
    required this.status,
    required this.value,
    required this.action,
  });
}

class RecommendationParametersCardWidget extends StatelessWidget {
  final RecommendationBundle parameters;

  const RecommendationParametersCardWidget({
    super.key,
    required this.parameters,
  });

  List<NpkNutrientDetail> _parseNpkDetails(String pesan, RecommendationSensorData? sensorData) {
    final details = <NpkNutrientDetail>[];
    final parts = pesan.split('|');

    final nutrientNames = {
      'N': 'Nitrogen',
      'P': 'Fosfor (Phosphorus)',
      'K': 'Kalium (Potassium)',
    };

    String statusFromActionText(String actionText) {
      final lower = actionText.toLowerCase();
      if (lower.contains('rendah') ||
          lower.contains('kurang') ||
          lower.contains('tambah') ||
          lower.contains('deficient') ||
          lower.contains('low')) {
        return 'Kekurangan';
      }
      if (lower.contains('tinggi') ||
          lower.contains('berlebih') ||
          lower.contains('excess') ||
          lower.contains('high')) {
        return 'Kelebihan';
      }
      return 'Optimal';
    }

    for (final part in parts) {
      final splitPart = part.split(':');
      if (splitPart.length < 2) continue;
      final label = splitPart[0].trim().toUpperCase();
      if (!nutrientNames.containsKey(label)) continue;

      final action = splitPart.sublist(1).join(':').trim();

      double? value;
      if (label == 'N') value = sensorData?.nitrogen?.toDouble();
      if (label == 'P') value = sensorData?.phosphorus?.toDouble();
      if (label == 'K') value = sensorData?.potassium?.toDouble();

      details.add(NpkNutrientDetail(
        label: label,
        name: nutrientNames[label]!,
        status: statusFromActionText(action),
        value: value,
        action: action,
      ));
    }
    return details;
  }

  Widget _buildNpkCard(BuildContext context, NpkNutrientDetail detail) {
    final statusColor = switch (detail.status) {
      'Kekurangan' => AppColors.error,
      'Kelebihan' => AppColors.warning,
      _ => AppColors.success,
    };
    final symbolBgColor = switch (detail.label) {
      'N' => Colors.blue.shade50,
      'P' => Colors.purple.shade50,
      _ => Colors.orange.shade50,
    };
    final symbolTextColor = switch (detail.label) {
      'N' => Colors.blue.shade700,
      'P' => Colors.purple.shade700,
      _ => Colors.orange.shade700,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: symbolBgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    detail.label,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.w800,
                      color: symbolTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.name,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(13),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (detail.value != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Kandungan: ${detail.value!.toStringAsFixed(1)} mg/kg',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: context.sp(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  detail.status,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  detail.action,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhSpectrumSlider(BuildContext context, double phValue) {
    final clampedPh = phValue.clamp(0.0, 14.0);
    final positionFraction = clampedPh / 14.0;

    String phCategory = 'Netral';
    Color phColor = Colors.green;
    String phDescription = 'Kondisi pH tanah ideal untuk sebagian besar tanaman.';
    if (clampedPh < 6.0) {
      phCategory = 'Asam (Tinggi)';
      phColor = Colors.orange;
      phDescription = 'Tanah cenderung asam. Penambahan kapur pertanian (Dolomit) mungkin diperlukan.';
    } else if (clampedPh > 7.5) {
      phCategory = 'Basa (Alkali)';
      phColor = Colors.blue;
      phDescription = 'Tanah cenderung basa. Penambahan belerang atau bahan organik mungkin diperlukan.';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tingkat Keasaman Tanah',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(12),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'pH $phValue',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: context.sp(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: phColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          phCategory,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(10),
                            fontWeight: FontWeight.bold,
                            color: phColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final pointerOffset = positionFraction * constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.orange,
                          Colors.green,
                          Colors.blue,
                          Colors.purple,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: pointerOffset - 6,
                    top: -6,
                    child: Container(
                      width: 12,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: phColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 (Asam)', style: AppTextStyles.hint(context).copyWith(fontSize: 10)),
              Text('7 (Netral)', style: AppTextStyles.hint(context).copyWith(fontSize: 10)),
              Text('14 (Basa)', style: AppTextStyles.hint(context).copyWith(fontSize: 10)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            phDescription,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(11),
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final npkDetails = parameters.npk != null
        ? _parseNpkDetails(parameters.npk!.pesan, parameters.sensorData)
        : <NpkNutrientDetail>[];

    final phValue = parameters.sensorData?.ph?.toDouble();

    final showVisualNpk = npkDetails.isNotEmpty;
    final showVisualPh = phValue != null;

    final hasEnvironmentalData = parameters.sensorData != null &&
        (parameters.sensorData!.envTemp != null ||
            parameters.sensorData!.envHum != null ||
            parameters.sensorData!.soilTemp != null ||
            parameters.sensorData!.soilHum != null);

    return AppCardWidget(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.recommendationParametersTitle,
            style: AppTextStyles.cardTitle(context),
          ),
          const SizedBox(height: 12),
          if (showVisualNpk) ...[
            ...npkDetails.map((detail) => _buildNpkCard(context, detail)),
            if (parameters.npk!.dosisKgHa > 0) ...[
              const SizedBox(height: 4),
              _buildRow(
                context,
                context.l10n.recommendationNpkDoseLabel,
                '${_formatNumber(parameters.npk!.dosisKgHa)} kg/ha',
              ),
            ],
          ] else if (parameters.npk != null) ...[
            _buildRow(
              context,
              context.l10n.recommendationNpkStatusLabel,
              parameters.npk!.status,
            ),
            _buildRow(
              context,
              context.l10n.recommendationNpkDoseLabel,
              _formatDose(context, parameters.npk!),
            ),
          ],

          if (showVisualPh) ...[
            if (showVisualNpk) const SizedBox(height: 12),
            _buildPhSpectrumSlider(context, phValue),
            if (parameters.ph != null && parameters.ph!.dosisKgHa > 0) ...[
              const SizedBox(height: 8),
              _buildRow(
                context,
                context.l10n.recommendationPhDoseLabel,
                '${_formatNumber(parameters.ph!.dosisKgHa)} kg/ha',
              ),
            ],
          ] else if (parameters.ph != null) ...[
            _buildRow(
              context,
              context.l10n.recommendationPhStatusLabel,
              parameters.ph!.status,
            ),
            _buildRow(
              context,
              context.l10n.recommendationPhDoseLabel,
              _formatDose(context, parameters.ph!),
            ),
          ],

          if (parameters.sensorData != null && !showVisualNpk && !showVisualPh) ...[
            const Divider(height: 20, color: AppColors.divider),
            if (parameters.sensorData!.nitrogen != null)
              _buildRow(
                context,
                context.l10n.commonNitrogen,
                _formatNumber(parameters.sensorData!.nitrogen!),
              ),
            if (parameters.sensorData!.phosphorus != null)
              _buildRow(
                context,
                context.l10n.commonPhosphorus,
                _formatNumber(parameters.sensorData!.phosphorus!),
              ),
            if (parameters.sensorData!.potassium != null)
              _buildRow(
                context,
                context.l10n.commonPotassium,
                _formatNumber(parameters.sensorData!.potassium!),
              ),
            if (parameters.sensorData!.ph != null)
              _buildRow(
                context,
                'pH',
                _formatNumber(parameters.sensorData!.ph!),
              ),
          ],

          if (hasEnvironmentalData) ...[
            const Divider(height: 20, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Parameter Lingkungan & Tanah',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (parameters.sensorData!.envTemp != null)
              _buildRow(
                context,
                'Suhu Udara',
                '${_formatNumber(parameters.sensorData!.envTemp!)} °C',
              ),
            if (parameters.sensorData!.envHum != null)
              _buildRow(
                context,
                'Kelembaban Udara',
                '${_formatNumber(parameters.sensorData!.envHum!)} %',
              ),
            if (parameters.sensorData!.soilTemp != null)
              _buildRow(
                context,
                'Suhu Tanah',
                '${_formatNumber(parameters.sensorData!.soilTemp!)} °C',
              ),
            if (parameters.sensorData!.soilHum != null)
              _buildRow(
                context,
                'Kelembaban Tanah',
                '${_formatNumber(parameters.sensorData!.soilHum!)} %',
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDose(BuildContext context, RecommendationActionResult result) {
    if (result.dosisKgHa > 0) {
      return '${_formatNumber(result.dosisKgHa)} kg/ha';
    }

    final text = '${result.status} ${result.pesan}'.toLowerCase();
    if (text.contains('normal') ||
        text.contains('aman') ||
        text.contains('tidak diperlukan') ||
        text.contains('tidak perlu')) {
      return context.l10n.recommendationNoAdditionalDose;
    }

    return context.l10n.recommendationBackendDataUnavailable;
  }

  String _formatNumber(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  }
}
