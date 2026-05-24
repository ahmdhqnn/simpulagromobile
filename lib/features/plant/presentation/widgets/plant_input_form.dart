import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final activePlant = ref.watch(currentPlantProvider);
    final createState = ref.watch(createPlantProvider);
    final updateState = ref.watch(updatePlantFormProvider);
    final isProviderSubmitting = _isEditMode
        ? updateState.isLoading
        : createState.isLoading;
    final hasActivePlant = !_isEditMode && activePlant != null;

    if (!_isEditMode) {
      _prefillVarietasFromHistory(ref.watch(plantsProvider).valueOrNull ?? []);
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.rh(0.015)),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularBackButtonWidget(
                    onPressed: () {},
                    svgIconPath: 'assets/icons/more-icon.svg',
                  ),
                ],
              ),

              SizedBox(height: context.rh(0.03)),

              Text(
                _isEditMode ? l10n.plantEditTitle : l10n.plantAddTitle,
                style: AppTextStyles.sectionTitle(context),
              ),

              SizedBox(height: context.rh(0.03)),

              if (hasActivePlant) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.rw(0.041)),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
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
                      SizedBox(width: context.rw(0.031)),
                      Expanded(
                        child: Text(
                          l10n.plantActiveConflict(activePlant.displayName),
                          style: AppTextStyles.label(
                            context,
                            size: context.sp(12),
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.rh(0.02)),
              ],

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.rw(0.051)),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        context,
                        'Plant Name',
                        _buildTextField(
                          context,
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

                      SizedBox(height: context.rh(0.025)),

                      _buildField(
                        context,
                        l10n.plantVarietasIdLabel,
                        _buildTextField(
                          context,
                          controller: _varietasIdController,
                          hintText: l10n.plantVarietasIdHint,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.plantVarietasIdRequired;
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: context.rh(0.025)),

                      _buildField(
                        context,
                        l10n.plantTypeLabel,
                        _buildPlantTypeDropdown(context),
                      ),

                      SizedBox(height: context.rh(0.025)),

                      _buildField(
                        context,
                        l10n.plantDateLabel,
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            height: context.rh(0.05).clamp(40.0, 48.0),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.rw(0.041),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormatter.formatDate(_plantDate),
                                  style: AppTextStyles.label(
                                    context,
                                    size: context.sp(14),
                                    weight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  size: context.sp(18),
                                  color: AppColors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: context.rh(0.037)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleButton(
                            context,
                            svgPath: 'assets/icons/close-icon.svg',
                            onTap: widget.onCancel,
                          ),
                          _buildCircleButton(
                            context,
                            svgPath: 'assets/icons/check-icon.svg',
                            onTap:
                                _isSubmitting ||
                                    isProviderSubmitting ||
                                    hasActivePlant
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

  Widget _buildField(BuildContext context, String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label(
            context,
            size: context.sp(14),
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(height: context.rh(0.01)),
        field,
      ],
    );
  }

  Widget _buildCircleButton(
    BuildContext context, {
    required String svgPath,
    required VoidCallback? onTap,
  }) {
    final size = context.rw(0.128).clamp(48.0, 56.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: context.rw(0.062).clamp(22.0, 28.0),
            height: context.rw(0.062).clamp(22.0, 28.0),
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      style: AppTextStyles.label(
        context,
        size: context.sp(14),
        weight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hint(context, size: context.sp(14)),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rw(0.041),
          vertical: context.rh(0.012),
        ),
      ),
    );
  }

  Widget _buildPlantTypeDropdown(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: context.rh(0.05).clamp(40.0, 48.0),
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CropType>(
          value: _selectedPlantType,
          hint: Text(
            l10n.plantTypeHint,
            style: AppTextStyles.hint(context, size: context.sp(14)),
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textPrimary,
            size: context.sp(22),
          ),
          items: CropType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type.displayName,
                style: AppTextStyles.label(
                  context,
                  size: context.sp(14),
                  weight: FontWeight.w400,
                ),
              ),
            );
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

    if (picked != null && mounted) {
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
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    if (_varietasIdController.text.trim().isEmpty) {
      SnackbarHelper.showError(context, l10n.plantVarietasIdRequired);
      return;
    }

    if (_selectedPlantType == null) {
      SnackbarHelper.showWarning(context, l10n.plantTypeRequired);
      return;
    }

    if (!_isEditMode) {
      final activePlant = ref.read(currentPlantProvider);

      if (!mounted) return;

      if (activePlant != null) {
        SnackbarHelper.showError(
          context,
          l10n.plantActiveConflict(activePlant.displayName),
        );
        return;
      }
    }

    if (!mounted) return;
    setState(() => _isSubmitting = true);

    final PlantMutationResult result;
    if (_isEditMode) {
      final plant = widget.initialPlant!;
      final siteId = (plant.siteId?.trim().isNotEmpty == true)
          ? plant.siteId!.trim()
          : widget.siteId;
      result = await ref
          .read(updatePlantFormProvider.notifier)
          .updatePlant(
            siteId: siteId,
            plantId: plant.plantId.trim(),
            plantName: _plantNameController.text.trim(),
            varietasId: _varietasIdController.text.trim(),
            plantType: _selectedPlantType!,
            plantDate: _plantDate,
          );
    } else {
      result = await ref.read(createPlantProvider.notifier).createPlant(
        siteId: widget.siteId,
        plantName: _plantNameController.text.trim(),
        varietasId: _varietasIdController.text.trim(),
        plantType: _selectedPlantType!,
        plantDate: _plantDate,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result.success) {
      SnackbarHelper.showSuccess(
        context,
        _isEditMode ? l10n.plantUpdateSuccess : l10n.plantCreateSuccess,
      );
      widget.onSuccess();
      return;
    }

    SnackbarHelper.showError(
      context,
      result.errorMessage ??
          (_isEditMode ? l10n.plantUpdateFailed : l10n.plantCreateFailed),
    );
  }
}
