import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
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
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

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
      final dsAsync = ref.watch(adminDeviceSensorDetailProvider(widget.dsId!));
      dsAsync.whenData((ds) {
        if (!_isInitialized) _initializeForm(ds);
      });

      if (dsAsync.isLoading) {
        return AdminFormScaffold(
          title: context.l10n.adminEditDeviceSensorTitle,
          body: const AdminFormScreenSkeleton(
            titleWidth: 220,
            sectionFieldCounts: [5, 7],
          ),
        );
      }
      if (dsAsync.hasError) {
        return AdminFormScaffold(
          title: context.l10n.commonErrorTitle,
          body: AdminErrorState(
            error: dsAsync.error!,
            onRetry: () =>
                ref.invalidate(adminDeviceSensorDetailProvider(widget.dsId!)),
          ),
        );
      }
    }

    final permission = _isEditMode ? 'ds:update' : 'ds:create';
    final title = _isEditMode
        ? context.l10n.adminEditDeviceSensorTitle
        : context.l10n.adminAddDeviceSensorTitle;

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: title,
        isLoading: formState.isLoading,
        loadingMessage: _isEditMode
            ? context.l10n.adminSavingChanges
            : context.l10n.adminCreatingMapping,
        body: Form(
          key: _formKey,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              _MappingInfoSection(
                idController: _idController,
                nameController: _nameController,
                addressController: _addressController,
                seqController: _seqController,
                isEditMode: _isEditMode,
                selectedDeviceId: _selectedDeviceId,
                selectedSensorId: _selectedSensorId,
                selectedUnitId: _selectedUnitId,
                onDeviceChanged: _isEditMode
                    ? null
                    : (v) => setState(() => _selectedDeviceId = v),
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
                title: context.l10n.adminStatusSection,
                child: AdminFormFields.buildStatusToggle(
                  context,
                  label: context.l10n.adminStatusMappingLabel,
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),
              AdminSubmitButton(
                label: _isEditMode
                    ? context.l10n.commonSaveChanges
                    : context.l10n.adminAddDeviceSensorTitle,
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
      SnackbarHelper.showError(context, context.l10n.adminDeviceRequired);
      return;
    }

    final minNorm = _parseDouble(_minNormController.text);
    final maxNorm = _parseDouble(_maxNormController.text);
    final minValue = _parseDouble(_minValueController.text);
    final maxValue = _parseDouble(_maxValueController.text);
    final minWarn = _parseDouble(_minWarnController.text);
    final maxWarn = _parseDouble(_maxWarnController.text);

    if (!_isEditMode &&
        (_selectedSensorId == null ||
            _selectedUnitId == null ||
            _addressController.text.trim().isEmpty ||
            _parseInt(_seqController.text) == null ||
            _parseDouble(_normalValueController.text) == null ||
            minNorm == null ||
            maxNorm == null ||
            minValue == null ||
            maxValue == null ||
            minWarn == null ||
            maxWarn == null)) {
      SnackbarHelper.showError(context, context.l10n.commonRequired);
      return;
    }

    if (minNorm != null && maxNorm != null && minNorm > maxNorm) {
      SnackbarHelper.showError(
        context,
        context.l10n.adminMinNormalGreaterThanMaxNormal,
      );
      return;
    }
    if (minValue != null && maxValue != null && minValue > maxValue) {
      SnackbarHelper.showError(
        context,
        context.l10n.adminMinAbsoluteGreaterThanMaxAbsolute,
      );
      return;
    }
    if (minWarn != null && maxWarn != null && minWarn > maxWarn) {
      SnackbarHelper.showError(
        context,
        context.l10n.adminMinWarningGreaterThanMaxWarning,
      );
      return;
    }

    if (minValue != null) {
      if (minNorm != null && minValue > minNorm) {
        SnackbarHelper.showError(
          context,
          context.l10n.adminMinAbsoluteGreaterThanMinNormal,
        );
        return;
      }
      if (minWarn != null && minValue > minWarn) {
        SnackbarHelper.showError(
          context,
          context.l10n.adminMinAbsoluteGreaterThanMinWarning,
        );
        return;
      }
    }

    if (maxValue != null) {
      if (maxNorm != null && maxValue < maxNorm) {
        SnackbarHelper.showError(
          context,
          context.l10n.adminMaxAbsoluteLessThanMaxNormal,
        );
        return;
      }
      if (maxWarn != null && maxValue < maxWarn) {
        SnackbarHelper.showError(
          context,
          context.l10n.adminMaxAbsoluteLessThanMaxWarning,
        );
        return;
      }
    }

    if (minWarn != null && minNorm != null && minWarn > minNorm) {
      SnackbarHelper.showError(
        context,
        context.l10n.adminMinWarningGreaterThanMinNormal,
      );
      return;
    }

    if (maxWarn != null && maxNorm != null && maxWarn < maxNorm) {
      SnackbarHelper.showError(
        context,
        context.l10n.adminMaxWarningLessThanMaxNormal,
      );
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
            ? context.l10n.adminUpdateSuccess(
                context.l10n.adminDeviceSensorTitle,
              )
            : context.l10n.adminCreateSuccess(
                context.l10n.adminDeviceSensorTitle,
              ),
      );
      context.pop();
    } else {
      final error = ref.read(adminDeviceSensorFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ??
            context.l10n.adminSaveFailed(context.l10n.adminDeviceSensorTitle),
      );
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
  final ValueChanged<String?>? onDeviceChanged;
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
      title: context.l10n.adminMappingInfoSection,
      child: Column(
        children: [
          AdminFormFields.buildField(
            context,
            controller: idController,
            label: context.l10n.adminDsIdLabel,
            hint: context.l10n.adminDsIdHint,
            icon: Icons.tag,
            enabled: !isEditMode,
            required: true,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? context.l10n.adminDsIdRequired
                : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AdminFormFields.buildField(
            context,
            controller: nameController,
            label: context.l10n.commonName,
            hint: context.l10n.adminMappingNameHint,
            icon: Icons.cable,
            required: true,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? context.l10n.adminNameRequired
                : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AsyncDropdownWidget<dynamic, String>(
            async: ref.watch(adminDeviceListProvider),
            value: selectedDeviceId,
            label: '${context.l10n.adminDeviceLabel} *',
            hint: context.l10n.adminSelectDeviceHint,
            icon: Icons.device_hub,
            errorMessage: context.l10n.adminLoadDeviceFailed,
            itemBuilder: (devices) => devices
                .map(
                  (d) => DropdownMenuItem<String>(
                    value: d.devId,
                    child: Text('${d.displayName} (${d.devId})'),
                  ),
                )
                .toList(),
            onChanged: onDeviceChanged ?? (_) {},
            enabled: onDeviceChanged != null,
            validator: (v) =>
                v == null ? context.l10n.adminDeviceRequired : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AsyncDropdownWidget<dynamic, String>(
            async: ref.watch(adminSensorListProvider),
            value: selectedSensorId,
            label: '${context.l10n.adminSensorLabel} *',
            hint: context.l10n.adminSelectSensorOptional,
            icon: Icons.sensors,
            errorMessage: context.l10n.adminNoSensorsMessage,
            itemBuilder: (sensors) => [
              DropdownMenuItem<String>(
                value: null,
                child: Text(context.l10n.adminNoSelection),
              ),
              ...sensors.map(
                (s) => DropdownMenuItem<String>(
                  value: s.sensId,
                  child: Text('${s.displayName} (${s.sensId})'),
                ),
              ),
            ],
            onChanged: onSensorChanged,
            validator: (v) => v == null ? context.l10n.commonRequired : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AsyncDropdownWidget<dynamic, String>(
            async: ref.watch(adminUnitListProvider),
            value: selectedUnitId,
            label: '${context.l10n.adminUnitLabel} *',
            hint: context.l10n.adminSelectUnitOptional,
            icon: Icons.straighten,
            errorMessage: context.l10n.adminNoUnitsMessage,
            itemBuilder: (units) => [
              DropdownMenuItem<String>(
                value: null,
                child: Text(context.l10n.adminNoSelection),
              ),
              ...units.map(
                (u) => DropdownMenuItem<String>(
                  value: u.unitId,
                  child: Text(u.displayNameWithSymbol),
                ),
              ),
            ],
            onChanged: onUnitChanged,
            validator: (v) => v == null ? context.l10n.commonRequired : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AdminFormFields.buildField(
            context,
            controller: addressController,
            label: context.l10n.adminAddressLabel,
            hint: 'Contoh: 0x10',
            icon: Icons.location_searching,
            required: true,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? context.l10n.commonRequired
                : null,
          ),
          SizedBox(height: context.rh(0.016)),
          AdminFormFields.buildField(
            context,
            controller: seqController,
            label: context.l10n.adminSequenceLabel,
            hint: context.l10n.adminSequenceHint,
            icon: Icons.format_list_numbered,
            keyboardType: TextInputType.number,
            required: true,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? context.l10n.commonRequired
                : null,
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
      title: context.l10n.adminThresholdSection,
      subtitle: context.l10n.adminThresholdSubtitle,
      child: Column(
        children: [
          AdminFormFields.buildField(
            context,
            controller: normalValueController,
            label: context.l10n.adminNormalValueLabel,
            hint: context.l10n.adminExampleDecimalHint,
            icon: Icons.check_circle_outline,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: context.rh(0.016)),
          ThresholdRowWidget(
            leftController: minNormController,
            leftLabel: context.l10n.adminMinNormalLabel,
            leftIcon: Icons.arrow_downward,
            leftColor: AppColors.success,
            rightController: maxNormController,
            rightLabel: context.l10n.adminMaxNormalLabel,
            rightIcon: Icons.arrow_upward,
            rightColor: AppColors.success,
          ),
          SizedBox(height: context.rh(0.016)),
          ThresholdRowWidget(
            leftController: minValueController,
            leftLabel: context.l10n.adminMinAbsoluteLabel,
            leftIcon: Icons.arrow_downward,
            leftColor: AppColors.info,
            rightController: maxValueController,
            rightLabel: context.l10n.adminMaxAbsoluteLabel,
            rightIcon: Icons.arrow_upward,
            rightColor: AppColors.info,
          ),
          SizedBox(height: context.rh(0.016)),
          ThresholdRowWidget(
            leftController: minWarnController,
            leftLabel: context.l10n.adminMinWarningLabel,
            leftIcon: Icons.warning_amber,
            leftColor: AppColors.warning,
            rightController: maxWarnController,
            rightLabel: context.l10n.adminMaxWarningLabel,
            rightIcon: Icons.warning_amber,
            rightColor: AppColors.warning,
          ),
        ],
      ),
    );
  }
}
