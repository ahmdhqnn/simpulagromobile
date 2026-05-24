import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/analytics/monthly_trend_card_widget.dart';

class MonthlyRecapTab extends ConsumerWidget {
  const MonthlyRecapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyReadsProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(monthlyReadsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.015),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeaderWidget(title: 'Rekap Bulanan'),
            SizedBox(height: context.rh(0.014)),
            monthlyAsync.when(
              data: (items) => MonthlyTrendCardWidget(data: items),
              loading: () => const LoadingCardWidget(height: 200),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(monthlyReadsProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
