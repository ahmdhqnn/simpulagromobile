import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../phase/domain/entities/phase.dart';
import '../../domain/entities/plant.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/localized_labels.dart';

String phaseSiteIdForPlant(Plant plant, {String? fallbackSiteId}) {
  final siteId = plant.siteId?.trim();
  if (siteId != null && siteId.isNotEmpty) return siteId;
  final fallback = fallbackSiteId?.trim();
  if (fallback != null && fallback.isNotEmpty) return fallback;
  return plant.plantId.trim();
}

String phaseNameOrDash(Phase? phase) {
  final name = phase?.phaseName.trim();
  if (name == null || name.isEmpty) return '-';
  return name;
}

String phaseLabelFromAsync(AsyncValue<Phase?>? phaseAsync) {
  if (phaseAsync == null) return '-';

  return phaseAsync.when(
    skipLoadingOnReload: true,
    skipLoadingOnRefresh: true,
    skipError: true,
    data: phaseNameOrDash,
    loading: () => '-',
    error: (_, __) => '-',
  );
}

String phaseLabelForPlant(
  Plant plant,
  AsyncValue<Phase?>? phaseAsync,
  AppLocalizations l10n,
) {
  if (plant.isHarvested) return plant.localizedStatus(l10n);
  if (!plant.isCurrentPlanting) return '-';
  return phaseLabelFromAsync(phaseAsync);
}
