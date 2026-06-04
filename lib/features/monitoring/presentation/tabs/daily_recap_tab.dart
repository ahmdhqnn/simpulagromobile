import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/bottom_navigation_spacing.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class DailyRecapTab extends ConsumerWidget {
  const DailyRecapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final siteId = ref.watch(selectedSiteIdProvider);
    if (siteId == null) {
      return Center(child: Text(l10n.monitoringSelectSiteFirst));
    }

    final todayAsync = ref.watch(dailyTodayProvider);
    final byDayAsync = ref.watch(dailyByDayProvider);
    final selectedDay = ref.watch(dailyByDayDateProvider);
    final fmt = context.dateFormat('dd MMM yyyy');

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(dailyTodayProvider);
        ref.invalidate(dailyByDayProvider);
      },
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
            SectionHeaderWidget(title: l10n.monitoringDailyTodaySection),
            SizedBox(height: context.rh(0.014)),
            todayAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              data: (items) => _DailyTable(items: items),
              loading: () => const LoadingCardWidget(height: 120),
              error: (e, _) => ErrorStateCardWidget(
                message: toUiErrorMessage(e),
                onRetry: () => ref.invalidate(dailyTodayProvider),
              ),
            ),
            SizedBox(height: context.rh(0.024)),
            SectionHeaderWidget(title: l10n.monitoringDailyByDateSection),
            SizedBox(height: context.rh(0.01)),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDay,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  ref.read(dailyByDayDateProvider.notifier).state = picked;
                }
              },
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(fmt.format(selectedDay)),
            ),
            SizedBox(height: context.rh(0.014)),
            byDayAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              skipError: true,
              data: (items) => _DailyTable(items: items),
              loading: () => const LoadingCardWidget(height: 120),
              error: (e, _) => ErrorStateCardWidget(
                message: toUiErrorMessage(e),
                onRetry: () => ref.invalidate(dailyByDayProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyTable extends StatelessWidget {
  final List<SensorDailyModel> items;

  const _DailyTable({required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (items.isEmpty) {
      return InfoStateWidget.icon(
        icon: Icons.table_chart_outlined,
        message: l10n.monitoringDailyNoRecap,
        height: 100,
      );
    }

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(l10n.commonDateLabel)),
            DataColumn(label: Text('ds_id')),
            DataColumn(label: Text('dev_id')),
            DataColumn(label: Text(l10n.commonMin)),
            DataColumn(label: Text(l10n.commonMax)),
            DataColumn(label: Text(l10n.commonAverage)),
          ],
          rows: items.map((r) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    r.day != null
                        ? context.dateFormat('yyyy-MM-dd').format(r.day!)
                        : '-',
                  ),
                ),
                DataCell(Text(r.dsId)),
                DataCell(Text(r.devId)),
                DataCell(Text(r.minVal?.toStringAsFixed(2) ?? '-')),
                DataCell(Text(r.maxVal?.toStringAsFixed(2) ?? '-')),
                DataCell(Text(r.avgVal?.toStringAsFixed(2) ?? '-')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
