import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/providers/app_providers.dart';
import 'package:simpulagromobile/features/monitoring/data/models/monitoring_models.dart';
import 'package:simpulagromobile/features/monitoring/domain/repositories/monitoring_repository.dart';
import 'package:simpulagromobile/features/monitoring/presentation/providers/monitoring_provider.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';

class _MockMonitoringRepository extends Mock implements MonitoringRepository {}

void main() {
  group('Monitoring providers', () {
    test(
      'latestReadsProvider returns empty list when no site is selected',
      () async {
        final repository = _MockMonitoringRepository();
        final container = ProviderContainer(
          overrides: [
            monitoringRepositoryProvider.overrideWithValue(repository),
            selectedSiteIdProvider.overrideWith((_) => null),
          ],
        );
        addTearDown(container.dispose);

        final result = await container.read(latestReadsProvider.future);
        expect(result, isEmpty);
        verifyNever(() => repository.getLatestReads(any()));
      },
    );

    test(
      'latestReadsProvider fetches data and updates monitoringLastUpdated',
      () async {
        final repository = _MockMonitoringRepository();
        when(() => repository.getLatestReads('SITE_1')).thenAnswer(
          (_) async => const Right([
            SensorReadUpdate(
              readUpdateId: 'READ_1',
              dsId: 'env_temp',
              devId: 'DEV_1',
              readUpdateValue: '28.4',
            ),
          ]),
        );

        final container = ProviderContainer(
          overrides: [
            monitoringRepositoryProvider.overrideWithValue(repository),
            selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(monitoringLastUpdatedProvider), isNull);

        final result = await container.read(latestReadsProvider.future);
        expect(result, hasLength(1));
        expect(container.read(monitoringLastUpdatedProvider), isNotNull);
        verify(() => repository.getLatestReads('SITE_1')).called(1);
      },
    );

    test('historyReadsProvider bounds date range to maximum 31 days', () async {
      final repository = _MockMonitoringRepository();
      when(
        () => repository.getDateRangeReads(
          'SITE_1',
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => const Right(<SensorReadModel>[]));

      final container = ProviderContainer(
        overrides: [
          monitoringRepositoryProvider.overrideWithValue(repository),
          selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
        ],
      );
      addTearDown(container.dispose);

      container.read(historyFilterProvider.notifier).state =
          HistoryFilter.dateRange;
      container.read(historyStartDateProvider.notifier).state = DateTime(
        2026,
        3,
        1,
      );
      container.read(historyEndDateProvider.notifier).state = DateTime(
        2026,
        5,
        20,
      );

      await container.read(historyReadsProvider.future);

      final captured = verify(
        () => repository.getDateRangeReads(
          'SITE_1',
          startDate: captureAny(named: 'startDate'),
          endDate: captureAny(named: 'endDate'),
        ),
      ).captured;

      expect(captured[0], '2026-04-19');
      expect(captured[1], '2026-05-20');
    });

    test('monitoringSyncStatusProvider marks stale data correctly', () {
      final now = DateTime.now();
      final staleTime = now.subtract(const Duration(seconds: 70));

      final container = ProviderContainer(
        overrides: [
          monitoringLastUpdatedProvider.overrideWith((_) => staleTime),
          appAutoRefreshEnabledProvider.overrideWith((_) => true),
          appRealtimeRefreshIntervalProvider.overrideWith(
            (_) => const Duration(seconds: 30),
          ),
        ],
      );
      addTearDown(container.dispose);

      final status = container.read(monitoringSyncStatusProvider);
      expect(status.isStale, isTrue);
      expect(status.lastUpdated, staleTime);
    });

    test(
      'deviceSensorThresholdValuesProvider fetches threshold metadata',
      () async {
        final repository = _MockMonitoringRepository();
        when(
          () => repository.getDeviceSensorThresholdValues('SITE_1'),
        ).thenAnswer(
          (_) async => const Right([
            DeviceSensorThresholdModel(
              dsId: 'soil_ph',
              devId: 'DEV_1',
              dsMinNormValue: 5.5,
              dsMaxNormValue: 7.0,
            ),
          ]),
        );

        final container = ProviderContainer(
          overrides: [
            monitoringRepositoryProvider.overrideWithValue(repository),
            selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
          ],
        );
        addTearDown(container.dispose);

        final rows = await container.read(
          deviceSensorThresholdValuesProvider.future,
        );
        expect(rows, hasLength(1));
        expect(rows.first.dsId, 'soil_ph');
        verify(
          () => repository.getDeviceSensorThresholdValues('SITE_1'),
        ).called(1);
      },
    );
  });
}
