import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simpulagromobile/core/theme/app_theme.dart';
import 'package:simpulagromobile/core/utils/responsive.dart';
import 'package:simpulagromobile/features/utilitas/presentation/widgets/utilitas_form_fields.dart';

class AsyncDropdownWidget<T, V> extends ConsumerWidget {
  final AsyncValue<List<T>> async;
  final V? value;
  final String label;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<V>> Function(List<T> items) itemBuilder;
  final ValueChanged<V?> onChanged;
  final String? Function(V?)? validator;
  final String errorMessage;

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
    this.errorMessage = 'Gagal memuat data',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return async.when(
      data: (items) => UtilitasFormFields.buildDropdown<V>(
        context,
        value: value,
        label: label,
        hint: hint,
        icon: icon,
        items: itemBuilder(items),
        onChanged: onChanged,
        validator: validator,
      ),
      loading: () => _placeholder(
        const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      error: (_, __) => _placeholder(
        Center(
          child: Text(
            errorMessage,
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

  Widget _placeholder(Widget child) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: child,
    );
  }
}
