import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_input_form_widget.dart';

class PlantFormScreen extends ConsumerWidget {
  final String? plantId;

  const PlantFormScreen({super.key, this.plantId});

  bool get _isEditMode => plantId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);

    if (siteId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.rh(0.015)),
                CircularBackButtonWidget(onPressed: () => context.pop()),
                Expanded(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.emptySite,
                      style: AppTextStyles.caption(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_isEditMode) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: PlantInputForm(
            siteId: siteId,
            onCancel: () => context.pop(),
            onSuccess: () => context.pop(),
          ),
        ),
      );
    }

    final plantAsync = ref.watch(plantDetailProvider(plantId!));

    return plantAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.rh(0.015)),
                  CircularBackButtonWidget(onPressed: () => context.pop()),
                  SizedBox(height: context.rh(0.03)),
                  Text(
                    AppLocalizations.of(context)!.plantEditTitle,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  SizedBox(height: context.rh(0.03)),
                  const PlantFormCardSkeleton(),
                  SizedBox(height: context.rh(0.02)),
                ],
              ),
            ),
          ),
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.rh(0.015)),
                CircularBackButtonWidget(onPressed: () => context.pop()),
                Expanded(
                  child: _EditLoadError(
                    error: error.toString(),
                    onRetry: () =>
                        ref.invalidate(plantDetailProvider(plantId!)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (plant) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: PlantInputForm(
            siteId: siteId,
            initialPlant: plant,
            onCancel: () => context.pop(),
            onSuccess: () => context.pop(),
          ),
        ),
      ),
    );
  }
}

class _EditLoadError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _EditLoadError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.061)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: context.rw(0.123).clamp(44.0, 56.0),
              color: AppColors.error,
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              l10n.plantLoadFailed,
              style: AppTextStyles.cardTitle(context, context.sp(16)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error,
              style: AppTextStyles.caption(context, size: context.sp(13)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.rh(0.03)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    l10n.plantDetailCancel,
                    style: AppTextStyles.label(context, size: context.sp(14)),
                  ),
                ),
                SizedBox(width: context.rw(0.031)),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    l10n.retry,
                    style: AppTextStyles.label(
                      context,
                      size: context.sp(14),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
