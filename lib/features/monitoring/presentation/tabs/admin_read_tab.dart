import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../admin/presentation/providers/permission_guard_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/monitoring_provider.dart';

/// Admin: koreksi read + trigger rekap harian.
class AdminReadTab extends ConsumerStatefulWidget {
  const AdminReadTab({super.key});

  @override
  ConsumerState<AdminReadTab> createState() => _AdminReadTabState();
}

class _AdminReadTabState extends ConsumerState<AdminReadTab> {
  final _readIdController = TextEditingController();
  final _readValueController = TextEditingController();
  final _readStsController = TextEditingController();
  DateTime _rekapDay = DateTime.now();

  @override
  void dispose() {
    _readIdController.dispose();
    _readValueController.dispose();
    _readStsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    final siteId = ref.watch(selectedSiteIdProvider);

    if (!isAdmin) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Tab admin hanya untuk pengguna dengan role admin.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (siteId == null) {
      return const Center(child: Text('Pilih site terlebih dahulu'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeaderWidget(title: 'Koreksi Sensor Read'),
          const SizedBox(height: 12),
          TextField(
            controller: _readIdController,
            decoration: const InputDecoration(
              labelText: 'read_id',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _readValueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'read_value (opsional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _readStsController,
            decoration: const InputDecoration(
              labelText: 'read_sts (opsional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => _submitCorrection(siteId),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Simpan Koreksi'),
          ),
          const SizedBox(height: 32),
          const SectionHeaderWidget(title: 'Generate Rekap Harian'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _rekapDay,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _rekapDay = picked);
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(DateFormat('yyyy-MM-dd').format(_rekapDay)),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => _triggerRekap(siteId),
            child: const Text('POST /reads/daily/rekap'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitCorrection(String siteId) async {
    final readId = _readIdController.text.trim();
    if (readId.isEmpty) return;
    final value = double.tryParse(_readValueController.text.trim());
    final sts = _readStsController.text.trim();

    final ok = await ref.read(readCorrectionProvider.notifier).updateRead(
          siteId,
          readId,
          readValue: value,
          readSts: sts.isEmpty ? null : sts,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Read diperbarui' : 'Gagal memperbarui read')),
    );
    if (ok) {
      ref.invalidate(todayReadsProvider);
      ref.invalidate(historyReadsProvider);
    }
  }

  Future<void> _triggerRekap(String siteId) async {
    final day = DateFormat('yyyy-MM-dd').format(_rekapDay);
    final ok = await ref.read(dailyRekapTriggerProvider.notifier).trigger(
          siteId,
          day,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Rekap diproses untuk $day' : 'Gagal trigger rekap')),
    );
    if (ok) {
      ref.invalidate(dailyTodayProvider);
      ref.invalidate(dailyByDayProvider);
      ref.invalidate(dailyReadsProvider);
    }
  }
}
