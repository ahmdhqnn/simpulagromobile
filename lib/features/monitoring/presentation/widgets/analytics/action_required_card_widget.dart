import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../monitoring_card_header_widget.dart';

class ActionRequiredCardWidget extends StatelessWidget {
  const ActionRequiredCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardWidget.elevated(
      boxShadow: null,
      radius: AppRadius.lg,
      child: MonitoringCardHeaderWidget.icon(
        icon: Icons.settings_suggest_outlined,
        title: context.l10n.monitoringActionRequiredTitle,
        description: context.l10n.monitoringNoSensorConfiguredDesc,
        background: AppColors.softOrange,
        tint: AppColors.warning,
      ),
    );
  }
}
