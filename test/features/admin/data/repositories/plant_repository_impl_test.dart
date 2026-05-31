import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/error/exceptions.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/admin/data/datasources/plant_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/models/plant_model.dart';
import 'package:simpulagromobile/features/admin/data/repositories/plant_repository_impl.dart';
import 'package:simpulagromobile/features/admin/domain/entities/plant.dart';

class MockPlantRemoteDatasource extends Mock implements PlantRemoteDatasource {}

void main() {
  late MockPlantRemoteDatasource mockDatasource;
  late PlantRepositoryImpl repository;

  const siteId = 'SITE_001';
  const plantId = 'PLANT_001';

  // Admin PlantModel uses CropType from the admin domain (lowercase enum).
  final plantModel = PlantModel(
    plantId: plantId,
    siteId: siteId,
    varietasId: 'VAR_001',
    plantName: 'Padi Demo',
    plantType: CropType.padi,
    plantDate: DateTime(2026, 5, 1),
    plantHarvest: null,
    plantSts: 1,
  );

  setUp(() {
    mockDatasource = MockPlantRemoteDatasource();
    repository = PlantRepositoryImpl(mockDatasource);
  });

  // ─── getPlantsBySite ──────────────────────────────────────────────────────

  group('getPlantsBySite', () {
    test('returns Right(List<Plant>) on success', () async {
      when(
        () => mockDatasource.getPlantsBySite(siteId),
      ).thenAnswer((_) async => [plantModel]);

      final result = await repository.getPlantsBySite(siteId);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (plants) {
        expect(plants.length, 1);
        expect(plants.first.plantId, plantId);
      });
    });

    test('returns Left(NetworkFailure) on connection timeout', () async {
      when(() => mockDatasource.getPlantsBySite(siteId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.getPlantsBySite(siteId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(ServerFailure) on generic exception', () async {
      when(
        () => mockDatasource.getPlantsBySite(siteId),
      ).thenThrow(Exception('Unexpected error'));

      final result = await repository.getPlantsBySite(siteId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── getPlantById ─────────────────────────────────────────────────────────

  group('getPlantById', () {
    test('returns Right(Plant) on success', () async {
      when(
        () => mockDatasource.getPlantById(siteId, plantId),
      ).thenAnswer((_) async => plantModel);

      final result = await repository.getPlantById(siteId, plantId);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (plant) => expect(plant.plantId, plantId),
      );
    });

    test('returns Left(NotFoundFailure) on 404', () async {
      when(() => mockDatasource.getPlantById(siteId, plantId)).thenThrow(
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
    final plantEntity = Plant(
      plantId: plantId,
      siteId: siteId,
      varietasId: 'VAR_001',
      plantName: 'Padi Demo',
      plantType: CropType.padi,
      plantDate: DateTime(2026, 5, 1),
      plantSts: 1,
    );

    test('creates plant and returns Right(Plant)', () async {
      when(
        () => mockDatasource.createPlant(siteId, any()),
      ).thenAnswer((_) async => plantModel);

      final result = await repository.createPlant(siteId, plantEntity);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (plant) => expect(plant.plantId, plantId),
      );
      verify(() => mockDatasource.createPlant(siteId, any())).called(1);
    });

    test('strips plant_harvest and plant_created from payload', () async {
      Map<String, dynamic>? capturedData;

      when(() => mockDatasource.createPlant(siteId, any())).thenAnswer((
        invocation,
      ) async {
        capturedData =
            invocation.positionalArguments[1] as Map<String, dynamic>;
        return plantModel;
      });

      await repository.createPlant(siteId, plantEntity);

      expect(capturedData, isNotNull);
      expect(capturedData!.containsKey('plant_harvest'), false);
      expect(capturedData!.containsKey('plant_created'), false);
      expect(capturedData!.containsKey('plant_update'), false);
    });
  });

  // ─── updatePlant ──────────────────────────────────────────────────────────

  group('updatePlant', () {
    final plantEntity = Plant(
      plantId: plantId,
      siteId: siteId,
      varietasId: 'VAR_001',
      plantName: 'Padi Demo Updated',
      plantType: CropType.padi,
      plantDate: DateTime(2026, 5, 1),
      plantSts: 1,
    );

    final updatedModel = PlantModel(
      plantId: plantId,
      siteId: siteId,
      varietasId: 'VAR_001',
      plantName: 'Padi Demo Updated',
      plantType: CropType.padi,
      plantDate: DateTime(2026, 5, 1),
      plantSts: 1,
    );

    test('updates plant and returns Right(Plant)', () async {
      when(
        () => mockDatasource.updatePlant(siteId, plantId, any()),
      ).thenAnswer((_) async => updatedModel);

      final result = await repository.updatePlant(siteId, plantId, plantEntity);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (plant) => expect(plant.plantName, 'Padi Demo Updated'),
      );
    });

    test('strips plant_id and plant_harvest from update payload', () async {
      Map<String, dynamic>? capturedData;

      when(() => mockDatasource.updatePlant(siteId, plantId, any())).thenAnswer(
        (invocation) async {
          capturedData =
              invocation.positionalArguments[2] as Map<String, dynamic>;
          return updatedModel;
        },
      );

      await repository.updatePlant(siteId, plantId, plantEntity);

      expect(capturedData, isNotNull);
      expect(capturedData!.containsKey('plant_id'), false);
      expect(capturedData!.containsKey('plant_harvest'), false);
    });

    test('returns Left(PermissionFailure) on 403', () async {
      when(() => mockDatasource.updatePlant(siteId, plantId, any())).thenThrow(
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

      final result = await repository.updatePlant(siteId, plantId, plantEntity);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<PermissionFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ─── harvestPlant ─────────────────────────────────────────────────────────

  group('harvestPlant', () {
    final harvestedModel = PlantModel(
      plantId: plantId,
      siteId: siteId,
      plantName: 'Padi Demo',
      plantType: CropType.padi,
      plantSts: 1,
      plantHarvest: DateTime(2026, 8, 15),
    );

    test('returns Right(Plant) with harvest date on success', () async {
      when(
        () => mockDatasource.harvestPlant(siteId, plantId),
      ).thenAnswer((_) async => harvestedModel);

      final result = await repository.harvestPlant(siteId, plantId);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (plant) {
        expect(plant.isHarvested, true);
        expect(plant.plantHarvest, isNotNull);
      });
    });

    test('returns Left(ServerFailure) on server error', () async {
      when(() => mockDatasource.harvestPlant(siteId, plantId)).thenThrow(
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
        () => mockDatasource.deletePlant(siteId, plantId),
      ).thenAnswer((_) async {});

      final result = await repository.deletePlant(siteId, plantId);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (_) {
        /* void — success */
      });
      verify(() => mockDatasource.deletePlant(siteId, plantId)).called(1);
    });

    test('returns Left(PermissionFailure) on 403 (non-Admin)', () async {
      when(() => mockDatasource.deletePlant(siteId, plantId)).thenThrow(
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
      result.fold(
        (failure) => expect(failure, isA<PermissionFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NotFoundFailure) on 404', () async {
      when(() => mockDatasource.deletePlant(siteId, plantId)).thenThrow(
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

    test('returns Left(AuthFailure) on 401', () async {
      when(() => mockDatasource.deletePlant(siteId, plantId)).thenThrow(
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
      'returns Left(UnsupportedBackendEndpointFailure) when datasource throws unsupported',
      () async {
        when(() => mockDatasource.deletePlant(siteId, plantId)).thenThrow(
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
