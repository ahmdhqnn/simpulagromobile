import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';

class PlantInputForm extends ConsumerStatefulWidget {
  final String siteId;
  final Plant? initialPlant;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const PlantInputForm({
    super.key,
    required this.siteId,
    this.initialPlant,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  ConsumerState<PlantInputForm> createState() => _PlantInputFormState();
}

class _PlantInputFormState extends ConsumerState<PlantInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _plantNameController = TextEditingController();
  final _varietasIdController = TextEditingController();

  CropType? _selectedPlantType;
  DateTime _plantDate = DateTime.now();
  bool _isSubmitting = false;
  bool _didPrefillVarietas = false;

  bool get _isEditMode => widget.initialPlant != null;

  @override
  void initState() {
    super.initState();
    final plant = widget.initialPlant;
    if (plant != null) {
      _plantNameController.text = plant.plantName ?? '';
      _varietasIdController.text = plant.varietasId ?? '';
      _selectedPlantType = plant.plantType;
      _plantDate = plant.plantDate ?? DateTime.now();
      _didPrefillVarietas = true;
    }
  }

  @override
  void dispose() {
    _plantNameController.dispose();
    _varietasIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activePlant = ref.watch(currentPlantProvider);
    final hasActivePlant = !_isEditMode && activePlant != null;
    if (!_isEditMode) {
      _prefillVarietasFromHistory(ref.watch(plantsProvider).valueOrNull ?? []);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularBackButtonWidget(
                    onPressed: () {},
                    svgIconPath: 'assets/icons/more-icon.svg',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                _isEditMode ? 'Edit Planting' : 'Add First Planting',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1D1D1D),
                ),
              ),

              const SizedBox(height: 24),

              if (hasActivePlant) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lokasi ini masih memiliki tanaman aktif ("${activePlant.displayName}"). Harap panen tanaman saat ini sebelum menambahkan yang baru.',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        'Plant Name',
                        _buildTextField(
                          controller: _plantNameController,
                          hintText: 'Ex. Padi Cigentur',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter plant name';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildField(
                        'Varietas ID',
                        _buildTextField(
                          controller: _varietasIdController,
                          hintText: 'Ex. VARIETAS001',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter varietas ID';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildField('Planting Type', _buildPlantTypeDropdown()),

                      const SizedBox(height: 20),

                      _buildField(
                        'Planting Date',
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd MMMM yyyy').format(_plantDate),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Icon(Icons.calendar_today, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleButton(
                            svgPath: 'assets/icons/close-icon.svg',
                            onTap: widget.onCancel,
                          ),
                          _buildCircleButton(
                            svgPath: 'assets/icons/check-icon.svg',
                            onTap: _isSubmitting || hasActivePlant
                                ? null
                                : _submitForm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildCircleButton({
    required String svgPath,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              Color(0xFF1D1D1D),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          fontStyle: FontStyle.italic,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildPlantTypeDropdown() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(100),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CropType>(
          value: _selectedPlantType,
          hint: const Text('Ex. PADI, JAGUNG, Dll'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: CropType.values.map((type) {
            return DropdownMenuItem(value: type, child: Text(type.displayName));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPlantType = value;
            });
          },
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _plantDate = picked;
      });
    }
  }

  void _prefillVarietasFromHistory(List<Plant> plants) {
    if (_didPrefillVarietas || _varietasIdController.text.trim().isNotEmpty) {
      return;
    }

    String? previousVarietasId;
    for (final plant in plants) {
      final varietasId = plant.varietasId?.trim();
      if (varietasId != null && varietasId.isNotEmpty) {
        previousVarietasId = varietasId;
        break;
      }
    }

    final candidateVarietasId = previousVarietasId;
    if (candidateVarietasId == null) return;
    _didPrefillVarietas = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _varietasIdController.text.trim().isNotEmpty) return;
      _varietasIdController.text = candidateVarietasId;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_varietasIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter varietas ID')));
      return;
    }

    if (_selectedPlantType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a planting type')),
      );
      return;
    }

    if (!_isEditMode) {
      Plant? activePlant;
      try {
        final plants = await ref.read(plantsProvider.future);
        for (final plant in plants) {
          if (plant.isCurrentPlanting) {
            activePlant = plant;
            break;
          }
        }
      } catch (_) {
        activePlant = ref.read(currentPlantProvider);
      }

      if (!mounted) return;

      if (activePlant != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menambahkan: Masih ada tanaman aktif "${activePlant.displayName}".',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    final success = _isEditMode
        ? await ref
              .read(updatePlantFormProvider.notifier)
              .updatePlant(
                siteId: widget.siteId,
                plantId: widget.initialPlant!.plantId,
                plantName: _plantNameController.text.trim(),
                varietasId: _varietasIdController.text.trim(),
                plantType: _selectedPlantType!,
                plantDate: _plantDate,
              )
        : await ref
              .read(createPlantProvider.notifier)
              .createPlant(
                siteId: widget.siteId,
                plantName: _plantNameController.text.trim(),
                varietasId: _varietasIdController.text.trim(),
                plantType: _selectedPlantType!,
                plantDate: _plantDate,
              );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      widget.onSuccess();
    } else {
      final errorMsg =
          (_isEditMode
              ? ref.read(updatePlantFormProvider).error
              : ref.read(createPlantProvider).error) ??
          (_isEditMode
              ? 'Gagal memperbarui tanaman. Silakan coba lagi.'
              : 'Gagal menambahkan tanaman. Silakan coba lagi.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
      );
    }
  }
}
