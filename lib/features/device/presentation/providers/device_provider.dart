import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/provider_utils.dart';
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
final deviceListProvider = FutureProvider.autoDispose
    .family<List<Device>, String>((ref, siteId) async {
      final repository = ref.watch(deviceRepositoryProvider);
      return await ref.retryOnError(() async {
        final result = await repository.getDevices(siteId);
        return result.fold((failure) => throw failure, (devices) => devices);
      });
    });

// ═══════════════════════════════════════════════════════════
// DEVICE DETAIL PROVIDER (by Site ID & Device ID)
// ═══════════════════════════════════════════════════════════
final deviceDetailProvider = FutureProvider.autoDispose
    .family<Device, ({String siteId, String devId})>((ref, params) async {
      final repository = ref.watch(deviceRepositoryProvider);
      return await ref.retryOnError(() async {
        final result = await repository.getDeviceById(
          params.siteId,
          params.devId,
        );
        return result.fold((failure) => throw failure, (device) => device);
      });
    });

// ═══════════════════════════════════════════════════════════
// DEVICE COORDINATES PROVIDER
// ═══════════════════════════════════════════════════════════
final deviceCoordinatesProvider = FutureProvider.autoDispose
    .family<List<Device>, String>((ref, siteId) async {
      final repository = ref.watch(deviceRepositoryProvider);
      return await ref.retryOnError(() async {
        final result = await repository.getDeviceCoordinates(siteId);
        return result.fold((failure) => throw failure, (devices) => devices);
      });
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
    final result = await _repository.createDevice(siteId, device);
    return result.fold(
      (failure) {
        state = DeviceFormState(error: failure.message);
        return false;
      },
      (savedDevice) {
        state = DeviceFormState(savedDevice: savedDevice);
        return true;
      },
    );
  }

  Future<bool> updateDevice(String siteId, String devId, Device device) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.updateDevice(siteId, devId, device);
    return result.fold(
      (failure) {
        state = DeviceFormState(error: failure.message);
        return false;
      },
      (savedDevice) {
        state = DeviceFormState(savedDevice: savedDevice);
        return true;
      },
    );
  }

  Future<bool> deleteDevice(String siteId, String devId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.deleteDevice(siteId, devId);
    return result.fold(
      (failure) {
        state = DeviceFormState(error: failure.message);
        return false;
      },
      (_) {
        state = const DeviceFormState(isDeleted: true);
        return true;
      },
    );
  }

  void reset() {
    state = const DeviceFormState();
  }
}

final deviceFormProvider =
    StateNotifierProvider.autoDispose<DeviceFormNotifier, DeviceFormState>((
      ref,
    ) {
      final repository = ref.watch(deviceRepositoryProvider);
      return DeviceFormNotifier(repository);
    });
