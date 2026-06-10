import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../utils/sensor_metadata_adapter.dart';
import '../monitoring_card_header_widget.dart';

class PlantRecommendationCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final SensorMetadataAdapter metadataAdapter;

  const PlantRecommendationCardWidget({
    super.key,
    required this.data,
    required this.metadataAdapter,
  });

  @override
  Widget build(BuildContext context) {
    final recData = _extractMap(data['data']) ?? data;
    final recommendations =
        _extractMap(recData['recommendations']) ??
        _extractMap(recData['recommendation']) ??
        _extractMap(recData['recommended_plant']);
    final sensorData =
        _extractMap(recData['sensor_data']) ??
        _extractMap(recData['sensorData']);
    final items = _buildRecommendationItems(
      context,
      recommendations ?? recData,
    );

    if (recData.isEmpty || (items.isEmpty && sensorData == null)) {
      return InfoStateWidget.svg(
        svgIconPath: 'assets/icons/recomendation-filled-icon.svg',
        message: context.l10n.monitoringPlantRecommendationEmpty,
        height: 195,
      );
    }

    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonitoringCardHeaderWidget.svg(
            svgIconPath: 'assets/icons/recomendation-filled-icon.svg',
            title: _titleFor(context, recData),
            description: _subtitleFor(context, recData),
            background: AppColors.softGreen,
            tint: AppColors.success,
            trailing: items.isNotEmpty
                ? _CountBadge(
                    label: context.l10n.monitoringRecommendationActionCount(
                      items.length,
                    ),
                  )
                : null,
          ),
          if (items.isNotEmpty) ...[
            SizedBox(height: context.rh(0.016)),
            ...items.take(5).map((item) => _RecommendationRow(item: item)),
            if (items.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  context.l10n.monitoringRecommendationMoreCount(
                    items.length - 5,
                  ),
                  style: AppTextStyles.caption(
                    context,
                    size: 11,
                    color: AppColors.textSecondary,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
          ],
          if (sensorData != null && sensorData.isNotEmpty) ...[
            SizedBox(height: context.rh(0.014)),
            const Divider(color: AppColors.divider),
            SizedBox(height: context.rh(0.006)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sensorData.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    '${_sensorLabel(context, entry.key)}: ${entry.value}',
                    style: AppTextStyles.caption(context, size: 11),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  List<_RecommendationItem> _buildRecommendationItems(
    BuildContext context,
    Map<String, dynamic> recommendations,
  ) {
    final result = <_RecommendationItem>[];

    void addFromRaw(String key, String fallbackTitle, dynamic raw) {
      if (raw == null) return;
      if (raw is String) {
        final text = raw.trim();
        if (text.isEmpty) return;
        result.add(_RecommendationItem(title: fallbackTitle, message: text));
        return;
      }
      final map = _extractMap(raw);
      if (map == null || map.isEmpty) return;

      final nestedKeys = ['n', 'p', 'k'];
      final hasNestedNpk = nestedKeys.any((nestedKey) {
        return map[nestedKey] != null || map[nestedKey.toUpperCase()] != null;
      });
      if (key == 'npk' && hasNestedNpk) {
        for (final nestedKey in nestedKeys) {
          addFromRaw(
            nestedKey,
            'NPK ${nestedKey.toUpperCase()}',
            map[nestedKey] ?? map[nestedKey.toUpperCase()],
          );
        }
        return;
      }

      final message = _stringValue(
        map['pesan'] ??
            map['message'] ??
            map['description'] ??
            map['recommendation'] ??
            map['action'] ??
            map['title'],
      );
      if (message == null) return;

      result.add(
        _RecommendationItem(
          title: _stringValue(map['name'] ?? map['title']) ?? fallbackTitle,
          message: message,
          status: _stringValue(map['status']),
          dose: _doseText(map),
        ),
      );
    }

    addFromRaw(
      'npk',
      context.l10n.monitoringNpkAdjustment,
      recommendations['npk'],
    );
    addFromRaw(
      'ph',
      context.l10n.monitoringSoilPhAdjustment,
      recommendations['ph'],
    );

    final lingkungan = _extractMap(recommendations['lingkungan']);
    if (lingkungan != null) {
      for (final entry in lingkungan.entries) {
        addFromRaw(entry.key, _sensorLabel(context, entry.key), entry.value);
      }
    }

    for (final entry in recommendations.entries) {
      if (entry.key == 'npk' ||
          entry.key == 'ph' ||
          entry.key == 'lingkungan') {
        continue;
      }
      addFromRaw(entry.key, _titleFromKey(entry.key), entry.value);
    }

    return result;
  }

  String _titleFor(BuildContext context, Map<String, dynamic> data) {
    return _stringValue(
          data['plant_name'] ??
              data['plantName'] ??
              data['plant'] ??
              data['name'] ??
              data['label'],
        ) ??
        context.l10n.monitoringRecommendationSiteTitle;
  }

  String _subtitleFor(BuildContext context, Map<String, dynamic> data) {
    final cached = data['cached'] == true;
    return cached
        ? context.l10n.monitoringRecommendationCachedSubtitle
        : context.l10n.monitoringRecommendationActiveSiteSubtitle;
  }

  String _sensorLabel(BuildContext context, String key) {
    switch (key) {
      case 'nitrogen':
        return context.l10n.commonNitrogen;
      case 'phosphorus':
        return context.l10n.commonPhosphorus;
      case 'potassium':
        return context.l10n.commonPotassium;
      case 'ph':
        return context.l10n.monitoringSoilPhLabel;
      default:
        return metadataAdapter.labelFor(key);
    }
  }

  String _titleFromKey(String key) {
    return key
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String? _doseText(Map<String, dynamic> map) {
    final raw =
        map['dosis_kg_ha'] ??
        map['dosisKgHa'] ??
        map['dose_kg_ha'] ??
        map['doseKgHa'] ??
        map['dose'] ??
        map['dosis'];
    if (raw == null) return null;
    final value = raw is num
        ? raw
        : num.tryParse(raw.toString().replaceAll(',', '.'));
    if (value == null || value <= 0) return null;
    final display = value % 1 == 0
        ? value.toInt().toString()
        : value.toString();
    return '$display kg/ha';
  }

  Map<String, dynamic>? _extractMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  String? _stringValue(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}

class _RecommendationItem {
  final String title;
  final String message;
  final String? status;
  final String? dose;

  const _RecommendationItem({
    required this.title,
    required this.message,
    this.status,
    this.dose,
  });
}

class _CountBadge extends StatelessWidget {
  final String label;

  const _CountBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption(
          context,
          size: 11,
          color: AppColors.success,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  final _RecommendationItem item;

  const _RecommendationRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(
                    context,
                    size: 12,
                    weight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                if (item.status != null || item.dose != null) ...[
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (item.status != null)
                        _SmallBadge(label: item.status!, color: AppColors.info),
                      if (item.dose != null)
                        _SmallBadge(
                          label: item.dose!,
                          color: AppColors.warning,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 3),
                Text(
                  item.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    context,
                    size: 11,
                    color: AppColors.textSecondary,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption(
          context,
          size: 9,
          color: color,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}
