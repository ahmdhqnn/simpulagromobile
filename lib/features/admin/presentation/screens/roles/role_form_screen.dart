import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/role_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/permission_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_guard.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/permission_checkbox_group.dart';
import 'package:simpulagromobile/features/admin/domain/entities/role.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

class RoleFormScreen extends ConsumerStatefulWidget {
  final String? roleId;

  const RoleFormScreen({super.key, this.roleId});

  @override
  ConsumerState<RoleFormScreen> createState() => _RoleFormScreenState();
}

class _RoleFormScreenState extends ConsumerState<RoleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  int _status = 1;
  Set<String> _selectedPermissionIds = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.roleId != null;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(adminRoleFormProvider);

    if (isEditMode && !_isInitialized) {
      final roleAsync = ref.watch(adminRoleDetailProvider(widget.roleId!));
      roleAsync.whenData((role) {
        if (!_isInitialized) _initializeForm(role);
      });

      if (roleAsync.isLoading) {
        return AdminFormScaffold(
          title: context.l10n.adminLoadingTitle,
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: FormCardSkeleton(fieldCount: 4),
          ),
        );
      }
      if (roleAsync.hasError) {
        return AdminFormScaffold(
          title: context.l10n.commonErrorTitle,
          body: AdminErrorState(
            error: roleAsync.error!,
            onRetry: () =>
                ref.invalidate(adminRoleDetailProvider(widget.roleId!)),
          ),
        );
      }
    }

    final permission = isEditMode ? 'role:update' : 'role:create';

    return PermissionGuardScreen(
      permission: permission,
      child: AdminFormScaffold(
        title: isEditMode ? context.l10n.adminEditRoleTitle : context.l10n.adminAddRoleTitle,
        isLoading: formState.isLoading,
        loadingMessage: isEditMode
            ? context.l10n.adminSavingChanges
            : context.l10n.adminCreatingRole,
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.051),
              vertical: context.rh(0.01),
            ),
            children: [
              SizedBox(height: context.rh(0.01)),
              Text(
                isEditMode ? context.l10n.adminEditRoleTitle : context.l10n.adminAddRoleTitle,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(22),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1D1D1D),
                  height: 1.0,
                ),
              ),
              SizedBox(height: context.rh(0.014)),
              AdminSectionCard(
                title: context.l10n.adminRoleInfoSection,
                child: Column(
                  children: [
                    AdminFormFields.buildField(
                      context,
                      controller: _idController,
                      label: context.l10n.adminRoleIdLabel,
                      hint: context.l10n.adminRoleIdHint,
                      icon: Icons.tag,
                      enabled: !isEditMode,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminRoleIdRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _nameController,
                      label: context.l10n.adminRoleNameLabel,
                      hint: context.l10n.adminRoleNameHint,
                      icon: Icons.admin_panel_settings,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.adminRoleNameRequired;
                        }
                        if (v.length < 3) {
                          return context.l10n.commonMinCharacters(3);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.rh(0.016)),
                    AdminFormFields.buildField(
                      context,
                      controller: _descController,
                      label: context.l10n.commonDescription,
                      hint: context.l10n.adminRoleDescriptionHint,
                      icon: Icons.description,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              AdminSectionCard(
                title: context.l10n.adminStatusSection,
                child: AdminFormFields.buildStatusToggle(
                  context,
                  label: context.l10n.adminStatusRoleLabel,
                  value: _status == 1,
                  onChanged: (v) => setState(() => _status = v ? 1 : 0),
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              AdminSectionCard(
                title: context.l10n.adminRolePermissionSection,
                child: PermissionCheckboxGroup(
                  selectedPermissionIds: _selectedPermissionIds,
                  onChanged: (ids) =>
                      setState(() => _selectedPermissionIds = ids),
                ),
              ),
              SizedBox(height: context.rh(0.02)),

              AdminSubmitButton(
                label: isEditMode ? context.l10n.commonSaveChanges : context.l10n.adminAddRoleTitle,
                onPressed: _handleSubmit,
              ),
              SizedBox(height: context.rh(0.04)),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeForm(Role role) {
    _idController.text = role.roleId;
    _nameController.text = role.roleName ?? '';
    _descController.text = role.roleDesc ?? '';
    _status = role.roleSts ?? 1;
    _selectedPermissionIds = role.permissions.map((p) => p.permId).toSet();
    _isInitialized = true;

    // Keep role edit prefill aligned with dedicated /permissions/role/{roleId}.
    ref
        .read(permissionsByRoleProvider(role.roleId).future)
        .then((permissions) {
          if (!mounted || permissions.isEmpty) return;
          setState(() {
            _selectedPermissionIds = permissions.map((p) => p.permId).toSet();
          });
        })
        .catchError((_) {});
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final role = Role(
      roleId: _idController.text.trim(),
      roleName: _nameController.text.trim(),
      roleDesc: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      roleSts: _status,
    );

    final permissionIds = _selectedPermissionIds.toList();

    final success = isEditMode
        ? await ref
              .read(adminRoleFormProvider.notifier)
              .updateRole(widget.roleId!, role, permissionIds)
        : await ref
              .read(adminRoleFormProvider.notifier)
              .createRole(role, permissionIds);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode
            ? context.l10n.adminUpdateSuccess(context.l10n.adminRoleTitle)
            : context.l10n.adminCreateSuccess(context.l10n.adminRoleTitle),
      );
      context.pop();
    } else {
      final error = ref.read(adminRoleFormProvider).error;
      SnackbarHelper.showError(
        context,
        error ?? context.l10n.adminSaveFailed(context.l10n.adminRoleTitle),
      );
    }
  }
}
