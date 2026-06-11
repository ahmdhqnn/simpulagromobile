// ignore_for_file: invalid_annotation_target, unused_element

import 'dart:developer' as developer;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/agro_entity.dart';

part 'agro_model.freezed.dart';

void _debugLog(String message) {
  assert(() {
    developer.log(message, name: 'AgroModel');
    return true;
  }());
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;

    final parsed = double.tryParse(normalized);
    if (parsed != null) return parsed;

    final match = RegExp(
      r'[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?',
    ).firstMatch(normalized);
    if (match == null) return null;
    return double.tryParse(match.group(0)!);
  }
  return null;
}

String _normalizeJsonKey(String key) =>
    key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();

dynamic _readRaw(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key) && json[key] != null) return json[key];
  }

  final normalizedKeys = keys.map(_normalizeJsonKey).toSet();
  for (final entry in json.entries) {
    if (entry.value == null) continue;
    if (normalizedKeys.contains(_normalizeJsonKey(entry.key))) {
      return entry.value;
    }
  }

  return null;
}

double? _readDouble(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _parseNullableDouble(json[key]);
    if (value != null) return value;
  }

  final normalizedKeys = keys.map(_normalizeJsonKey).toSet();
  for (final entry in json.entries) {
    if (entry.value == null) continue;
    if (!normalizedKeys.contains(_normalizeJsonKey(entry.key))) continue;

    final value = _parseNullableDouble(entry.value);
    if (value != null) return value;
  }

  return null;
}

String? _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }

  final normalizedKeys = keys.map(_normalizeJsonKey).toSet();
  for (final entry in json.entries) {
    if (entry.value == null) continue;
    if (!normalizedKeys.contains(_normalizeJsonKey(entry.key))) continue;

    final text = entry.value.toString().trim();
    if (text.isNotEmpty) return text;
  }

  return null;
}

const _vdpValueKeys = [
  'vdp',
  'vpd',
  'v',
  'value',
  'vdpValue',
  'vpdValue',
  'vdp_value',
  'vpd_value',
  'vaporPressureDeficit',
  'vapor_pressure_deficit',
  'vaporPressureDeficitKpa',
  'vapor_pressure_deficit_kpa',
];

const _vdpEsKeys = [
  'es',
  'e_s',
  'svp',
  'saturationVaporPressure',
  'saturation_vapor_pressure',
  'saturationVaporPressureKpa',
  'saturation_vapor_pressure_kpa',
  'deficit',
  'deficitPressure',
  'deficit_pressure',
  'd',
];

const _vdpEaKeys = [
  'ea',
  'e_a',
  'avp',
  'actualVaporPressure',
  'actual_vapor_pressure',
  'actualVaporPressureKpa',
  'actual_vapor_pressure_kpa',
  'pressure',
  'vaporPressure',
  'vapor_pressure',
  'p',
];

bool _hasAnyVdpMetric(Map<String, dynamic> json) =>
    _readDouble(json, _vdpValueKeys) != null ||
    _readDouble(json, _vdpEsKeys) != null ||
    _readDouble(json, _vdpEaKeys) != null;

@freezed
class VdpModel with _$VdpModel {
  const VdpModel._();

  const factory VdpModel({
    double? vdp,
    String? status,
    double? temperature,
    double? humidity,
    double? es,
    double? ea,
    String? description,
  }) = _VdpModel;

  factory VdpModel.fromJson(Map<String, dynamic> json) {
    return VdpModel(
      vdp: _readDouble(json, _vdpValueKeys),
      status: _readString(json, ['status', 'condition', 'category']),
      temperature: _readDouble(json, [
        'temperature',
        'temp',
        'tempAvg',
        'temp_avg',
        'airTemperature',
        'air_temperature',
        'temperatureC',
        'temperature_c',
        'env_temp',
        't',
      ]),
      humidity: _readDouble(json, [
        'humidity',
        'hum',
        'relativeHumidity',
        'relative_humidity',
        'rh',
        'rhAvg',
        'rh_avg',
        'env_hum',
        'h',
      ]),
      es: _readDouble(json, _vdpEsKeys),
      ea: _readDouble(json, _vdpEaKeys),
      description: _readString(json, ['description', 'desc', 'message']),
    );
  }

  VdpEntity toEntity() => VdpEntity(
    vdp: vdp,
    temperature: temperature,
    humidity: humidity,
    es: es,
    ea: ea,
    status: status,
    description: description,
  );

