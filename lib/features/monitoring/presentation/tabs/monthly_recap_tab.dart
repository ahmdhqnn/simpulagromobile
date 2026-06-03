import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../providers/monitoring_provider.dart';
import '../widgets/analytics/monthly_trend_card_widget.dart';

class MonthlyRecapTab extends ConsumerWidget {
  const MonthlyRecapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final monthlyAsync = ref.watch(monthlyReadsProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(monthlyReadsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          0,
          context.rw(0.051),
          context.rh(0.015),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeaderWidget(title: l10n.monitoringMonthlyRecapSection),
            SizedBox(height: context.rh(0.014)),
            monthlyAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              data: (items) => MonthlyTrendCardWidget(
                data: items,
                metadataAdapter: metadataAdapter,
              ),
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
