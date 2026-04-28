import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/device_sensor_remote_datasource.dart';
import '../../data/repositories/device_sensor_repository_impl.dart';
import '../../domain/entities/device_sensor.dart';
import '../../domain/repositories/device_sensor_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE & REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════
final deviceSensorRemoteDatasourceProvider =
    Provider<DeviceSensorRemoteDatasource>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return DeviceSensorRemoteDatasourceImpl(dioClient.dio);
    });

final deviceSensorRepositoryProvider = Provider<DeviceSensorRepository>((ref) {
  final datasource = ref.watch(deviceSensorRemoteDatasourceProvider);
  return DeviceSensorRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// DEVICE SENSOR LIST PROVIDER
// ═══════════════════════════════════════════════════════════
final utilitasDeviceSensorListProvider = FutureProvider<List<DeviceSensor>>((
  ref,
) async {
  final repository = ref.watch(deviceSensorRepositoryProvider);
  return repository.getAllDeviceSensors();
});

// ═══════════════════════════════════════════════════════════
// DEVICE SENSOR DETAIL PROVIDER
// ═══════════════════════════════════════════════════════════
final utilitasDeviceSensorDetailProvider =
    FutureProvider.family<DeviceSensor, String>((ref, dsId) async {
      final repository = ref.watch(deviceSensorRepositoryProvider);
      return repository.getDeviceSensorById(dsId);
    });

// ═══════════════════════════════════════════════════════════
// DEVICE SENSOR FORM STATE
// ═══════════════════════════════════════════════════════════
class DeviceSensorFormState {
  final bool isLoading;
  final String? error;
  final DeviceSensor? savedDeviceSensor;

  const DeviceSensorFormState({
    this.isLoading = false,
    this.error,
    this.savedDeviceSensor,
  });

  DeviceSensorFormState copyWith({
    bool? isLoading,
    String? error,
    DeviceSensor? savedDeviceSensor,
  }) {
    return DeviceSensorFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedDeviceSensor: savedDeviceSensor ?? this.savedDeviceSensor,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// DEVICE SENSOR FORM NOTIFIER
// ═══════════════════════════════════════════════════════════
class DeviceSensorFormNotifier extends StateNotifier<DeviceSensorFormState> {
  final DeviceSensorRepository _repository;
  final Ref _ref;

  DeviceSensorFormNotifier(this._repository, this._ref)
    : super(const DeviceSensorFormState());

  Future<bool> createDeviceSensor(DeviceSensor deviceSensor) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final saved = await _repository.createDeviceSensor(deviceSensor);
      state = DeviceSensorFormState(savedDeviceSensor: saved);
      _ref.invalidate(utilitasDeviceSensorListProvider);
      return true;
    } catch (e) {
      state = DeviceSensorFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateDeviceSensor(
    String dsId,
    DeviceSensor deviceSensor,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final saved = await _repository.updateDeviceSensor(dsId, deviceSensor);
      state = DeviceSensorFormState(savedDeviceSensor: saved);
      _ref.invalidate(utilitasDeviceSensorListProvider);
      _ref.invalidate(utilitasDeviceSensorDetailProvider(dsId));
      return true;
    } catch (e) {
      state = DeviceSensorFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteDeviceSensor(String dsId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteDeviceSensor(dsId);
      state = const DeviceSensorFormState();
      _ref.invalidate(utilitasDeviceSensorListProvider);
      return true;
    } catch (e) {
      state = DeviceSensorFormState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const DeviceSensorFormState();
  }
}

// ═══════════════════════════════════════════════════════════
// DEVICE SENSOR FORM PROVIDER
// ═══════════════════════════════════════════════════════════
final deviceSensorFormProvider =
    StateNotifierProvider<DeviceSensorFormNotifier, DeviceSensorFormState>((
      ref,
    ) {
      final repository = ref.watch(deviceSensorRepositoryProvider);
      return DeviceSensorFormNotifier(repository, ref);
    });
