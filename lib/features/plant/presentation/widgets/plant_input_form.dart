import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/plant_model.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlantInputForm extends ConsumerStatefulWidget {
  final String siteId;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const PlantInputForm({
    super.key,
    required this.siteId,
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
  VarietasModel? _selectedVarietas;
  DateTime _plantDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _plantNameController.dispose();
    _varietasIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final varietasAsync = ref.watch(varietasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// TOP RIGHT BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/more-icon.svg',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// TITLE
              const Text(
                'Add First Planting',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1D1D1D),
                ),
              ),

              const SizedBox(height: 24),

              /// CARD
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
                        varietasAsync.when(
                          loading: () => _buildTextField(
                            controller: _varietasIdController,
                            hintText: 'Loading...',
                            enabled: false,
                          ),
                          error: (_, __) => _buildTextField(
                            controller: _varietasIdController,
                            hintText: 'Error loading',
                            enabled: false,
                          ),
                          data: (varietas) => _buildVarietasDropdown(varietas),
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

                      /// ACTION BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleButton(
                            svgPath: 'assets/icons/close-icon.svg',
                            onTap: widget.onCancel,
                          ),
                          _buildCircleButton(
                            svgPath: 'assets/icons/check-icon.svg',
                            onTap: _isSubmitting ? null : _submitForm,
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

  /// =========================
  /// COMPONENTS
  /// =========================

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
          color: AppColors.textSecondary.withOpacity(0.5),
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

  Widget _buildVarietasDropdown(List<VarietasModel> varietas) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(100),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VarietasModel>(
          value: _selectedVarietas,
          hint: const Text('Select varietas'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: varietas.map((v) {
            return DropdownMenuItem(
              value: v,
              child: Text(v.varietasName ?? v.varietasId),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedVarietas = value;
              _varietasIdController.text = value?.varietasId ?? '';
            });
          },
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

  /// =========================
  /// LOGIC (UNCHANGED)
  /// =========================

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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVarietas == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a varietas')));
      return;
    }

    if (_selectedPlantType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a planting type')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await ref
        .read(createPlantProvider.notifier)
        .createPlant(
          siteId: widget.siteId,
          plantName: _plantNameController.text,
          varietasId: _selectedVarietas!.varietasId,
          plantType: _selectedPlantType!,
          plantDate: _plantDate,
        );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      widget.onSuccess();
    }
  }
}
