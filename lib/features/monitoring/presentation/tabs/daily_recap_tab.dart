import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class DailyRecapTab extends ConsumerWidget {
  const DailyRecapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteId = ref.watch(selectedSiteIdProvider);
    if (siteId == null) {
      return const Center(child: Text('Pilih site terlebih dahulu'));
    }

    final todayAsync = ref.watch(dailyTodayProvider);
    final byDayAsync = ref.watch(dailyByDayProvider);
    final selectedDay = ref.watch(dailyByDayDateProvider);
    final fmt = DateFormat('dd MMM yyyy');

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(dailyTodayProvider);
        ref.invalidate(dailyByDayProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.015),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeaderWidget(title: 'Rekap Hari Ini'),
            SizedBox(height: context.rh(0.014)),
            todayAsync.when(
              data: (items) => _DailyTable(items: items),
              loading: () => const LoadingCardWidget(height: 120),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(dailyTodayProvider),
              ),
            ),
            SizedBox(height: context.rh(0.024)),
            const SectionHeaderWidget(title: 'Rekap Per Tanggal'),
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
                  ref.invalidate(dailyByDayProvider);
                }
              },
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(fmt.format(selectedDay)),
            ),
            SizedBox(height: context.rh(0.014)),
            byDayAsync.when(
              data: (items) => _DailyTable(items: items),
              loading: () => const LoadingCardWidget(height: 120),
              error: (e, _) => ErrorStateCardWidget(
                message: e.toString(),
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
    if (items.isEmpty) {
      return const InfoStateWidget.icon(
        icon: Icons.table_chart_outlined,
        message: 'Tidak ada data rekap',
        height: 100,
      );
    }

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Hari')),
            DataColumn(label: Text('ds_id')),
            DataColumn(label: Text('dev_id')),
            DataColumn(label: Text('Min')),
            DataColumn(label: Text('Max')),
            DataColumn(label: Text('Avg')),
          ],
          rows: items.map((r) {
            return DataRow(
              cells: [
                DataCell(Text(
                  r.day != null
                      ? DateFormat('yyyy-MM-dd').format(r.day!)
                      : '-',
                )),
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
