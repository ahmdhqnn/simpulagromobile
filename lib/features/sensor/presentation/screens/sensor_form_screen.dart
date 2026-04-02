import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/validators.dart';
import '../providers/sensor_provider.dart';

class SensorFormScreen extends ConsumerStatefulWidget {
  final String? sensorId;
  final String? deviceId;

  const SensorFormScreen({super.key, this.sensorId, this.deviceId});

  @override
  ConsumerState<SensorFormScreen> createState() => _SensorFormScreenState();
}

class _SensorFormScreenState extends ConsumerState<SensorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitController = TextEditingController();

  String _selectedType = 'temperature';
  bool _isActive = true;
  bool _isLoading = false;

  final List<Map<String, String>> _sensorTypes = [
    {'value': 'temperature', 'label': 'Temperature'},
    {'value': 'humidity', 'label': 'Humidity'},
    {'value': 'soil_moisture', 'label': 'Soil Moisture'},
    {'value': 'ph', 'label': 'pH Level'},
    {'value': 'light', 'label': 'Light Intensity'},
    {'value': 'pressure', 'label': 'Pressure'},
    {'value': 'wind_speed', 'label': 'Wind Speed'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.sensorId != null) {
      _loadSensorData();
    }
  }

  void _loadSensorData() async {
    final sensor = await ref.read(
      sensorDetailProvider(widget.sensorId!).future,
    );
    _nameController.text = sensor.name;
    _descriptionController.text = sensor.description ?? '';
    _unitController.text = sensor.unit;
    _selectedType = sensor.type;
    _isActive = sensor.isActive;
    setState(() {});
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

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Sensor' : 'Add Sensor')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Sensor Name',
                hintText: 'e.g., Temperature Sensor 1',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sensors),
              ),
              validator: (value) => Validators.required(value, 'Sensor name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Sensor Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _sensorTypes.map((type) {
                return DropdownMenuItem(
                  value: type['value'],
                  child: Text(type['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                  // Auto-fill unit based on type
                  _unitController.text = _getDefaultUnit(value);
                });
              },
              validator: (value) => Validators.required(value, 'Sensor type'),
            ),
            const SizedBox(height: 16),

            // Unit Field
            TextFormField(
              controller: _unitController,
              decoration: const InputDecoration(
                labelText: 'Unit',
                hintText: 'e.g., °C, %, pH',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              validator: (value) => Validators.required(value, 'Unit'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter sensor description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),

            // Active Status Switch
            Card(
              child: SwitchListTile(
                title: const Text('Active Status'),
                subtitle: Text(
                  _isActive ? 'Sensor is active' : 'Sensor is inactive',
                ),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                secondary: Icon(
                  _isActive ? Icons.check_circle : Icons.cancel,
                  color: _isActive ? Colors.green : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? 'Update Sensor' : 'Create Sensor'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDefaultUnit(String type) {
    switch (type) {
      case 'temperature':
        return '°C';
      case 'humidity':
      case 'soil_moisture':
        return '%';
      case 'ph':
        return 'pH';
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

    setState(() => _isLoading = true);

    final data = {
      'name': _nameController.text.trim(),
      'type': _selectedType,
      'unit': _unitController.text.trim(),
      'description': _descriptionController.text.trim(),
      'is_active': _isActive,
    };

    try {
      final formNotifier = ref.read(sensorFormProvider.notifier);

      if (widget.sensorId != null) {
        await formNotifier.updateSensor(widget.sensorId!, data);
      } else {
        if (widget.deviceId == null) {
          throw Exception('Device ID is required');
        }
        await formNotifier.createSensor(widget.deviceId!, data);
      }

      final state = ref.read(sensorFormProvider);
      state.when(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.sensorId != null
                      ? 'Sensor updated successfully'
                      : 'Sensor created successfully',
                ),
              ),
            );
            Navigator.pop(context);
          }
        },
        loading: () {},
        error: (error, _) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
