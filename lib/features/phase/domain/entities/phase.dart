import 'package:freezed_annotation/freezed_annotation.dart';

part 'phase.freezed.dart';

/// Phase entity — domain layer.
/// Hanya berisi field yang benar-benar ada di API response
/// ditambah field kalkulasi (status, progress, currentHst).
@freezed
class Phase with _$Phase {
  const Phase._();

  const factory Phase({
    required String id,

    /// Jenis tanaman: PADI, JAGUNG, KEDELAI
    required String cropType,

    /// Nama fase: Vegetatif, Generatif, dll.
    required String phaseName,

    /// Urutan fase (1, 2, 3, ...)
    required int phaseOrder,

    /// HST minimum fase ini dimulai
    required int hstMin,

    /// HST maksimum fase ini berakhir
    required int hstMax,

    /// HST saat ini (dari /fase/phases-by-hst)
    @Default(0) int currentHst,

    /// Status: upcoming / active / completed
    @Default('upcoming') String status,

    /// Progress 0.0–1.0
    @Default(0.0) double progress,

    /// Deskripsi fase (dibangun dari phaseName)
    @Default('') String description,
  }) = _Phase;

  // ─── Computed Properties ──────────────────────────────

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isUpcoming => status == 'upcoming';

  /// Progress dalam persen (0–100)
  double get progressPercentage => (progress * 100).clamp(0.0, 100.0);

  /// Durasi fase dalam hari
  int get phaseDuration => (hstMax - hstMin + 1).clamp(0, 100000);

  /// Sisa hari estimasi
  int get remainingDays => (hstMax - currentHst).clamp(0, hstMax);
}
