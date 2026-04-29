import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_form_fields.dart';
import 'package:simpulagromobile/features/utilitas/domain/entities/device.dart';

class DeviceFormScreen extends ConsumerStatefulWidget {
  final String? deviceId;

  const DeviceFormScreen({super.key, this.deviceId});

  @override
  ConsumerState<DeviceFormScreen> createState() => _DeviceFormScreenState();
}

class _DeviceFormScreenState extends ConsumerState<DeviceFormScreen> {
  final _formKey = GlobalKey<FormState>();

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

    if (isEditMode && !_isInitialized) {
      final deviceAsync = ref.watch(
        utilitasDeviceDetailProvider(widget.deviceId!),
      );
      deviceAsync.whenData((device) {
        if (!_isInitialized) _initializeForm(device);
      });

      if (deviceAsync.isLoading) {
        return UtilitasFormScaffold(
          title: 'Memuat...',
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }
      if (deviceAsync.hasError) {
        return UtilitasFormScaffold(
          title: 'Error',
          body: UtilitasErrorState(
            error: deviceAsync.error!,
            onRetry: () =>
                ref.invalidate(utilitasDeviceDetailProvider(widget.deviceId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'device:update' : 'device:create';

    return PermissionGuardScreen(
      permission: permission,
      child: UtilitasFormScaffold(
        title: isEditMode ? 'Edit Device' : 'Tambah Device',
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? 'Menyimpan perubahan...'
            : 'Membuat device...',
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
                isEditMode ? 'Edit Device' : 'Tambah Device',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(22),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1D1D1D),
                  height: 1.0,
                ),
              ),
              SizedBox(height: context.rh(0.014)),
              UtilitasSectionCard(
                title: 'Informasi Dasar',
                child: Column(
                  children: [
                    UtilitasFormFields.buildField(
                      context,
                      controller: _idController,
                      label: 'Device ID',
                      hint: 'Contoh: DEV001',
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Device ID wajib diisi';
                        if (v.length < 3) return 'Minimal 3 karakter';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: 'Nama Device',
                      hint: 'Contoh: Main Gateway',
                      icon: Icons.device_hub,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Nama device wajib diisi';
                        if (v.length < 3) return 'Minimal 3 karakter';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _locationController,
                      label: 'Lokasi',
                      hint: 'Contoh: Greenhouse A',
                      icon: Icons.place,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              UtilitasSectionCard(
                title: 'Koneksi',
                subtitle: 'Opsional — IP address dan port device',
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: UtilitasFormFields.buildField(
                        context,
                        controller: _ipController,
                        label: 'IP Address',
                        hint: '192.168.1.100',
                        icon: Icons.wifi,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                            if (!ipRegex.hasMatch(v)) return 'IP tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: context.rw(0.03)),
                    Expanded(
                      child: UtilitasFormFields.buildField(
                        context,
                        controller: _portController,
                        label: 'Port',
                        hint: '8080',
                        icon: Icons.settings_ethernet,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final port = int.tryParse(v);
                            if (port == null || port < 1 || port > 65535) {
                              return 'Tidak valid';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              UtilitasSectionCard(
                title: 'Koordinat',
                subtitle: 'Opsional — untuk pemetaan lokasi device',
                child: Column(
                  children: [
                    UtilitasFormFields.buildCoordinateRow(
                      context,
                      latController: _latController,
                      lonController: _lonController,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
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

              UtilitasSectionCard(
                title: 'Status',
                child: UtilitasFormFields.buildStatusToggle(
                  context,
                  label: 'Status Device',
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              UtilitasSubmitButton(
                label: isEditMode ? 'Simpan Perubahan' : 'Tambah Device',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

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
