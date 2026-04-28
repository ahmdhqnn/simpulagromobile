import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';

@freezed
class Unit with _$Unit {
  const Unit._();

  const factory Unit({
    required String unitId,
    String? unitName,
    String? unitSymbol,
    String? unitDesc,
    int? unitSts,
    DateTime? unitCreated,
    DateTime? unitUpdate,
  }) = _Unit;

  /// Check if unit is active
  bool get isActive => unitSts == 1;

  /// Get display name with symbol
  String get displayNameWithSymbol {
    if (unitName != null && unitSymbol != null) {
      return '$unitName ($unitSymbol)';
    }
    return unitName ?? unitSymbol ?? unitId;
  }
}
