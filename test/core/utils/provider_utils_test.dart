import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/core/utils/provider_utils.dart';

void main() {
  test('retryOnError does not auto-retry server failures', () async {
    var attempts = 0;
    final provider = FutureProvider<int>((ref) {
      return ref.retryOnError(() async {
        attempts++;
        throw const ServerFailure('Server error', statusCode: 500);
      }, delay: const Duration(milliseconds: 20));
    });

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await expectLater(
      container.read(provider.future),
      throwsA(isA<ServerFailure>()),
    );

    await Future<void>.delayed(const Duration(milliseconds: 80));

    expect(attempts, 1);
  });
}
