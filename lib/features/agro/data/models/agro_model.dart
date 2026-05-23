// ignore_for_file: invalid_annotation_target, unused_element

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/agro_entity.dart';

part 'agro_model.freezed.dart';

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
    double? parseD(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }
    
    return VdpModel(
      vdp: parseD(json['vdp']) ?? parseD(json['v']),
      status: json['status'] as String?,
      temperature: parseD(json['temperature']) ?? parseD(json['d']),
      humidity: parseD(json['humidity']) ?? parseD(json['p']),
      es: parseD(json['es']) ?? parseD(json['d']),
      ea: parseD(json['ea']) ?? parseD(json['p']),
      description: json['description'] as String?,
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
      if (kDebugMode) debugPrint('VdpModel: vdp=$vdp out of range [0, 100]');
      return false;
    }
    if (temperature != null && (temperature! < -50 || temperature! > 60)) {
      if (kDebugMode) {
        debugPrint('VdpModel: temperature=$temperature out of range');
      }
      return false;
    }
    if (humidity != null && (humidity! < 0 || humidity! > 100)) {
      if (kDebugMode) debugPrint('VdpModel: humidity=$humidity out of range');
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
    double? parseD(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }
    
    double? readGdd() {
      if (json['gdd'] is num) return (json['gdd'] as num).toDouble();
      if (json['gdd'] is Map) return parseD((json['gdd'] as Map)['gdd']);
      return null;
    }

    return GddDailyModel(
      day: json['day'] as String?,
      tempMin: parseD(json['tempMin']),
      tempMax: parseD(json['tempMax']),
      gdd: readGdd(),
    );
  }

  GddDailyEntity toEntity() => GddDailyEntity(day: day, tempMin: tempMin, tempMax: tempMax, gdd: gdd);

  bool isValid() {
    if (gdd != null && gdd! < 0) {
      if (kDebugMode) debugPrint('GddDailyModel: gdd=$gdd is negative');
      return false;
    }
    if (tempMin != null && (tempMin! < -50 || tempMin! > 60)) {
      if (kDebugMode) {
        debugPrint('GddDailyModel: tempMin=$tempMin out of range');
      }
      return false;
    }
    if (tempMax != null && (tempMax! < -50 || tempMax! > 60)) {
      if (kDebugMode) {
        debugPrint('GddDailyModel: tempMax=$tempMax out of range');
      }
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
    double? parseD(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }
    
    return GddModel(
      totalGDD: parseD(json['totalGDD']),
      daily: (json['daily'] as List?)?.map((e) => GddDailyModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  GddEntity toEntity() => GddEntity(
    totalGDD: totalGDD,
    daily: daily.map((d) => d.toEntity()).toList(),
  );

  bool get isEmpty => (totalGDD == null || totalGDD == 0) && daily.isEmpty;

  bool isValid() {
    if (totalGDD != null && totalGDD! < 0) {
      if (kDebugMode) debugPrint('GddModel: totalGDD=$totalGDD is negative');
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
    String? day,
    double? tempMin,
    double? tempMax,
    double? rhMin,
    double? rhMax,
    double? etc,
    double? kc,
    double? waterNeeds,
  }) = _EtcDailyModel;

  factory EtcDailyModel.fromJson(Map<String, dynamic> json) {
    double? parseD(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }
    
    double? readEtc() {
      final etcField = json['etc'];
      if (etcField is Map) return parseD(etcField['etc']);
      return parseD(etcField);
    }
    
    double? readKc() {
      final etcField = json['etc'];
      if (etcField is Map && etcField['kc'] != null) return parseD(etcField['kc']);
      return parseD(json['kc']);
    }
    
    double? readWaterNeeds() {
      final etcField = json['etc'];
      if (etcField is Map && etcField['waterNeeds'] != null) return parseD(etcField['waterNeeds']);
      return parseD(json['waterNeeds']);
    }

    return EtcDailyModel(
      day: json['day'] as String?,
      tempMin: parseD(json['tempMin']),
      tempMax: parseD(json['tempMax']),
      rhMin: parseD(json['rhMin']),
      rhMax: parseD(json['rhMax']),
      etc: readEtc(),
      kc: readKc(),
      waterNeeds: readWaterNeeds(),
    );
  }

  EtcDailyEntity toEntity() => EtcDailyEntity(
    day: day,
    tempMin: tempMin,
    tempMax: tempMax,
    rhMin: rhMin,
    rhMax: rhMax,
    etc: etc,
    kc: kc,
    waterNeeds: waterNeeds,
  );

  bool get isEmpty => etc == null && waterNeeds == null && kc == null;

  bool isValid() {
    if (etc != null && etc! < 0) {
      if (kDebugMode) debugPrint('EtcDailyModel: etc=$etc is negative');
      return false;
    }
    if (kc != null && (kc! < 0 || kc! > 3)) {
      if (kDebugMode) debugPrint('EtcDailyModel: kc=$kc out of range [0, 3]');
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
    if (json['vdp'] is Map<String, dynamic>) {
      vdp = VdpModel.fromJson(json['vdp'] as Map<String, dynamic>);
    } else if (json['vdp'] is num) {
      vdp = VdpModel(vdp: (json['vdp'] as num).toDouble());
    }

    GddModel? gdd;
    if (json['gdd'] is Map<String, dynamic>) {
      gdd = GddModel.fromJson(json['gdd'] as Map<String, dynamic>);
    } else if (json['gdd'] is num) {
      gdd = GddModel(totalGDD: (json['gdd'] as num).toDouble(), daily: []);
    }

    List<EtcDailyModel> etc = [];
    if (json['etc'] is List) {
      etc = (json['etc'] as List).map((e) => EtcDailyModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (json['etc'] is Map<String, dynamic>) {
      etc = [EtcDailyModel.fromJson(json['etc'] as Map<String, dynamic>)];
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
      if (kDebugMode) debugPrint('AgroModel: all fields empty');
      return false;
    }
    if (vdp != null && !vdp!.isValid()) {
      if (kDebugMode) debugPrint('AgroModel: vdp validation failed');
      return false;
    }
    if (gdd != null && !gdd!.isValid()) {
      if (kDebugMode) debugPrint('AgroModel: gdd validation failed');
      return false;
    }
    for (final etcItem in etc) {
      if (!etcItem.isValid()) {
        if (kDebugMode) {
          debugPrint('AgroModel: EtcDailyModel failed for day=${etcItem.day}');
        }
        return false;
      }
    }
    return true;
  }
}
