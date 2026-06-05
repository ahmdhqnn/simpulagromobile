import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../admin/presentation/providers/permission_guard_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/monitoring_card_header_widget.dart';

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
    final correctionState = ref.watch(readCorrectionProvider);
    final rekapState = ref.watch(dailyRekapTriggerProvider);
    final isSavingCorrection = correctionState.isLoading;
    final isTriggeringRekap = rekapState.isLoading;

    if (!isAdmin) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: InfoStateWidget.icon(
            icon: Icons.lock_outline_rounded,
            message: 'Tab admin hanya untuk pengguna dengan role admin.',
            height: 120,
          ),
        ),
      );
    }

    if (siteId == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: InfoStateWidget.icon(
            icon: Icons.agriculture_outlined,
            message: 'Pilih site terlebih dahulu',
            height: 120,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        context.rw(0.051),
        0,
        context.rw(0.051),
        bottomNavigationContentSpace(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCardWidget.elevated(
            radius: AppRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MonitoringCardHeaderWidget.icon(
                  icon: Icons.edit_note_rounded,
                  title: 'Koreksi Sensor Read',
                  description:
                      'Perbarui nilai atau status read pada site aktif',
                  background: AppColors.softBlue,
                  tint: AppColors.info,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _readIdController,
                  enabled: !isSavingCorrection,
                  decoration: const InputDecoration(
                    labelText: 'read_id',
                    prefixIcon: Icon(Icons.key_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _readValueController,
                  enabled: !isSavingCorrection,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'read_value (opsional)',
                    prefixIcon: Icon(Icons.speed_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _readStsController,
                  enabled: !isSavingCorrection,
                  decoration: const InputDecoration(
                    labelText: 'read_sts (opsional)',
                    prefixIcon: Icon(Icons.flag_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: isSavingCorrection
                      ? null
                      : () => _submitCorrection(siteId),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  icon: isSavingCorrection
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    isSavingCorrection ? 'Menyimpan...' : 'Simpan Koreksi',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AppCardWidget.elevated(
            radius: AppRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MonitoringCardHeaderWidget.icon(
                  icon: Icons.event_repeat_rounded,
                  title: 'Generate Rekap Harian',
                  description:
                      'Proses ulang agregasi sensor untuk tanggal dipilih',
                  background: AppColors.softGreen,
                  tint: AppColors.primary,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: isTriggeringRekap
                      ? null
                      : () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _rekapDay,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _rekapDay = picked);
                          }
                        },
                  icon: const Icon(Icons.calendar_today_rounded),
                  label: Text(DateFormat('yyyy-MM-dd').format(_rekapDay)),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: isTriggeringRekap
                      ? null
                      : () => _triggerRekap(siteId),
                  icon: isTriggeringRekap
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    isTriggeringRekap ? 'Memproses...' : 'Generate Rekap',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitCorrection(String siteId) async {
    final readId = _readIdController.text.trim();
    if (readId.isEmpty) {
      _showSnackBar('read_id wajib diisi');
      return;
    }

    final valueText = _readValueController.text.trim();
    final value = valueText.isEmpty
        ? null
        : double.tryParse(valueText.replaceAll(',', '.'));
    if (valueText.isNotEmpty && value == null) {
      _showSnackBar('read_value harus berupa angka');
      return;
    }

    final sts = _readStsController.text.trim();
    if (value == null && sts.isEmpty) {
      _showSnackBar('Isi read_value atau read_sts');
      return;
    }

    final ok = await ref
        .read(readCorrectionProvider.notifier)
        .updateRead(
          siteId,
          readId,
          readValue: value,
          readSts: sts.isEmpty ? null : sts,
        );
    if (!mounted) return;
    _showSnackBar(ok ? 'Read diperbarui' : 'Gagal memperbarui read');
    if (ok) {
      _readIdController.clear();
      _readValueController.clear();
      _readStsController.clear();
      ref.invalidate(latestReadsProvider);
      ref.invalidate(todayReadsProvider);
      ref.invalidate(historyReadsProvider);
    }
  }

  Future<void> _triggerRekap(String siteId) async {
    final day = DateFormat('yyyy-MM-dd').format(_rekapDay);
    final ok = await ref
        .read(dailyRekapTriggerProvider.notifier)
        .trigger(siteId, day);
    if (!mounted) return;
    _showSnackBar(ok ? 'Rekap diproses untuk $day' : 'Gagal trigger rekap');
    if (ok) {
      ref.invalidate(dailyTodayProvider);
      ref.invalidate(dailyByDayProvider);
      ref.invalidate(dailyReadsProvider);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
