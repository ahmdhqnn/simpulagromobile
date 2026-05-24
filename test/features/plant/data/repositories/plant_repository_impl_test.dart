import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/error/exceptions.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/plant/data/datasources/plant_remote_datasource.dart';
import 'package:simpulagromobile/features/plant/data/models/plant_model.dart';
import 'package:simpulagromobile/features/plant/data/repositories/plant_repository_impl.dart';

class MockPlantRemoteDataSource extends Mock implements PlantRemoteDataSource {}

void main() {
  late MockPlantRemoteDataSource mockDataSource;
  late PlantRepositoryImpl repository;

  const siteId = 'SITE_001';
  const plantId = 'PLANT_001';

  // Shared test fixture
  final plantModel = PlantModel(
    plantId: plantId,
    siteId: siteId,
    varietasId: 'VAR_001',
    plantName: 'Padi Demo',
    plantType: 'PADI',
    plantDate: DateTime(2026, 5, 1),
    plantHarvest: null,
    plantSts: 1,
  );

  setUp(() {
    mockDataSource = MockPlantRemoteDataSource();
    repository = PlantRepositoryImpl(mockDataSource);
  });

  // ─── getPlants ────────────────────────────────────────────────────────────

  group('getPlants', () {
    test('returns Right(List<Plant>) on success', () async {
      when(
        () => mockDataSource.getPlants(siteId),
      ).thenAnswer((_) async => [plantModel]);

      final result = await repository.getPlants(siteId);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (plants) {
        expect(plants.length, 1);
        expect(plants.first.plantId, plantId);
        expect(plants.first.plantName, 'Padi Demo');
      });
    });

    test('returns Left(NetworkFailure) on connection error', () async {
      when(() => mockDataSource.getPlants(siteId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getPlants(siteId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(UnknownFailure) on unexpected error', () async {
      when(
        () => mockDataSource.getPlants(siteId),
      ).thenThrow(Exception('Unexpected'));

      final result = await repository.getPlants(siteId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── getPlantById ─────────────────────────────────────────────────────────

  group('getPlantById', () {
    test('returns Right(Plant) on success', () async {
      when(
        () => mockDataSource.getPlantById(siteId, plantId),
      ).thenAnswer((_) async => plantModel);

      final result = await repository.getPlantById(siteId, plantId);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (plant) {
        expect(plant.plantId, plantId);
        expect(plant.siteId, siteId);
      });
    });

    test('returns Left(NotFoundFailure) on 404', () async {
      when(() => mockDataSource.getPlantById(siteId, plantId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            data: {'message': 'Plant tidak ditemukan'},
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.getPlantById(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── createPlant ──────────────────────────────────────────────────────────

  group('createPlant', () {
    final createData = {
      'plant_name': 'Padi Demo',
      'varietas_id': 'VAR_001',
      'plant_type': 'PADI',
      'plant_date': '2026-05-01',
    };

    test('returns Right(Plant) on success', () async {
      when(
        () => mockDataSource.createPlant(siteId, createData),
      ).thenAnswer((_) async => plantModel);

      final result = await repository.createPlant(siteId, createData);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (plant) => expect(plant.plantId, plantId),
      );
    });

    test('returns Left(ValidationFailure) on 409 conflict', () async {
      when(() => mockDataSource.createPlant(siteId, createData)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 409,
            data: {'message': 'Plant ID sudah ada'},
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.createPlant(siteId, createData);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── updatePlant ──────────────────────────────────────────────────────────

  group('updatePlant', () {
    final updateData = {
      'plant_name': 'Padi Demo Updated',
      'varietas_id': 'VAR_001',
      'plant_type': 'PADI',
      'plant_date': '2026-05-01',
    };

    final updatedModel = PlantModel(
      plantId: plantId,
      siteId: siteId,
      varietasId: 'VAR_001',
      plantName: 'Padi Demo Updated',
      plantType: 'PADI',
      plantDate: DateTime(2026, 5, 1),
      plantHarvest: null,
      plantSts: 1,
    );

    test('returns Right(Plant) with updated data on success', () async {
      when(
        () => mockDataSource.updatePlant(siteId, plantId, updateData),
      ).thenAnswer((_) async => updatedModel);

      final result = await repository.updatePlant(siteId, plantId, updateData);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (plant) => expect(plant.plantName, 'Padi Demo Updated'),
      );
    });

    test('returns Left(PermissionFailure) on 403', () async {
      when(
        () => mockDataSource.updatePlant(siteId, plantId, updateData),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            data: {'message': 'Tidak memiliki izin (plant:update)'},
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.updatePlant(siteId, plantId, updateData);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<PermissionFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NotFoundFailure) when plantId not in siteId', () async {
      when(
        () => mockDataSource.updatePlant(siteId, plantId, updateData),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            data: {
              'message':
                  'Plant tidak ditemukan atau plantId tidak sesuai dengan siteId',
            },
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.updatePlant(siteId, plantId, updateData);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── harvestPlant ─────────────────────────────────────────────────────────

  group('harvestPlant', () {
    test('returns Right(null) on success', () async {
      when(
        () => mockDataSource.harvestPlant(siteId, plantId),
      ).thenAnswer((_) async {});

      final result = await repository.harvestPlant(siteId, plantId);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (_) {
        /* void — success */
      });
    });

    test('returns Left(ServerFailure) on server error', () async {
      when(() => mockDataSource.harvestPlant(siteId, plantId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            data: {'message': 'Internal server error'},
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.harvestPlant(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── deletePlant ──────────────────────────────────────────────────────────

  group('deletePlant', () {
    test('returns Right(null) on success (Admin)', () async {
      when(
        () => mockDataSource.deletePlant(siteId, plantId),
      ).thenAnswer((_) async {});

      final result = await repository.deletePlant(siteId, plantId);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (_) {
        /* void — success */
      });
    });

    test('returns Left(PermissionFailure) on 403 (non-Admin)', () async {
      when(() => mockDataSource.deletePlant(siteId, plantId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            data: {
              'message': 'Forbidden - hanya Admin yang dapat menghapus plant',
            },
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.deletePlant(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<PermissionFailure>());
        expect(failure.message, contains('Forbidden'));
      }, (_) => fail('Expected Left'));
    });

    test('returns Left(NotFoundFailure) when plant not in site', () async {
      when(() => mockDataSource.deletePlant(siteId, plantId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            data: {
              'message':
                  'Plant tidak ditemukan atau plantId tidak sesuai dengan siteId',
            },
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.deletePlant(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(AuthFailure) on 401 (unauthenticated)', () async {
      when(() => mockDataSource.deletePlant(siteId, plantId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            data: {'message': 'Tidak terautentikasi'},
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.deletePlant(siteId, plantId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test(
      'returns Left(UnsupportedBackendEndpointFailure) on unsupported',
      () async {
        when(() => mockDataSource.deletePlant(siteId, plantId)).thenThrow(
          const UnsupportedBackendEndpointException('Fitur belum didukung'),
        );

        final result = await repository.deletePlant(siteId, plantId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) =>
              expect(failure, isA<UnsupportedBackendEndpointFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );
  });
}
