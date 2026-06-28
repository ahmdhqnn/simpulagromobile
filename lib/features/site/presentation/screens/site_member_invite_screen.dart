import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/core/utils/snackbar_helper.dart';
import 'package:simpulagromobile/features/admin/presentation/providers/user_provider.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';
import 'package:simpulagromobile/l10n/l10n.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_loaders.dart';

class SiteMemberInviteScreen extends ConsumerStatefulWidget {
  const SiteMemberInviteScreen({super.key, required this.siteId});

  final String siteId;

  @override
  ConsumerState<SiteMemberInviteScreen> createState() =>
      _SiteMemberInviteScreenState();
}

class _SiteMemberInviteScreenState
    extends ConsumerState<SiteMemberInviteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _manualUserIdController = TextEditingController();

  String? _selectedUserId;

  @override
  void dispose() {
    _manualUserIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inviteState = ref.watch(siteMemberInviteProvider);
    final usersAsync = ref.watch(adminUserListProvider);

    return AdminFormScaffold(
      title: context.l10n.siteInviteTitle,
      isLoading: inviteState.isLoading,
      loadingMessage: context.l10n.siteInviteSubmit,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SiteInfo(siteId: widget.siteId),
                  const SizedBox(height: AppSpacing.sm),
                  usersAsync.when(
                    skipLoadingOnReload: true,
                    skipLoadingOnRefresh: true,
                    skipError: true,
                    data: (users) {
                      final availableUsers =
                          users
                              .where((user) => user.userId.trim().isNotEmpty)
                              .toList()
                            ..sort((a, b) => a.userName.compareTo(b.userName));

                      if (availableUsers.isEmpty) {
                        return _ManualUserIdField(
                          controller: _manualUserIdController,
                        );
                      }

                      return _UserDropdown(
                        users: availableUsers,
                        selectedUserId: _selectedUserId,
                        onChanged: (value) =>
                            setState(() => _selectedUserId = value),
                      );
                    },
                    loading: () => const FormCardSkeleton(fieldCount: 1),
                    error: (_, __) =>
                        _ManualUserIdField(controller: _manualUserIdController),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AdminSubmitButton(
              label: context.l10n.siteInviteSubmit,
              isLoading: inviteState.isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = (_selectedUserId ?? _manualUserIdController.text).trim();
    if (userId.isEmpty) {
      SnackbarHelper.showError(context, context.l10n.siteInviteUserIdRequired);
      return;
    }
    final success = await ref
        .read(siteMemberInviteProvider.notifier)
        .inviteMember(siteId: widget.siteId, userId: userId);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, context.l10n.siteInviteSuccess);
      context.pop();
      return;
    }

    final state = ref.read(siteMemberInviteProvider);
    final message = switch (state.errorType) {
      SiteMemberInviteErrorType.badRequest =>
        context.l10n.siteInviteErrorBadRequest,
      SiteMemberInviteErrorType.forbidden =>
        context.l10n.siteInviteErrorForbidden,
      SiteMemberInviteErrorType.conflict =>
        context.l10n.siteInviteErrorConflict,
      SiteMemberInviteErrorType.noSiteSelected =>
        context.l10n.siteInviteErrorNoSiteSelected,
      SiteMemberInviteErrorType.unknown ||
      null => state.message ?? context.l10n.siteInviteErrorUnknown,
    };
    SnackbarHelper.showError(context, message);
  }
}

class _SiteInfo extends StatelessWidget {
  const _SiteInfo({required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.siteInviteSiteIdLabel(siteId),
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1D1D1D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserDropdown extends StatelessWidget {
  const _UserDropdown({
    required this.users,
    required this.selectedUserId,
    required this.onChanged,
  });

  final List<User> users;
  final String? selectedUserId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AdminFormFields.buildDropdown<String>(
      context,
      value: selectedUserId,
      label: context.l10n.siteInviteUserIdLabel,
      hint: context.l10n.siteInviteUserIdHint,
      icon: Icons.person_add_alt_1_outlined,
      required: true,
      items: users
          .map(
            (user) => DropdownMenuItem<String>(
              value: user.userId,
              child: Text(
                '${user.userName} (${user.userId})',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return context.l10n.siteInviteUserIdRequired;
        }
        return null;
      },
    );
  }
}

class _ManualUserIdField extends StatelessWidget {
  const _ManualUserIdField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AdminFormFields.buildField(
      context,
      controller: controller,
      label: context.l10n.siteInviteUserIdLabel,
      hint: context.l10n.siteInviteUserIdHint,
      icon: Icons.person_add_alt_1_outlined,
      required: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return context.l10n.siteInviteUserIdRequired;
        }
        return null;
      },
    );
  }
}
