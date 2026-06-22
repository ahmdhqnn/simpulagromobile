import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/device_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/admin/domain/entities/device.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

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
    final formState = ref.watch(adminDeviceFormProvider);

    if (isEditMode && !_isInitialized) {
      final deviceAsync = ref.watch(
        adminDeviceDetailProvider(widget.deviceId!),
      );
      deviceAsync.whenData((device) {
        if (!_isInitialized) _initializeForm(device);
      });

      if (deviceAsync.isLoading) {
        return AdminFormScaffold(
          title: context.l10n.adminEditDeviceTitle,
          body: const AdminFormScreenSkeleton(
            titleWidth: 168,
            sectionFieldCounts: [4, 2, 3, 1],
          ),
        );
      }
      if (deviceAsync.hasError) {
        return AdminFormScaffold(
          title: context.l10n.commonErrorTitle,
          body: AdminErrorState(
            error: deviceAsync.error!,
            onRetry: () =>
                ref.invalidate(adminDeviceDetailProvider(widget.deviceId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'device:update' : 'device:create';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: isEditMode
            ? context.l10n.adminEditDeviceTitle
            : context.l10n.adminAddDeviceTitle,
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? context.l10n.adminSavingChanges
            : context.l10n.adminCreatingDevice,
        body: Form(
          key: _formKey,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              AdminSectionCard(
                title: context.l10n.adminBasicInfoSection,
                child: Column(
                  children: [
                    AdminFormFields.buildField(
                      context,
                      controller: _idController,
                      label: context.l10n.adminDeviceIdLabel,
                      hint: context.l10n.adminDeviceIdHint,
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminDeviceIdRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AdminFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: context.l10n.adminDeviceNameLabel,
                      hint: context.l10n.adminDeviceNameHint,
                      icon: Icons.device_hub,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminDeviceNameRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AdminFormFields.buildField(
                      context,
                      controller: _locationController,
                      label: context.l10n.commonLocation,
                      hint: context.l10n.adminDeviceLocationHint,
                      icon: Icons.place,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              AdminSectionCard(
                title: context.l10n.adminConnectionSection,
                subtitle: context.l10n.adminConnectionSubtitle,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AdminFormFields.buildField(
                        context,
                        controller: _ipController,
                        label: context.l10n.adminIpAddressLabel,
                        hint: '192.168.1.100',
                        icon: Icons.wifi,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                            if (!ipRegex.hasMatch(v)) {
                              return context.l10n.adminIpInvalid;
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: context.rw(0.03)),
                    Expanded(
                      child: AdminFormFields.buildField(
                        context,
                        controller: _portController,
                        label: context.l10n.adminPortLabel,
                        hint: '8080',
                        icon: Icons.settings_ethernet,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final port = int.tryParse(v);
                            if (port == null || port < 1 || port > 65535) {
                              return context.l10n.commonInvalid;
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              AdminSectionCard(
                title: context.l10n.adminCoordinatesSection,
                subtitle: context.l10n.adminDeviceCoordinateSubtitle,
                child: Column(
                  children: [
                    AdminFormFields.buildCoordinateRow(
                      context,
                      latController: _latController,
                      lonController: _lonController,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AdminFormFields.buildField(
                      context,
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
              const SizedBox(height: AppSpacing.sm),

              AdminSectionCard(
                title: context.l10n.adminStatusSection,
                child: AdminFormFields.buildStatusToggle(
                  context,
                  label: context.l10n.adminStatusDeviceLabel,
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              AdminSubmitButton(
                label: isEditMode
                    ? context.l10n.commonSaveChanges
                    : context.l10n.adminAddDeviceTitle,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: AppSpacing.xxl),
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
              .read(adminDeviceFormProvider.notifier)
              .updateDevice(widget.deviceId!, device)
        : await ref.read(adminDeviceFormProvider.notifier).createDevice(device);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? context.l10n.adminUpdateSuccess(context.l10n.adminDeviceLabel)
            : context.l10n.adminCreateSuccess(context.l10n.adminDeviceLabel),
      );
      context.pop();
    } else {
      final error = ref.read(adminDeviceFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.adminSaveFailed(context.l10n.adminDeviceLabel),
      );
    }
  }
}
