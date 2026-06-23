import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/l10n.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCardWidget.elevated(
          boxShadow: null,
          radius: AppRadius.lg,
          padding: EdgeInsets.zero,
          child: ListView.separated(
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
        ),
        if (logs.length > 3) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _expanded
                        ? context.l10n.commonHide
                        : context.l10n.monitoringShowAllLogsCount(logs.length),
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
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
