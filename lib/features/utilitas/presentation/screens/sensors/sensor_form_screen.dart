import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/shared/widgets/loading_overlay.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/sensor.dart';
import 'package:simpulagromobile/features/monitoring/presentation/providers/monitoring_provider.dart';

class SensorFormScreen extends ConsumerStatefulWidget {
  final String? sensorId; // null = create, not null = edit

  const SensorFormScreen({super.key, this.sensorId});

  @override
  ConsumerState<SensorFormScreen> createState() => _SensorFormScreenState();
}

class _SensorFormScreenState extends ConsumerState<SensorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _locationController;
  late final TextEditingController _latController;
  late final TextEditingController _lonController;
  late final TextEditingController _altController;

  String? _selectedDeviceId;
  int _status = 1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _locationController = TextEditingController();
    _latController = TextEditingController();
    _lonController = TextEditingController();
    _altController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _altController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.sensorId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(sensorFormProvider);

    // Load sensor data for edit mode
    if (isEditMode && !_isInitialized) {
      final sensorAsync = ref.watch(
        utilitasSensorDetailProvider(widget.sensorId!),
      );

      sensorAsync.whenData((sensor) {
        if (!_isInitialized) {
          _initializeForm(sensor);
        }
      });

      if (sensorAsync.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (sensorAsync.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${sensorAsync.error}')),
        );
      }
    }

    final permission = isEditMode ? 'sensor:update' : 'sensor:create';

    return PermissionGuardScreen(
      permission: permission,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Sensor' : 'Tambah Sensor'),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: formState.isLoading,
          message: isEditMode ? 'Menyimpan perubahan...' : 'Membuat sensor...',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSensorIdField(),
                const Gap(16),
                _buildSensorNameField(),
                const Gap(16),
                _buildDeviceDropdown(),
                const Gap(16),
                _buildAddressField(),
                const Gap(16),
                _buildLocationField(),
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

  void _initializeForm(Sensor sensor) {
    _idController.text = sensor.sensId;
    _nameController.text = sensor.sensName ?? '';
    _addressController.text = sensor.sensAddress ?? '';
    _locationController.text = sensor.sensLocation ?? '';
    _latController.text = sensor.sensLat?.toString() ?? '';
    _lonController.text = sensor.sensLon?.toString() ?? '';
    _altController.text = sensor.sensAlt?.toString() ?? '';
    _selectedDeviceId = sensor.devId;
    _status = sensor.sensSts ?? 1;
    _isInitialized = true;
  }

  Widget _buildSensorIdField() {
    return TextFormField(
      controller: _idController,
      enabled: !isEditMode, // ID cannot be changed in edit mode
      decoration: InputDecoration(
        labelText: 'Sensor ID *',
        hintText: 'Contoh: soil_nitro',
        prefixIcon: const Icon(Icons.tag),
        filled: true,
        fillColor: isEditMode ? Colors.grey[100] : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Sensor ID wajib diisi';
        }
        if (value.length < 3) {
          return 'Sensor ID minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildSensorNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Sensor *',
        hintText: 'Contoh: Nitrogen Sensor',
        prefixIcon: Icon(Icons.sensors),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama sensor wajib diisi';
        }
        if (value.length < 3) {
          return 'Nama sensor minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildDeviceDropdown() {
    final devicesAsync = ref.watch(devicesProvider);

    return devicesAsync.when(
      data: (devices) {
        return DropdownButtonFormField<String>(
          value: _selectedDeviceId,
          decoration: const InputDecoration(
            labelText: 'Device',
            hintText: 'Pilih device (opsional)',
            prefixIcon: Icon(Icons.device_hub),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Tidak ada device'),
            ),
            ...devices.map((device) {
              return DropdownMenuItem(
                value: device.devId,
                child: Text(
                  '${device.devName ?? device.devId} (${device.devId})',
                ),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedDeviceId = value;
            });
          },
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Gagal memuat device'),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Alamat Sensor',
        hintText: 'Contoh: 0x10',
        prefixIcon: Icon(Icons.location_searching),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Lokasi',
        hintText: 'Contoh: Soil Layer 1',
        prefixIcon: Icon(Icons.place),
      ),
      maxLines: 2,
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
      title: const Text('Status Sensor'),
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
        isEditMode ? 'Simpan Perubahan' : 'Tambah Sensor',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create sensor entity
    final sensor = Sensor(
      sensId: _idController.text.trim(),
      devId: _selectedDeviceId,
      sensName: _nameController.text.trim(),
      sensAddress: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      sensLocation: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      sensLat: _latController.text.trim().isEmpty
          ? null
          : double.tryParse(_latController.text.trim()),
      sensLon: _lonController.text.trim().isEmpty
          ? null
          : double.tryParse(_lonController.text.trim()),
      sensAlt: _altController.text.trim().isEmpty
          ? null
          : double.tryParse(_altController.text.trim()),
      sensSts: _status,
    );

    // Submit
    final success = isEditMode
        ? await ref
              .read(sensorFormProvider.notifier)
              .updateSensor(widget.sensorId!, sensor)
        : await ref.read(sensorFormProvider.notifier).createSensor(sensor);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? 'Sensor berhasil diperbarui'
            : 'Sensor berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(sensorFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan sensor');
    }
  }
}
