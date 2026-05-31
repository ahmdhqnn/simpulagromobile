import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../monitoring/presentation/providers/monitoring_provider.dart';

/// Rekap harian hari ini dari GET /reads/daily/today
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
          return const InfoStateWidget.icon(
            icon: Icons.today_outlined,
            message: 'Belum ada rekap harian hari ini',
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ds: ${r.dsId}',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'avg ${r.avgVal?.toStringAsFixed(1) ?? '-'}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => const LoadingCardWidget(height: 80),
      error: (e, _) => InfoStateWidget.icon(
        icon: Icons.error_outline,
        message: e.toString(),
        height: 72,
      ),
    );
  }
}
