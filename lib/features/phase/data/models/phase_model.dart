// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/phase.dart';

part 'phase_model.freezed.dart';
part 'phase_model.g.dart';

/// PhaseModel — data layer model sesuai kontrak API backend.
///
/// API /fase/phases-list dan /fase/phases-list/{cropType} mengembalikan:
/// { "phase_id", "phase_name", "phase_order", "phase_hst_min",
///   "phase_hst_max", "chrop_type" }
///
/// Field seperti startDate, createdAt, requiredGdd TIDAK ada di API —
/// dihapus dari model ini. Logika progress/status dihitung di domain layer.
@freezed
class PhaseModel with _$PhaseModel {
  const PhaseModel._();

  const factory PhaseModel({
    /// phase_id dari API
    @JsonKey(name: 'phase_id') required String id,

    /// Jenis tanaman: PADI, JAGUNG, KEDELAI (field 'chrop_type' di API)
    @JsonKey(name: 'chrop_type') required String cropType,

    /// Nama fase: Vegetatif, Generatif, dll.
    @JsonKey(name: 'phase_name') required String phaseName,

    /// Urutan fase (1, 2, 3, ...)
    @JsonKey(name: 'phase_order') required int phaseOrder,

    /// HST minimum fase ini dimulai
    @JsonKey(name: 'phase_hst_min') required int hstMin,

    /// HST maksimum fase ini berakhir
    @JsonKey(name: 'phase_hst_max') required int hstMax,

    /// HST saat ini — diisi via enrichWithHst(), default 0
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0)
    int currentHst,

    /// Status fase: upcoming / active / completed — diisi via enrichWithHst()
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('upcoming')
    String status,

    /// Progress 0.0–1.0 — dihitung via enrichWithHst()
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0.0)
    double progress,
  }) = _PhaseModel;

  factory PhaseModel.fromJson(Map<String, dynamic> json) =>
      _$PhaseModelFromJson(json);

  /// Buat PhaseModel dari response API backend.
  /// Menangani kedua format: field langsung atau nested.
  factory PhaseModel.fromApiJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: (json['phase_id'] as String?) ?? '',
      cropType: (json['chrop_type'] as String?) ?? '',
      phaseName: (json['phase_name'] as String?) ?? '',
      phaseOrder: (json['phase_order'] as num?)?.toInt() ?? 1,
      hstMin: (json['phase_hst_min'] as num?)?.toInt() ?? 0,
      hstMax: (json['phase_hst_max'] as num?)?.toInt() ?? 0,
    );
  }

  /// Enrich model dengan HST saat ini untuk menentukan status dan progress.
  /// Dipanggil setelah mendapat data dari /fase/phases-by-hst/{siteId}.
  PhaseModel enrichWithHst({required int currentHst, String? currentPhaseId}) {
    final String phaseStatus;
    final double phaseProgress;

    if (currentHst > hstMax) {
      phaseStatus = 'completed';
      phaseProgress = 1.0;
    } else if (id == currentPhaseId ||
        (currentHst >= hstMin && currentHst <= hstMax)) {
      phaseStatus = 'active';
      final range = hstMax - hstMin;
      phaseProgress = range > 0
          ? ((currentHst - hstMin) / range).clamp(0.0, 1.0)
          : 0.0;
    } else {
      phaseStatus = 'upcoming';
      phaseProgress = 0.0;
    }

    return copyWith(
      currentHst: currentHst,
      status: phaseStatus,
      progress: phaseProgress,
    );
  }

  /// Konversi ke domain entity.
  Phase toEntity() => Phase(
    id: id,
    cropType: cropType,
    phaseName: phaseName,
    phaseOrder: phaseOrder,
    hstMin: hstMin,
    hstMax: hstMax,
    currentHst: currentHst,
    status: status,
    progress: progress,
    description: _buildDescription(phaseName, cropType, phaseOrder),
  );

  static String _buildDescription(
    String phaseName,
    String cropType,
    int order,
  ) {
    const descriptions = {
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
