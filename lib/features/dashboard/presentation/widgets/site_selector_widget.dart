import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../site/domain/entities/site.dart';

class SiteSelectorWidget extends StatelessWidget {
  final List<Site> sites;
  final Site? selectedSite;
  final ValueChanged<Site> onSiteSelected;
  final VoidCallback? onOpenDetail;
  final bool canSelectSite;

  const SiteSelectorWidget({
    super.key,
    required this.sites,
    required this.selectedSite,
    required this.onSiteSelected,
    this.onOpenDetail,
    this.canSelectSite = true,
  });

  void _showSiteSheet(BuildContext context) {
    if (!canSelectSite) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  context.l10n.siteSelect,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: MediaQuery.sizeOf(ctx).width / 390 * 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (sites.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(context.l10n.siteNoSitesAvailable),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sites.length,
                  itemBuilder: (_, i) {
                    final site = sites[i];
                    final isSelected = selectedSite?.siteId == site.siteId;
                    return ListTile(
                      onTap: () {
                        onSiteSelected(site);
                        Navigator.pop(ctx);
                      },
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        site.siteName ?? site.siteId,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: site.siteAddress != null
                          ? Text(
                              site.siteAddress!,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: AppColors.textTertiary,
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final siteName =
        selectedSite?.siteName ??
        selectedSite?.siteId ??
        context.l10n.siteSelect;
    final siteAddress = selectedSite?.siteAddress;

    return Container(
      width: double.infinity,
      height: context.rh(0.14).clamp(100.0, 120.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/maps-image.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.92),
                      Colors.white.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: selectedSite == null ? null : onOpenDetail,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              right: canSelectSite ? 112 : 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    siteName,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(22),
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (siteAddress != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      siteAddress,
                      style: AppTextStyles.hint(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (canSelectSite)
              Positioned(
                right: 12,
                top: 12,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showSiteSheet(context),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      context.l10n.siteSelect,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(11),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 12,
              bottom: 12,
              child: SvgPicture.asset(
                'assets/icons/maps-dot-outline-icon.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
