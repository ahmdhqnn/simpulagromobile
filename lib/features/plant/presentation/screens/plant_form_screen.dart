import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_input_form_widget.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';

class PlantFormScreen extends ConsumerWidget {
  final String? plantId;

  const PlantFormScreen({super.key, this.plantId});

  bool get _isEditMode => plantId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);

    if (siteId == null) {
      return AdminFormScaffold(
        title: AppLocalizations.of(context)!.plantAddTitle,
        body: AdminEmptyState(
          icon: Icons.location_off_outlined,
          title: AppLocalizations.of(context)!.emptySite,
          message: AppLocalizations.of(context)!.emptySite,
        ),
      );
    }

    if (!_isEditMode) {
      return PlantInputForm(
        siteId: siteId,
        onCancel: () => context.pop(),
        onSuccess: () => context.pop(),
      );
    }

    final plantAsync = ref.watch(plantDetailProvider(plantId!));

    return plantAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      loading: () => AdminFormScaffold(
        title: AppLocalizations.of(context)!.plantEditTitle,
        body: const AdminFormScreenSkeleton(
          titleWidth: 150,
          sectionFieldCounts: [4],
        ),
      ),
      error: (error, _) => AdminFormScaffold(
        title: AppLocalizations.of(context)!.plantEditTitle,
        body: AdminErrorState(
          error: error.toString(),
          onRetry: () => ref.invalidate(plantDetailProvider(plantId!)),
        ),
      ),
      data: (plant) => PlantInputForm(
        siteId: siteId,
        initialPlant: plant,
        onCancel: () => context.pop(),
        onSuccess: () => context.pop(),
      ),
    );
  }
}
