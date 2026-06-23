import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/device_sensor_remote_datasource.dart';
import '../../data/repositories/device_sensor_repository_impl.dart';
import '../../domain/entities/device_sensor.dart';
import '../../domain/repositories/device_sensor_repository.dart';
import '../../../site/presentation/providers/site_provider.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE & REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════
final adminDeviceSensorRemoteDatasourceProvider =
    Provider<DeviceSensorRemoteDatasource>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return DeviceSensorRemoteDatasourceImpl(dioClient.dio);
    });

final adminDeviceSensorRepositoryProvider = Provider<DeviceSensorRepository>((
  ref,
) {
  final datasource = ref.watch(adminDeviceSensorRemoteDatasourceProvider);
  return DeviceSensorRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// DEVICE SENSOR LIST PROVIDER
// ═══════════════════════════════════════════════════════════
final adminDeviceSensorListProvider = FutureProvider<List<DeviceSensor>>((
  ref,
) async {
  final repository = ref.watch(adminDeviceSensorRepositoryProvider);
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  return repository.getAllDeviceSensors(siteId);
});

/// GET /sites/{siteId}/device-sensors/values
final deviceSensorThresholdValuesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final ds = ref.watch(adminDeviceSensorRemoteDatasourceProvider);
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) return [];
      return ds.getThresholdValues(siteId);
    });

String adminDeviceSensorLookupKey(String dsId, {String? devId}) {
  final trimmedDevId = devId?.trim();
  if (trimmedDevId == null || trimmedDevId.isEmpty) return dsId;
  return '${Uri.encodeComponent(dsId)}|${Uri.encodeComponent(trimmedDevId)}';
}

({String dsId, String? devId}) _parseDeviceSensorLookupKey(String key) {
  final parts = key.split('|');
  if (parts.length < 2) return (dsId: key, devId: null);
  return (
    dsId: Uri.decodeComponent(parts.first),
    devId: Uri.decodeComponent(parts.sublist(1).join('|')),
  );
}

// ═══════════════════════════════════════════════════════════
// DEVICE SENSOR DETAIL PROVIDER
// ═══════════════════════════════════════════════════════════
final adminDeviceSensorDetailProvider =
    FutureProvider.family<DeviceSensor, String>((ref, lookupKey) async {
      final repository = ref.watch(adminDeviceSensorRepositoryProvider);
      final siteId = ref.watch(selectedSiteIdProvider);
      if (siteId == null) throw Exception('No site selected');
      final lookup = _parseDeviceSensorLookupKey(lookupKey);
      return repository.getDeviceSensorById(
        siteId,
        lookup.dsId,
        devId: lookup.devId,
      );
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
    final siteId = _ref.read(selectedSiteIdProvider);
    if (siteId == null) {
      state = const DeviceSensorFormState(error: 'No site selected');
      return false;
    }

    try {
      final saved = await _repository.createDeviceSensor(siteId, deviceSensor);
      state = DeviceSensorFormState(savedDeviceSensor: saved);
      _ref.invalidate(adminDeviceSensorListProvider);
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
    final siteId = _ref.read(selectedSiteIdProvider);
    if (siteId == null) {
      state = const DeviceSensorFormState(error: 'No site selected');
      return false;
    }

    try {
      final saved = await _repository.updateDeviceSensor(
        siteId,
        dsId,
        deviceSensor,
      );
      state = DeviceSensorFormState(savedDeviceSensor: saved);
      _ref.invalidate(adminDeviceSensorListProvider);
      _ref.invalidate(adminDeviceSensorDetailProvider(dsId));
      _ref.invalidate(
        adminDeviceSensorDetailProvider(
          adminDeviceSensorLookupKey(dsId, devId: deviceSensor.devId),
        ),
      );
      return true;
    } catch (e) {
      state = DeviceSensorFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteDeviceSensor(String dsId) async {
    state = state.copyWith(isLoading: true, error: null);
    final siteId = _ref.read(selectedSiteIdProvider);
    if (siteId == null) {
      state = const DeviceSensorFormState(error: 'No site selected');
      return false;
    }

    try {
      await _repository.deleteDeviceSensor(siteId, dsId);
      state = const DeviceSensorFormState();
      _ref.invalidate(adminDeviceSensorListProvider);
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
final adminDeviceSensorFormProvider =
    StateNotifierProvider<DeviceSensorFormNotifier, DeviceSensorFormState>((
      ref,
    ) {
      final repository = ref.watch(adminDeviceSensorRepositoryProvider);
      return DeviceSensorFormNotifier(repository, ref);
    });
