import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/l10n.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';
import '../../../admin/presentation/widgets/admin_form_fields.dart';
import '../providers/notes_provider.dart';

class SiteNoteFormScreen extends ConsumerStatefulWidget {
  final String siteId;

  const SiteNoteFormScreen({super.key, required this.siteId});

  @override
  ConsumerState<SiteNoteFormScreen> createState() => _SiteNoteFormScreenState();
}

class _SiteNoteFormScreenState extends ConsumerState<SiteNoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final l10n = context.l10n;
    setState(() => _isSubmitting = true);

    final success = await ref
        .read(createNoteProvider.notifier)
        .create(
          siteId: widget.siteId, 
          title: _titleController.text.trim(), 
          desc: _descController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      SnackbarHelper.showSuccess(context, l10n.notesSaved);
      context.pop();
      return;
    }

    final error = ref.read(createNoteProvider).error;
    SnackbarHelper.showError(
      context,
      _errorMessage(error) ?? l10n.notesSaveFailed,
    );
  }

  String? _errorMessage(Object? error) {
    final message = error?.toString().trim();
    if (message == null || message.isEmpty) return null;
    return message.replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AdminFormScaffold(
      title: l10n.notesNew,
      isLoading: _isSubmitting,
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
                children: [
                  AdminFormFields.buildField(
                    context,
                    controller: _titleController,
                    label: l10n.forumPostTitleLabel,
                    hint: l10n.forumPostTitleLabel,
                    icon: Icons.title_outlined,
                    required: true,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return l10n.forumPostTitleRequired;
                      return null;
                    },
                  ),
                  SizedBox(height: context.rh(0.016)),
                  AdminFormFields.buildField(
                    context,
                    controller: _descController,
                    label: l10n.commonDescription,
                    hint: l10n.notesContentHint,
                    icon: Icons.article_outlined,
                    maxLines: 4,
                    required: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.commonRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rh(0.03)),
            AdminSubmitButton(
              label: l10n.commonSave,
              onPressed: _submit,
              isLoading: _isSubmitting,
            ),
            SizedBox(height: context.rh(0.04)),
          ],
        ),
      ),
    );
  }
}
