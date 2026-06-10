import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/sensor_provider.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/app_localizations.dart';

class SensorFormScreen extends ConsumerStatefulWidget {
  final String siteId;
  final String? sensorId; // null = create, non-null = edit

  const SensorFormScreen({super.key, required this.siteId, this.sensorId});

  @override
  ConsumerState<SensorFormScreen> createState() => _SensorFormScreenState();
}

class _SensorFormScreenState extends ConsumerState<SensorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitController = TextEditingController();

  String _selectedType = 'env_temp';
  bool _isActive = true;
  bool _isLoadingData = false;

  final List<Map<String, String>> _sensorTypes = [
    {'value': 'env_temp', 'label': 'Suhu Udara'},
    {'value': 'env_hum', 'label': 'Kelembaban Udara'},
    {'value': 'soil_hum', 'label': 'Kelembaban Tanah'},
    {'value': 'soil_ph', 'label': 'pH Tanah'},
    {'value': 'soil_nitro', 'label': 'Nitrogen Tanah'},
    {'value': 'soil_phos', 'label': 'Fosfor Tanah'},
    {'value': 'soil_pot', 'label': 'Kalium Tanah'},
    {'value': 'temperature', 'label': 'Suhu (Umum)'},
    {'value': 'humidity', 'label': 'Kelembaban (Umum)'},
    {'value': 'ph', 'label': 'pH (Umum)'},
    {'value': 'light', 'label': 'Intensitas Cahaya'},
    {'value': 'pressure', 'label': 'Tekanan'},
    {'value': 'wind_speed', 'label': 'Kecepatan Angin'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.sensorId != null) {
      _loadSensorData();
    }
  }

  void _loadSensorData() async {
    setState(() => _isLoadingData = true);
    try {
      final sensor = await ref.read(
        sensorDetailProvider((
          siteId: widget.siteId,
          sensId: widget.sensorId!,
        )).future,
      );
      if (mounted) {
        _nameController.text = sensor.name;
        _descriptionController.text = sensor.description ?? '';
        _unitController.text = sensor.unit;
        _selectedType = sensor.type;
        _isActive = sensor.isActive;
        setState(() => _isLoadingData = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.sensorId != null;
    final formState = ref.watch(sensorFormProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEdit ? context.l10n.sensorEditTitle : context.l10n.sensorAddTitle,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1D),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1D1D1D)),
      ),
      body: _isLoadingData
          ? Padding(
              padding: EdgeInsets.all(context.rw(0.051)),
              child: const FormCardSkeleton(fieldCount: 4, hasLargeField: true),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(context.rw(0.051)),
                children: [
                  // Error banner
                  if (formState.error != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              formState.error!,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: AppColors.error,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  _buildCard(
                    context,
                    children: [
                      // Nama Sensor
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                          context.l10n.sensorNameLabel,
                          context.l10n.adminSensorNameHint,
                          Icons.sensors,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return context.l10n.sensorNameRequired;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                      ),
                      const SizedBox(height: 16),

                      // Tipe Sensor
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: _inputDecoration(
                          context.l10n.sensorTypeLabel,
                          null,
                          Icons.category,
                        ),
                        items: _sensorTypes.map((type) {
                          return DropdownMenuItem(
                            value: type['value'],
                            child: Text(
                              _getSensorTypeLabel(type['value']!, context.l10n),
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                            _unitController.text = _getDefaultUnit(value);
                          });
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return context.l10n.sensorTypeRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Satuan
                      TextFormField(
                        controller: _unitController,
                        decoration: _inputDecoration(
                          context.l10n.commonUnit,
                          context.l10n.sensorUnitHint,
                          Icons.straighten,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return context.l10n.sensorUnitRequired;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                      ),
                      const SizedBox(height: 16),

                      // Deskripsi
                      TextFormField(
                        controller: _descriptionController,
                        decoration: _inputDecoration(
                          context.l10n.sensorDescLabel,
                          context.l10n.sensorDescHint,
                          Icons.description,
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Status aktif
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        context.l10n.sensorStatusActiveLabel,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        _isActive
                            ? context.l10n.sensorStatusActiveDesc
                            : context.l10n.sensorStatusInactiveDesc,
                        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                      ),
                      value: _isActive,
                      activeColor: AppColors.primary,
                      onChanged: (value) => setState(() => _isActive = value),
                      secondary: Icon(
                        _isActive ? Icons.check_circle : Icons.cancel,
                        color: _isActive ? AppColors.success : Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: formState.isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: formState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isEdit
                                  ? context.l10n.commonSaveChanges
                                  : context.l10n.sensorAddTitle,
                              style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }

  InputDecoration _inputDecoration(String label, String? hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: Icon(icon),
      labelStyle: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
      hintStyle: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
    );
  }

  String _getDefaultUnit(String type) {
    switch (type) {
      case 'env_temp':
      case 'temperature':
        return '°C';
      case 'env_hum':
      case 'humidity':
      case 'soil_hum':
      case 'soil_moisture':
        return '%';
      case 'soil_ph':
      case 'ph':
        return 'pH';
      case 'soil_nitro':
      case 'soil_phos':
      case 'soil_pot':
        return 'mg/kg';
      case 'light':
        return 'lux';
      case 'pressure':
        return 'hPa';
      case 'wind_speed':
        return 'm/s';
      default:
        return '';
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(sensorFormProvider.notifier).reset();

    final data = {
      'sens_name': _nameController.text.trim(),
      'sens_type': _selectedType,
      'sens_unit': _unitController.text.trim(),
      'sens_desc': _descriptionController.text.trim(),
      'sens_sts': _isActive ? 1 : 0,
    };

    final formNotifier = ref.read(sensorFormProvider.notifier);
    bool success;

    if (widget.sensorId != null) {
      success = await formNotifier.updateSensor(
        widget.siteId,
        widget.sensorId!,
        data,
      );
    } else {
      success = await formNotifier.createSensor(widget.siteId, data);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.sensorId != null
                ? context.l10n.sensorUpdatedSuccess
                : context.l10n.sensorCreatedSuccess,
            style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
    // Error ditampilkan via formState.error di UI
  }

  String _getSensorTypeLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'env_temp':
      case 'temperature':
        return l10n.sensorTypeAirTemperature;
      case 'env_hum':
      case 'humidity':
        return l10n.sensorTypeAirHumidity;
      case 'soil_hum':
        return l10n.sensorTypeSoilMoisture;
      case 'soil_ph':
      case 'ph':
        return l10n.sensorTypeSoilPh;
      case 'soil_nitro':
        return l10n.sensorTypeSoilNitrogen;
      case 'soil_phos':
        return l10n.sensorTypeSoilPhosphorus;
      case 'soil_pot':
        return l10n.sensorTypeSoilPotassium;
      case 'light':
        return l10n.sensorTypeLightIntensity;
      case 'pressure':
        return l10n.sensorTypeAtmosphericPressure;
      case 'wind_speed':
        return l10n.sensorTypeWindSpeed;
      default:
        return value;
    }
  }
}
