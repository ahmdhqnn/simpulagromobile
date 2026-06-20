import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/admin/presentation/widgets/admin_form_fields.dart';
import 'package:simpulagromobile/shared/widgets/skeleton_elements.dart';
import 'package:simpulagromobile/l10n/app_localizations.dart';

class AsyncDropdownWidget<T, V> extends ConsumerWidget {
  final AsyncValue<List<T>> async;
  final V? value;
  final String label;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<V>> Function(List<T> items) itemBuilder;
  final ValueChanged<V?> onChanged;
  final String? Function(V?)? validator;
  final String? errorMessage;
  final bool enabled;

  const AsyncDropdownWidget({
    super.key,
    required this.async,
    required this.value,
    required this.label,
    required this.hint,
    required this.icon,
    required this.itemBuilder,
    required this.onChanged,
    this.validator,
    this.errorMessage,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayErrorMessage =
        errorMessage ?? AppLocalizations.of(context)!.commonLoadFailed;

    return async.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (items) => AdminFormFields.buildDropdown<V>(
        context,
        value: value,
        label: label,
        hint: hint,
        icon: icon,
        items: itemBuilder(items),
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
      ),
      loading: () => _placeholder(
        context,
        const SkeletonContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SkeletonLine(width: 160, height: 14),
            ),
          ),
        ),
      ),
      error: (_, __) => _placeholder(
        context,
        Center(
          child: Text(
            displayErrorMessage,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              color: AppColors.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, Widget child) {
    return AdminFormFields.buildFieldShell(
      context,
      label: label,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: child,
      ),
    );
  }
}
