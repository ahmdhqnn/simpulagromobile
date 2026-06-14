import 'package:freezed_annotation/freezed_annotation.dart';

part 'agro_entity.freezed.dart';

class AgroSensorHealthEntity {
  const AgroSensorHealthEntity({
    required this.devId,
    required this.dsId,
    required this.readUpdateValue,
    required this.percentage,
  });

  final String devId;
  final String dsId;
  final String readUpdateValue;
  final double percentage;
}

class AgroEnvironmentalHealthEntity {
  const AgroEnvironmentalHealthEntity({
    required this.overallHealth,
    required this.totalSensors,
    required this.sensors,
  });

  final double overallHealth;
  final int totalSensors;
  final List<AgroSensorHealthEntity> sensors;

  bool get isEmpty => totalSensors == 0 && sensors.isEmpty;
}

@freezed
class VdpEntity with _$VdpEntity {
  const VdpEntity._();
  const factory VdpEntity({
    double? vdp,
    double? temperature,
    double? humidity,
    double? es,
    double? ea,
    String? status,
    String? description,
  }) = _VdpEntity;

  bool get isEmpty => vdp == null;

  bool get hasDisplayData =>
      vdp != null ||
      temperature != null ||
      humidity != null ||
      es != null ||
      ea != null;
}

@freezed
class GddDailyEntity with _$GddDailyEntity {
  const GddDailyEntity._();
  const factory GddDailyEntity({
    String? day,
    double? tempMin,
    double? tempMax,
    double? gdd,
  }) = _GddDailyEntity;
}

@freezed
class GddEntity with _$GddEntity {
  const GddEntity._();
  const factory GddEntity({
    double? totalGDD,
    @Default([]) List<GddDailyEntity> daily,
  }) = _GddEntity;

  bool get isEmpty => (totalGDD == null || totalGDD == 0) && daily.isEmpty;
}

@freezed
class EtcDailyEntity with _$EtcDailyEntity {
  const EtcDailyEntity._();
  const factory EtcDailyEntity({
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
    double? waterNeededMM,
    int? waterNeededLiter,
    String? waterManagement,
    int? daysToHarvest,
    bool? isCriticalPhase,
    DateTime? harvestDate,
  }) = _EtcDailyEntity;

  bool get isEmpty =>
      etc == null &&
      waterNeeds == null &&
      kc == null &&
      et0 == null &&
      phase == null &&
      recommendation == null &&
      waterNeededMM == null &&
      waterNeededLiter == null &&
      waterManagement == null;
}

@freezed
class AgroEntity with _$AgroEntity {
  const AgroEntity._();
  const factory AgroEntity({
    VdpEntity? vdp,
    GddEntity? gdd,
    @Default([]) List<EtcDailyEntity> etc,
  }) = _AgroEntity;

  bool get isEmpty => vdp == null && gdd == null && etc.isEmpty;
}
