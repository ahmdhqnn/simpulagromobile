import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../data/models/monitoring_models.dart';
import '../monitoring_card_header_widget.dart';

class AlarmSummaryCardWidget extends StatelessWidget {
  final List<AlarmDataModel> alarms;
  const AlarmSummaryCardWidget({super.key, required this.alarms});

  @override
  Widget build(BuildContext context) {
    if (alarms.isEmpty) return _buildNoAlarms(context);

    final recent = alarms.where((a) => a.isRecent).length;
    final total = alarms.length;

    return AppCardWidget.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, total),
          const SizedBox(height: 14),
          _buildCountRow(context, recent, total),
          if (alarms.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFEEEEEE), height: 1),
            const SizedBox(height: 10),
            Text(
              'Alarm Terbaru',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ...alarms.take(3).map((a) => _AlarmRow(alarm: a)),
          ],
        ],
      ),
    );
  }

  Widget _buildNoAlarms(BuildContext context) {
    return AppCardWidget.elevated(
      radius: AppRadius.lg,
      child: const MonitoringCardHeaderWidget.icon(
        icon: Icons.check_circle_outline_rounded,
        title: 'Tidak ada alarm aktif',
        description: 'Semua sensor berjalan normal',
        background: AppColors.softGreen,
        tint: AppColors.success,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int total) {
    return MonitoringCardHeaderWidget.icon(
      icon: Icons.notifications_outlined,
      title: 'Ringkasan Alarm',
      description: '$total total alarm tercatat',
      background: AppColors.softOrange,
      tint: AppColors.warning,
    );
  }

  Widget _buildCountRow(BuildContext context, int recent, int total) {
    return Row(
      children: [
        Expanded(
          child: _CountBox(
            value: '$recent',
            label: 'Alarm 24 Jam',
            color: const Color(0xFFFF9800),
            background: const Color(0xFFFFF3E0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CountBox(
            value: '$total',
            label: 'Total Alarm',
            color: AppColors.error,
            background: const Color(0xFFFBE9E7),
          ),
        ),
      ],
    );
  }
}

class _CountBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color background;

  const _CountBox({
    required this.value,
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(22),
              fontWeight: FontWeight.w700,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(10),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlarmRow extends StatelessWidget {
  final AlarmDataModel alarm;
  const _AlarmRow({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5, right: 10),
            decoration: BoxDecoration(
              color: alarm.isRecent
                  ? const Color(0xFFFF9800)
                  : AppColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              alarm.alcodeNote ?? 'Alarm terdeteksi',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(11),
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          if (alarm.almDate != null) ...[
            const SizedBox(width: 8),
            Text(
              DateFormat('d/M HH:mm').format(alarm.almDate!),
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(9),
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
