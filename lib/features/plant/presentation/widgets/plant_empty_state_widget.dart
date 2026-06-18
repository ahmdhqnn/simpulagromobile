import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';

class PlantEmptyState extends StatelessWidget {
  final VoidCallback onAddPlant;
  final bool actionEnabled;

  const PlantEmptyState({
    super.key,
    required this.onAddPlant,
    this.actionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.rh(0.015)),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [const SizedBox(width: 58, height: 58)],
          ),

          SizedBox(height: context.rh(0.03)),

          Text(
            l10n.plantOverviewTitle,
            style: AppTextStyles.sectionTitle(context),
          ),

          SizedBox(height: context.rh(0.03)),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.rw(0.133),
              vertical: context.rh(0.069),
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.plantEmptyTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(12),
                    weight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.83,
                  ),
                ),
                SizedBox(height: context.rh(0.004)),
                Text(
                  l10n.plantEmptyMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(12),
                    weight: FontWeight.w400,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.rh(0.025)),

          GestureDetector(
            onTap: actionEnabled ? onAddPlant : null,
            child: Container(
              width: double.infinity,
              height: context.rh(0.071).clamp(52.0, 64.0),
              decoration: BoxDecoration(
                color: actionEnabled
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Center(
                child: Text(
                  l10n.plantAddFirst,
                  style: AppTextStyles.sectionTitle(context, context.sp(18))
                      .copyWith(
                        fontWeight: FontWeight.w400,
                        color: actionEnabled
                            ? AppColors.textPrimary
                            : AppColors.textPrimary.withValues(alpha: 0.45),
                        height: 1.22,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
