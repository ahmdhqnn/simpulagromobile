import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/sensor_remote_datasource.dart';
import '../../data/repositories/sensor_repository_impl.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/repositories/sensor_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE PROVIDER
// ═══════════════════════════════════════════════════════════
final sensorRemoteDatasourceProvider = Provider<SensorRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SensorRemoteDatasourceImpl(dioClient.dio);
});

// ═══════════════════════════════════════════════════════════
// REPOSITORY PROVIDER
// ═══════════════════════════════════════════════════════════
final sensorRepositoryProvider = Provider<SensorRepository>((ref) {
  final datasource = ref.watch(sensorRemoteDatasourceProvider);
  return SensorRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// SENSOR LIST PROVIDER (by selected site)
// ═══════════════════════════════════════════════════════════
final utilitasSensorListProvider = FutureProvider<List<Sensor>>((ref) async {
  final repository = ref.watch(sensorRepositoryProvider);
  final selectedSite = ref.watch(selectedSiteProvider);

  if (selectedSite == null) {
    throw Exception('Tidak ada site yang dipilih');
  }

  return repository.getSensorsBySite(selectedSite.siteId);
});

// ═══════════════════════════════════════════════════════════
// SENSOR DETAIL PROVIDER (by ID)
// ═══════════════════════════════════════════════════════════
final utilitasSensorDetailProvider = FutureProvider.family<Sensor, String>((
  ref,
  sensorId,
) async {
  final repository = ref.watch(sensorRepositoryProvider);
  final selectedSite = ref.watch(selectedSiteProvider);

  if (selectedSite == null) {
    throw Exception('Tidak ada site yang dipilih');
  }

  return repository.getSensorById(selectedSite.siteId, sensorId);
});

// ═══════════════════════════════════════════════════════════
// SENSOR FORM STATE
// ═══════════════════════════════════════════════════════════
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

// ═══════════════════════════════════════════════════════════
// SENSOR FORM NOTIFIER
// ═══════════════════════════════════════════════════════════
class SensorFormNotifier extends StateNotifier<SensorFormState> {
  final SensorRepository _repository;
  final Ref _ref;

  SensorFormNotifier(this._repository, this._ref)
    : super(const SensorFormState());

  /// Create new sensor
  Future<bool> createSensor(Sensor sensor) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final savedSensor = await _repository.createSensor(
        selectedSite.siteId,
        sensor,
      );

      state = SensorFormState(savedSensor: savedSensor);

      // Invalidate list to refresh
      _ref.invalidate(utilitasSensorListProvider);

      return true;
    } catch (e) {
      state = SensorFormState(error: e.toString());
      return false;
    }
  }

  /// Update existing sensor
  Future<bool> updateSensor(String sensorId, Sensor sensor) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final savedSensor = await _repository.updateSensor(
        selectedSite.siteId,
        sensorId,
        sensor,
      );

      state = SensorFormState(savedSensor: savedSensor);

      // Invalidate list and detail to refresh
      _ref.invalidate(utilitasSensorListProvider);
      _ref.invalidate(utilitasSensorDetailProvider(sensorId));

      return true;
    } catch (e) {
      state = SensorFormState(error: e.toString());
      return false;
    }
  }

  /// Delete sensor
  Future<bool> deleteSensor(String sensorId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      await _repository.deleteSensor(selectedSite.siteId, sensorId);

      state = const SensorFormState();

      // Invalidate list to refresh
      _ref.invalidate(utilitasSensorListProvider);

      return true;
    } catch (e) {
      state = SensorFormState(error: e.toString());
      return false;
    }
  }

  /// Reset form state
  void reset() {
    state = const SensorFormState();
  }
}

// ═══════════════════════════════════════════════════════════
// SENSOR FORM PROVIDER
// ═══════════════════════════════════════════════════════════
final sensorFormProvider =
    StateNotifierProvider<SensorFormNotifier, SensorFormState>((ref) {
      final repository = ref.watch(sensorRepositoryProvider);
      return SensorFormNotifier(repository, ref);
    });
