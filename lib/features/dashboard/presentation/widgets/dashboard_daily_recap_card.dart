import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../monitoring/presentation/providers/monitoring_provider.dart';

class DashboardDailyRecapCard extends ConsumerWidget {
  const DashboardDailyRecapCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyTodayProvider);

    return dailyAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (items) {
        if (items.isEmpty) {
          return InfoStateWidget.icon(
            icon: Icons.today_outlined,
            message: context.l10n.dashboardNoDailyRecapToday,
            height: 72,
          );
        }
        final preview = items.take(4).toList();
        return Column(
          children: preview.map((r) {
            return Container(
              margin: EdgeInsets.only(bottom: context.rh(0.01)),
              padding: EdgeInsets.all(context.rw(0.035)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ds: ${r.dsId}',
                      style: AppTextStyles.label(
                        context,
                        size: 12,
                        weight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Text(
                    '${context.l10n.dashboardAverageLabel} ${r.avgVal?.toStringAsFixed(1) ?? '-'}',
                    style: AppTextStyles.label(
                      context,
                      size: 11,
                      color: AppColors.primary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => const CompactTextRowsSkeleton(rowCount: 4),
      error: (e, _) => InfoStateWidget.icon(
        icon: Icons.error_outline,
        message: toUiErrorMessage(e, context.l10n),
        height: 72,
      ),
    );
  }
}
