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

  String get statusText => isActive ? 'Aktif' : 'Tidak Aktif';

  String get typeDisplay {
    switch (type.toLowerCase()) {
      case 'temperature':
      case 'env_temp':
        return 'Suhu Udara';
      case 'humidity':
      case 'env_hum':
        return 'Kelembaban Udara';
      case 'soil_moisture':
      case 'soil_hum':
        return 'Kelembaban Tanah';
      case 'ph':
      case 'soil_ph':
        return 'pH Tanah';
      case 'soil_nitro':
        return 'Nitrogen Tanah';
      case 'soil_phos':
        return 'Fosfor Tanah';
      case 'soil_pot':
        return 'Kalium Tanah';
      case 'light':
        return 'Intensitas Cahaya';
      case 'pressure':
        return 'Tekanan';
      case 'wind_speed':
        return 'Kecepatan Angin';
      default:
        return type;
    }
  }
}
