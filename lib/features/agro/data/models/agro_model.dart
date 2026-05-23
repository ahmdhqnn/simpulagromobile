/// Models for /api/sites/:siteId/agro endpoint
library;

import 'package:flutter/foundation.dart';

class VdpModel {
  final double? vdp;
  final String? status;
  final double? temperature;
  final double? humidity;
  final double? es;
  final double? ea;
  final String? description;

  const VdpModel({
    this.vdp,
    this.status,
    this.temperature,
    this.humidity,
    this.es,
    this.ea,
    this.description,
  });

  factory VdpModel.fromJson(Map<String, dynamic> json) {
    double? parseD(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return VdpModel(
      vdp: parseD(json['vdp']) ?? parseD(json['v']),
      status: json['status']?.toString(),
      temperature: parseD(json['temperature']) ?? parseD(json['d']),
      humidity: parseD(json['humidity']) ?? parseD(json['p']),
      es: parseD(json['es']),
      ea: parseD(json['ea']),
      description: json['description']?.toString(),
    );
  }

  /// Validates VdpModel values within expected ranges
  /// - vdp: 0-100 (vapor pressure deficit in kPa)
  /// - temperature: -50 to 60 °C
  /// - humidity: 0-100 %RH
  bool isValid() {
    if (vdp != null && (vdp! < 0 || vdp! > 100)) {
      if (kDebugMode) {
        debugPrint('VdpModel: vdp=$vdp is out of range [0, 100]');
      }
      return false;
    }
    if (temperature != null && (temperature! < -50 || temperature! > 60)) {
      if (kDebugMode) {
        debugPrint('VdpModel: temperature=$temperature is out of range [-50, 60]');
      }
      return false;
    }
    if (humidity != null && (humidity! < 0 || humidity! > 100)) {
      if (kDebugMode) {
        debugPrint('VdpModel: humidity=$humidity is out of range [0, 100]');
      }
      return false;
    }
    return true;
  }
}

class GddDailyModel {
  final String? day;
  final double? tempMin;
  final double? tempMax;
  final double? gdd;

  const GddDailyModel({this.day, this.tempMin, this.tempMax, this.gdd});

  factory GddDailyModel.fromJson(Map<String, dynamic> json) {
    return GddDailyModel(
      day: json['day']?.toString(),
      tempMin: (json['tempMin'] as num?)?.toDouble(),
      tempMax: (json['tempMax'] as num?)?.toDouble(),
      // 'gdd' bisa berupa num atau nested map
      gdd: json['gdd'] is num
          ? (json['gdd'] as num).toDouble()
          : (json['gdd'] is Map
                ? ((json['gdd'] as Map)['gdd'] as num?)?.toDouble()
                : null),
    );
  }

  /// Validates GddDailyModel values
  /// - gdd: must be >= 0 (Growing Degree Days)
  /// - temperature values: -50 to 60 °C
  bool isValid() {
    if (gdd != null && gdd! < 0) {
      if (kDebugMode) {
        debugPrint('GddDailyModel: gdd=$gdd is negative');
      }
      return false;
    }
    if (tempMin != null && (tempMin! < -50 || tempMin! > 60)) {
      if (kDebugMode) {
        debugPrint('GddDailyModel: tempMin=$tempMin is out of range [-50, 60]');
      }
      return false;
    }
    if (tempMax != null && (tempMax! < -50 || tempMax! > 60)) {
      if (kDebugMode) {
        debugPrint('GddDailyModel: tempMax=$tempMax is out of range [-50, 60]');
      }
      return false;
    }
    return true;
  }
}

class GddModel {
  final double? totalGDD;
  final List<GddDailyModel> daily;

  const GddModel({this.totalGDD, this.daily = const []});

  factory GddModel.fromJson(Map<String, dynamic> json) {
    List<GddDailyModel> dailyList = const [];
    final dailyRaw = json['daily'];
    if (dailyRaw is List) {
      dailyList = dailyRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => GddDailyModel.fromJson(e))
          .toList();
    }
    return GddModel(
      totalGDD: (json['totalGDD'] as num?)?.toDouble(),
      daily: dailyList,
    );
  }

  /// Validates GddModel structure and values
  /// - totalGDD: must be >= 0 if present
  /// - daily list: should not be empty if GddModel exists
  /// - all daily items: must pass individual validation
  bool isValid() {
    if (totalGDD != null && totalGDD! < 0) {
      if (kDebugMode) {
        debugPrint('GddModel: totalGDD=$totalGDD is negative');
      }
      return false;
    }
    
    if (daily.isEmpty) {
      if (kDebugMode) {
        debugPrint('GddModel: daily list is empty');
      }
      return false;
    }
    
    for (final item in daily) {
      if (!item.isValid()) {
        return false;
      }
    }
    
    return true;
  }

  /// Check if GddModel has meaningful data
  bool get isEmpty => (totalGDD == null || totalGDD == 0) && daily.isEmpty;
}

class EtcDailyModel {
  final String? day;
  final double? tempMin;
  final double? tempMax;
  final double? rhMin;
  final double? rhMax;
  final double? etc;
  final double? kc;
  final double? waterNeeds;

  const EtcDailyModel({
    this.day,
    this.tempMin,
    this.tempMax,
    this.rhMin,
    this.rhMax,
    this.etc,
    this.kc,
    this.waterNeeds,
  });

