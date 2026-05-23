import 'package:freezed_annotation/freezed_annotation.dart';

part 'agro_entity.freezed.dart';

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
    String? day,
    double? tempMin,
    double? tempMax,
    double? rhMin,
    double? rhMax,
    double? etc,
    double? kc,
    double? waterNeeds,
  }) = _EtcDailyEntity;

  bool get isEmpty => etc == null && waterNeeds == null && kc == null;
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
