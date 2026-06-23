dynamic adminFirstOf(Map<String, dynamic> json, Iterable<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null) return value;
  }
  return null;
}

String adminStringValue(dynamic value, {String fallback = ''}) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? fallback : text;
}

String? adminNullableString(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

double? adminDoubleValue(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().trim().replaceAll(',', '.'));
}

int? adminIntValue(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value ? 1 : 0;
  if (value is num) return value.toInt();

  final text = value.toString().trim().toLowerCase();
  if (text.isEmpty) return null;
  if (text == 'active' ||
      text == 'aktif' ||
      text == 'enabled' ||
      text == 'true' ||
      text == 'yes') {
    return 1;
  }
  if (text == 'inactive' ||
      text == 'nonaktif' ||
      text == 'disabled' ||
      text == 'false' ||
      text == 'no') {
    return 0;
  }
  return int.tryParse(text);
}

DateTime? adminDateTimeValue(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is num) {
    final raw = value.toInt();
    final millis = raw > 1000000000000 ? raw : raw * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text) ??
      DateTime.tryParse(text.replaceFirst(' ', 'T'));
}

dynamic adminCreatedValue(Map<String, dynamic> json, String prefix) {
  return adminFirstOf(json, [
    '${prefix}_created',
    '${prefix}_created_at',
    '${prefix}_createdAt',
    '${prefix}_create',
    '${prefix}Created',
    '${prefix}CreatedAt',
    'created_at',
    'createdAt',
    'created_date',
    'createdDate',
    'date_created',
    'dateCreated',
    'created',
  ]);
}

dynamic adminUpdatedValue(Map<String, dynamic> json, String prefix) {
  return adminFirstOf(json, [
    '${prefix}_update',
    '${prefix}_updated',
    '${prefix}_updated_at',
    '${prefix}_update_at',
    '${prefix}_updatedAt',
    '${prefix}_updateAt',
    '${prefix}Update',
    '${prefix}Updated',
    '${prefix}UpdatedAt',
    '${prefix}UpdateAt',
    'updated_at',
    'updatedAt',
    'updated_date',
    'updatedDate',
    'date_updated',
    'dateUpdated',
    'modified_at',
    'modifiedAt',
    'updated',
    'modified',
  ]);
}
