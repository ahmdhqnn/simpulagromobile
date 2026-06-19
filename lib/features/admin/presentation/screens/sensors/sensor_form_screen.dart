import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/sensor_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/domain/entities/sensor.dart';
import 'package:simpulagromobile/features/monitoring/presentation/providers/monitoring_provider.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_elements.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

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
    final formState = ref.watch(adminSensorFormProvider);

    if (isEditMode && !_isInitialized) {
      final sensorAsync = ref.watch(
        adminSensorDetailProvider(widget.sensorId!),
      );
      sensorAsync.whenData((sensor) {
        if (!_isInitialized) _initializeForm(sensor);
      });

      if (sensorAsync.isLoading) {
        return AdminFormScaffold(
          title: context.l10n.adminLoadingTitle,
          body: const AdminFormScreenSkeleton(
            titleWidth: 164,
            sectionFieldCounts: [4, 1, 3, 1],
          ),
        );
      }
      if (sensorAsync.hasError) {
        return AdminFormScaffold(
          title: context.l10n.commonErrorTitle,
          body: AdminErrorState(
            error: sensorAsync.error!,
            onRetry: () =>
                ref.invalidate(adminSensorDetailProvider(widget.sensorId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'sensor:update' : 'sensor:create';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: isEditMode
            ? context.l10n.adminEditSensorTitle
            : context.l10n.adminAddSensorTitle,
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? context.l10n.adminSavingChanges
            : context.l10n.adminCreatingSensor,
        body: Form(
          key: _formKey,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              SizedBox(height: context.rh(0.01)),
              Text(
                isEditMode
                    ? context.l10n.adminEditSensorTitle
                    : context.l10n.adminAddSensorTitle,
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
              AdminSectionCard(
                title: context.l10n.adminBasicInfoSection,
                child: Column(
                  children: [
                    _buildField(
                      controller: _idController,
                      label: context.l10n.adminSensorIdLabel,
                      hint: context.l10n.adminSensorIdHint,
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminSensorIdRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildField(
                      controller: _nameController,
                      label: context.l10n.adminSensorNameLabel,
                      hint: context.l10n.adminSensorNameHint,
                      icon: Icons.sensors,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminSensorNameRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
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
              AdminSectionCard(
                title: context.l10n.adminConfigurationSection,
                child: Column(
                  children: [
                    _buildField(
                      controller: _addressController,
                      label: context.l10n.adminSensorAddressLabel,
                      hint: context.l10n.adminSensorAddressHint,
                      icon: Icons.location_searching,
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildField(
                      controller: _locationController,
                      label: context.l10n.commonLocation,
                      hint: context.l10n.adminSensorLocationHint,
                      icon: Icons.place,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              // ── Koordinat ────────────────────────────────
              AdminSectionCard(
                title: context.l10n.adminCoordinatesSection,
                subtitle: context.l10n.adminSensorCoordinateSubtitle,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _latController,
                            label: context.l10n.commonLatitude,
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
                                  return context.l10n.commonInvalid;
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
                            label: context.l10n.commonLongitude,
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
                                  return context.l10n.commonInvalid;
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
                      label: context.l10n.adminAltitudeLabel,
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
              AdminSectionCard(
                title: context.l10n.adminStatusSection,
                child: _buildStatusToggle(
                  label: context.l10n.adminStatusSensorLabel,
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              // ── Submit ───────────────────────────────────
              AdminSubmitButton(
                label: isEditMode
                    ? context.l10n.commonSaveChanges
                    : context.l10n.adminAddSensorTitle,
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
          borderSide: BorderSide.none,
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
          labelText: isEditMode
              ? context.l10n.adminDeviceLabel
              : '${context.l10n.adminDeviceLabel} *',
          hintText: context.l10n.adminSelectDeviceHint,
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
            borderSide: BorderSide.none,
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
          DropdownMenuItem(
            value: null,
            child: Text(context.l10n.adminNoDevice),
          ),
          ...devices.map(
            (d) => DropdownMenuItem(
              value: d.devId,
              child: Text('${d.devName ?? d.devId} (${d.devId})'),
            ),
          ),
        ],
        onChanged: (v) => setState(() => _selectedDeviceId = v),
        validator: (v) =>
            !isEditMode && v == null ? context.l10n.adminDeviceRequired : null,
      ),
      loading: () => Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const SkeletonContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SkeletonLine(width: 160, height: 14),
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
            context.l10n.adminLoadDeviceFailed,
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
                value ? context.l10n.commonActive : context.l10n.commonInactive,
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

    if (!isEditMode && _selectedDeviceId == null) {
      SnackbarHelper.showError(context, context.l10n.adminDeviceRequired);
      return;
    }

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
              .read(adminSensorFormProvider.notifier)
              .updateSensor(widget.sensorId!, sensor)
        : await ref.read(adminSensorFormProvider.notifier).createSensor(sensor);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? context.l10n.adminUpdateSuccess(context.l10n.adminSensorLabel)
            : context.l10n.adminCreateSuccess(context.l10n.adminSensorLabel),
      );
      context.pop();
    } else {
      final error = ref.read(adminSensorFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.adminSaveFailed(context.l10n.adminSensorLabel),
      );
    }
  }
}
