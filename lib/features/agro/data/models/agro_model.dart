/// Models for /api/sites/:siteId/agro endpoint

class VdpModel {
  final double? vdp;
  final String? status;

  const VdpModel({this.vdp, this.status});

  factory VdpModel.fromJson(Map<String, dynamic> json) {
    return VdpModel(
      vdp: (json['vdp'] as num?)?.toDouble(),
      status: json['status'] as String?,
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
      day: json['day'] as String?,
      tempMin: (json['tempMin'] as num?)?.toDouble(),
      tempMax: (json['tempMax'] as num?)?.toDouble(),
      gdd: (json['gdd'] as num?)?.toDouble(),
    );
  }
}

class GddModel {
  final double? totalGDD;
  final List<GddDailyModel> daily;

  const GddModel({this.totalGDD, this.daily = const []});

  factory GddModel.fromJson(Map<String, dynamic> json) {
    final dailyList = (json['daily'] as List? ?? [])
        .map((e) => GddDailyModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
    final etcMap = json['etc'] as Map<String, dynamic>?;
    return EtcDailyModel(
      day: json['day'] as String?,
      tempMin: (json['tempMin'] as num?)?.toDouble(),
      tempMax: (json['tempMax'] as num?)?.toDouble(),
      rhMin: (json['rhMin'] as num?)?.toDouble(),
      rhMax: (json['rhMax'] as num?)?.toDouble(),
      etc:
          (etcMap?['etc'] as num?)?.toDouble() ??
          (json['etc'] is num ? (json['etc'] as num).toDouble() : null),
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
    final etcList = (json['etc'] as List? ?? [])
        .map((e) => EtcDailyModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return AgroModel(
      vdp: json['vdp'] != null
          ? VdpModel.fromJson(json['vdp'] as Map<String, dynamic>)
          : null,
      gdd: json['gdd'] != null
          ? GddModel.fromJson(json['gdd'] as Map<String, dynamic>)
          : null,
      etc: etcList,
    );
  }
}
