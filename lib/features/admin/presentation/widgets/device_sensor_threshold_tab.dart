import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/device_sensor_provider.dart';
import 'admin_scaffold.dart';

class DeviceSensorThresholdTab extends ConsumerWidget {
  const DeviceSensorThresholdTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valuesAsync = ref.watch(deviceSensorThresholdValuesProvider);

    return valuesAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (rows) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(deviceSensorThresholdValuesProvider);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              if (rows.isEmpty)
                AdminEmptyState(
                  icon: Icons.tune_outlined,
                  title: context.l10n.adminNoThresholdData,
                  message: context.l10n.adminNoThresholdData,
                )
              else
                ...List.generate(rows.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.rh(0.014)),
                    child: _ThresholdCard(row: rows[index]),
                  );
                }),
            ],
          ),
        );
      },
      loading: () => buildListSkeleton(count: 6),
      error: (error, _) => AdminErrorState(
        error: error,
        onRetry: () => ref.invalidate(deviceSensorThresholdValuesProvider),
      ),
    );
  }
}

class _ThresholdCard extends StatelessWidget {
  const _ThresholdCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _value('ds_name', fallbackKeys: const ['ds_id']),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(15),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _ThresholdLine(label: 'Device', value: _value('dev_id')),
          _ThresholdLine(label: 'Sensor', value: _value('sens_id')),
          _ThresholdLine(
            label: 'Normal',
            value:
                '${_value('ds_min_norm_value', fallbackKeys: const ['min_norm'])} - ${_value('ds_max_norm_value', fallbackKeys: const ['max_norm'])}',
          ),
          _ThresholdLine(
            label: 'Warning',
            value:
                '${_value('ds_min_val_warn', fallbackKeys: const ['min_warn'])} - ${_value('ds_max_val_warn', fallbackKeys: const ['max_warn'])}',
          ),
          _ThresholdLine(
            label: 'Absolute',
            value:
                '${_value('ds_min_value', fallbackKeys: const ['ds_min', 'min_val'])} - ${_value('ds_max_value', fallbackKeys: const ['ds_max', 'max_val'])}',
          ),
        ],
      ),
    );
  }

  String _value(String key, {List<String> fallbackKeys = const []}) {
    final value = row[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
    for (final fallbackKey in fallbackKeys) {
      final fallback = row[fallbackKey];
      if (fallback != null && fallback.toString().trim().isNotEmpty) {
        return fallback.toString();
      }
    }
    return '-';
  }
}

class _ThresholdLine extends StatelessWidget {
  const _ThresholdLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
