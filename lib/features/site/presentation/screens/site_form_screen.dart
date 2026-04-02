import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SiteFormScreen extends ConsumerStatefulWidget {
  final String? siteId;

  const SiteFormScreen({super.key, this.siteId});

  @override
  ConsumerState<SiteFormScreen> createState() => _SiteFormScreenState();
}

class _SiteFormScreenState extends ConsumerState<SiteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _altController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  bool get isEdit => widget.siteId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _altController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Lokasi' : 'Tambah Lokasi'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNameField(),
            const Gap(16),
            _buildAddressField(),
            const Gap(16),
            _buildCoordinatesSection(),
            const Gap(16),
            _buildAltitudeField(),
            const Gap(16),
            _buildStatusSwitch(),
            const Gap(24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama Lokasi *',
        hintText: 'Contoh: Sawah Utara',
        prefixIcon: Icon(Icons.location_on),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama lokasi tidak boleh kosong';
        }
        if (value.length < 3) {
          return 'Nama lokasi minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Alamat',
        hintText: 'Contoh: Jl. Raya Pertanian No. 123',
        prefixIcon: Icon(Icons.location_city),
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }

  Widget _buildCoordinatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Koordinat GPS',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _latController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  hintText: '-6.200000',
                  prefixIcon: Icon(Icons.explore),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final lat = double.tryParse(value);
                    if (lat == null || lat < -90 || lat > 90) {
                      return 'Latitude tidak valid';
                    }
                  }
                  return null;
                },
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: _lonController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  hintText: '106.816666',
                  prefixIcon: Icon(Icons.explore),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final lon = double.tryParse(value);
                    if (lon == null || lon < -180 || lon > 180) {
                      return 'Longitude tidak valid';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAltitudeField() {
    return TextFormField(
      controller: _altController,
      decoration: const InputDecoration(
        labelText: 'Ketinggian (meter)',
        hintText: 'Contoh: 150',
        prefixIcon: Icon(Icons.terrain),
        border: OutlineInputBorder(),
        suffixText: 'm',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final alt = double.tryParse(value);
          if (alt == null || alt < -500 || alt > 9000) {
            return 'Ketinggian tidak valid';
          }
        }
        return null;
      },
    );
  }

  Widget _buildStatusSwitch() {
    return Card(
      child: SwitchListTile(
        title: const Text('Status Lokasi'),
        subtitle: Text(_isActive ? 'Aktif' : 'Tidak Aktif'),
        value: _isActive,
        onChanged: (value) => setState(() => _isActive = value),
        secondary: Icon(
          _isActive ? Icons.check_circle : Icons.cancel,
          color: _isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSave,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Lokasi'),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Lokasi berhasil diperbarui'
                  : 'Lokasi berhasil ditambahkan',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
