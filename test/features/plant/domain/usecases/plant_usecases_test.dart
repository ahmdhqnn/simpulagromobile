import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/plant/domain/entities/plant.dart';
import 'package:simpulagromobile/features/plant/domain/repositories/plant_repository.dart';
import 'package:simpulagromobile/features/plant/domain/usecases/create_plant_usecase.dart';
import 'package:simpulagromobile/features/plant/domain/usecases/delete_plant_usecase.dart';
import 'package:simpulagromobile/features/plant/domain/usecases/get_plants_usecase.dart';
import 'package:simpulagromobile/features/plant/domain/usecases/harvest_plant_usecase.dart';
import 'package:simpulagromobile/features/plant/domain/usecases/update_plant_usecase.dart';

class MockPlantRepository extends Mock implements PlantRepository {}

void main() {
  late MockPlantRepository mockRepository;

  const siteId = 'SITE_001';
  const plantId = 'PLANT_001';

  final plant = Plant(
    plantId: plantId,
    siteId: siteId,
    varietasId: 'VAR_001',
    plantName: 'Padi Demo',
    plantType: CropType.PADI,
    plantDate: DateTime(2026, 5, 1),
    plantSts: 1,
  );

  setUp(() {
    mockRepository = MockPlantRepository();
  });

  // ─── GetPlantsUseCase ─────────────────────────────────────────────────────

  group('GetPlantsUseCase', () {
    late GetPlantsUseCase useCase;

    setUp(() => useCase = GetPlantsUseCase(mockRepository));

    test('delegates to repository.getPlants and returns result', () async {
      when(
        () => mockRepository.getPlants(siteId),
      ).thenAnswer((_) async => Right([plant]));

      final result = await useCase(siteId);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (plants) => expect(plants.first.plantId, plantId),
      );
      verify(() => mockRepository.getPlants(siteId)).called(1);
    });

    test('propagates failure from repository', () async {
      when(
        () => mockRepository.getPlants(siteId),
      ).thenAnswer((_) async => const Left(NetworkFailure('No connection')));

      final result = await useCase(siteId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── GetPlantByIdUseCase ──────────────────────────────────────────────────

  group('GetPlantByIdUseCase', () {
    late GetPlantByIdUseCase useCase;

    setUp(() => useCase = GetPlantByIdUseCase(mockRepository));

    test('delegates to repository.getPlantById and returns plant', () async {
      when(
        () => mockRepository.getPlantById(siteId, plantId),
      ).thenAnswer((_) async => Right(plant));

      final result = await useCase(siteId, plantId);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (p) => expect(p.plantName, 'Padi Demo'),
      );
      verify(() => mockRepository.getPlantById(siteId, plantId)).called(1);
    });

    test('returns Left(NotFoundFailure) when plant not found', () async {
      when(() => mockRepository.getPlantById(siteId, plantId)).thenAnswer(
        (_) async => const Left(NotFoundFailure('Plant tidak ditemukan')),
      );

      final result = await useCase(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── CreatePlantUseCase ───────────────────────────────────────────────────

  group('CreatePlantUseCase', () {
    late CreatePlantUseCase useCase;

    final createData = {
      'plant_name': 'Padi Demo',
      'varietas_id': 'VAR_001',
      'plant_type': 'PADI',
      'plant_date': '2026-05-01',
    };

    setUp(() => useCase = CreatePlantUseCase(mockRepository));

    test(
      'delegates to repository.createPlant and returns created plant',
      () async {
        when(
          () => mockRepository.createPlant(siteId, createData),
        ).thenAnswer((_) async => Right(plant));

        final result = await useCase(siteId, createData);

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected Right'),
          (p) => expect(p.plantId, plantId),
        );
        verify(() => mockRepository.createPlant(siteId, createData)).called(1);
      },
    );
  });

  // ─── UpdatePlantUseCase ───────────────────────────────────────────────────

  group('UpdatePlantUseCase', () {
    late UpdatePlantUseCase useCase;

    final updateData = {
      'plant_name': 'Padi Demo Updated',
      'varietas_id': 'VAR_001',
      'plant_type': 'PADI',
      'plant_date': '2026-05-01',
    };

    final updatedPlant = Plant(
      plantId: plantId,
      siteId: siteId,
      varietasId: 'VAR_001',
      plantName: 'Padi Demo Updated',
      plantType: CropType.PADI,
      plantDate: DateTime(2026, 5, 1),
      plantSts: 1,
    );

    setUp(() => useCase = UpdatePlantUseCase(mockRepository));

    test(
      'delegates to repository.updatePlant and returns updated plant',
      () async {
        when(
          () => mockRepository.updatePlant(siteId, plantId, updateData),
        ).thenAnswer((_) async => Right(updatedPlant));

        final result = await useCase(siteId, plantId, updateData);

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Expected Right'),
          (p) => expect(p.plantName, 'Padi Demo Updated'),
        );
        verify(
          () => mockRepository.updatePlant(siteId, plantId, updateData),
        ).called(1);
      },
    );

    test(
      'returns Left(PermissionFailure) when user lacks plant:update',
      () async {
        when(
          () => mockRepository.updatePlant(siteId, plantId, updateData),
        ).thenAnswer(
          (_) async => const Left(
            PermissionFailure('Tidak memiliki izin (plant:update)'),
          ),
        );

        final result = await useCase(siteId, plantId, updateData);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<PermissionFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );
  });

  // ─── HarvestPlantUseCase ──────────────────────────────────────────────────

  group('HarvestPlantUseCase', () {
    late HarvestPlantUseCase useCase;

    setUp(() => useCase = HarvestPlantUseCase(mockRepository));

    test('delegates to repository.harvestPlant and returns void', () async {
      when(
        () => mockRepository.harvestPlant(siteId, plantId),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(siteId, plantId);

      expect(result.isRight(), true);
      verify(() => mockRepository.harvestPlant(siteId, plantId)).called(1);
    });

    test('propagates failure from repository', () async {
      when(() => mockRepository.harvestPlant(siteId, plantId)).thenAnswer(
        (_) async => const Left(ServerFailure('Gagal memproses panen')),
      );

      final result = await useCase(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── DeletePlantUseCase ───────────────────────────────────────────────────

  group('DeletePlantUseCase', () {
    late DeletePlantUseCase useCase;

    setUp(() => useCase = DeletePlantUseCase(mockRepository));

    test(
      'delegates to repository.deletePlant and returns void on success',
      () async {
        when(
          () => mockRepository.deletePlant(siteId, plantId),
        ).thenAnswer((_) async => const Right(null));

        final result = await useCase(siteId, plantId);

        expect(result.isRight(), true);
        verify(() => mockRepository.deletePlant(siteId, plantId)).called(1);
      },
    );

    test(
      'returns Left(PermissionFailure) when non-Admin tries to delete',
      () async {
        when(() => mockRepository.deletePlant(siteId, plantId)).thenAnswer(
          (_) async => const Left(
            PermissionFailure(
              'Forbidden - hanya Admin yang dapat menghapus plant',
            ),
          ),
        );

        final result = await useCase(siteId, plantId);

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<PermissionFailure>());
          expect(failure.message, contains('Admin'));
        }, (_) => fail('Expected Left'));
      },
    );

    test('returns Left(NotFoundFailure) when plant not found', () async {
      when(() => mockRepository.deletePlant(siteId, plantId)).thenAnswer(
        (_) async => const Left(
          NotFoundFailure(
            'Plant tidak ditemukan atau plantId tidak sesuai dengan siteId',
          ),
        ),
      );

      final result = await useCase(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(AuthFailure) when unauthenticated', () async {
      when(() => mockRepository.deletePlant(siteId, plantId)).thenAnswer(
        (_) async => const Left(AuthFailure('Tidak terautentikasi')),
      );

      final result = await useCase(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
