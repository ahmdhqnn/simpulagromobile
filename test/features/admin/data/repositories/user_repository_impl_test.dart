import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/features/admin/data/datasources/user_remote_datasource.dart';
import 'package:simpulagromobile/features/admin/data/repositories/user_repository_impl.dart';

class MockUserRemoteDatasource extends Mock implements UserRemoteDatasource {}

void main() {
  late MockUserRemoteDatasource mockDatasource;
  late UserRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockUserRemoteDatasource();
    repository = UserRepositoryImpl(mockDatasource);
  });

  group('UserRepositoryImpl Tests', () {
    const dummyUser = User(
      userId: 'USER_001',
      userName: 'John Doe',
      userEmail: 'john@example.com',
      userPhone: '081234567890',
      roleId: 'ROLE002',
    );

    test(
      'createUser correctly maps user_password to user_pass and calls remote datasource',
      () async {
        when(
          () => mockDatasource.createUser(any()),
        ).thenAnswer((_) async => dummyUser);

        final result = await repository.createUser(dummyUser, 'secret123');

        expect(result.userId, equals('USER_001'));
        expect(result.userName, equals('John Doe'));

        verify(
          () => mockDatasource.createUser({
            'user_id': 'USER_001',
            'user_name': 'John Doe',
            'user_email': 'john@example.com',
            'user_phone': '081234567890',
            'user_pass': 'secret123',
            'role_id': 'ROLE002',
          }),
        ).called(1);
      },
    );
  });
}
