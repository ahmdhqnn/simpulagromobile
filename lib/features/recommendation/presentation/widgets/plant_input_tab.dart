import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
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
  bool _loading = false;
  String? _result;

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

    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final ds = ref.read(recommendationDatasourceProvider);
      final models = await ds.postPlantRecommendation(siteId, {
        'soil_nitro': double.parse(_nitro.text),
        'soil_phos': double.parse(_phos.text),
        'soil_pot': double.parse(_pot.text),
        'env_temp': double.parse(_temp.text),
        'env_hum': double.parse(_hum.text),
        'soil_ph': double.parse(_ph.text),
      });
      ref.invalidate(recommendationListProvider);
      setState(() {
        _result = models.isEmpty
            ? 'Tidak ada rekomendasi dikembalikan'
            : '${models.length} rekomendasi dihasilkan';
      });
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final siteId = ref.watch(selectedSiteIdProvider);
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
            style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
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
            onPressed: _loading ? null : _submit,
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: _loading
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
          if (_result != null) ...[
            const SizedBox(height: 12),
            Text(_result!, textAlign: TextAlign.center),
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
