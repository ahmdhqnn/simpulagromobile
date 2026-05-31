import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/domain/entities/device_sensor.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/device_sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/device_sensors/async_dropdown_widget.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/device_sensors/threshold_row_widget.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';

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

  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _seqController = TextEditingController();
  final _normalValueController = TextEditingController();
  final _minNormController = TextEditingController();
  final _maxNormController = TextEditingController();
  final _minValueController = TextEditingController();
  final _maxValueController = TextEditingController();
  final _minWarnController = TextEditingController();
  final _maxWarnController = TextEditingController();

  String? _selectedDeviceId;
  String? _selectedSensorId;
  String? _selectedUnitId;
  int _status = 1;
  bool _isInitialized = false;

  bool get _isEditMode => widget.dsId != null;

  @override
  void dispose() {
    for (final c in [
      _idController,
      _nameController,
      _addressController,
      _seqController,
      _normalValueController,
      _minNormController,
      _maxNormController,
      _minValueController,
      _maxValueController,
      _minWarnController,
      _maxWarnController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(adminDeviceSensorFormProvider);

    if (_isEditMode && !_isInitialized) {
      final dsAsync = ref.watch(
        adminDeviceSensorDetailProvider(widget.dsId!),
      );
      dsAsync.whenData((ds) {
        if (!_isInitialized) _initializeForm(ds);
      });

      if (dsAsync.isLoading) {
        return AdminFormScaffold(
          title: 'Memuat...',
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }
      if (dsAsync.hasError) {
        return AdminFormScaffold(
          title: 'Error',
          body: AdminErrorState(
            error: dsAsync.error!,
            onRetry: () => ref.invalidate(
              adminDeviceSensorDetailProvider(widget.dsId!),
            ),
          ),
        );
      }
    }

    final permission = _isEditMode ? 'ds:update' : 'ds:create';
    final title = _isEditMode ? 'Edit Device Sensor' : 'Tambah Device Sensor';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: title,
        isLoading: formState.isLoading,
        loadingMessage: _isEditMode
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
              Text(title, style: AppTextStyles.sectionTitle(context)),
              SizedBox(height: context.rh(0.014)),
              _MappingInfoSection(
                idController: _idController,
                nameController: _nameController,
                addressController: _addressController,
                seqController: _seqController,
                isEditMode: _isEditMode,
                selectedDeviceId: _selectedDeviceId,
                selectedSensorId: _selectedSensorId,
                selectedUnitId: _selectedUnitId,
                onDeviceChanged: (v) => setState(() => _selectedDeviceId = v),
                onSensorChanged: (v) => setState(() => _selectedSensorId = v),
                onUnitChanged: (v) => setState(() => _selectedUnitId = v),
              ),
              SizedBox(height: context.rh(0.02)),
              _ThresholdSection(
                normalValueController: _normalValueController,
                minNormController: _minNormController,
                maxNormController: _maxNormController,
                minValueController: _minValueController,
                maxValueController: _maxValueController,
                minWarnController: _minWarnController,
                maxWarnController: _maxWarnController,
              ),
              SizedBox(height: context.rh(0.02)),
              AdminSectionCard(
                title: 'Status',
                child: AdminFormFields.buildStatusToggle(
                  context,
                  label: 'Status Mapping',
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),
              AdminSubmitButton(
                label: _isEditMode ? 'Simpan Perubahan' : 'Tambah Mapping',
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
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

    final minNorm = _parseDouble(_minNormController.text);
    final maxNorm = _parseDouble(_maxNormController.text);
    final minValue = _parseDouble(_minValueController.text);
    final maxValue = _parseDouble(_maxValueController.text);
    final minWarn = _parseDouble(_minWarnController.text);
    final maxWarn = _parseDouble(_maxWarnController.text);

    if (minNorm != null && maxNorm != null && minNorm > maxNorm) {
      SnackbarHelper.showError(context, 'Min Normal tidak boleh lebih besar dari Max Normal');
      return;
    }
    if (minValue != null && maxValue != null && minValue > maxValue) {
      SnackbarHelper.showError(context, 'Min Absolut tidak boleh lebih besar dari Max Absolut');
      return;
    }
    if (minWarn != null && maxWarn != null && minWarn > maxWarn) {
      SnackbarHelper.showError(context, 'Min Warning tidak boleh lebih besar dari Max Warning');
      return;
    }

    if (minValue != null) {
      if (minNorm != null && minValue > minNorm) {
        SnackbarHelper.showError(context, 'Min Absolut tidak boleh lebih besar dari Min Normal');
        return;
      }
      if (minWarn != null && minValue > minWarn) {
        SnackbarHelper.showError(context, 'Min Absolut tidak boleh lebih besar dari Min Warning');
        return;
      }
    }

    if (maxValue != null) {
      if (maxNorm != null && maxValue < maxNorm) {
        SnackbarHelper.showError(context, 'Max Absolut tidak boleh lebih kecil dari Max Normal');
        return;
      }
      if (maxWarn != null && maxValue < maxWarn) {
        SnackbarHelper.showError(context, 'Max Absolut tidak boleh lebih kecil dari Max Warning');
        return;
      }
    }

    if (minWarn != null && minNorm != null && minWarn > minNorm) {
      SnackbarHelper.showError(context, 'Min Warning tidak boleh lebih besar dari Min Normal');
      return;
    }

    if (maxWarn != null && maxNorm != null && maxWarn < maxNorm) {
      SnackbarHelper.showError(context, 'Max Warning tidak boleh lebih kecil dari Max Normal');
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

    final notifier = ref.read(adminDeviceSensorFormProvider.notifier);
    final success = _isEditMode
        ? await notifier.updateDeviceSensor(widget.dsId!, ds)
        : await notifier.createDeviceSensor(ds);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        _isEditMode
            ? 'Mapping berhasil diperbarui'
            : 'Mapping berhasil ditambahkan',
      );
      context.pop();
    } else {
      final error = ref.read(adminDeviceSensorFormProvider).error;
      SnackbarHelper.showError(context, error ?? 'Gagal menyimpan mapping');
    }
  }
}

class _MappingInfoSection extends ConsumerWidget {
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController seqController;
  final bool isEditMode;
  final String? selectedDeviceId;
  final String? selectedSensorId;
  final String? selectedUnitId;
  final ValueChanged<String?> onDeviceChanged;
  final ValueChanged<String?> onSensorChanged;
  final ValueChanged<String?> onUnitChanged;

  const _MappingInfoSection({
    required this.idController,
    required this.nameController,
    required this.addressController,
    required this.seqController,
    required this.isEditMode,
    required this.selectedDeviceId,
    required this.selectedSensorId,
    required this.selectedUnitId,
    required this.onDeviceChanged,
    required this.onSensorChanged,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdminSectionCard(
      title: 'Informasi Mapping',
      child: Column(
        children: [
          AdminFormFields.buildField(
            context,
            controller: idController,
            label: 'DS ID',
            hint: 'Contoh: DS001',
            icon: Icons.tag,
            enabled: !isEditMode,
            required: true,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'DS ID wajib diisi' : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AdminFormFields.buildField(
            context,
            controller: nameController,
            label: 'Nama',
            hint: 'Contoh: Nitrogen Sensor DEV001',
            icon: Icons.cable,
            required: true,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AsyncDropdownWidget<dynamic, String>(
            async: ref.watch(adminDeviceListProvider),
            value: selectedDeviceId,
            label: 'Device *',
            hint: 'Pilih device',
            icon: Icons.device_hub,
            errorMessage: 'Gagal memuat device',
            itemBuilder: (devices) => devices
                .map(
                  (d) => DropdownMenuItem<String>(
                    value: d.devId,
                    child: Text('${d.displayName} (${d.devId})'),
                  ),
                )
                .toList(),
            onChanged: onDeviceChanged,
            validator: (v) => v == null ? 'Device wajib dipilih' : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AsyncDropdownWidget<dynamic, String>(
            async: ref.watch(adminSensorListProvider),
            value: selectedSensorId,
            label: 'Sensor',
            hint: 'Pilih sensor (opsional)',
            icon: Icons.sensors,
            errorMessage: 'Gagal memuat sensor',
            itemBuilder: (sensors) => [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Tidak ada'),
              ),
              ...sensors.map(
                (s) => DropdownMenuItem<String>(
                  value: s.sensId,
                  child: Text('${s.displayName} (${s.sensId})'),
                ),
              ),
            ],
            onChanged: onSensorChanged,
          ),
          SizedBox(height: context.rh(0.016)),
          AsyncDropdownWidget<dynamic, String>(
            async: ref.watch(adminUnitListProvider),
            value: selectedUnitId,
            label: 'Unit',
            hint: 'Pilih unit (opsional)',
            icon: Icons.straighten,
            errorMessage: 'Gagal memuat unit',
            itemBuilder: (units) => [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Tidak ada'),
              ),
              ...units.map(
                (u) => DropdownMenuItem<String>(
                  value: u.unitId,
                  child: Text(u.displayNameWithSymbol),
                ),
              ),
            ],
            onChanged: onUnitChanged,
          ),
          SizedBox(height: context.rh(0.016)),
          AdminFormFields.buildField(
            context,
            controller: addressController,
            label: 'Alamat',
            hint: 'Contoh: 0x10',
            icon: Icons.location_searching,
          ),
          SizedBox(height: context.rh(0.016)),
          AdminFormFields.buildField(
            context,
            controller: seqController,
            label: 'Urutan (Seq)',
            hint: 'Contoh: 1',
            icon: Icons.format_list_numbered,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

/// Section: nilai threshold normal/absolut/warning.
class _ThresholdSection extends StatelessWidget {
  final TextEditingController normalValueController;
  final TextEditingController minNormController;
  final TextEditingController maxNormController;
  final TextEditingController minValueController;
  final TextEditingController maxValueController;
  final TextEditingController minWarnController;
  final TextEditingController maxWarnController;

  const _ThresholdSection({
    required this.normalValueController,
    required this.minNormController,
    required this.maxNormController,
    required this.minValueController,
    required this.maxValueController,
    required this.minWarnController,
    required this.maxWarnController,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Threshold',
      subtitle: 'Konfigurasi batas nilai sensor',
      child: Column(
        children: [
          AdminFormFields.buildField(
            context,
            controller: normalValueController,
            label: 'Nilai Normal',
            hint: 'Contoh: 25.0',
            icon: Icons.check_circle_outline,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: context.rh(0.016)),
          ThresholdRowWidget(
            leftController: minNormController,
            leftLabel: 'Min Normal',
            leftIcon: Icons.arrow_downward,
            leftColor: AppColors.success,
            rightController: maxNormController,
            rightLabel: 'Max Normal',
            rightIcon: Icons.arrow_upward,
            rightColor: AppColors.success,
          ),
          SizedBox(height: context.rh(0.016)),
          ThresholdRowWidget(
            leftController: minValueController,
            leftLabel: 'Min Absolut',
            leftIcon: Icons.arrow_downward,
            leftColor: AppColors.info,
            rightController: maxValueController,
            rightLabel: 'Max Absolut',
            rightIcon: Icons.arrow_upward,
            rightColor: AppColors.info,
          ),
          SizedBox(height: context.rh(0.016)),
          ThresholdRowWidget(
            leftController: minWarnController,
            leftLabel: 'Min Warning',
            leftIcon: Icons.warning_amber,
            leftColor: AppColors.warning,
            rightController: maxWarnController,
            rightLabel: 'Max Warning',
            rightIcon: Icons.warning_amber,
            rightColor: AppColors.warning,
          ),
        ],
      ),
    );
  }
}
