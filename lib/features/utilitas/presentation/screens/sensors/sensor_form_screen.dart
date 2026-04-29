import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/sensor.dart';
import 'package:simpulagromobile/features/monitoring/presentation/providers/monitoring_provider.dart';

class SensorFormScreen extends ConsumerStatefulWidget {
  final String? sensorId;

  const SensorFormScreen({super.key, this.sensorId});

  @override
  ConsumerState<SensorFormScreen> createState() => _SensorFormScreenState();
}

class _SensorFormScreenState extends ConsumerState<SensorFormScreen> {
  final _formKey = GlobalKey<FormState>();

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

    if (isEditMode && !_isInitialized) {
      final sensorAsync = ref.watch(
        utilitasSensorDetailProvider(widget.sensorId!),
      );
      sensorAsync.whenData((sensor) {
        if (!_isInitialized) _initializeForm(sensor);
      });

      if (sensorAsync.isLoading) {
        return UtilitasFormScaffold(
          title: 'Memuat...',
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }
      if (sensorAsync.hasError) {
        return UtilitasFormScaffold(
          title: 'Error',
          body: UtilitasErrorState(
            error: sensorAsync.error!,
            onRetry: () =>
                ref.invalidate(utilitasSensorDetailProvider(widget.sensorId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'sensor:update' : 'sensor:create';

    return PermissionGuardScreen(
      permission: permission,
      child: UtilitasFormScaffold(
        title: isEditMode ? 'Edit Sensor' : 'Tambah Sensor',
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? 'Menyimpan perubahan...'
            : 'Membuat sensor...',
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              SizedBox(height: context.rh(0.01)),
              Text(
                isEditMode ? 'Edit Sensor' : 'Tambah Sensor',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(22),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1D1D1D),
                  height: 1.0,
                ),
              ),
              SizedBox(height: context.rh(0.014)),
              // ── Informasi Dasar ──────────────────────────
              UtilitasSectionCard(
                title: 'Informasi Dasar',
                child: Column(
                  children: [
                    _buildField(
                      controller: _idController,
                      label: 'Sensor ID',
                      hint: 'Contoh: soil_nitro',
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Sensor ID wajib diisi';
                        if (v.length < 3) return 'Minimal 3 karakter';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildField(
                      controller: _nameController,
                      label: 'Nama Sensor',
                      hint: 'Contoh: Nitrogen Sensor',
                      icon: Icons.sensors,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Nama sensor wajib diisi';
                        if (v.length < 3) return 'Minimal 3 karakter';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildDeviceDropdown(),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              // ── Konfigurasi ──────────────────────────────
              UtilitasSectionCard(
                title: 'Konfigurasi',
                child: Column(
                  children: [
                    _buildField(
                      controller: _addressController,
                      label: 'Alamat Sensor',
                      hint: 'Contoh: 0x10',
                      icon: Icons.location_searching,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildField(
                      controller: _locationController,
                      label: 'Lokasi',
                      hint: 'Contoh: Soil Layer 1',
                      icon: Icons.place,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              // ── Koordinat ────────────────────────────────
              UtilitasSectionCard(
                title: 'Koordinat',
                subtitle: 'Opsional — untuk pemetaan lokasi sensor',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _latController,
                            label: 'Latitude',
                            hint: '-7.7956',
                            icon: Icons.my_location,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: (v) {
                              if (v != null && v.isNotEmpty) {
                                final lat = double.tryParse(v);
                                if (lat == null || lat < -90 || lat > 90) {
                                  return 'Tidak valid';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: context.rw(0.03)),
                        Expanded(
                          child: _buildField(
                            controller: _lonController,
                            label: 'Longitude',
                            hint: '110.3695',
                            icon: Icons.location_on,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: (v) {
                              if (v != null && v.isNotEmpty) {
                                final lon = double.tryParse(v);
                                if (lon == null || lon < -180 || lon > 180) {
                                  return 'Tidak valid';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildField(
                      controller: _altController,
                      label: 'Altitude (meter)',
                      hint: '113.5',
                      icon: Icons.terrain,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              // ── Status ───────────────────────────────────
              UtilitasSectionCard(
                title: 'Status',
                child: _buildStatusToggle(
                  label: 'Status Sensor',
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              // ── Submit ───────────────────────────────────
              UtilitasSubmitButton(
                label: isEditMode ? 'Simpan Perubahan' : 'Tambah Sensor',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(14),
        color: const Color(0xFF1D1D1D),
      ),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: enabled
            ? AppColors.surfaceVariant
            : const Color(0xFF1D1D1D).withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: context.sp(14),
          color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: context.sp(13),
          color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDeviceDropdown() {
    final devicesAsync = ref.watch(devicesProvider);

    return devicesAsync.when(
      data: (devices) => DropdownButtonFormField<String>(
        value: _selectedDeviceId,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: context.sp(14),
          color: const Color(0xFF1D1D1D),
        ),
        decoration: InputDecoration(
          labelText: 'Device',
          hintText: 'Pilih device (opsional)',
          prefixIcon: const Icon(Icons.device_hub, size: 20),
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          labelStyle: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(14),
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
          ),
        ),
        items: [
          const DropdownMenuItem(value: null, child: Text('Tidak ada device')),
          ...devices.map(
            (d) => DropdownMenuItem(
              value: d.devId,
              child: Text('${d.devName ?? d.devId} (${d.devId})'),
            ),
          ),
        ],
        onChanged: (v) => setState(() => _selectedDeviceId = v),
      ),
      loading: () => Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      error: (_, __) => Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Gagal memuat device',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: AppColors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (value ? AppColors.success : Colors.grey).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            value ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: value ? AppColors.success : Colors.grey,
            size: 22,
          ),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
              Text(
                value ? 'Aktif' : 'Nonaktif',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

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