  factory EtcDailyModel.fromJson(Map<String, dynamic> json) {
    // API bisa mengembalikan 'etc' sebagai:
    // 1. double langsung: { "etc": 5.2, "day": "...", ... }
    // 2. nested map: { "etc": { "etc": 5.2, "kc": 1.1, "waterNeeds": 5.5 }, ... }
    final etcField = json['etc'];
    Map<String, dynamic>? etcMap;
    double? etcValue;

    if (etcField is Map) {
      etcMap = etcField as Map<String, dynamic>;
      etcValue = (etcMap['etc'] as num?)?.toDouble();
    } else if (etcField is num) {
      etcValue = etcField.toDouble();
    }

    return EtcDailyModel(
      day: json['day'] as String?,
      tempMin: (json['tempMin'] as num?)?.toDouble(),
      tempMax: (json['tempMax'] as num?)?.toDouble(),
      rhMin: (json['rhMin'] as num?)?.toDouble(),
      rhMax: (json['rhMax'] as num?)?.toDouble(),
      etc: etcValue,
      kc:
          (etcMap?['kc'] as num?)?.toDouble() ??
          (json['kc'] is num ? (json['kc'] as num).toDouble() : null),
      waterNeeds:
          (etcMap?['waterNeeds'] as num?)?.toDouble() ??
          (json['waterNeeds'] is num
              ? (json['waterNeeds'] as num).toDouble()
              : null),
    );
  }

  /// Validates EtcDailyModel values
  /// - day: should be a valid date string if present
  /// - etc: must be >= 0 (Evapotranspiration in mm/day)
  /// - kc: typically 0-2 (crop coefficient)
  /// - waterNeeds: must be >= 0
  /// - temperature/humidity: within reasonable ranges
  bool isValid() {
    if (day != null && day!.isEmpty) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: day is empty string');
      }
      return false;
    }

    if (etc != null && etc! < 0) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: etc=$etc is negative');
      }
      return false;
    }

    if (kc != null && (kc! < 0 || kc! > 3)) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: kc=$kc is out of typical range [0, 3]');
      }
      return false;
    }

    if (waterNeeds != null && waterNeeds! < 0) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: waterNeeds=$waterNeeds is negative');
      }
      return false;
    }

    if (tempMin != null && (tempMin! < -50 || tempMin! > 60)) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: tempMin=$tempMin is out of range [-50, 60]');
      }
      return false;
    }

    if (tempMax != null && (tempMax! < -50 || tempMax! > 60)) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: tempMax=$tempMax is out of range [-50, 60]');
      }
      return false;
    }

    if (rhMin != null && (rhMin! < 0 || rhMin! > 100)) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: rhMin=$rhMin is out of range [0, 100]');
      }
      return false;
    }

    if (rhMax != null && (rhMax! < 0 || rhMax! > 100)) {
      if (kDebugMode) {
        debugPrint('EtcDailyModel: rhMax=$rhMax is out of range [0, 100]');
      }
      return false;
    }

    return true;
  }

  /// Check if EtcDailyModel has meaningful data
  bool get isEmpty => etc == null && waterNeeds == null && kc == null;
}

class AgroModel {
  final VdpModel? vdp;
  final GddModel? gdd;
  final List<EtcDailyModel> etc;

  const AgroModel({this.vdp, this.gdd, this.etc = const []});

  factory AgroModel.fromJson(Map<String, dynamic> json) {
    // Parse etc — bisa berupa List atau null
    List<EtcDailyModel> etcList = const [];
    final etcRaw = json['etc'];
    if (etcRaw is List) {
      etcList = etcRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => EtcDailyModel.fromJson(e))
          .toList();
    }

    // Parse vdp — bisa berupa Map atau null
    VdpModel? vdpModel;
    final vdpRaw = json['vdp'];
    if (vdpRaw is Map<String, dynamic>) {
      vdpModel = VdpModel.fromJson(vdpRaw);
    }

    // Parse gdd — bisa berupa Map atau null
    GddModel? gddModel;
    final gddRaw = json['gdd'];
    if (gddRaw is Map<String, dynamic>) {
      gddModel = GddModel.fromJson(gddRaw);
    }

    return AgroModel(vdp: vdpModel, gdd: gddModel, etc: etcList);
  }

  /// Check if AgroModel is empty (no valid agro data)
  bool get isEmpty => vdp == null && gdd == null && etc.isEmpty;

  /// Validates AgroModel structure
  /// - At least one of vdp/gdd/etc must be present
  /// - All nested models must pass their own validation
  bool isValid() {
    if (isEmpty) {
      if (kDebugMode) {
        debugPrint('AgroModel: all fields are empty (vdp=null, gdd=null, etc=[])');
      }
      return false;
    }

    if (vdp != null && !vdp!.isValid()) {
      if (kDebugMode) {
        debugPrint('AgroModel: vdp validation failed');
      }
      return false;
    }

    if (gdd != null && !gdd!.isValid()) {
      if (kDebugMode) {
        debugPrint('AgroModel: gdd validation failed');
      }
      return false;
    }

    for (final etcItem in etc) {
      if (!etcItem.isValid()) {
        if (kDebugMode) {
          debugPrint('AgroModel: EtcDailyModel validation failed for day=${etcItem.day}');
        }
        return false;
      }
    }

    return true;
  }

  /// Get count of valid data sources present
  int get dataSourceCount {
    int count = 0;
    if (vdp != null) count++;
    if (gdd != null && !gdd!.isEmpty) count++;
    if (etc.isNotEmpty) count++;
    return count;
  }
}
