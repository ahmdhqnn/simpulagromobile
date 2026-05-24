import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/plant/data/datasources/plant_remote_datasource.dart';
import 'package:simpulagromobile/features/plant/data/models/plant_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PlantRemoteDataSource datasource;

  const siteId = 'SITE_001';
  const plantId = 'PLANT_001';

  final plantJson = {
    'plant_id': plantId,
    'site_id': siteId,
    'varietas_id': 'VAR_001',
    'plant_name': 'Padi Demo',
    'plant_type': 'PADI',
    'plant_date': '2026-05-01T00:00:00.000Z',
    'plant_harvest': null,
    'plant_sts': 1,
  };

  setUp(() {
    mockDio = MockDio();
    datasource = PlantRemoteDataSource(mockDio);
  });

  group('PlantRemoteDataSource.getPlants', () {
    test('returns list of PlantModel on success', () async {
      when(() => mockDio.get(ApiEndpoints.plants(siteId))).thenAnswer(
        (_) async => Response(
          data: {
            'data': [plantJson],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.plants(siteId)),
        ),
      );

      final result = await datasource.getPlants(siteId);

      expect(result, isA<List<PlantModel>>());
      expect(result.length, 1);
      expect(result.first.plantId, plantId);
    });

    test('throws on DioException', () async {
      when(() => mockDio.get(ApiEndpoints.plants(siteId))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.plants(siteId)),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(() => datasource.getPlants(siteId), throwsA(isA<DioException>()));
    });
  });

  group('PlantRemoteDataSource.getPlantById', () {
    test('returns PlantModel on success', () async {
      when(
        () => mockDio.get(ApiEndpoints.plantById(siteId, plantId)),
      ).thenAnswer(
        (_) async => Response(
          data: {'data': plantJson},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantById(siteId, plantId),
          ),
        ),
      );

      final result = await datasource.getPlantById(siteId, plantId);

      expect(result.plantId, plantId);
      expect(result.plantName, 'Padi Demo');
    });

    test('throws ServerFailure when data is null', () async {
      when(
        () => mockDio.get(ApiEndpoints.plantById(siteId, plantId)),
      ).thenAnswer(
        (_) async => Response(
          data: {'data': null},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantById(siteId, plantId),
          ),
        ),
      );

      expect(
        () => datasource.getPlantById(siteId, plantId),
        throwsA(isA<NotFoundFailure>()),
      );
    });
  });

  group('PlantRemoteDataSource.createPlant', () {
    final createData = {
      'plant_name': 'Padi Demo',
      'varietas_id': 'VAR_001',
      'plant_type': 'PADI',
      'plant_date': '2026-05-01',
    };

    test('returns PlantModel on success', () async {
      when(
        () =>
            mockDio.post(ApiEndpoints.plants(siteId), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          data: {'data': plantJson},
          statusCode: 201,
          requestOptions: RequestOptions(path: ApiEndpoints.plants(siteId)),
        ),
      );

      final result = await datasource.createPlant(siteId, createData);

      expect(result.plantId, plantId);
    });
  });

  group('PlantRemoteDataSource.updatePlant', () {
    final updateData = {
      'plant_name': 'Padi Demo Updated',
      'varietas_id': 'VAR_001',
      'plant_type': 'PADI',
      'plant_date': '2026-05-01',
    };

    test('returns updated PlantModel on success', () async {
      when(
        () => mockDio.put(
          ApiEndpoints.plantById(siteId, plantId),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'data': {...plantJson, 'plant_name': 'Padi Demo Updated'},
          },
          statusCode: 200,
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantById(siteId, plantId),
          ),
        ),
      );

      final result = await datasource.updatePlant(siteId, plantId, updateData);

      expect(result.plantName, 'Padi Demo Updated');
    });
  });

  group('PlantRemoteDataSource.harvestPlant', () {
    test('completes without error on success', () async {
      when(
        () => mockDio.post(ApiEndpoints.harvestPlant(siteId, plantId)),
      ).thenAnswer(
        (_) async => Response(
          data: {'success': true, 'message': 'Plant harvested successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: ApiEndpoints.harvestPlant(siteId, plantId),
          ),
        ),
      );

      await expectLater(datasource.harvestPlant(siteId, plantId), completes);
    });

    test('throws ServerFailure when success is false', () async {
      when(
        () => mockDio.post(ApiEndpoints.harvestPlant(siteId, plantId)),
      ).thenAnswer(
        (_) async => Response(
          data: {'success': false, 'message': 'Already harvested'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: ApiEndpoints.harvestPlant(siteId, plantId),
          ),
        ),
      );

      expect(
        () => datasource.harvestPlant(siteId, plantId),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  group('PlantRemoteDataSource.deletePlant', () {
    test('completes without error on success', () async {
      when(
        () => mockDio.delete(ApiEndpoints.plantById(siteId, plantId)),
      ).thenAnswer(
        (_) async => Response(
          data: {'success': true, 'message': 'Plant deleted successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantById(siteId, plantId),
          ),
        ),
      );

      await expectLater(datasource.deletePlant(siteId, plantId), completes);
    });

    test('throws DioException on 403 (non-admin)', () async {
      when(
        () => mockDio.delete(ApiEndpoints.plantById(siteId, plantId)),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: ApiEndpoints.plantById(siteId, plantId),
          ),
          response: Response(
            statusCode: 403,
            data: {
              'message': 'Forbidden - hanya Admin yang dapat menghapus plant',
            },
            requestOptions: RequestOptions(
              path: ApiEndpoints.plantById(siteId, plantId),
            ),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.deletePlant(siteId, plantId),
        throwsA(isA<DioException>()),
      );
    });
  });
}
