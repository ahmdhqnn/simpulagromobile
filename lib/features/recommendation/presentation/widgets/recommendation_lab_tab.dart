import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recommendation_request.dart';
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

  RecommendationLabInput _input() => RecommendationLabInput(
    phase: _phase,
    soilNitro: double.tryParse(_nitro.text) ?? 0,
    soilPhos: double.tryParse(_phos.text) ?? 0,
    soilPot: double.tryParse(_pot.text) ?? 0,
  );

  Future<void> _runPreview() async {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId == null) return;
    await ref
        .read(recommendationLabProvider.notifier)
        .preview(siteId, _input());
  }

  Future<void> _save() async {
    final siteId = ref.read(selectedSiteIdProvider);
    if (siteId == null) return;
    final success = await ref
        .read(recommendationLabProvider.notifier)
        .save(siteId, _input());
    final state = ref.read(recommendationLabProvider);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? state.message ?? 'Rekomendasi tersimpan'
              : 'Gagal: ${state.error ?? 'Unknown error'}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final siteId = ref.watch(selectedSiteIdProvider);
    final state = ref.watch(recommendationLabProvider);
    final previewData = state.preview?.data;

    if (siteId == null) {
      return const Center(child: Text('Pilih site terlebih dahulu'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '[TEST] Rekomendasi dummy - admin only',
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
                .map(
                  (phase) => DropdownMenuItem(value: phase, child: Text(phase)),
                )
                .toList(),
            onChanged: (value) => setState(() => _phase = value ?? _phase),
          ),
          const SizedBox(height: 8),
          _numberField(_nitro, 'soil_nitro'),
          const SizedBox(height: 8),
          _numberField(_phos, 'soil_phos'),
          const SizedBox(height: 8),
          _numberField(_pot, 'soil_pot'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: state.isLoading ? null : _runPreview,
                  child: const Text('Preview'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: state.isLoading ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
          if (state.isLoading) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
          if (state.error != null) ...[
            const SizedBox(height: 16),
            Text(state.error!, style: const TextStyle(color: Colors.red)),
          ],
          if (previewData != null) ...[
            const SizedBox(height: 16),
            Text(
              previewData.toString(),
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _numberField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
