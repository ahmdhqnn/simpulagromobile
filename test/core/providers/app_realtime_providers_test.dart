import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpulagromobile/core/providers/app_providers.dart';

void main() {
  group('App realtime providers', () {
    test('appRealtimeRefreshIntervalProvider clamps to minimum 15 seconds', () {
      final container = ProviderContainer(
        overrides: [
          appSettingsProvider.overrideWith(
            () => _TestAppSettings({
              ...AppSettings.defaults,
              'refreshInterval': 5,
            }),
          ),
        ],
      );
      addTearDown(container.dispose);

      final interval = container.read(appRealtimeRefreshIntervalProvider);
      expect(interval, const Duration(seconds: 15));
    });

    test(
      'appRealtimeRefreshIntervalProvider clamps to maximum 300 seconds',
      () {
        final container = ProviderContainer(
          overrides: [
            appSettingsProvider.overrideWith(
              () => _TestAppSettings({
                ...AppSettings.defaults,
                'refreshInterval': 999,
              }),
            ),
          ],
        );
        addTearDown(container.dispose);

        final interval = container.read(appRealtimeRefreshIntervalProvider);
        expect(interval, const Duration(seconds: 300));
      },
    );

    test(
      'realtimeRefreshTickProvider emits nothing when auto refresh is off',
      () async {
        final container = ProviderContainer(
          overrides: [appAutoRefreshEnabledProvider.overrideWith((_) => false)],
        );
        addTearDown(container.dispose);

        final ticks = <int>[];
        final subscription = container.listen<AsyncValue<int>>(
          realtimeRefreshTickProvider,
          (_, next) => next.whenData(ticks.add),
          fireImmediately: true,
        );
        addTearDown(subscription.close);

        await Future<void>.delayed(const Duration(milliseconds: 30));
        expect(ticks, isEmpty);
      },
    );

    test(
      'realtimeRefreshTickProvider emits periodic ticks when enabled',
      () async {
        final container = ProviderContainer(
          overrides: [
            appAutoRefreshEnabledProvider.overrideWith((_) => true),
            appRealtimeRefreshIntervalProvider.overrideWith(
              (_) => const Duration(milliseconds: 10),
            ),
          ],
        );
        addTearDown(container.dispose);

        final ticks = <int>[];
        final subscription = container.listen<AsyncValue<int>>(
          realtimeRefreshTickProvider,
          (_, next) => next.whenData(ticks.add),
          fireImmediately: true,
        );
        addTearDown(subscription.close);

        await Future<void>.delayed(const Duration(milliseconds: 45));
        expect(ticks, containsAllInOrder([1, 2, 3]));
      },
    );
  });
}

class _TestAppSettings extends AppSettings {
  _TestAppSettings(this._state);

  final Map<String, dynamic> _state;

  @override
  Map<String, dynamic> build() => _state;
}
