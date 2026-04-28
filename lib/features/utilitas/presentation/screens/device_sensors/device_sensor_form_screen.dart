import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:simpulagromobile/shared/widgets/loading_overlay.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/device_sensor.dart';

class DeviceSensorFormScreen extends ConsumerStatefulWidget {
  final String? dsId;

  const DeviceSensorFormScreen({super.key, this.dsId});

  @override
  ConsumerState<DeviceSensorFormScreen> createState() =>
      _DeviceSensorFormScreenState();
}

class _DeviceSensorFormScreenState
    extends ConsumerState<DeviceSensorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _seqController;
  late final TextEditingController _normalValueController;
  late final TextEditingController _minNormController;
  late final TextEditingController _maxNormController;
  late final TextEditingController _minValueController;
  late final TextEditingController _maxValueController;
  late final TextEditingController _minWarnController;
  late final TextEditingController _maxWarnController;

  String? _selectedDeviceId;
  String? _selectedSensorId;
  String? _selectedUnitId;
  int _status = 1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _seqController = TextEditingController();
    _normalValueController = TextEditingController();
    _minNormController = TextEditingController();
    _maxNormController = TextEditingController();
    _minValueController = TextEditingController();
    _maxValueController = TextEditingController();
    _minWarnController = TextEditingController();
    _maxWarnController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _seqController.dispose();
    _normalValueController.dispose();
    _minNormController.dispose();
    _maxNormController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _minWarnController.dispose();
    _maxWarnController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.dsId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(deviceSensorFormProvider);

    if (isEditMode && !_isInitialized) {
      final dsAsync = ref.watch(
        utilitasDeviceSensorDetailProvider(widget.dsId!),
      );

      dsAsync.whenData((ds) {
        if (!_isInitialized) {
          _initializeForm(ds);
        }
      });

      if (dsAsync.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (dsAsync.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${dsAsync.error}')),
        );
      }
    }

    final permission = isEditMode ? 'ds:update' : 'ds:create';

    return PermissionGuardScreen(
      permission: permission,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditMode ? 'Edit Device Sensor' : 'Tambah Device Sensor',
          ),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: formState.isLoading,
          message: isEditMode ? 'Menyimpan perubahan...' : 'Membuat mapping...',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildIdField(),
                const Gap(16),
                _buildNameField(),
                const Gap(16),
                _buildDeviceDropdown(),
                const Gap(16),
                _buildSensorDropdown(),
                const Gap(16),
                _buildUnitDropdown(),
                const Gap(16),
                _buildAddressField(),
                const Gap(16),
                _buildSeqField(),
                const Gap(24),
                _buildThresholdSection(),
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

  void _initializeForm(DeviceSensor ds) {
    _idController.text = ds.dsId;
    _nameController.text = ds.dsName ?? '';
    _addressController.text = ds.dsAddress ?? '';
    _seqController.text = ds.dsSeq?.toString() ?? '';
    _normalValueController.text = ds.dcNormalValue?.toString() ?? '';
    _minNormController.text = ds.dsMinNormValue?.toString() ?? '';
    _maxNormController.text = ds.dsMaxNormValue?.toString() ?? '';
    _minValueController.text = ds.dsMinValue?.toString() ?? '';
    _maxValueController.text = ds.dsMaxValue?.toString() ?? '';
    _minWarnController.text = ds.dsMinValWarn?.toString() ?? '';
    _maxWarnController.text = ds.dsMaxValWarn?.toString() ?? '';
    _selectedDeviceId = ds.devId;
    _selectedSensorId = ds.sensId;
    _selectedUnitId = ds.unitId;
    _status = ds.dsSts ?? 1;
    _isInitialized = true;
  }

  Widget _buildIdField() {
    return TextFormField(
      controller: _idController,
      enabled: !isEditMode,
      decoration: InputDecoration(
        labelText: 'DS ID *',
        hintText: 'Contoh: DS001',
        prefixIcon: const Icon(Icons.tag),
        filled: true,
        fillColor: isEditMode ? Colors.grey[100] : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'DS ID wajib diisi';
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama *',
        hintText: 'Contoh: Nitrogen Sensor DEV001',
        prefixIcon: Icon(Icons.cable),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama wajib diisi';
        }
        return null;
      },
    );
  }

  Widget _buildDeviceDropdown() {
    final devicesAsync = ref.watch(utilitasDeviceListProvider);

    return devicesAsync.when(
      data: (devices) => DropdownButtonFormField<String>(
        value: _selectedDeviceId,
        decoration: const InputDecoration(
          labelText: 'Device *',
          prefixIcon: Icon(Icons.device_hub),
        ),
        items: devices
            .map(
              (d) => DropdownMenuItem(
                value: d.devId,
                child: Text('${d.displayName} (${d.devId})'),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _selectedDeviceId = value),
        validator: (value) => value == null ? 'Device wajib dipilih' : null,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Gagal memuat device'),
    );
  }

  Widget _buildSensorDropdown() {
    final sensorsAsync = ref.watch(utilitasSensorListProvider);

    return sensorsAsync.when(
      data: (sensors) => DropdownButtonFormField<String>(
        value: _selectedSensorId,
        decoration: const InputDecoration(
          labelText: 'Sensor',
          prefixIcon: Icon(Icons.sensors),
        ),
        items: [
          const DropdownMenuItem(value: null, child: Text('Tidak ada')),
          ...sensors.map(
            (s) => DropdownMenuItem(
              value: s.sensId,
              child: Text('${s.displayName} (${s.sensId})'),
            ),
          ),
        ],
        onChanged: (value) => setState(() => _selectedSensorId = value),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Gagal memuat sensor'),
    );
  }

  Widget _buildUnitDropdown() {
    final unitsAsync = ref.watch(utilitasUnitListProvider);

    return unitsAsync.when(
      data: (units) => DropdownButtonFormField<String>(
        value: _selectedUnitId,
        decoration: const InputDecoration(
          labelText: 'Unit',
          prefixIcon: Icon(Icons.straighten),
        ),
        items: [
          const DropdownMenuItem(value: null, child: Text('Tidak ada')),
          ...units.map(
            (u) => DropdownMenuItem(
              value: u.unitId,
              child: Text(u.displayNameWithSymbol),
            ),
          ),
        ],
        onChanged: (value) => setState(() => _selectedUnitId = value),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Gagal memuat unit'),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Alamat',
        hintText: 'Contoh: 0x10',
        prefixIcon: Icon(Icons.location_searching),
      ),
    );
  }

  Widget _buildSeqField() {
    return TextFormField(
      controller: _seqController,
      decoration: const InputDecoration(
        labelText: 'Urutan (Seq)',
        hintText: 'Contoh: 1',
        prefixIcon: Icon(Icons.format_list_numbered),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildThresholdSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Konfigurasi Threshold',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          'Atur batas nilai normal dan peringatan sensor',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const Gap(16),
        // Normal value
        TextFormField(
          controller: _normalValueController,
          decoration: const InputDecoration(
            labelText: 'Nilai Normal',
            prefixIcon: Icon(Icons.check_circle_outline, color: Colors.green),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const Gap(12),
        // Normal range
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minNormController,
                decoration: const InputDecoration(
                  labelText: 'Min Normal',
                  prefixIcon: Icon(Icons.arrow_downward, color: Colors.green),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: _maxNormController,
                decoration: const InputDecoration(
                  labelText: 'Max Normal',
                  prefixIcon: Icon(Icons.arrow_upward, color: Colors.green),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        // Absolute range
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minValueController,
                decoration: const InputDecoration(
                  labelText: 'Min Absolut',
                  prefixIcon: Icon(Icons.arrow_downward, color: Colors.blue),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: _maxValueController,
                decoration: const InputDecoration(
                  labelText: 'Max Absolut',
                  prefixIcon: Icon(Icons.arrow_upward, color: Colors.blue),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        // Warning range
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minWarnController,
                decoration: const InputDecoration(
                  labelText: 'Min Warning',
                  prefixIcon: Icon(Icons.warning_amber, color: Colors.orange),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: _maxWarnController,
                decoration: const InputDecoration(
                  labelText: 'Max Warning',
                  prefixIcon: Icon(Icons.warning_amber, color: Colors.orange),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSwitch() {
    return SwitchListTile(
      title: const Text('Status Mapping'),
      subtitle: Text(_status == 1 ? 'Aktif' : 'Nonaktif'),
      value: _status == 1,
      onChanged: (value) => setState(() => _status = value ? 1 : 0),
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
        isEditMode ? 'Simpan Perubahan' : 'Tambah Mapping',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  double? _parseDouble(String text) =>
      text.trim().isEmpty ? null : double.tryParse(text.trim());

  int? _parseInt(String text) =>
      text.trim().isEmpty ? null : int.tryParse(text.trim());

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDeviceId == null) {
      SnackbarHelper.showError(context, 'Device wajib dipilih');
      return;
    }

    final ds = DeviceSensor(
      dsId: _idController.text.trim(),
      devId: _selectedDeviceId!,
      sensId: _selectedSensorId,
      unitId: _selectedUnitId,
      dsName: _nameController.text.trim(),
      dsAddress: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      dsSeq: _parseInt(_seqController.text),
      dcNormalValue: _parseDouble(_normalValueController.text),
      dsMinNormValue: _parseDouble(_minNormController.text),
      dsMaxNormValue: _parseDouble(_maxNormController.text),
      dsMinValue: _parseDouble(_minValueController.text),
      dsMaxValue: _parseDouble(_maxValueController.text),
      dsMinValWarn: _parseDouble(_minWarnController.text),
      dsMaxValWarn: _parseDouble(_maxWarnController.text),
      dsSts: _status,
    );

    final success = isEditMode
        ? await ref
              .read(deviceSensorFormProvider.notifier)
              .updateDeviceSensor(widget.dsId!, ds)
        : await ref
              .read(deviceSensorFormProvider.notifier)
              .createDeviceSensor(ds);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? 'Mapping berhasil diperbarui'
            : 'Mapping berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(deviceSensorFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan mapping');
    }
  }
}
