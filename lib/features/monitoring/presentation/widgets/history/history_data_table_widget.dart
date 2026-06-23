import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/locale_formatters.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/app_card_widget.dart';
import '../../../../../shared/widgets/info_state_widget.dart';
import '../../../data/models/monitoring_models.dart';
import '../../utils/sensor_metadata_adapter.dart';

class HistoryDataTableWidget extends StatefulWidget {
  final List<SensorReadModel> reads;
  final SensorMetadataAdapter metadataAdapter;
  const HistoryDataTableWidget({
    super.key,
    required this.reads,
    required this.metadataAdapter,
  });

  @override
  State<HistoryDataTableWidget> createState() => _HistoryDataTableWidgetState();
}

class _HistoryDataTableWidgetState extends State<HistoryDataTableWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reads.isEmpty) {
      return InfoStateWidget.icon(
        icon: Icons.table_chart_outlined,
        message: context.l10n.commonNoData,
        height: 80,
      );
    }

    final displayCount = _expanded
        ? widget.reads.length
        : (widget.reads.length > 5 ? 5 : widget.reads.length);

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
              height: 1,
              color: AppColors.textPrimary.withValues(alpha: 0.1),
            ),
            itemBuilder: (context, i) {
              final r = widget.reads[i];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: context.rh(0.008)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.readDate != null
                          ? context
                                .dateFormat('dd/MM HH:mm')
                                .format(r.readDate!)
                          : '-',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(11),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.metadataAdapter.displayValueWithUnit(
                        r.dsId ?? '',
                        r.readValue,
                        devId: r.devId,
                      ),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (widget.reads.length > 5) ...[
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
                        : context.l10n.monitoringShowAllCount(
                            widget.reads.length,
                          ),
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
