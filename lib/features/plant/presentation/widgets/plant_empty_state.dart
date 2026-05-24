import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.rh(0.015)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularBackButtonWidget(
                    onPressed: () {},
                    svgIconPath: 'assets/icons/more-icon.svg',
                  ),
                ],
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
                  horizontal: context.rw(0.062),
                  vertical: context.rh(0.04),
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/plant-filled-icon.svg',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: context.rh(0.02)),
                    Text(
                      l10n.plantEmptyTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.label(
                        context,
                        size: context.sp(12),
                        weight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: context.rh(0.008)),
                    Text(
                      l10n.plantEmptyMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption(context, size: context.sp(12)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.rh(0.025)),
              GestureDetector(
                onTap: actionEnabled ? onAddPlant : null,
                child: Container(
                  width: double.infinity,
                  height: context.rh(0.075).clamp(52.0, 64.0),
                  decoration: BoxDecoration(
                    color: actionEnabled
                        ? colorScheme.surface
                        : colorScheme.surface.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Center(
                    child: Text(
                      l10n.plantAddFirst,
                      style: AppTextStyles.sectionTitle(
                        context,
                        context.sp(18),
                      ).copyWith(
                        color: actionEnabled
                            ? AppColors.textPrimary
                            : AppColors.textPrimary.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
