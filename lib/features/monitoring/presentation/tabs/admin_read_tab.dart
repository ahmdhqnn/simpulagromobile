import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
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
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: InfoStateWidget.icon(
            icon: Icons.lock_outline_rounded,
            message: context.l10n.monitoringAdminOnlyMessage,
            height: 120,
          ),
        ),
      );
    }

    if (siteId == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: InfoStateWidget.icon(
            icon: Icons.agriculture_outlined,
            message: context.l10n.siteSelectFirst,
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
            boxShadow: null,
            radius: AppRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MonitoringCardHeaderWidget.icon(
                  icon: Icons.edit_note_rounded,
                  title: context.l10n.monitoringReadCorrectionTitle,
                  description: context.l10n.monitoringReadCorrectionDescription,
                  background: AppColors.softBlue,
                  tint: AppColors.info,
                ),
                const SizedBox(height: 16),
                 TextField(
                  controller: _readIdController,
                  enabled: !isSavingCorrection,
                  decoration: InputDecoration(
                    labelText: context.l10n.monitoringReadIdLabel,
                    prefixIcon: const Icon(Icons.key_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _readValueController,
                  enabled: !isSavingCorrection,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.monitoringReadValueLabel,
                    prefixIcon: const Icon(Icons.speed_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _readStsController,
                  enabled: !isSavingCorrection,
                  decoration: InputDecoration(
                    labelText: context.l10n.monitoringReadStsLabel,
                    prefixIcon: const Icon(Icons.flag_rounded),
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
                    isSavingCorrection
                        ? context.l10n.monitoringSaving
                        : context.l10n.monitoringSaveCorrection,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AppCardWidget.elevated(
            boxShadow: null,
            radius: AppRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MonitoringCardHeaderWidget.icon(
                  icon: Icons.event_repeat_rounded,
                  title: context.l10n.monitoringGenerateDailyRecapTitle,
                  description:
                      context.l10n.monitoringGenerateDailyRecapDescription,
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
                    isTriggeringRekap
                        ? context.l10n.monitoringProcessing
                        : context.l10n.monitoringGenerateRecap,
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
    final l10n = context.l10n;
    final readId = _readIdController.text.trim();
    if (readId.isEmpty) {
      _showSnackBar(l10n.monitoringReadIdRequired);
      return;
    }

    final valueText = _readValueController.text.trim();
    final value = valueText.isEmpty
        ? null
        : double.tryParse(valueText.replaceAll(',', '.'));
    if (valueText.isNotEmpty && value == null) {
      _showSnackBar(l10n.monitoringReadValueMustBeNumber);
      return;
    }

    final sts = _readStsController.text.trim();
    if (value == null && sts.isEmpty) {
      _showSnackBar(l10n.monitoringReadValueOrStatusRequired);
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
    _showSnackBar(
      ok ? l10n.monitoringReadUpdated : l10n.monitoringReadUpdateFailed,
    );
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
    final l10n = context.l10n;
    final day = DateFormat('yyyy-MM-dd').format(_rekapDay);
    final ok = await ref
        .read(dailyRekapTriggerProvider.notifier)
        .trigger(siteId, day);
    if (!mounted) return;
    _showSnackBar(
      ok
          ? l10n.monitoringDailyRecapTriggered(day)
          : l10n.monitoringDailyRecapTriggerFailed,
    );
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
