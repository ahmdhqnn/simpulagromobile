import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../phase/domain/entities/phase.dart';
import '../../domain/entities/plant.dart';

String phaseSiteIdForPlant(Plant plant) {
  final siteId = plant.siteId?.trim();
  if (siteId != null && siteId.isNotEmpty) return siteId;
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

String phaseLabelForPlant(Plant plant, AsyncValue<Phase?>? phaseAsync) {
  if (plant.isHarvested) return plant.statusText;
  if (!plant.isCurrentPlanting) return '-';
  return phaseLabelFromAsync(phaseAsync);
}
