import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_scaffold.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_form_fields.dart';
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
        if (!_isInitialized) _initializeForm(ds);
      });

      if (dsAsync.isLoading) {
        return UtilitasFormScaffold(
          title: 'Memuat...',
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }
      if (dsAsync.hasError) {
        return UtilitasFormScaffold(
          title: 'Error',
          body: UtilitasErrorState(
            error: dsAsync.error!,
            onRetry: () => ref.invalidate(
              utilitasDeviceSensorDetailProvider(widget.dsId!),
            ),
          ),
        );
      }
    }

    final permission = isEditMode ? 'ds:update' : 'ds:create';

    return PermissionGuardScreen(
      permission: permission,
      child: UtilitasFormScaffold(
        title: isEditMode ? 'Edit Device Sensor' : 'Tambah Device Sensor',
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? 'Menyimpan perubahan...'
            : 'Membuat mapping...',
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
                isEditMode ? 'Edit Device Sensor' : 'Tambah Device Sensor',
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
                title: 'Informasi Mapping',
                child: Column(
                  children: [
                    UtilitasFormFields.buildField(
                      context,
                      controller: _idController,
                      label: 'DS ID',
                      hint: 'Contoh: DS001',
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'DS ID wajib diisi';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: 'Nama',
                      hint: 'Contoh: Nitrogen Sensor DEV001',
                      icon: Icons.cable,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Nama wajib diisi';
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildDeviceDropdown(context),
                    SizedBox(height: context.rh(0.016)),
                    _buildSensorDropdown(context),
                    SizedBox(height: context.rh(0.016)),
                    _buildUnitDropdown(context),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _addressController,
                      label: 'Alamat',
                      hint: 'Contoh: 0x10',
                      icon: Icons.location_searching,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    UtilitasFormFields.buildField(
                      context,
                      controller: _seqController,
                      label: 'Urutan (Seq)',
                      hint: 'Contoh: 1',
                      icon: Icons.format_list_numbered,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              UtilitasSectionCard(
                title: 'Threshold',
                subtitle: 'Konfigurasi batas nilai sensor',
                child: Column(
                  children: [
                    UtilitasFormFields.buildField(
                      context,
                      controller: _normalValueController,
                      label: 'Nilai Normal',
                      hint: 'Contoh: 25.0',
                      icon: Icons.check_circle_outline,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildThresholdRow(
                      context,
                      leftController: _minNormController,
                      leftLabel: 'Min Normal',
                      leftIcon: Icons.arrow_downward,
                      leftColor: AppColors.success,
                      rightController: _maxNormController,
                      rightLabel: 'Max Normal',
                      rightIcon: Icons.arrow_upward,
                      rightColor: AppColors.success,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildThresholdRow(
                      context,
                      leftController: _minValueController,
                      leftLabel: 'Min Absolut',
                      leftIcon: Icons.arrow_downward,
                      leftColor: AppColors.info,
                      rightController: _maxValueController,
                      rightLabel: 'Max Absolut',
                      rightIcon: Icons.arrow_upward,
                      rightColor: AppColors.info,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildThresholdRow(
                      context,
                      leftController: _minWarnController,
                      leftLabel: 'Min Warning',
                      leftIcon: Icons.warning_amber,
                      leftColor: AppColors.warning,
                      rightController: _maxWarnController,
                      rightLabel: 'Max Warning',
                      rightIcon: Icons.warning_amber,
                      rightColor: AppColors.warning,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              UtilitasSectionCard(
                title: 'Status',
                child: UtilitasFormFields.buildStatusToggle(
                  context,
                  label: 'Status Mapping',
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              UtilitasSubmitButton(
                label: isEditMode ? 'Simpan Perubahan' : 'Tambah Mapping',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThresholdRow(
    BuildContext context, {
    required TextEditingController leftController,
    required String leftLabel,
    required IconData leftIcon,
    required Color leftColor,
    required TextEditingController rightController,
    required String rightLabel,
    required IconData rightIcon,
    required Color rightColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: leftController,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              color: const Color(0xFF1D1D1D),
            ),
            decoration: InputDecoration(
              labelText: leftLabel,
              prefixIcon: Icon(leftIcon, size: 18, color: leftColor),
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
          ),
        ),
        SizedBox(width: context.rw(0.03)),
        Expanded(
          child: TextFormField(
            controller: rightController,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              color: const Color(0xFF1D1D1D),
            ),
            decoration: InputDecoration(
              labelText: rightLabel,
              prefixIcon: Icon(rightIcon, size: 18, color: rightColor),
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              labelStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceDropdown(BuildContext context) {
    final devicesAsync = ref.watch(utilitasDeviceListProvider);
    return devicesAsync.when(
      data: (devices) => UtilitasFormFields.buildDropdown<String>(
        context,
        value: _selectedDeviceId,
        label: 'Device *',
        hint: 'Pilih device',
        icon: Icons.device_hub,
        items: devices
            .map(
              (d) => DropdownMenuItem(
                value: d.devId,
                child: Text('${d.displayName} (${d.devId})'),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _selectedDeviceId = v),
        validator: (v) => v == null ? 'Device wajib dipilih' : null,
      ),
      loading: () => _loadingDropdown(context),
      error: (_, __) => _errorDropdown(context, 'Gagal memuat device'),
    );
  }

  Widget _buildSensorDropdown(BuildContext context) {
    final sensorsAsync = ref.watch(utilitasSensorListProvider);
    return sensorsAsync.when(
      data: (sensors) => UtilitasFormFields.buildDropdown<String>(
        context,
        value: _selectedSensorId,
        label: 'Sensor',
        hint: 'Pilih sensor (opsional)',
        icon: Icons.sensors,
        items: [
          const DropdownMenuItem(value: null, child: Text('Tidak ada')),
          ...sensors.map(
            (s) => DropdownMenuItem(
              value: s.sensId,
              child: Text('${s.displayName} (${s.sensId})'),
            ),
          ),
        ],
        onChanged: (v) => setState(() => _selectedSensorId = v),
      ),
      loading: () => _loadingDropdown(context),
      error: (_, __) => _errorDropdown(context, 'Gagal memuat sensor'),
    );
  }

  Widget _buildUnitDropdown(BuildContext context) {
    final unitsAsync = ref.watch(utilitasUnitListProvider);
    return unitsAsync.when(
      data: (units) => UtilitasFormFields.buildDropdown<String>(
        context,
        value: _selectedUnitId,
        label: 'Unit',
        hint: 'Pilih unit (opsional)',
        icon: Icons.straighten,
        items: [
          const DropdownMenuItem(value: null, child: Text('Tidak ada')),
          ...units.map(
            (u) => DropdownMenuItem(
              value: u.unitId,
              child: Text(u.displayNameWithSymbol),
            ),
          ),
        ],
        onChanged: (v) => setState(() => _selectedUnitId = v),
      ),
      loading: () => _loadingDropdown(context),
      error: (_, __) => _errorDropdown(context, 'Gagal memuat unit'),
    );
  }

  Widget _loadingDropdown(BuildContext context) {
    return Container(
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
    );
  }

  Widget _errorDropdown(BuildContext context, String message) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(13),
            color: AppColors.error,
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
