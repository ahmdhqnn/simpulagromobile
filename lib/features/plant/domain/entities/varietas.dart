import 'package:freezed_annotation/freezed_annotation.dart';

part 'varietas.freezed.dart';

@freezed
class Varietas with _$Varietas {
  const Varietas._();

  const factory Varietas({
    required String varietasId,
    String? varietasName,
    String? varietasDesc,
    required int varietasStatus,
  }) = _Varietas;

  bool isActive() => varietasStatus == 1;

  String get displayName => varietasName ?? varietasId;
}
