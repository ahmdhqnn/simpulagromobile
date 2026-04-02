import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor.freezed.dart';

@freezed
class Sensor with _$Sensor {
  const Sensor._();

  const factory Sensor({
    required String id,
    required String deviceId,
    required String name,
    required String type,
    required String unit,
    String? description,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Sensor;

  // Helper methods
  String get displayName => name;

  String get statusText => isActive ? 'Active' : 'Inactive';

  String get typeDisplay {
    switch (type.toLowerCase()) {
      case 'temperature':
        return 'Temperature';
      case 'humidity':
        return 'Humidity';
      case 'soil_moisture':
        return 'Soil Moisture';
      case 'ph':
        return 'pH Level';
      case 'light':
        return 'Light Intensity';
      default:
        return type;
    }
  }
}
