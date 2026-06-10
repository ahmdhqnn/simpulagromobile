import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../site/domain/entities/site.dart';

class DashboardSiteCommandBanner extends StatelessWidget {
  final Site? site;

  const DashboardSiteCommandBanner({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    if (site == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.rw(0.04)),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: AppColors.warning),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.dashboardSelectSitePrompt,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(13),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.04)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            site!.displayName,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (site!.siteAddress != null) ...[
            const SizedBox(height: 4),
            Text(
              site!.siteAddress!,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            'ID: ${site!.siteId} · ${site!.isActive ? context.l10n.commonActive : context.l10n.commonInactive}',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(11),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
