import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../providers/monitoring_provider.dart';
import '../utils/sensor_metadata_adapter.dart';
import '../widgets/history/history_chart_widget.dart';
import '../widgets/history/history_data_table_widget.dart';
import '../widgets/history/history_filter_widget.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(historyReadsProvider);
    final selectedParam = ref.watch(selectedSensorParamProvider);
    final metadataAdapter = ref.watch(sensorMetadataAdapterProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(historyReadsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          0,
          context.rw(0.051),
          bottomNavigationContentSpace(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HistoryFilterWidget(),
            SizedBox(height: context.rh(0.024)),

            SectionHeaderWidget(title: l10n.monitoringHistoryChartSection),
            SizedBox(height: context.rh(0.014)),

            historyAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () =>
                  const ChartCardSkeleton(chartHeight: 220, hasSelector: false),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(historyReadsProvider),
              ),
              data: (reads) {
                final params =
                    reads
                        .map((r) => r.dsId ?? '')
                        .where((s) => s.isNotEmpty)
                        .toSet()
                        .toList()
                      ..sort();
                final param =
                    selectedParam != null && params.contains(selectedParam)
                    ? selectedParam
                    : (params.isNotEmpty ? params.first : null);
                if (param == null || reads.isEmpty) {
                  return InfoStateWidget.icon(
                    icon: Icons.show_chart_rounded,
                    message: l10n.monitoringEmptyHistory,
                    height: 195,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (params.length > 1)
                      _buildParamSelector(
                        context,
                        ref,
                        params,
                        param,
                        metadataAdapter,
                      ),
                    Builder(
                      builder: (_) {
                        final filtered =
                            reads.where((r) => r.dsId == param).toList()..sort(
                              (a, b) => (a.readDate ?? DateTime(0)).compareTo(
                                b.readDate ?? DateTime(0),
                              ),
                            );
                        return HistoryChartWidget(
                          reads: filtered,
                          param: param,
                          metadataAdapter: metadataAdapter,
                        );
                      },
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: context.rh(0.024)),

            // Data Table
            historyAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const KeyValueRowsCardSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
              data: (reads) {
                if (reads.isEmpty) {
                  return const SizedBox.shrink();
                }
                final params =
                    reads
                        .map((r) => r.dsId ?? '')
                        .where((s) => s.isNotEmpty)
                        .toSet()
                        .toList()
                      ..sort();
                final param =
                    selectedParam != null && params.contains(selectedParam)
                    ? selectedParam
                    : (params.isNotEmpty ? params.first : null);
                if (param == null) {
                  return InfoStateWidget.icon(
                    icon: Icons.table_chart_outlined,
                    message: 'Parameter sensor tidak tersedia pada data raw',
                    height: 60,
                  );
                }
                final filtered = reads.where((r) => r.dsId == param).toList()
                  ..sort(
                    (a, b) => (b.readDate ?? DateTime(0)).compareTo(
                      a.readDate ?? DateTime(0),
                    ),
                  );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeaderWidget(
                      title: l10n.monitoringHistoryDataSection,
                    ),
                    SizedBox(height: context.rh(0.014)),
                    HistoryDataTableWidget(
                      reads: filtered.take(50).toList(),
                      metadataAdapter: metadataAdapter,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParamSelector(
    BuildContext context,
    WidgetRef ref,
    List<String> params,
    String selected,
    SensorMetadataAdapter metadataAdapter,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: params.map((p) {
          final isSel = p == selected;
          final c = metadataAdapter.colorFor(p);
          return GestureDetector(
            onTap: () =>
                ref.read(selectedSensorParamProvider.notifier).state = p,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSel ? c : c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSel
                    ? [
                        BoxShadow(
                          color: c.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                metadataAdapter.shortLabelFor(p),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(11),
                  fontWeight: FontWeight.w600,
                  color: isSel ? Colors.white : c,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
