import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/device.dart';
import '../providers/device_provider.dart';

class DeviceFormScreen extends ConsumerStatefulWidget {
  final String siteId;
  final Device? device; // null = create, not null = edit

  const DeviceFormScreen({super.key, required this.siteId, this.device});

  @override
  ConsumerState<DeviceFormScreen> createState() => _DeviceFormScreenState();
}

class _DeviceFormScreenState extends ConsumerState<DeviceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _devIdController;
  late final TextEditingController _devNameController;
  late final TextEditingController _devLocationController;
  late final TextEditingController _devLonController;
  late final TextEditingController _devLatController;
  late final TextEditingController _devAltController;
  late final TextEditingController _devNumberIdController;
  late final TextEditingController _devIpController;
  late final TextEditingController _devPortController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final device = widget.device;
    _devIdController = TextEditingController(text: device?.devId);
    _devNameController = TextEditingController(text: device?.devName);
    _devLocationController = TextEditingController(text: device?.devLocation);
    _devLonController = TextEditingController(text: device?.devLon?.toString());
    _devLatController = TextEditingController(text: device?.devLat?.toString());
    _devAltController = TextEditingController(text: device?.devAlt?.toString());
    _devNumberIdController = TextEditingController(text: device?.devNumberId);
    _devIpController = TextEditingController(text: device?.devIp);
    _devPortController = TextEditingController(text: device?.devPort);
    _isActive = device?.isActive ?? true;
  }

  @override
  void dispose() {
    _devIdController.dispose();
    _devNameController.dispose();
    _devLocationController.dispose();
    _devLonController.dispose();
    _devLatController.dispose();
    _devAltController.dispose();
    _devNumberIdController.dispose();
    _devIpController.dispose();
    _devPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(deviceFormProvider);
    final isEdit = widget.device != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? context.l10n.deviceEditTitle : context.l10n.deviceAddTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _devIdController,
              decoration: InputDecoration(
                labelText: '${context.l10n.deviceIdLabel} *',
                border: OutlineInputBorder(),
              ),
              enabled: !isEdit,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.deviceIdRequired;
                }
                return null;
              },
            ),
            const Gap(16),
            TextFormField(
              controller: _devNameController,
              decoration: InputDecoration(
                labelText: '${context.l10n.deviceNameLabel} *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.deviceNameRequired;
                }
                return null;
              },
            ),
            const Gap(16),
            TextFormField(
              controller: _devLocationController,
              decoration: InputDecoration(
                labelText: context.l10n.commonLocation,
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _devLonController,
                    decoration: InputDecoration(
                      labelText: context.l10n.commonLongitude,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: TextFormField(
                    controller: _devLatController,
                    decoration: InputDecoration(
                      labelText: context.l10n.commonLatitude,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Gap(16),
            TextFormField(
              controller: _devAltController,
              decoration: InputDecoration(
                labelText: '${context.l10n.commonAltitude} (m)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const Gap(16),
            TextFormField(
              controller: _devNumberIdController,
              decoration: InputDecoration(
                labelText: context.l10n.deviceNumberIdLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _devIpController,
                    decoration: InputDecoration(
                      labelText: context.l10n.commonIpAddress,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: TextFormField(
                    controller: _devPortController,
                    decoration: InputDecoration(
                      labelText: context.l10n.commonPort,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Gap(16),
            SwitchListTile(
              title: Text(context.l10n.deviceStatusActive),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const Gap(24),
            if (formState.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  formState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: formState.isLoading ? null : _handleSubmit,
              child: formState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      isEdit
                          ? context.l10n.commonSaveChanges
                          : context.l10n.deviceAddTitle,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;

    final device = Device(
      devId: _devIdController.text,
      siteId: widget.siteId,
      devName: _devNameController.text,
      devLocation: _devLocationController.text.isEmpty
          ? null
          : _devLocationController.text,
      devLon: _devLonController.text.isEmpty
          ? null
          : double.tryParse(_devLonController.text),
      devLat: _devLatController.text.isEmpty
          ? null
          : double.tryParse(_devLatController.text),
      devAlt: _devAltController.text.isEmpty
          ? null
          : double.tryParse(_devAltController.text),
      devNumberId: _devNumberIdController.text.isEmpty
          ? null
          : _devNumberIdController.text,
      devIp: _devIpController.text.isEmpty ? null : _devIpController.text,
      devPort: _devPortController.text.isEmpty ? null : _devPortController.text,
      devSts: _isActive ? 1 : 0,
    );

    final notifier = ref.read(deviceFormProvider.notifier);
    final success = widget.device == null
        ? await notifier.createDevice(widget.siteId, device)
        : await notifier.updateDevice(widget.siteId, device.devId, device);

    if (success && mounted) {
      ref.invalidate(deviceListProvider(widget.siteId));
      Navigator.pop(context);
      if (context.mounted) {
        SnackbarHelper.showSuccess(
          context,
          widget.device == null
              ? l10n.deviceCreateSuccess
              : l10n.deviceUpdateSuccess,
        );
      }
    }
  }
}
