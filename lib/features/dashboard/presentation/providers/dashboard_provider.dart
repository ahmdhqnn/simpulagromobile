import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/models/environmental_health_model.dart';

final dashboardDataSourceProvider =
    Provider<DashboardRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dioClient.dio);
});

/// Environmental health for selected site
final environmentalHealthProvider =
    FutureProvider.autoDispose<EnvironmentalHealth?>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return null;
  final ds = ref.watch(dashboardDataSourceProvider);
  return ds.getEnvironmentalHealth(siteId);
});

/// Latest sensor reads for selected site
final latestSensorReadsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final ds = ref.watch(dashboardDataSourceProvider);
  return ds.getLatestSensorReads(siteId);
});

/// Seven day reads for chart
final sevenDayReadsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final siteId = ref.watch(selectedSiteIdProvider);
  if (siteId == null) return [];
  final ds = ref.watch(dashboardDataSourceProvider);
  return ds.getSevenDayReads(siteId);
});
