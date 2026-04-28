import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/shared/widgets/loading_overlay.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/device.dart';

class DeviceFormScreen extends ConsumerStatefulWidget {
  final String? deviceId; // null = create, not null = edit

  const DeviceFormScreen({super.key, this.deviceId});

  @override
  ConsumerState<DeviceFormScreen> createState() => _DeviceFormScreenState();
}

class _DeviceFormScreenState extends ConsumerState<DeviceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _ipController;
  late final TextEditingController _portController;
  late final TextEditingController _latController;
  late final TextEditingController _lonController;
  late final TextEditingController _altController;

  int _status = 1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _locationController = TextEditingController();
    _ipController = TextEditingController();
    _portController = TextEditingController();
    _latController = TextEditingController();
    _lonController = TextEditingController();
    _altController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _altController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.deviceId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(deviceFormProvider);

    // Load device data for edit mode
    if (isEditMode && !_isInitialized) {
      final deviceAsync = ref.watch(
        utilitasDeviceDetailProvider(widget.deviceId!),
      );

      deviceAsync.whenData((device) {
        if (!_isInitialized) {
          _initializeForm(device);
        }
      });

      if (deviceAsync.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (deviceAsync.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${deviceAsync.error}')),
        );
      }
    }

    final permission = isEditMode ? 'device:update' : 'device:create';

    return PermissionGuardScreen(
      permission: permission,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Device' : 'Tambah Device'),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: formState.isLoading,
          message: isEditMode ? 'Menyimpan perubahan...' : 'Membuat device...',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDeviceIdField(),
                const Gap(16),
                _buildDeviceNameField(),
                const Gap(16),
                _buildLocationField(),
                const Gap(24),
                _buildConnectionSection(),
                const Gap(24),
                _buildCoordinatesSection(),
                const Gap(24),
                _buildStatusSwitch(),
                const Gap(32),
                _buildSubmitButton(),
                const Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initializeForm(Device device) {
    _idController.text = device.devId;
    _nameController.text = device.devName ?? '';
    _locationController.text = device.devLocation ?? '';
    _ipController.text = device.devIp ?? '';
    _portController.text = device.devPort ?? '';
    _latController.text = device.devLat?.toString() ?? '';
    _lonController.text = device.devLon?.toString() ?? '';
    _altController.text = device.devAlt?.toString() ?? '';
    _status = device.devSts ?? 1;
    _isInitialized = true;
  }

  Widget _buildDeviceIdField() {
    return TextFormField(
      controller: _idController,
      enabled: !isEditMode,
      decoration: InputDecoration(
        labelText: 'Device ID *',
        hintText: 'Contoh: DEV001',
        prefixIcon: const Icon(Icons.tag),
        filled: true,
        fillColor: isEditMode ? Colors.grey[100] : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Device ID wajib diisi';
        }
        if (value.length < 3) {
          return 'Device ID minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildDeviceNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Device *',
        hintText: 'Contoh: Main Gateway',
        prefixIcon: Icon(Icons.device_hub),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama device wajib diisi';
        }
        if (value.length < 3) {
          return 'Nama device minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Lokasi',
        hintText: 'Contoh: Greenhouse A',
        prefixIcon: Icon(Icons.place),
      ),
      maxLines: 2,
    );
  }

  Widget _buildConnectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Koneksi (Opsional)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                  hintText: '192.168.1.100',
                  prefixIcon: Icon(Icons.wifi),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                    if (!ipRegex.hasMatch(value)) {
                      return 'IP tidak valid';
                    }
                  }
                  return null;
                },
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: _portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  hintText: '8080',
                  prefixIcon: Icon(Icons.settings_ethernet),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final port = int.tryParse(value);
                    if (port == null || port < 1 || port > 65535) {
                      return 'Port tidak valid';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoordinatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Koordinat (Opsional)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _latController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  hintText: '-7.7956',
                  prefixIcon: Icon(Icons.my_location),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final lat = double.tryParse(value);
                    if (lat == null || lat < -90 || lat > 90) {
                      return 'Latitude tidak valid';
                    }
                  }
                  return null;
                },
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: _lonController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  hintText: '110.3695',
                  prefixIcon: Icon(Icons.location_on),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final lon = double.tryParse(value);
                    if (lon == null || lon < -180 || lon > 180) {
                      return 'Longitude tidak valid';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const Gap(12),
        TextFormField(
          controller: _altController,
          decoration: const InputDecoration(
            labelText: 'Altitude (meter)',
            hintText: '113.5',
            prefixIcon: Icon(Icons.terrain),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final alt = double.tryParse(value);
              if (alt == null || alt < 0) {
                return 'Altitude tidak valid';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStatusSwitch() {
    return SwitchListTile(
      title: const Text('Status Device'),
      subtitle: Text(_status == 1 ? 'Aktif' : 'Nonaktif'),
      value: _status == 1,
      onChanged: (value) {
        setState(() {
          _status = value ? 1 : 0;
        });
      },
      secondary: Icon(
        _status == 1 ? Icons.check_circle : Icons.cancel,
        color: _status == 1 ? Colors.green : Colors.grey,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _handleSubmit,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isEditMode ? 'Simpan Perubahan' : 'Tambah Device',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create device entity
    final device = Device(
      devId: _idController.text.trim(),
      devName: _nameController.text.trim(),
      devLocation: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      devIp: _ipController.text.trim().isEmpty
          ? null
          : _ipController.text.trim(),
      devPort: _portController.text.trim().isEmpty
          ? null
          : _portController.text.trim(),
      devLat: _latController.text.trim().isEmpty
          ? null
          : double.tryParse(_latController.text.trim()),
      devLon: _lonController.text.trim().isEmpty
          ? null
          : double.tryParse(_lonController.text.trim()),
      devAlt: _altController.text.trim().isEmpty
          ? null
          : double.tryParse(_altController.text.trim()),
      devSts: _status,
    );

    // Submit
    final success = isEditMode
        ? await ref
              .read(deviceFormProvider.notifier)
              .updateDevice(widget.deviceId!, device)
        : await ref.read(deviceFormProvider.notifier).createDevice(device);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? 'Device berhasil diperbarui'
            : 'Device berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(deviceFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan device');
    }
  }
}
