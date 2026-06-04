import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/core/providers/app_providers.dart';
import 'package:simpulagromobile/features/plant/domain/entities/plant.dart';
import 'package:simpulagromobile/features/plant/domain/repositories/plant_repository.dart';
import 'package:simpulagromobile/features/plant/presentation/providers/plant_provider.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';

void main() {
  group('PlantsNotifier', () {
    test('refreshes silently from centralized realtime ticks', () async {
      final tickController = StreamController<int>();
      final repository = _TickDrivenPlantRepository();
      final container = ProviderContainer(
        overrides: [
          plantRepositoryProvider.overrideWithValue(repository),
          selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
          realtimeRefreshTickProvider.overrideWith(
            (_) => tickController.stream,
          ),
        ],
      );
      addTearDown(() async {
        await tickController.close();
        container.dispose();
      });

      final initial = await container.read(plantsProvider.future);
      expect(initial.single.plantId, 'PLANT_1');

      tickController.add(1);
      await _waitUntil(
        () =>
            container.read(plantsProvider).valueOrNull?.single.plantId ==
            'PLANT_2',
      );

      expect(repository.getPlantsCallCount, 2);
      expect(
        container.read(plantsProvider).valueOrNull?.single.plantId,
        'PLANT_2',
      );
    });

    test(
      'normalizes open lifecycle plants as active in plantsProvider',
      () async {
        final repository = _OpenLifecyclePlantRepository();
        final container = ProviderContainer(
          overrides: [
            plantRepositoryProvider.overrideWithValue(repository),
            selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
          ],
        );
        addTearDown(container.dispose);

        final plants = await container.read(plantsProvider.future);
        final activePlant = plants.firstWhere(
          (plant) => plant.plantId == 'ACTIVE',
        );
        final harvestedPlant = plants.firstWhere(
          (plant) => plant.plantId == 'HARVESTED',
        );

        expect(activePlant.plantSts, 1);
        expect(activePlant.isCurrentPlanting, isTrue);
        expect(harvestedPlant.isHarvested, isTrue);
        expect(harvestedPlant.isCurrentPlanting, isFalse);
        expect(
          container.read(plantScreenStateProvider),
          PlantScreenState.hasData,
        );
      },
    );
  });

  group('Active plant providers', () {
    test(
      'ongoingPlantProvider falls back to all plants when active query misses',
      () async {
        final repository = _OpenLifecyclePlantRepository();
        final container = ProviderContainer(
          overrides: [
            plantRepositoryProvider.overrideWithValue(repository),
            selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
          ],
        );
        addTearDown(container.dispose);

        final activePlant = await container.read(ongoingPlantProvider.future);

        expect(activePlant, isNotNull);
        expect(activePlant?.plantId, 'ACTIVE');
        expect(activePlant?.plantSts, 1);
        expect(activePlant?.isCurrentPlanting, isTrue);
        expect(repository.filteredCalls, 1);
        expect(repository.allCalls, 1);
        expect(container.read(currentPlantProvider)?.plantId, 'ACTIVE');
      },
    );

    test(
      'plantDetailProvider normalizes open lifecycle plant detail',
      () async {
        final repository = _OpenLifecyclePlantRepository();
        final container = ProviderContainer(
          overrides: [
            plantRepositoryProvider.overrideWithValue(repository),
            selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
          ],
        );
        addTearDown(container.dispose);

        final plant = await container.read(
          plantDetailProvider('ACTIVE').future,
        );

        expect(plant.plantId, 'ACTIVE');
        expect(plant.plantSts, 1);
        expect(plant.isCurrentPlanting, isTrue);
        expect(repository.detailCalls, 1);
      },
    );
  });
}

Future<void> _waitUntil(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 1),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('Condition was not met before timeout.');
}

class _TickDrivenPlantRepository implements PlantRepository {
  int getPlantsCallCount = 0;

  @override
  Future<Either<Failure, List<Plant>>> getPlants(
    String siteId, {
    bool? isOnGoingPlant,
  }) async {
    getPlantsCallCount++;
    return Right([
      Plant(
        plantId: getPlantsCallCount == 1 ? 'PLANT_1' : 'PLANT_2',
        siteId: siteId,
        plantName: 'Padi',
        plantType: CropType.PADI,
        plantSts: 1,
      ),
    ]);
  }

  @override
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId) =>
      Future.value(Left(NotFoundFailure('not found')));

  @override
  Future<Either<Failure, Plant>> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) => Future.value(Left(UnknownFailure('skip')));

  @override
  Future<Either<Failure, Plant>> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) => Future.value(Left(UnknownFailure('skip')));

  @override
  Future<Either<Failure, Plant>> harvestPlant(String siteId, String plantId) =>
      Future.value(Left(UnknownFailure('skip')));

  @override
  Future<Either<Failure, void>> deletePlant(String siteId, String plantId) =>
      Future.value(Left(UnknownFailure('skip')));
}

class _OpenLifecyclePlantRepository implements PlantRepository {
  int filteredCalls = 0;
  int allCalls = 0;
  int detailCalls = 0;

  @override
  Future<Either<Failure, List<Plant>>> getPlants(
    String siteId, {
    bool? isOnGoingPlant,
  }) async {
    if (isOnGoingPlant == true) {
      filteredCalls++;
      return const Right([]);
    }

    allCalls++;
    return Right([
      Plant(
        plantId: 'HARVESTED',
        siteId: siteId,
        plantName: 'Panen',
        plantType: CropType.PADI,
        plantSts: 1,
        plantHarvest: DateTime(2026, 5, 1),
      ),
      Plant(
        plantId: 'ACTIVE',
        siteId: siteId,
        plantName: 'Aktif',
        plantType: CropType.PADI,
        plantSts: 0,
        plantDate: DateTime(2026, 5, 20),
      ),
    ]);
  }

  @override
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId) {
    detailCalls++;
    return Future.value(
      Right(
        Plant(
          plantId: plantId,
          siteId: siteId,
          plantName: 'Aktif',
          plantType: CropType.PADI,
          plantSts: 0,
          plantDate: DateTime(2026, 5, 20),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Plant>> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) => Future.value(Left(UnknownFailure('skip')));

  @override
  Future<Either<Failure, Plant>> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) => Future.value(Left(UnknownFailure('skip')));

  @override
  Future<Either<Failure, Plant>> harvestPlant(String siteId, String plantId) =>
      Future.value(Left(UnknownFailure('skip')));

  @override
  Future<Either<Failure, void>> deletePlant(String siteId, String plantId) =>
      Future.value(Left(UnknownFailure('skip')));
}
