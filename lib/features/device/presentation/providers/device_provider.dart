import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/device_remote_datasource.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATA SOURCE
// ═══════════════════════════════════════════════════════════
final deviceRemoteDataSourceProvider = Provider<DeviceRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DeviceRemoteDataSource(dioClient.dio);
});

// ═══════════════════════════════════════════════════════════
// REPOSITORY
// ═══════════════════════════════════════════════════════════
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final remoteDataSource = ref.watch(deviceRemoteDataSourceProvider);
  return DeviceRepositoryImpl(remoteDataSource);
});

// ═══════════════════════════════════════════════════════════
// DEVICE LIST PROVIDER (by Site ID)
// ═══════════════════════════════════════════════════════════
final deviceListProvider = FutureProvider.family<List<Device>, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(deviceRepositoryProvider);
  return await repository.getDevices(siteId);
});

// ═══════════════════════════════════════════════════════════
// DEVICE DETAIL PROVIDER (by Site ID & Device ID)
// ═══════════════════════════════════════════════════════════
final deviceDetailProvider =
    FutureProvider.family<Device, ({String siteId, String devId})>((
      ref,
      params,
    ) async {
      final repository = ref.watch(deviceRepositoryProvider);
      return await repository.getDeviceById(params.siteId, params.devId);
    });

// ═══════════════════════════════════════════════════════════
// DEVICE COORDINATES PROVIDER
// ═══════════════════════════════════════════════════════════
final deviceCoordinatesProvider = FutureProvider.family<List<Device>, String>((
  ref,
  siteId,
) async {
  final repository = ref.watch(deviceRepositoryProvider);
  return await repository.getDeviceCoordinates(siteId);
});

// ═══════════════════════════════════════════════════════════
// SELECTED DEVICE PROVIDER
// ═══════════════════════════════════════════════════════════
final selectedDeviceProvider = StateProvider<Device?>((ref) => null);

// ═══════════════════════════════════════════════════════════
// DEVICE FORM NOTIFIER (for Create/Update/Delete)
// ═══════════════════════════════════════════════════════════
class DeviceFormState {
  final bool isLoading;
  final String? error;
  final Device? savedDevice;
  final bool isDeleted;

  const DeviceFormState({
    this.isLoading = false,
    this.error,
    this.savedDevice,
    this.isDeleted = false,
  });

  DeviceFormState copyWith({
    bool? isLoading,
    String? error,
    Device? savedDevice,
    bool? isDeleted,
  }) {
    return DeviceFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedDevice: savedDevice ?? this.savedDevice,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class DeviceFormNotifier extends StateNotifier<DeviceFormState> {
  final DeviceRepository _repository;

  DeviceFormNotifier(this._repository) : super(const DeviceFormState());

  Future<bool> createDevice(String siteId, Device device) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final savedDevice = await _repository.createDevice(siteId, device);
      state = DeviceFormState(savedDevice: savedDevice);
      return true;
    } catch (e) {
      state = DeviceFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateDevice(String siteId, String devId, Device device) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final savedDevice = await _repository.updateDevice(siteId, devId, device);
      state = DeviceFormState(savedDevice: savedDevice);
      return true;
    } catch (e) {
      state = DeviceFormState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteDevice(String siteId, String devId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteDevice(siteId, devId);
      state = const DeviceFormState(isDeleted: true);
      return true;
    } catch (e) {
      state = DeviceFormState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const DeviceFormState();
  }
}

final deviceFormProvider =
    StateNotifierProvider<DeviceFormNotifier, DeviceFormState>((ref) {
      final repository = ref.watch(deviceRepositoryProvider);
      return DeviceFormNotifier(repository);
    });
