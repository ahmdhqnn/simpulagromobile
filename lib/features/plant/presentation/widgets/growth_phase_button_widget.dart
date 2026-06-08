import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

class GrowthPhaseButton extends StatelessWidget {
  final String siteId;
  final String plantName;

  const GrowthPhaseButton({
    super.key,
    required this.siteId,
    required this.plantName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => context.push(
        '/phases/${Uri.encodeComponent(siteId)}/${Uri.encodeComponent(plantName)}',
      ),
      child: Container(
        width: 160,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.phaseGrowthTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label(
                context,
                size: 12,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/icons/arrow-up-right-long-outline-icon.svg',
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
