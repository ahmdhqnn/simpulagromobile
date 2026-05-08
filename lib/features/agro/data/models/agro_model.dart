/// Models for /api/sites/:siteId/agro endpoint
library;

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
    return VdpModel(
      vdp: (json['vdp'] as num?)?.toDouble(),
      status: json['status'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      es: (json['es'] as num?)?.toDouble(),
      ea: (json['ea'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );
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
}
