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
                _AdminFormField(
                  label: context.l10n.monitoringReadIdLabel,
                  example: 'Contoh: pakai read_id/log_rx_id dari tab Raw Reads',
                  child: _buildTextField(
                    context,
                    controller: _readIdController,
                    hintText: 'LOG_RX_001',
                    enabled: !isSavingCorrection,
                  ),
                ),
                const SizedBox(height: 10),
                _AdminFormField(
                  label: context.l10n.monitoringReadValueLabel,
                  example: 'Contoh: 27.5, gunakan titik untuk desimal',
                  child: _buildTextField(
                    context,
                    controller: _readValueController,
                    hintText: '27.5',
                    enabled: !isSavingCorrection,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _AdminFormField(
                  label: context.l10n.monitoringReadStsLabel,
                  example: 'Contoh: 1 atau 0, isi hanya jika status berubah',
                  child: _buildTextField(
                    context,
                    controller: _readStsController,
                    hintText: '1',
                    enabled: !isSavingCorrection,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            isLoading: isSavingCorrection,
            label: context.l10n.monitoringSaveCorrection,
            onPressed: () => _submitCorrection(siteId),
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
                _AdminFormField(
                  label: context.l10n.commonDateLabel,
                  example:
                      'Contoh: pilih tanggal data sensor yang diproses ulang',
                  child: _buildDatePickerField(
                    context,
                    enabled: !isTriggeringRekap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            isLoading: isTriggeringRekap,
            label: context.l10n.monitoringGenerateRecap,
            onPressed: () => _triggerRekap(siteId),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    bool enabled = true,
    String? hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: context.sp(14),
        color: AppColors.textPrimary,
      ),
      decoration: _fieldDecoration(
        context,
        enabled: enabled,
        hintText: hintText,
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context, {required bool enabled}) {
    final radius = BorderRadius.circular(AppRadius.pill);
    final iconColor = AppColors.textPrimary.withValues(
      alpha: enabled ? 0.56 : 0.32,
    );

    return Material(
      color: enabled
          ? AppColors.surfaceVariant
          : AppColors.textPrimary.withValues(alpha: 0.05),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: enabled
            ? () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _rekapDay,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _rekapDay = picked);
                }
              }
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.rw(0.041),
            vertical: context.rh(0.012),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('yyyy-MM-dd').format(_rekapDay),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(14),
                    weight: FontWeight.w400,
                  ).copyWith(height: 1),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.expand_more_rounded, size: 20, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required bool isLoading,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.22,
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required bool enabled,
    String? hintText,
  }) {
    final borderRadius = BorderRadius.circular(AppRadius.pill);

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.hint(context, size: context.sp(14)),
      filled: true,
      fillColor: enabled
          ? AppColors.surfaceVariant
          : AppColors.textPrimary.withValues(alpha: 0.05),
      hoverColor: Colors.transparent,
      border: _cleanInputBorder(borderRadius),
      enabledBorder: _cleanInputBorder(borderRadius),
      focusedBorder: _cleanInputBorder(borderRadius),
      disabledBorder: _cleanInputBorder(borderRadius),
      errorBorder: _cleanInputBorder(borderRadius),
      focusedErrorBorder: _cleanInputBorder(borderRadius),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.rw(0.041),
        vertical: context.rh(0.012),
      ),
    );
  }

  OutlineInputBorder _cleanInputBorder(BorderRadius borderRadius) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
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

class _AdminFormField extends StatelessWidget {
  final String label;
  final String? example;
  final Widget child;

  const _AdminFormField({
    required this.label,
    this.example,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label(
            context,
            size: context.sp(14),
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(height: context.rh(0.01)),
        child,
        if (example != null) ...[
          SizedBox(height: context.rh(0.006)),
          Text(
            example!,
            style: AppTextStyles.caption(
              context,
              size: context.sp(11),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
