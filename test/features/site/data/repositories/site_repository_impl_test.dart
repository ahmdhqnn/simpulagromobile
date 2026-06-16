import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/features/site/data/datasources/site_remote_datasource.dart';
import 'package:simpulagromobile/features/site/data/repositories/site_repository_impl.dart';

class _MockSiteRemoteDataSource extends Mock implements SiteRemoteDataSource {}

void main() {
  group('SiteRepositoryImpl errors', () {
    late _MockSiteRemoteDataSource remoteDataSource;
    late SiteRepositoryImpl repository;

    setUp(() {
      remoteDataSource = _MockSiteRemoteDataSource();
      repository = SiteRepositoryImpl(remoteDataSource);
    });

    test('maps non-map error bodies without index type crash', () async {
      when(() => remoteDataSource.getSiteById('SITE_1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/sites'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/sites'),
            statusCode: 500,
            data: ['backend error'],
          ),
        ),
      );

      final result = await repository.getSiteById('SITE_1');

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should fail'),
      );
    });
  });

  group('SiteRepositoryImpl inviteMember', () {
    late _MockSiteRemoteDataSource remoteDataSource;
    late SiteRepositoryImpl repository;

    setUp(() {
      remoteDataSource = _MockSiteRemoteDataSource();
      repository = SiteRepositoryImpl(remoteDataSource);
    });

    test('returns Right(null) on success', () async {
      when(
        () => remoteDataSource.inviteMember('SITE_1', 'USR_001'),
      ).thenAnswer((_) async {});

      final result = await repository.inviteMember('SITE_1', 'USR_001');

      result.fold((failure) => fail('Should not fail'), (_) {});
      verify(
        () => remoteDataSource.inviteMember('SITE_1', 'USR_001'),
      ).called(1);
    });

    test('maps 400 to ValidationFailure', () async {
      when(() => remoteDataSource.inviteMember('SITE_1', 'USR_001')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/sites/SITE_1/members/invite'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: '/sites/SITE_1/members/invite',
            ),
            statusCode: 400,
            data: {'message': 'Bad request'},
          ),
        ),
      );

      final result = await repository.inviteMember('SITE_1', 'USR_001');

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should fail'),
      );
    });

    test('maps 403 to PermissionFailure', () async {
      when(() => remoteDataSource.inviteMember('SITE_1', 'USR_001')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/sites/SITE_1/members/invite'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: '/sites/SITE_1/members/invite',
            ),
            statusCode: 403,
            data: {'message': 'Forbidden'},
          ),
        ),
      );

      final result = await repository.inviteMember('SITE_1', 'USR_001');

      result.fold(
        (failure) => expect(failure, isA<PermissionFailure>()),
        (_) => fail('Should fail'),
      );
    });

    test('maps 409 to ValidationFailure', () async {
      when(() => remoteDataSource.inviteMember('SITE_1', 'USR_001')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/sites/SITE_1/members/invite'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: '/sites/SITE_1/members/invite',
            ),
            statusCode: 409,
            data: {'message': 'Conflict'},
          ),
        ),
      );

      final result = await repository.inviteMember('SITE_1', 'USR_001');

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should fail'),
      );
    });
  });
}
