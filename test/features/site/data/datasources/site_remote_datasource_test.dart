import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/constants/api_endpoints.dart';
import 'package:simpulagromobile/features/site/data/datasources/site_remote_datasource.dart';
import 'package:simpulagromobile/features/site/domain/entities/site.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(String path, dynamic data) {
  return Response(
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
    data: data,
  );
}

void main() {
  late MockDio dio;
  late SiteRemoteDataSource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = SiteRemoteDataSource(dio);
  });

  group('SiteRemoteDataSource', () {
    test(
      'getSites accepts documented sites wrapper and string values',
      () async {
        when(() => dio.get(ApiEndpoints.sites)).thenAnswer(
          (_) async => _response(ApiEndpoints.sites, {
            'data': {
              'sites': [
                {
                  'site_id': 101,
                  'site_name': 'Sawah Utama',
                  'site_lat': '-6.2001',
                  'site_lon': '106.8002',
                  'site_alt': '42.5',
                  'site_sts': '1',
                },
              ],
            },
          }),
        );

        final result = await dataSource.getSites();

        expect(result, hasLength(1));
        expect(result.first.siteId, '101');
        expect(result.first.siteLat, -6.2001);
        expect(result.first.siteLon, 106.8002);
        expect(result.first.siteAlt, 42.5);
        expect(result.first.siteSts, 1);
      },
    );

    test('getSiteById unwraps site object and parses mixed types', () async {
      when(
        () => dio.get(
          ApiEndpoints.sites,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => _response(ApiEndpoints.sites, {
          'message': 'ok',
          'data': {
            'site': {
              'site_id': 101,
              'site_name': 'Sawah Utama',
              'site_address': 12,
              'site_lat': '-6.2001',
              'site_lon': '106.8002',
              'site_alt': 42,
              'site_sts': 'active',
              'site_created': '2026-06-01T00:00:00.000Z',
              'updated_at': '2026-06-02T00:00:00.000Z',
            },
          },
        }),
      );

      final result = await dataSource.getSiteById('101');

      expect(result.siteId, '101');
      expect(result.siteAddress, '12');
      expect(result.siteSts, 1);
      expect(result.siteCreated, DateTime.parse('2026-06-01T00:00:00.000Z'));
      expect(result.siteUpdate, DateTime.parse('2026-06-02T00:00:00.000Z'));
    });

    test('getSiteById uses documented site_id query filter', () async {
      when(
        () => dio.get(
          ApiEndpoints.sites,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => _response(ApiEndpoints.sites, {
          'data': {
            'sites': [
              {'site_id': 'SITE_001', 'site_name': 'Other'},
              {'site_id': 'SITE_002', 'site_name': 'Target'},
            ],
          },
        }),
      );

      final result = await dataSource.getSiteById('SITE_002');

      expect(result.siteId, 'SITE_002');
      expect(result.siteName, 'Target');
      verify(
        () => dio.get(
          ApiEndpoints.sites,
          queryParameters: any(
            named: 'queryParameters',
            that: containsPair('site_id', 'SITE_002'),
          ),
        ),
      ).called(1);
    });

    test('updateSite parses string coordinate response', () async {
      when(
        () => dio.put(ApiEndpoints.siteById('101'), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(ApiEndpoints.siteById('101'), {
          'data': {
            'site': {
              'site_id': '101',
              'site_name': 'Sawah Revisi',
              'site_lat': '-6.21',
              'site_lon': '106.81',
              'site_alt': '55',
              'site_sts': '1',
            },
          },
        }),
      );

      final result = await dataSource.updateSite(
        '101',
        const Site(siteId: '101', siteName: 'Sawah Revisi'),
      );

      expect(result.siteName, 'Sawah Revisi');
      expect(result.siteLat, -6.21);
      expect(result.siteLon, 106.81);
      expect(result.siteAlt, 55);
      expect(result.siteSts, 1);
    });
  });
}
