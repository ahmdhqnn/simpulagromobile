import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/site.dart';
import '../providers/site_provider.dart';

class SiteFormScreen extends ConsumerStatefulWidget {
  final String? siteId;

  const SiteFormScreen({super.key, this.siteId});

  @override
  ConsumerState<SiteFormScreen> createState() => _SiteFormScreenState();
}

class _SiteFormScreenState extends ConsumerState<SiteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _altController = TextEditingController();
  bool _isActive = true;
  bool _isLoadingData = false;

  bool get isEdit => widget.siteId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) _loadSiteData();
  }

  Future<void> _loadSiteData() async {
    setState(() => _isLoadingData = true);
    try {
      final site = await ref.read(siteDetailProvider(widget.siteId!).future);
      if (mounted) {
        _idController.text = site.siteId;
        _nameController.text = site.siteName ?? '';
        _addressController.text = site.siteAddress ?? '';
        _latController.text = site.siteLat?.toString() ?? '';
        _lonController.text = site.siteLon?.toString() ?? '';
        _altController.text = site.siteAlt?.toString() ?? '';
        _isActive = site.siteSts == 1;
        setState(() => _isLoadingData = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _altController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(siteFormProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEdit ? 'Edit Lokasi' : 'Tambah Lokasi',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1D),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1D1D1D)),
      ),
      body: _isLoadingData
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
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
                      if (!isEdit) ...[
                        _buildField(
                          label: 'ID Lokasi *',
                          controller: _idController,
                          hint: 'Contoh: SITE001',
                          icon: Icons.tag,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'ID lokasi tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const Gap(16),
                      ],
                      _buildField(
                        label: 'Nama Lokasi *',
                        controller: _nameController,
                        hint: 'Contoh: Sawah Utara',
                        icon: Icons.location_on,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Nama lokasi tidak boleh kosong';
                          }
                          if (v.trim().length < 3) {
                            return 'Nama minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      const Gap(16),
                      _buildField(
                        label: 'Alamat',
                        controller: _addressController,
                        hint: 'Contoh: Jl. Raya Pertanian No. 123',
                        icon: Icons.location_city,
                        maxLines: 2,
                      ),
                    ],
                  ),

                  const Gap(16),

                  _buildCard(
                    context,
                    children: [
                      Text(
                        'Koordinat GPS',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                      const Gap(12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              label: 'Latitude',
                              controller: _latController,
                              hint: '-6.200000',
                              icon: Icons.explore,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              validator: (v) {
                                if (v != null && v.isNotEmpty) {
                                  final lat = double.tryParse(v);
                                  if (lat == null || lat < -90 || lat > 90) {
                                    return 'Tidak valid';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _buildField(
                              label: 'Longitude',
                              controller: _lonController,
                              hint: '106.816666',
                              icon: Icons.explore,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              validator: (v) {
                                if (v != null && v.isNotEmpty) {
                                  final lon = double.tryParse(v);
                                  if (lon == null || lon < -180 || lon > 180) {
                                    return 'Tidak valid';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      _buildField(
                        label: 'Ketinggian (meter)',
                        controller: _altController,
                        hint: 'Contoh: 150',
                        icon: Icons.terrain,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        suffix: 'm',
                      ),
                    ],
                  ),

                  const Gap(16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Status Lokasi',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        _isActive ? 'Aktif' : 'Tidak Aktif',
                        style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                      ),
                      value: _isActive,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _isActive = v),
                      secondary: Icon(
                        _isActive ? Icons.check_circle : Icons.cancel,
                        color: _isActive ? AppColors.success : Colors.grey,
                      ),
                    ),
                  ),

                  const Gap(24),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: formState.isLoading ? null : _handleSave,
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
                              isEdit ? 'Simpan Perubahan' : 'Tambah Lokasi',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
        hintStyle: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(siteFormProvider.notifier).reset();

    final site = Site(
      siteId: isEdit ? widget.siteId! : _idController.text.trim(),
      siteName: _nameController.text.trim(),
      siteAddress: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      siteLat: double.tryParse(_latController.text),
      siteLon: double.tryParse(_lonController.text),
      siteAlt: double.tryParse(_altController.text),
      siteSts: _isActive ? 1 : 0,
    );

    final notifier = ref.read(siteFormProvider.notifier);
    final success = isEdit
        ? await notifier.updateSite(widget.siteId!, site)
        : await notifier.createSite(site);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Lokasi berhasil diperbarui'
                : 'Lokasi berhasil ditambahkan',
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
