import 'package:freezed_annotation/freezed_annotation.dart';

part 'phase.freezed.dart';

/// Phase entity representing a growth phase of a plant
@freezed
class Phase with _$Phase {
  const Phase._();

  const factory Phase({
    required String id,
    required String plantId,
    required String plantName,
    required String phaseName,
    required String description,
    required int startHst,
    required int endHst,
    required int currentHst,
    required double requiredGdd,
    required double currentGdd,
    required double progress,
    required String status, // active, completed, upcoming
    required DateTime startDate,
    DateTime? endDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Phase;

  /// Check if phase is active
  bool get isActive => status == 'active';

  /// Check if phase is completed
  bool get isCompleted => status == 'completed';

  /// Check if phase is upcoming
  bool get isUpcoming => status == 'upcoming';

  /// Get progress percentage (0-100)
  double get progressPercentage => (progress * 100).clamp(0, 100);

  /// Get GDD progress percentage
  double get gddProgressPercentage =>
      currentGdd > 0 ? (currentGdd / requiredGdd * 100).clamp(0, 100) : 0;

  /// Get remaining days estimate
  int get remainingDays => endHst - currentHst;

  /// Get phase duration
  int get phaseDuration => endHst - startHst;
}
