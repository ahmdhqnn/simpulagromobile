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

  /// Buat PhaseModel dari response API backend
  /// API mengembalikan: phase_id, phase_name, chrop_type, phase_order,
  ///                    phase_hst_min, phase_hst_max
  factory PhaseModel.fromApiJson(Map<String, dynamic> json) {
    final phaseId = (json['phase_id'] as String?) ?? '';
    final phaseName = (json['phase_name'] as String?) ?? '';
    final cropType = (json['chrop_type'] as String?) ?? '';
    final hstMin = (json['phase_hst_min'] as int?) ?? 0;
    final hstMax = (json['phase_hst_max'] as int?) ?? 0;
    final phaseOrder = (json['phase_order'] as int?) ?? 1;

    // Estimasi GDD berdasarkan durasi fase (10 GDD per hari sebagai default)
    final estimatedGdd = (hstMax - hstMin) * 10.0;

    return PhaseModel(
      id: phaseId,
      plantId: cropType, // gunakan cropType sebagai plantId sementara
      plantName: cropType,
      phaseName: phaseName,
      description: _buildDescription(phaseName, cropType, phaseOrder),
      startHst: hstMin,
      endHst: hstMax,
      currentHst: 0, // akan di-update via enrichWithHst
      requiredGdd: estimatedGdd,
      currentGdd: 0.0, // akan di-update via enrichWithHst
      progress: 0.0, // akan di-update via enrichWithHst
      status: 'upcoming', // akan di-update via enrichWithHst
      startDate: DateTime.now(),
      endDate: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Enrich model dengan data HST saat ini untuk menentukan status dan progress
  PhaseModel enrichWithHst({required int currentHst, String? currentPhaseId}) {
    final String phaseStatus;
    final double phaseProgress;
    final double phaseCurrentGdd;

    if (currentHst > endHst) {
      // Fase sudah selesai
      phaseStatus = 'completed';
      phaseProgress = 1.0;
      phaseCurrentGdd = requiredGdd;
    } else if (id == currentPhaseId ||
        (currentHst >= startHst && currentHst <= endHst)) {
      // Fase sedang aktif
      phaseStatus = 'active';
      final range = endHst - startHst;
      phaseProgress = range > 0
          ? ((currentHst - startHst) / range).clamp(0.0, 1.0)
          : 0.0;
      phaseCurrentGdd = requiredGdd * phaseProgress;
    } else {
      // Fase belum dimulai
      phaseStatus = 'upcoming';
      phaseProgress = 0.0;
      phaseCurrentGdd = 0.0;
    }

    return copyWith(
      currentHst: currentHst,
      status: phaseStatus,
      progress: phaseProgress,
      currentGdd: phaseCurrentGdd,
    );
  }

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

  static String _buildDescription(
    String phaseName,
    String cropType,
    int order,
  ) {
    final descriptions = {
      'Vegetatif Awal':
          'Fase awal pertumbuhan vegetatif — pembentukan akar dan daun pertama.',
      'Vegetatif Akhir':
          'Pertumbuhan batang, daun, dan sistem perakaran secara aktif.',
      'Generatif': 'Pembentukan bunga, malai, dan pengisian biji/buah.',
      'Pematangan': 'Pematangan biji/buah hingga siap panen.',
      'Perkecambahan': 'Fase awal pertumbuhan benih hingga muncul tunas.',
      'Vegetatif': 'Pertumbuhan vegetatif aktif — batang dan daun berkembang.',
      'Berbunga': 'Fase pembungaan dan penyerbukan.',
      'Pengisian Biji': 'Pengisian dan pematangan biji.',
      'Pengisian Polong': 'Pengisian dan pematangan polong.',
    };
    return descriptions[phaseName] ??
        'Fase $order pertumbuhan tanaman $cropType.';
  }
}