  bool isValid() {
    if (vdp != null && (vdp! < 0 || vdp! > 100)) {
      _debugLog('VdpModel: vdp=$vdp out of range [0, 100]');
      return false;
    }
    if (temperature != null && (temperature! < -50 || temperature! > 60)) {
      _debugLog('VdpModel: temperature=$temperature out of range');
      return false;
    }
    if (humidity != null && (humidity! < 0 || humidity! > 100)) {
      _debugLog('VdpModel: humidity=$humidity out of range');
      return false;
    }
    return true;
  }
}

@freezed
class GddDailyModel with _$GddDailyModel {
  const GddDailyModel._();

  const factory GddDailyModel({
    String? day,
    double? tempMin,
    double? tempMax,
    double? gdd,
  }) = _GddDailyModel;

  factory GddDailyModel.fromJson(Map<String, dynamic> json) {
    double? readGdd() {
      if (json['gdd'] is num) return (json['gdd'] as num).toDouble();
      if (json['gdd'] is Map) {
        return _parseNullableDouble((json['gdd'] as Map)['gdd']);
      }
      return _parseNullableDouble(json['gdd']);
    }

    return GddDailyModel(
      day: _readString(json, ['day', 'date']),
      tempMin: _readDouble(json, ['tempMin', 'temp_min']),
      tempMax: _readDouble(json, ['tempMax', 'temp_max']),
      gdd: readGdd(),
    );
  }

  GddDailyEntity toEntity() =>
      GddDailyEntity(day: day, tempMin: tempMin, tempMax: tempMax, gdd: gdd);

  bool isValid() {
    if (gdd != null && gdd! < 0) {
      _debugLog('GddDailyModel: gdd=$gdd is negative');
      return false;
    }
    if (tempMin != null && (tempMin! < -50 || tempMin! > 60)) {
      _debugLog('GddDailyModel: tempMin=$tempMin out of range');
      return false;
    }
    if (tempMax != null && (tempMax! < -50 || tempMax! > 60)) {
      _debugLog('GddDailyModel: tempMax=$tempMax out of range');
      return false;
    }
    return true;
  }
}

@freezed
class GddModel with _$GddModel {
  const GddModel._();

  const factory GddModel({
    double? totalGDD,
    @Default([]) List<GddDailyModel> daily,
  }) = _GddModel;

