import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/device_remote_datasource.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

// ═══════════════════════════════════════════════════════════
// DATASOURCE PROVIDER
// ═══════════════════════════════════════════════════════════
final deviceRemoteDatasourceProvider = Provider<DeviceRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DeviceRemoteDatasourceImpl(dioClient.dio);
});

// ═══════════════════════════════════════════════════════════
// REPOSITORY PROVIDER
// ═══════════════════════════════════════════════════════════
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final datasource = ref.watch(deviceRemoteDatasourceProvider);
  return DeviceRepositoryImpl(datasource);
});

// ═══════════════════════════════════════════════════════════
// DEVICE LIST PROVIDER (by selected site)
// ═══════════════════════════════════════════════════════════
final utilitasDeviceListProvider = FutureProvider<List<Device>>((ref) async {
  final repository = ref.watch(deviceRepositoryProvider);
  final selectedSite = ref.watch(selectedSiteProvider);

  if (selectedSite == null) {
    throw Exception('Tidak ada site yang dipilih');
  }

  return repository.getDevicesBySite(selectedSite.siteId);
});

// ═══════════════════════════════════════════════════════════
// DEVICE DETAIL PROVIDER (by ID)
// ═══════════════════════════════════════════════════════════
final utilitasDeviceDetailProvider = FutureProvider.family<Device, String>((
  ref,
  deviceId,
) async {
  final repository = ref.watch(deviceRepositoryProvider);
  final selectedSite = ref.watch(selectedSiteProvider);

  if (selectedSite == null) {
    throw Exception('Tidak ada site yang dipilih');
  }

  return repository.getDeviceById(selectedSite.siteId, deviceId);
});

// ═══════════════════════════════════════════════════════════
// DEVICE FORM STATE
// ═══════════════════════════════════════════════════════════
class DeviceFormState {
  final bool isLoading;
  final String? error;
  final Device? savedDevice;

  const DeviceFormState({this.isLoading = false, this.error, this.savedDevice});

  DeviceFormState copyWith({
    bool? isLoading,
    String? error,
    Device? savedDevice,
  }) {
    return DeviceFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedDevice: savedDevice ?? this.savedDevice,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// DEVICE FORM NOTIFIER
// ═══════════════════════════════════════════════════════════
class DeviceFormNotifier extends StateNotifier<DeviceFormState> {
  final DeviceRepository _repository;
  final Ref _ref;

  DeviceFormNotifier(this._repository, this._ref)
    : super(const DeviceFormState());

  /// Create new device
  Future<bool> createDevice(Device device) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final savedDevice = await _repository.createDevice(
        selectedSite.siteId,
        device,
      );

      state = DeviceFormState(savedDevice: savedDevice);

      // Invalidate list to refresh
      _ref.invalidate(utilitasDeviceListProvider);

      return true;
    } catch (e) {
      state = DeviceFormState(error: e.toString());
      return false;
    }
  }

  /// Update existing device
  Future<bool> updateDevice(String deviceId, Device device) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      final savedDevice = await _repository.updateDevice(
        selectedSite.siteId,
        deviceId,
        device,
      );

      state = DeviceFormState(savedDevice: savedDevice);

      // Invalidate list and detail to refresh
      _ref.invalidate(utilitasDeviceListProvider);
      _ref.invalidate(utilitasDeviceDetailProvider(deviceId));

      return true;
    } catch (e) {
      state = DeviceFormState(error: e.toString());
      return false;
    }
  }

  /// Delete device
  Future<bool> deleteDevice(String deviceId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final selectedSite = _ref.read(selectedSiteProvider);
      if (selectedSite == null) {
        throw Exception('Tidak ada site yang dipilih');
      }

      await _repository.deleteDevice(selectedSite.siteId, deviceId);

      state = const DeviceFormState();

      // Invalidate list to refresh
      _ref.invalidate(utilitasDeviceListProvider);

      return true;
    } catch (e) {
      state = DeviceFormState(error: e.toString());
      return false;
    }
  }

  /// Reset form state
  void reset() {
    state = const DeviceFormState();
  }
}

// ═══════════════════════════════════════════════════════════
// DEVICE FORM PROVIDER
// ═══════════════════════════════════════════════════════════
final deviceFormProvider =
    StateNotifierProvider<DeviceFormNotifier, DeviceFormState>((ref) {
      final repository = ref.watch(deviceRepositoryProvider);
      return DeviceFormNotifier(repository, ref);
    });
