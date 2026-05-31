import '../../domain/entities/varietas_item.dart';

class VarietasItemModel {
  const VarietasItemModel({
    required this.varietasId,
    this.varietasName,
    this.varietasDesc,
    this.varietasSts,
    this.varietasUpdate,
  });

  final String varietasId;
  final String? varietasName;
  final String? varietasDesc;
  final int? varietasSts;
  final DateTime? varietasUpdate;

  factory VarietasItemModel.fromJson(Map<String, dynamic> json) {
    final id = json['varietas_id']?.toString().trim() ?? '';
    if (id.isEmpty) {
      throw const FormatException('varietas_id wajib diisi');
    }

    return VarietasItemModel(
      varietasId: id,
      varietasName: json['varietas_name']?.toString(),
      varietasDesc: json['varietas_desc']?.toString(),
      varietasSts: _toInt(json['varietas_sts']),
      varietasUpdate: _toDateTime(json['varietas_update']),
    );
  }

  VarietasItem toEntity() => VarietasItem(
    varietasId: varietasId,
    varietasName: varietasName,
    varietasDesc: varietasDesc,
    varietasSts: varietasSts,
    varietasUpdate: varietasUpdate,
  );
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

DateTime? _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value.trim());
  }
  return null;
}
