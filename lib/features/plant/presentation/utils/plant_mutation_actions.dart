import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_provider.dart';

/// Aksi panen/hapus tanaman terpusat — hindari duplikasi di screen/widget.
class PlantMutationActions {
  PlantMutationActions._();

  static String? _resolveSiteId(Plant plant, WidgetRef ref) {
    final fromPlant = plant.siteId?.trim();
    if (fromPlant != null && fromPlant.isNotEmpty) return fromPlant;
    return ref.read(selectedSiteIdProvider);
  }

  static void _invalidatePhaseCache(WidgetRef ref, String siteId) {
    ref.invalidate(currentPhaseProvider(siteId));
    ref.invalidate(phaseListProvider(siteId));
    ref.invalidate(phaseHistoryProvider(siteId));
    ref.invalidate(phaseStatsProvider(siteId));
    ref.invalidate(phasesForSelectedSiteProvider);
  }

  static Future<void> confirmAndHarvest(
    BuildContext context,
    WidgetRef ref, {
    required Plant plant,
    bool popOnSuccess = false,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showConfirmationDialog(
      context,
      title: l10n.plantHarvestDialogTitle,
      message: l10n.plantHarvestDialogMessage(plant.displayName),
      confirmText: l10n.plantHarvestConfirm,
      confirmColor: AppColors.warning,
    );
    if (!confirmed || !context.mounted) return;

    final siteId = _resolveSiteId(plant, ref);
    if (siteId == null) {
      SnackbarHelper.showError(context, l10n.plantInvalidSite);
      return;
    }

    final result = await ref
        .read(harvestPlantProvider.notifier)
        .harvest(siteId: siteId, plantId: plant.plantId);
    if (!context.mounted) return;

    if (result.success) {
      _invalidatePhaseCache(ref, siteId);
      SnackbarHelper.showSuccess(
        context,
        l10n.plantHarvestSuccess(plant.displayName),
      );
      if (popOnSuccess) context.pop();
    } else {
      SnackbarHelper.showError(
        context,
        result.errorMessage ?? l10n.plantHarvestFailed,
      );
    }
  }

  static Future<void> confirmAndDelete(
    BuildContext context,
    WidgetRef ref, {
    required Plant plant,
    bool popOnSuccess = false,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDeleteConfirmationDialog(
      context,
      itemName: l10n.plantTitle,
      additionalMessage: l10n.plantDeleteDialogMessage(plant.displayName),
    );
    if (!confirmed || !context.mounted) return;

    final siteId = _resolveSiteId(plant, ref);
    if (siteId == null) {
      SnackbarHelper.showError(context, l10n.plantInvalidSite);
      return;
    }

    final result = await ref
        .read(deletePlantProvider.notifier)
        .delete(siteId: siteId, plantId: plant.plantId);
    if (!context.mounted) return;

    if (result.success) {
      _invalidatePhaseCache(ref, siteId);
      SnackbarHelper.showSuccess(
        context,
        l10n.plantDeleteSuccess(plant.displayName),
      );
      if (popOnSuccess) context.pop();
    } else {
      SnackbarHelper.showError(
        context,
        result.errorMessage ?? l10n.plantDeleteFailed,
      );
    }
  }
}
