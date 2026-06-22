import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/skeleton_elements.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../varietas/domain/entities/varietas_item.dart';
import '../../../varietas/presentation/providers/varietas_provider.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';
import '../../../admin/presentation/widgets/admin_form_fields.dart';

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

    return AdminFormScaffold(
      title: _isEditMode ? l10n.plantEditTitle : l10n.plantAddTitle,
      isLoading: _isSubmitting || isProviderSubmitting,
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.rw(0.051),
            vertical: context.rh(0.01),
          ),
          children: [
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

            AdminSectionCard(
              child: Column(
                children: [
                  AdminFormFields.buildField(
                    context,
                    controller: _plantNameController,
                    label: l10n.plantNameLabel,
                    hint: l10n.plantNameHint,
                    icon: Icons.eco_outlined,
                    required: true,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.plantNameRequired
                        : null,
                  ),
                  SizedBox(height: context.rh(0.016)),
                  _buildVarietasField(context, l10n, varietasAsync),
                  SizedBox(height: context.rh(0.016)),
                  AdminFormFields.buildFieldShell(
                    context,
                    label: l10n.plantTypeLabel,
                    child: _buildPlantTypeDropdown(context, l10n),
                  ),
                  SizedBox(height: context.rh(0.016)),
                  AdminFormFields.buildFieldShell(
                    context,
                    label: l10n.plantDateLabel,
                    child: _buildDatePicker(context),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: context.rh(0.03)),
            AdminSubmitButton(
              label: _isEditMode ? l10n.commonSaveChanges : l10n.plantAddTitle,
              onPressed: hasActivePlant ? () {} : _submitForm,
              isLoading: _isSubmitting || isProviderSubmitting,
            ),
            SizedBox(height: context.rh(0.04)),
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
          AdminFormFields.buildField(
            context,
            controller: _varietasIdController,
            label: l10n.plantVarietasIdLabel,
            hint: l10n.plantVarietasIdHint,
            icon: Icons.tag,
            required: true,
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
              AdminFormFields.buildField(
                context,
                controller: _varietasIdController,
                label: l10n.plantVarietasIdLabel,
                hint: l10n.plantVarietasIdHint,
                icon: Icons.tag,
                required: true,
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
            AdminFormFields.buildDropdown<String>(
              context,
              value: _selectedVarietasId,
              label: l10n.plantVarietasIdLabel,
              hint: l10n.plantVarietasIdHint,
              icon: Icons.grass_outlined,
              required: true,
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
      loading: () => AdminFormFields.buildFieldShell(
        context,
        label: l10n.plantVarietasIdLabel,
        child: Container(
          height: context.rh(0.05).clamp(44.0, 48.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: const SkeletonContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SkeletonLine(width: 150, height: 13),
              ),
            ),
          ),
        ),
      ),
      error: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminFormFields.buildField(
            context,
            controller: _varietasIdController,
            label: l10n.plantVarietasIdLabel,
            hint: l10n.plantVarietasIdHint,
            icon: Icons.tag,
            required: true,
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

  Widget _buildPlantTypeDropdown(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: context.rh(0.05).clamp(44.0, 48.0),
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
          focusColor: Colors.transparent,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textPrimary,
            size: context.sp(22),
          ),
          items: CropType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type.localizedLabel(l10n),
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
        height: context.rh(0.05).clamp(44.0, 48.0),
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

  void _invalidatePhaseCache(String siteId) {
    ref.invalidate(currentPhaseProvider(siteId));
    ref.invalidate(phaseListProvider(siteId));
    ref.invalidate(phaseHistoryProvider(siteId));
    ref.invalidate(phaseStatsProvider(siteId));
    ref.invalidate(phasesForSelectedSiteProvider);
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
      _invalidatePhaseCache(result.plant?.siteId ?? widget.siteId);
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