  factory GddModel.fromJson(Map<String, dynamic> json) {
    return GddModel(
      totalGDD: _readDouble(json, ['totalGDD', 'totalGdd', 'total_gdd']),
      daily: (json['daily'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (item) => GddDailyModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }

  GddEntity toEntity() => GddEntity(
    totalGDD: totalGDD,
    daily: daily.map((d) => d.toEntity()).toList(),
  );

  bool get isEmpty => (totalGDD == null || totalGDD == 0) && daily.isEmpty;

  bool isValid() {
    if (totalGDD != null && totalGDD! < 0) {
      _debugLog('GddModel: totalGDD=$totalGDD is negative');
      return false;
    }
    if (daily.isEmpty) {
      _debugLog('GddModel: daily list is empty');
      return false;
    }
    for (final item in daily) {
      if (!item.isValid()) return false;
    }
    return true;
  }
}

@freezed
class EtcDailyModel with _$EtcDailyModel {
  const EtcDailyModel._();

  const factory EtcDailyModel({
    int? hst,
    String? phase,
    double? et0,
    String? day,
    double? tempMin,
    double? tempMax,
    double? rhMin,
    double? rhMax,
    double? etc,
    double? kc,
    double? waterNeeds,
    String? waterStatus,
    String? recommendation,
    String? riceType,
  }) = _EtcDailyModel;

  factory EtcDailyModel.fromJson(Map<String, dynamic> json) {
    double? readEtc() {
      final etcField = json['etc'];
      if (etcField is Map) return _parseNullableDouble(etcField['etc']);
      return _parseNullableDouble(etcField);
    }

    double? readKc() {
      final etcField = json['etc'];
      if (etcField is Map && etcField['kc'] != null) {
        return _parseNullableDouble(etcField['kc']);
      }
      return _parseNullableDouble(json['kc']);
    }

    double? readWaterNeeds() {
      final etcField = json['etc'];
      if (etcField is Map && etcField['waterNeeds'] != null) {
        return _parseNullableDouble(etcField['waterNeeds']);
      }
      return _parseNullableDouble(json['waterNeeds']);
    }

    return EtcDailyModel(
      hst: _parseNullableDouble(
        _readRaw(json, ['hst', 'currentHst', 'current_hst']),
      )?.toInt(),
      phase: _readString(json, ['phase', 'phaseName', 'phase_name']),
      et0: _readDouble(json, ['et0', 'et_0', 'referenceEt']),
      day: _readString(json, ['day', 'date']),
      tempMin: _readDouble(json, ['tempMin', 'temp_min']),
      tempMax: _readDouble(json, ['tempMax', 'temp_max']),
      rhMin: _readDouble(json, ['rhMin', 'rh_min']),
      rhMax: _readDouble(json, ['rhMax', 'rh_max']),
      etc: readEtc(),
      kc: readKc(),
      waterNeeds: readWaterNeeds(),
      waterStatus: _readString(json, ['waterStatus', 'water_status']),
      recommendation: _readString(json, [
        'recommendation',
        'recommendationText',
        'message',
      ]),
      riceType: _readString(json, ['riceType', 'rice_type']),
    );
  }

  EtcDailyEntity toEntity() => EtcDailyEntity(
    hst: hst,
    phase: phase,
    et0: et0,
    day: day,
    tempMin: tempMin,
    tempMax: tempMax,
    rhMin: rhMin,
    rhMax: rhMax,
    etc: etc,
    kc: kc,
    waterNeeds: waterNeeds,
    waterStatus: waterStatus,
    recommendation: recommendation,
    riceType: riceType,
  );

  bool get isEmpty =>
      etc == null &&
      waterNeeds == null &&
      kc == null &&
      et0 == null &&
      phase == null &&
      recommendation == null;

  bool isValid() {
    if (etc != null && etc! < 0) {
      _debugLog('EtcDailyModel: etc=$etc is negative');
      return false;
    }
    if (kc != null && (kc! < 0 || kc! > 3)) {
      _debugLog('EtcDailyModel: kc=$kc out of range [0, 3]');
      return false;
    }
    return true;
  }
}

@freezed
class AgroModel with _$AgroModel {
  const AgroModel._();

  const factory AgroModel({
    VdpModel? vdp,
    GddModel? gdd,
    @Default([]) List<EtcDailyModel> etc,
  }) = _AgroModel;

  factory AgroModel.fromJson(Map<String, dynamic> json) {
    VdpModel? vdp;
    final vdpField = _readRaw(json, ['vdp', 'vpd']);
    if (vdpField is Map) {
      vdp = VdpModel.fromJson(Map<String, dynamic>.from(vdpField));
    } else {
      final parsedVdp = _parseNullableDouble(vdpField);
      if (parsedVdp != null) {
        vdp = VdpModel.fromJson({...json, 'vdp': parsedVdp});
      } else if (_hasAnyVdpMetric(json)) {
        vdp = VdpModel.fromJson(json);
      }
    }

    GddModel? gdd;
    if (json['gdd'] is Map) {
      gdd = GddModel.fromJson(Map<String, dynamic>.from(json['gdd'] as Map));
    } else if (json['gdd'] is num) {
      gdd = GddModel(totalGDD: (json['gdd'] as num).toDouble(), daily: []);
    }

    List<EtcDailyModel> etc = [];
    if (json['etc'] is List) {
      etc = (json['etc'] as List)
          .whereType<Map>()
          .map(
            (item) => EtcDailyModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } else if (json['etc'] is Map) {
      etc = [
        EtcDailyModel.fromJson(Map<String, dynamic>.from(json['etc'] as Map)),
      ];
    } else if (json['etc'] is num) {
      etc = [EtcDailyModel(etc: (json['etc'] as num).toDouble())];
    }

    return AgroModel(vdp: vdp, gdd: gdd, etc: etc);
  }

  AgroEntity toEntity() => AgroEntity(
    vdp: vdp?.toEntity(),
    gdd: gdd?.toEntity(),
    etc: etc.map((e) => e.toEntity()).toList(),
  );

  bool get isEmpty => vdp == null && gdd == null && etc.isEmpty;

  bool isValid() {
    if (isEmpty) {
      _debugLog('AgroModel: all fields empty');
      return false;
    }
    if (vdp != null && !vdp!.isValid()) {
      _debugLog('AgroModel: vdp validation failed');
      return false;
    }
    if (gdd != null && !gdd!.isValid()) {
      _debugLog('AgroModel: gdd validation failed');
      return false;
    }
    for (final etcItem in etc) {
      if (!etcItem.isValid()) {
        _debugLog('AgroModel: EtcDailyModel failed for day=${etcItem.day}');
        return false;
      }
    }
    return true;
  }
}
