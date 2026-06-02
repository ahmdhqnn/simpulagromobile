import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recommendation_request.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/recommendation_provider.dart';

class PlantInputTab extends ConsumerStatefulWidget {
  const PlantInputTab({super.key});

  @override
  ConsumerState<PlantInputTab> createState() => _PlantInputTabState();
}

class _PlantInputTabState extends ConsumerState<PlantInputTab> {
  final _nitro = TextEditingController(text: '12');
  final _phos = TextEditingController(text: '8');
  final _pot = TextEditingController(text: '10');
  final _temp = TextEditingController(text: '30');
  final _hum = TextEditingController(text: '75');
  final _ph = TextEditingController(text: '6.4');

  @override
  void dispose() {
    _nitro.dispose();
    _phos.dispose();
    _pot.dispose();
    _temp.dispose();
    _hum.dispose();
    _ph.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId == null) return;

    await ref
        .read(plantRecommendationProvider.notifier)
        .submit(
          siteId,
          PlantRecommendationInput(
            soilNitro: double.tryParse(_nitro.text) ?? 0,
            soilPhos: double.tryParse(_phos.text) ?? 0,
            soilPot: double.tryParse(_pot.text) ?? 0,
            envTemp: double.tryParse(_temp.text) ?? 0,
            envHum: double.tryParse(_hum.text) ?? 0,
            soilPh: double.tryParse(_ph.text) ?? 0,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final state = ref.watch(plantRecommendationProvider);
    if (siteId == null) {
      return const Center(child: Text('Pilih site terlebih dahulu'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Input nilai sensor untuk rekomendasi tanaman',
            style: TextStyle(fontFamily: AppTextStyles.fontFamily),
          ),
          const SizedBox(height: 16),
          _field(_nitro, 'soil_nitro'),
          _field(_phos, 'soil_phos'),
          _field(_pot, 'soil_pot'),
          _field(_temp, 'env_temp'),
          _field(_hum, 'env_hum'),
          _field(_ph, 'soil_ph'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: state.isLoading ? null : _submit,
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('POST /recommendations/plant'),
          ),
          if (state.message != null || state.error != null) ...[
            const SizedBox(height: 12),
            Text(
              state.message ?? 'Error: ${state.error}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: state.error == null
                    ? null
                    : Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
