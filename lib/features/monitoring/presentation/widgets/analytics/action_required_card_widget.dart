import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../monitoring_card_header_widget.dart';

class ActionRequiredCardWidget extends StatelessWidget {
  const ActionRequiredCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      child: const MonitoringCardHeaderWidget.icon(
        icon: Icons.settings_suggest_outlined,
        title: 'Tindakan Diperlukan',
        description:
            '0 sensor tersedia, belum ada konfigurasi. Silakan konfigurasi sensor untuk mulai monitoring',
        background: AppColors.softOrange,
        tint: AppColors.warning,
      ),
    );
  }
}
