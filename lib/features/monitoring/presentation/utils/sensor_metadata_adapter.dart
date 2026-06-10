import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

import '../../data/models/monitoring_models.dart';

enum SensorReadingStatus { optimal, warning, critical, offline, unknown }

class SensorMetadataAdapter {
  SensorMetadataAdapter(Iterable<DeviceSensorThresholdModel> rows) {
    for (final row in rows) {
      if (row.dsId.isEmpty) continue;
      _byDsId.putIfAbsent(row.dsId, () => row);
      if ((row.devId ?? '').isNotEmpty) {
        _byComposite['${row.devId}|${row.dsId}'] = row;
      }
    }
  }

  final Map<String, DeviceSensorThresholdModel> _byComposite = {};
  final Map<String, DeviceSensorThresholdModel> _byDsId = {};

  DeviceSensorThresholdModel? thresholdFor({
    required String dsId,
    String? devId,
  }) {
    if (dsId.isEmpty) return null;
    if (devId != null && devId.isNotEmpty) {
      final match = _byComposite['$devId|$dsId'];
      if (match != null) return match;
    }
    return _byDsId[dsId];
  }

  String labelFor(String dsId, {String? devId}) {
    final threshold = thresholdFor(dsId: dsId, devId: devId);
    final backend = _firstFilled(threshold?.dsName, threshold?.sensName);
    if (backend != null) {
      return backend;
    }
    return SensorMeta.label(dsId);
  }

  String shortLabelFor(String dsId, {String? devId}) {
    final backendLabel = labelFor(dsId, devId: devId);
    if (backendLabel == dsId) {
      return SensorMeta.shortLabel(dsId);
    }
    if (backendLabel.length <= 16) return backendLabel;
    final words = backendLabel.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length >= 2) {
      final compact = '${words.first} ${words[1]}';
      if (compact.length <= 16) return compact;
    }
    return '${backendLabel.substring(0, 15)}…';
  }

  String unitFor(String dsId, {String? devId}) {
    final threshold = thresholdFor(dsId: dsId, devId: devId);
    final backend = _firstFilled(threshold?.unitSymbol, threshold?.unitName);
    if (backend != null) {
      return backend;
    }
    return SensorMeta.unit(dsId);
  }

  Color colorFor(String dsId) => Color(SensorMeta.colorValue(dsId));

  SensorReadingStatus statusFor({
    required String dsId,
    String? devId,
    required double value,
  }) {
    if (value <= 0) return SensorReadingStatus.offline;

    final threshold = thresholdFor(dsId: dsId, devId: devId);
    if (threshold == null) return SensorReadingStatus.unknown;

    if (threshold.dsMinValue != null && value < threshold.dsMinValue!) {
      return SensorReadingStatus.critical;
    }
    if (threshold.dsMaxValue != null && value > threshold.dsMaxValue!) {
      return SensorReadingStatus.critical;
    }

    if (threshold.dsMinValWarn != null && value < threshold.dsMinValWarn!) {
      return SensorReadingStatus.warning;
    }
    if (threshold.dsMaxValWarn != null && value > threshold.dsMaxValWarn!) {
      return SensorReadingStatus.warning;
    }

    if (threshold.dsMinNormValue != null && value < threshold.dsMinNormValue!) {
      return SensorReadingStatus.warning;
    }
    if (threshold.dsMaxNormValue != null && value > threshold.dsMaxNormValue!) {
      return SensorReadingStatus.warning;
    }

    if (threshold.hasNormalRange ||
        threshold.hasWarnRange ||
        threshold.hasAbsoluteRange) {
      return SensorReadingStatus.optimal;
    }

    return SensorReadingStatus.unknown;
  }

  String statusLabel(SensorReadingStatus status, AppLocalizations l10n) {
    switch (status) {
      case SensorReadingStatus.optimal:
        return l10n.commonOptimal;
      case SensorReadingStatus.warning:
        return l10n.commonWarning;
      case SensorReadingStatus.critical:
        return l10n.commonCritical;
      case SensorReadingStatus.offline:
        return l10n.commonOffline;
      case SensorReadingStatus.unknown:
        return l10n.commonActive;
    }
  }

  String? _firstFilled(String? primary, String? secondary) {
    final candidates = [primary, secondary];
    for (final item in candidates) {
      if (item == null) continue;
      final normalized = item.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (normalized.isNotEmpty) return normalized;
    }
    return null;
  }
}
