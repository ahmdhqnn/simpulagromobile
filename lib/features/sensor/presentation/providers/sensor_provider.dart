import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/sensor_remote_datasource.dart';
import '../../data/repositories/sensor_repository_impl.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/repositories/sensor_repository.dart';

// ─── DataSource Provider ─────────────────────────────────
final sensorRemoteDataSourceProvider = Provider<SensorRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SensorRemoteDataSource(dioClient.dio);
});

// ─── Repository Provider ─────────────────────────────────
final sensorRepositoryProvider = Provider<SensorRepository>((ref) {
  final remoteDataSource = ref.watch(sensorRemoteDataSourceProvider);
  return SensorRepositoryImpl(remoteDataSource);
});

// ─── Sensor List Provider (by siteId) ────────────────────
/// Mengambil semua sensor untuk site yang dipilih
final sensorListProvider = FutureProvider.family<List<Sensor>, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(sensorRepositoryProvider);
  return await ref.retryOnError(() => repository.getSensors(siteId));
});

// ─── Sensor List for Selected Site ───────────────────────
/// Shortcut provider yang otomatis menggunakan selectedSiteProvider
final sensorsForSelectedSiteProvider = FutureProvider<List<Sensor>>((
  ref,
) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final repository = ref.watch(sensorRepositoryProvider);
  return await ref.retryOnError(() => repository.getSensors(siteId));
});

// ─── Sensor Detail Provider ───────────────────────────────
/// Mengambil detail sensor berdasarkan siteId dan sensId
final sensorDetailProvider =
    FutureProvider.family<Sensor, ({String siteId, String sensId})>((
      ref,
      params,
    ) async {
      final repository = ref.watch(sensorRepositoryProvider);
      return await ref.retryOnError(() => repository.getSensorById(params.siteId, params.sensId));
    });

// ─── Sensor Form State ────────────────────────────────────
class SensorFormState {
  final bool isLoading;
  final String? error;
  final Sensor? savedSensor;

  const SensorFormState({this.isLoading = false, this.error, this.savedSensor});

  SensorFormState copyWith({
    bool? isLoading,
    String? error,
    Sensor? savedSensor,
  }) {
    return SensorFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedSensor: savedSensor ?? this.savedSensor,
    );
  }
}

// ─── Sensor Form Notifier ─────────────────────────────────
class SensorFormNotifier extends StateNotifier<SensorFormState> {
  final SensorRepository _repository;
  final Ref _ref;

  SensorFormNotifier(this._repository, this._ref)
    : super(const SensorFormState());

  Future<bool> createSensor(String siteId, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sensor = await _repository.createSensor(siteId, data);
      state = SensorFormState(savedSensor: sensor);
      _ref.invalidate(sensorListProvider(siteId));
      _ref.invalidate(sensorsForSelectedSiteProvider);
      return true;
    } catch (e) {
      state = SensorFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateSensor(
    String siteId,
    String sensId,
    Map<String, dynamic> data,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sensor = await _repository.updateSensor(siteId, sensId, data);
      state = SensorFormState(savedSensor: sensor);
      _ref.invalidate(sensorListProvider(siteId));
      _ref.invalidate(sensorsForSelectedSiteProvider);
      _ref.invalidate(sensorDetailProvider((siteId: siteId, sensId: sensId)));
      return true;
    } catch (e) {
      state = SensorFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteSensor(String siteId, String sensId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteSensor(siteId, sensId);
      state = const SensorFormState();
      _ref.invalidate(sensorListProvider(siteId));
      _ref.invalidate(sensorsForSelectedSiteProvider);
      return true;
    } catch (e) {
      state = SensorFormState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const SensorFormState();
  }
}

// ─── Sensor Form Provider ─────────────────────────────────
final sensorFormProvider =
    StateNotifierProvider<SensorFormNotifier, SensorFormState>((ref) {
      final repository = ref.watch(sensorRepositoryProvider);
      return SensorFormNotifier(repository, ref);
    });
