// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/phase.dart';

part 'phase_model.freezed.dart';
part 'phase_model.g.dart';

@freezed
class PhaseModel with _$PhaseModel {
  const PhaseModel._();

  const factory PhaseModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'plant_id') required String plantId,
    @JsonKey(name: 'plant_name') required String plantName,
    @JsonKey(name: 'phase_name') required String phaseName,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'start_hst') required int startHst,
    @JsonKey(name: 'end_hst') required int endHst,
    @JsonKey(name: 'current_hst') required int currentHst,
    @JsonKey(name: 'required_gdd') required double requiredGdd,
    @JsonKey(name: 'current_gdd') required double currentGdd,
    @JsonKey(name: 'progress') required double progress,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PhaseModel;

  factory PhaseModel.fromJson(Map<String, dynamic> json) =>
      _$PhaseModelFromJson(json);

  Phase toEntity() => Phase(
    id: id,
    plantId: plantId,
    plantName: plantName,
    phaseName: phaseName,
    description: description,
    startHst: startHst,
    endHst: endHst,
    currentHst: currentHst,
    requiredGdd: requiredGdd,
    currentGdd: currentGdd,
    progress: progress,
    status: status,
    startDate: startDate,
    endDate: endDate,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
