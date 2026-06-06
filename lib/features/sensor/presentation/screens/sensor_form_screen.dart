import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/sensor_provider.dart';

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
          isEdit ? 'Edit Sensor' : 'Tambah Sensor',
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
                          'Nama Sensor',
                          'Contoh: Sensor Suhu 1',
                          Icons.sensors,
                        ),
                        validator: (v) => Validators.required(v, 'Nama sensor'),
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                      ),
                      const SizedBox(height: 16),

                      // Tipe Sensor
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: _inputDecoration(
                          'Tipe Sensor',
                          null,
                          Icons.category,
                        ),
                        items: _sensorTypes.map((type) {
                          return DropdownMenuItem(
                            value: type['value'],
                            child: Text(
                              type['label']!,
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
                        validator: (v) => Validators.required(v, 'Tipe sensor'),
                      ),
                      const SizedBox(height: 16),

                      // Satuan
                      TextFormField(
                        controller: _unitController,
                        decoration: _inputDecoration(
                          'Satuan',
                          'Contoh: °C, %, pH',
                          Icons.straighten,
                        ),
                        validator: (v) => Validators.required(v, 'Satuan'),
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                      ),
                      const SizedBox(height: 16),

                      // Deskripsi
                      TextFormField(
                        controller: _descriptionController,
                        decoration: _inputDecoration(
                          'Deskripsi (Opsional)',
                          'Masukkan deskripsi sensor',
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
                      title: const Text(
                        'Status Aktif',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        _isActive ? 'Sensor aktif' : 'Sensor tidak aktif',
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
                              isEdit ? 'Simpan Perubahan' : 'Tambah Sensor',
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
                ? 'Sensor berhasil diperbarui'
                : 'Sensor berhasil ditambahkan',
            style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
    // Error ditampilkan via formState.error di UI
  }
}
