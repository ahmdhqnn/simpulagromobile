import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/recommendation_provider.dart';

class RecommendationLabTab extends ConsumerStatefulWidget {
  const RecommendationLabTab({super.key});

  @override
  ConsumerState<RecommendationLabTab> createState() =>
      _RecommendationLabTabState();
}

class _RecommendationLabTabState extends ConsumerState<RecommendationLabTab> {
  String _phase = 'Fase Bibit';
  final _nitro = TextEditingController(text: '50');
  final _phos = TextEditingController(text: '10');
  final _pot = TextEditingController(text: '95');
  bool _loading = false;
  Map<String, dynamic>? _previewData;

  static const _phases = [
    'Perkecambahan',
    'Fase Bibit',
    'Fase Anakan (Tillering)',
    'Perpanjangan Batang',
    'Bunting (Booting)',
    'Berbunga (Heading)',
    'Pengisian Biji',
    'Pemasakan',
  ];

  @override
  void dispose() {
    _nitro.dispose();
    _phos.dispose();
    _pot.dispose();
    super.dispose();
  }

  Map<String, dynamic> _payload(String siteId) => {
        'phase': _phase,
        'sensorData': {
          'soil_nitro': double.parse(_nitro.text),
          'soil_phos': double.parse(_phos.text),
          'soil_pot': double.parse(_pot.text),
        },
        'siteId': siteId,
      };

  Future<void> _runPreview() async {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId == null) return;
    setState(() => _loading = true);
    try {
      final ds = ref.read(recommendationDatasourceProvider);
      final data = await ds.previewDummyRecommendation(
        siteId,
        {'phase': _phase, 'sensorData': _payload(siteId)['sensorData']},
      );
      setState(() => _previewData = data);
    } catch (e) {
      setState(() => _previewData = {'error': e.toString()});
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId == null) return;
    setState(() => _loading = true);
    try {
      final ds = ref.read(recommendationDatasourceProvider);
      await ds.saveDummyRecommendation(siteId, _payload(siteId));
      ref.invalidate(recommendationListProvider);
      ref.invalidate(recommendationHistoryProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rekomendasi dummy tersimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
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
            '[TEST] Rekomendasi dummy — admin only',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _phase,
            decoration: const InputDecoration(
              labelText: 'phase',
              border: OutlineInputBorder(),
            ),
            items: _phases
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) => setState(() => _phase = v ?? _phase),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nitro,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'soil_nitro',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phos,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'soil_phos',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pot,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'soil_pot',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _loading ? null : _runPreview,
                  child: const Text('Preview'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _loading ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
          if (_previewData != null) ...[
            const SizedBox(height: 16),
            Text(
              _previewData.toString(),
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ],
        ],
      ),
    );
  }
}
