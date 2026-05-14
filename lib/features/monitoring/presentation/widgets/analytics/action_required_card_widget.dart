import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/icon_badge_widget.dart';

class ActionRequiredCardWidget extends StatelessWidget {
  const ActionRequiredCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      radius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Tindakan Diperlukan',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(22),
                    fontWeight: FontWeight.w300,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
              ),
              const IconBadgeWidget.svg(
                svgIconPath:
                    'assets/icons/recomendation-action-outline-icon.svg',
                background: AppColors.softOrange,
                tint: AppColors.warning,
                padding: EdgeInsets.all(14),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '0 Sensor Tersedia, belum ada konfigurasi\nSilahkan konfigurasi sensor untuk mulai monitoring',
            style: AppTextStyles.hint(context, height: 1.5),
          ),
        ],
      ),
    );
  }
}
