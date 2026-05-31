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
import '../../../varietas/domain/entities/varietas_item.dart';
import '../../../varietas/presentation/providers/varietas_provider.dart';

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
  String? _selectedVarietasId;
  DateTime _plantDate = DateTime.now();
  bool _isSubmitting = false;
  bool _useManualVarietasId = false;
  bool _didPrefillVarietas = false;

  bool get _isEditMode => widget.initialPlant != null;

  @override
  void initState() {
    super.initState();
    final plant = widget.initialPlant;
    if (plant != null) {
      _plantNameController.text = plant.plantName ?? '';
      _varietasIdController.text = plant.varietasId ?? '';
      _selectedVarietasId = plant.varietasId?.trim();
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
    final activePlant = ref.watch(currentPlantProvider);
    final createState = ref.watch(createPlantProvider);
    final updateState = ref.watch(updatePlantFormProvider);
    final varietasAsync = ref.watch(varietasListProvider);
    final isProviderSubmitting = _isEditMode
        ? updateState.isLoading
        : createState.isLoading;
    final hasActivePlant = !_isEditMode && activePlant != null;

    if (!_isEditMode) {
      _prefillVarietasFromHistory(ref.watch(plantsProvider).valueOrNull ?? []);
    }
    _syncVarietasSelection(varietasAsync.valueOrNull ?? const <VarietasItem>[]);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.rh(0.015)),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Opacity(
                  opacity: 0.35,
                  child: CircularBackButtonWidget(
                    onPressed: () {}, // disabled saat form aktif
                    svgIconPath: 'assets/icons/more-icon.svg',
                  ),
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FormField(
                      label: l10n.plantNameLabel,
                      child: _buildTextField(
                        context,
                        controller: _plantNameController,
                        hintText: l10n.plantNameHint,
                        validator: (v) => (v == null || v.isEmpty)
                            ? l10n.plantNameRequired
                            : null,
                      ),
                    ),

                    SizedBox(height: context.rh(0.025)),

                    _FormField(
                      label: l10n.plantVarietasIdLabel,
                      child: _buildVarietasField(context, l10n, varietasAsync),
                    ),

                    SizedBox(height: context.rh(0.025)),

                    _FormField(
                      label: l10n.plantTypeLabel,
                      child: _buildPlantTypeDropdown(context, l10n),
                    ),

                    SizedBox(height: context.rh(0.025)),

                    _FormField(
                      label: l10n.plantDateLabel,
                      child: _buildDatePicker(context),
                    ),

                    SizedBox(height: context.rh(0.037)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleActionButton(
                          svgPath: 'assets/icons/close-icon.svg',
                          onTap: widget.onCancel,
                        ),
                        _CircleActionButton(
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

            SizedBox(height: context.rh(0.02)),
          ],
        ),
      ),
    );
  }

  Widget _buildVarietasField(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<VarietasItem>> varietasAsync,
  ) {
    if (_useManualVarietasId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            context,
            controller: _varietasIdController,
            hintText: l10n.plantVarietasIdHint,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.plantVarietasIdRequired
                : null,
          ),
          SizedBox(height: context.rh(0.008)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => _useManualVarietasId = false),
              child: Text(l10n.plantVarietasUseList),
            ),
          ),
        ],
      );
    }

    return varietasAsync.when(
      data: (items) {
        final activeItems = items.where((item) => item.isActive).toList();
        if (activeItems.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                context,
                controller: _varietasIdController,
                hintText: l10n.plantVarietasIdHint,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.plantVarietasIdRequired
                    : null,
              ),
              SizedBox(height: context.rh(0.008)),
              Text(
                l10n.plantVarietasEmptyFallback,
                style: AppTextStyles.hint(context, size: context.sp(12)),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: context.rh(0.05).clamp(40.0, 48.0),
              padding: EdgeInsets.symmetric(horizontal: context.rw(0.041)),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedVarietasId,
                  hint: Text(
                    l10n.plantVarietasIdHint,
                    style: AppTextStyles.hint(context, size: context.sp(14)),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textPrimary,
                    size: context.sp(22),
                  ),
                  items: activeItems.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.varietasId,
                      child: Text(
                        item.displayName,
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
                      _selectedVarietasId = value;
                      _varietasIdController.text = value ?? '';
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: context.rh(0.008)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _useManualVarietasId = true),
                child: Text(l10n.plantVarietasUseManual),
              ),
            ),
          ],
        );
      },
      loading: () => Container(
        height: context.rh(0.05).clamp(40.0, 48.0),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            context,
            controller: _varietasIdController,
            hintText: l10n.plantVarietasIdHint,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.plantVarietasIdRequired
                : null,
          ),
          SizedBox(height: context.rh(0.008)),
          Text(
            l10n.plantVarietasLoadFailedFallback,
            style: AppTextStyles.label(
              context,
              size: context.sp(12),
              color: AppColors.error,
            ),
          ),
        ],
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rw(0.041),
          vertical: context.rh(0.012),
        ),
      ),
    );
  }

  Widget _buildPlantTypeDropdown(BuildContext context, AppLocalizations l10n) {
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
          onChanged: (value) => setState(() => _selectedPlantType = value),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        height: context.rh(0.05).clamp(40.0, 48.0),
        padding: EdgeInsets.symmetric(horizontal: context.rw(0.041)),
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
      setState(() => _plantDate = picked);
    }
  }

  void _prefillVarietasFromHistory(List<Plant> plants) {
    if (_didPrefillVarietas || _varietasIdController.text.trim().isNotEmpty) {
      return;
    }
    String? previousVarietasId;
    for (final plant in plants) {
      final id = plant.varietasId?.trim();
      if (id != null && id.isNotEmpty) {
        previousVarietasId = id;
        break;
      }
    }
    if (previousVarietasId == null) return;
    _didPrefillVarietas = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _varietasIdController.text.trim().isNotEmpty) return;
      final id = previousVarietasId!;
      _varietasIdController.text = id;
      _selectedVarietasId = id;
    });
  }

  void _syncVarietasSelection(List<VarietasItem> items) {
    final currentId = _varietasIdController.text.trim();
    if (currentId.isEmpty || items.isEmpty) return;

    final exists = items.any((item) => item.varietasId == currentId);
    if (!exists) {
      if (!_useManualVarietasId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _useManualVarietasId = true);
        });
      }
      return;
    }

    if (_selectedVarietasId == currentId) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _selectedVarietasId = currentId);
    });
  }

  Future<void> _submitForm() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    final varietasId = _resolveVarietasId();
    if (varietasId == null) {
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
            varietasId: varietasId,
            plantType: _selectedPlantType!,
            plantDate: _plantDate,
          );
    } else {
      result = await ref
          .read(createPlantProvider.notifier)
          .createPlant(
            siteId: widget.siteId,
            plantName: _plantNameController.text.trim(),
            varietasId: varietasId,
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

  String? _resolveVarietasId() {
    final fromDropdown = _selectedVarietasId?.trim();
    if (!_useManualVarietasId &&
        fromDropdown != null &&
        fromDropdown.isNotEmpty) {
      return fromDropdown;
    }
    final fromInput = _varietasIdController.text.trim();
    if (fromInput.isEmpty) return null;
    return fromInput;
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
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
        child,
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback? onTap;

  const _CircleActionButton({required this.svgPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = context.rw(0.128).clamp(48.0, 56.0);
    final iconSize = context.rw(0.062).clamp(22.0, 28.0);
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.surfaceVariant.withValues(alpha: 0.5)
              : AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              isDisabled
                  ? AppColors.textPrimary.withValues(alpha: 0.3)
                  : AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
