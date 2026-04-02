import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/sensor_remote_datasource.dart';
import '../../data/repositories/sensor_repository_impl.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/repositories/sensor_repository.dart';

// Repository Provider
final sensorRepositoryProvider = Provider<SensorRepository>((ref) {
  final remoteDataSource = ref.watch(sensorRemoteDataSourceProvider);
  return SensorRepositoryImpl(remoteDataSource);
});

// Sensor List Provider
final sensorListProvider = FutureProvider.family<List<Sensor>, String>((
  ref,
  deviceId,
) async {
  final repository = ref.watch(sensorRepositoryProvider);
  return await repository.getSensors(deviceId);
});

// Sensor Detail Provider
final sensorDetailProvider = FutureProvider.family<Sensor, String>((
  ref,
  sensorId,
) async {
  final repository = ref.watch(sensorRepositoryProvider);
  return await repository.getSensorById(sensorId);
});

// Sensor Form State Provider
final sensorFormProvider =
    StateNotifierProvider<SensorFormNotifier, AsyncValue<Sensor?>>((ref) {
      final repository = ref.watch(sensorRepositoryProvider);
      return SensorFormNotifier(repository);
    });

class SensorFormNotifier extends StateNotifier<AsyncValue<Sensor?>> {
  final SensorRepository _repository;

  SensorFormNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createSensor(String deviceId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final sensor = await _repository.createSensor(deviceId, data);
      state = AsyncValue.data(sensor);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSensor(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final sensor = await _repository.updateSensor(id, data);
      state = AsyncValue.data(sensor);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteSensor(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteSensor(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
