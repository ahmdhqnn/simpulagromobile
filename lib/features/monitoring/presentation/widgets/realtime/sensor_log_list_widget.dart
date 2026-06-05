import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../data/models/monitoring_models.dart';

class SensorLogListWidget extends StatefulWidget {
  final List<LogModel> logs;
  const SensorLogListWidget({super.key, required this.logs});

  @override
  State<SensorLogListWidget> createState() => _SensorLogListWidgetState();
}

class _SensorLogListWidgetState extends State<SensorLogListWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final logs = widget.logs;
    final displayCount = _expanded
        ? logs.length
        : (logs.length > 3 ? 3 : logs.length);

    return AppCardWidget.elevated(
      radius: AppRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: displayCount,
            separatorBuilder: (_, __) => Divider(
              height: 12,
              color: AppColors.textPrimary.withValues(alpha: 0.07),
            ),
            itemBuilder: (context, i) => _LogRow(log: logs[i]),
          ),
          if (logs.length > 3)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.center,
                child: Text(
                  _expanded ? 'Tutup Log' : 'Lihat Semua Log (${logs.length})',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  final LogModel log;
  const _LogRow({required this.log});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.rw(0.025)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.logRxPayload ?? '-',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(11),
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (log.logRxDate != null) ...[
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm:ss').format(log.logRxDate!),
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(9),
                    color: AppColors.textPrimary.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
