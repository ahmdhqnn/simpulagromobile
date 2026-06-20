import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/unit_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/admin/domain/entities/unit.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

class UnitFormScreen extends ConsumerStatefulWidget {
  final String? unitId;

  const UnitFormScreen({super.key, this.unitId});

  @override
  ConsumerState<UnitFormScreen> createState() => _UnitFormScreenState();
}

class _UnitFormScreenState extends ConsumerState<UnitFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _symbolController;
  late final TextEditingController _descController;

  int _status = 1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _symbolController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _symbolController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.unitId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(adminUnitFormProvider);

    if (isEditMode && !_isInitialized) {
      final unitAsync = ref.watch(adminUnitDetailProvider(widget.unitId!));
      unitAsync.whenData((unit) {
        if (!_isInitialized) _initializeForm(unit);
      });

      if (unitAsync.isLoading) {
        return AdminFormScaffold(
          title: context.l10n.adminEditUnitTitle,
          body: const AdminFormScreenSkeleton(
            titleWidth: 150,
            sectionFieldCounts: [4, 1],
          ),
        );
      }
      if (unitAsync.hasError) {
        return AdminFormScaffold(
          title: context.l10n.commonErrorTitle,
          body: AdminErrorState(
            error: unitAsync.error!,
            onRetry: () =>
                ref.invalidate(adminUnitDetailProvider(widget.unitId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'unit:update' : 'unit:create';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: isEditMode
            ? context.l10n.adminEditUnitTitle
            : context.l10n.adminAddUnitTitle,
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? context.l10n.adminSavingChanges
            : context.l10n.adminCreatingUnit,
        body: Form(
          key: _formKey,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              AdminSectionCard(
                title: context.l10n.adminUnitInfoSection,
                child: Column(
                  children: [
                    AdminFormFields.buildField(
                      context,
                      controller: _idController,
                      label: context.l10n.adminUnitIdLabel,
                      hint: context.l10n.adminUnitIdHint,
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminUnitIdRequired;
                        }
                        if (v.length < 2) {
                          return context.l10n.commonMinCharacters(2);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: context.l10n.adminUnitNameLabel,
                      hint: context.l10n.adminUnitNameHint,
                      icon: Icons.straighten,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminUnitNameRequired;
                        }
                        if (v.length < 2) {
                          return context.l10n.commonMinCharacters(2);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _symbolController,
                      label: context.l10n.adminUnitSymbolLabel,
                      hint: context.l10n.adminUnitSymbolHint,
                      icon: Icons.text_fields,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminUnitSymbolRequired;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _descController,
                      label: context.l10n.commonDescription,
                      hint: context.l10n.adminUnitDescriptionHint,
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              AdminSectionCard(
                title: context.l10n.adminStatusSection,
                child: AdminFormFields.buildStatusToggle(
                  context,
                  label: context.l10n.adminStatusUnitLabel,
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.03)),

              AdminSubmitButton(
                label: isEditMode
                    ? context.l10n.commonSaveChanges
                    : context.l10n.adminAddUnitTitle,
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeForm(Unit unit) {
    _idController.text = unit.unitId;
    _nameController.text = unit.unitName ?? '';
    _symbolController.text = unit.unitSymbol ?? '';
    _descController.text = unit.unitDesc ?? '';
    _status = unit.unitSts ?? 1;
    _isInitialized = true;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final unit = Unit(
      unitId: _idController.text.trim(),
      unitName: _nameController.text.trim(),
      unitSymbol: _symbolController.text.trim(),
      unitDesc: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      unitSts: _status,
    );

    final success = isEditMode
        ? await ref
              .read(adminUnitFormProvider.notifier)
              .updateUnit(widget.unitId!, unit)
        : await ref.read(adminUnitFormProvider.notifier).createUnit(unit);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? context.l10n.adminUpdateSuccess(context.l10n.adminUnitTitle)
            : context.l10n.adminCreateSuccess(context.l10n.adminUnitTitle),
      );
      context.pop();
    } else {
      final error = ref.read(adminUnitFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.adminSaveFailed(context.l10n.adminUnitTitle),
      );
    }
  }
}
