import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_input_form.dart';

/// Screen wrapper untuk form tambah/edit tanaman.
///
/// Mode create : [plantId] == null
/// Mode edit   : [plantId] != null → load data dulu via [plantDetailProvider]
class PlantFormScreen extends ConsumerWidget {
  final String? plantId;

  const PlantFormScreen({super.key, this.plantId});

  bool get _isEditMode => plantId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);

    if (siteId == null) {
      return const Scaffold(
        body: Center(child: Text('Pilih lokasi terlebih dahulu')),
      );
    }

    // ── Mode create ──────────────────────────────────────────────────────────
    if (!_isEditMode) {
      return PlantInputForm(
        siteId: siteId,
        onCancel: () => context.pop(),
        onSuccess: () {
          // plantsProvider sudah di-invalidate di dalam CreatePlantNotifier
          context.pop();
        },
      );
    }

    // ── Mode edit — load data terlebih dahulu ────────────────────────────────
    final plantAsync = ref.watch(plantDetailProvider(plantId!));

    return plantAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFF0F0F0),
        body: Center(
          child: DetailScreenSkeleton(
            infoRowCount: 3,
            hasDescription: false,
            headerHeight: 120,
          ),
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: _EditLoadError(
          error: error.toString(),
          onRetry: () => ref.invalidate(plantDetailProvider(plantId!)),
        ),
      ),
      data: (plant) => PlantInputForm(
        siteId: siteId,
        initialPlant: plant,
        onCancel: () => context.pop(),
        onSuccess: () {
          // plantsProvider & plantDetailProvider sudah di-invalidate
          // di dalam UpdatePlantNotifier — cukup pop
          context.pop();
        },
      ),
    );
  }
}

// ─── Error state saat load data edit ─────────────────────────────────────────

class _EditLoadError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _EditLoadError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data tanaman',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Kembali'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
