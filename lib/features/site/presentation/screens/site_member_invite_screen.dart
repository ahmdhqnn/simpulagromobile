import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/site_provider.dart';

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
  final _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inviteState = ref.watch(siteMemberInviteProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.siteInviteTitle), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.siteInviteSiteIdLabel(widget.siteId)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _userIdController,
                      decoration: InputDecoration(
                        labelText: l10n.siteInviteUserIdLabel,
                        hintText: l10n.siteInviteUserIdHint,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.siteInviteUserIdRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: inviteState.isLoading ? null : _submit,
                        child: inviteState.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.siteInviteSubmit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(siteMemberInviteProvider.notifier)
        .inviteMember(
          siteId: widget.siteId,
          userId: _userIdController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, l10n.siteInviteSuccess);
      context.pop();
      return;
    }

    final state = ref.read(siteMemberInviteProvider);
    final message = switch (state.errorType) {
      SiteMemberInviteErrorType.badRequest => l10n.siteInviteErrorBadRequest,
      SiteMemberInviteErrorType.forbidden => l10n.siteInviteErrorForbidden,
      SiteMemberInviteErrorType.conflict => l10n.siteInviteErrorConflict,
      SiteMemberInviteErrorType.noSiteSelected =>
        l10n.siteInviteErrorNoSiteSelected,
      SiteMemberInviteErrorType.unknown ||
      null => state.message ?? l10n.siteInviteErrorUnknown,
    };
    SnackbarHelper.showError(context, message);
  }
}
