import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/plant/domain/entities/plant.dart';
import 'package:simpulagromobile/features/plant/domain/repositories/plant_repository.dart';
import 'package:simpulagromobile/features/plant/presentation/providers/plant_provider.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';

class _FakePlantRepository implements PlantRepository {
  bool harvestCalled = false;
  bool deleteCalled = false;

  @override
  Future<Either<Failure, Plant>> harvestPlant(
    String siteId,
    String plantId,
  ) async {
    harvestCalled = true;
    return Right(
      Plant(
        plantId: plantId,
        siteId: siteId,
        plantName: 'Padi',
        plantType: CropType.PADI,
        plantSts: 1,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deletePlant(
    String siteId,
    String plantId,
  ) async {
    deleteCalled = true;
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Plant>>> getPlants(
    String siteId, {
    bool? isOnGoingPlant,
  }) =>
      Future.value(const Right([]));

  @override
  Future<Either<Failure, Plant>> getPlantById(String siteId, String plantId) =>
      Future.value(Left(NotFoundFailure('not found')));

  @override
  Future<Either<Failure, Plant>> createPlant(
    String siteId,
    Map<String, dynamic> data,
  ) =>
      Future.value(Left(UnknownFailure('skip')));

  @override
  Future<Either<Failure, Plant>> updatePlant(
    String siteId,
    String plantId,
    Map<String, dynamic> data,
  ) =>
      Future.value(Left(UnknownFailure('skip')));
}

void main() {
  group('HarvestPlantNotifier', () {
    test('returns success and calls repository', () async {
      final repo = _FakePlantRepository();
      final container = ProviderContainer(
        overrides: [
          plantRepositoryProvider.overrideWithValue(repo),
          selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(harvestPlantProvider.notifier);
      final result = await notifier.harvest(
        siteId: 'SITE_1',
        plantId: 'PLANT_1',
      );

      expect(result.success, isTrue);
      expect(repo.harvestCalled, isTrue);
    });
  });

  group('DeletePlantNotifier', () {
    test('returns success and calls repository', () async {
      final repo = _FakePlantRepository();
      final container = ProviderContainer(
        overrides: [
          plantRepositoryProvider.overrideWithValue(repo),
          selectedSiteIdProvider.overrideWith((_) => 'SITE_1'),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(deletePlantProvider.notifier);
      final result = await notifier.delete(
        siteId: 'SITE_1',
        plantId: 'PLANT_1',
      );

      expect(result.success, isTrue);
      expect(repo.deleteCalled, isTrue);
    });
  });
}
