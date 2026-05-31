import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/core/providers/app_startup_provider.dart';
import 'package:simpulagromobile/core/providers/core_providers.dart';
import 'package:simpulagromobile/core/storage/secure_storage.dart';
import 'package:simpulagromobile/features/site/domain/entities/site.dart';
import 'package:simpulagromobile/features/site/domain/repositories/site_repository.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';

void main() {
  group('SelectedSite provider', () {
    test('uses preloaded site when available in current site list', () async {
      final storage = _FakeSecureStorage();
      final sites = [
        const Site(siteId: 'SITE_1', siteName: 'Site 1'),
        const Site(siteId: 'SITE_2', siteName: 'Site 2'),
      ];

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          appStartupDataProvider.overrideWith(
            (_) => const AppStartupData(selectedSiteId: 'SITE_2'),
          ),
          siteListProvider.overrideWith((_) async => sites),
        ],
      );
      addTearDown(container.dispose);

      // Trigger build + listener.
      container.read(selectedSiteProvider);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(selectedSiteIdProvider), 'SITE_2');
      expect(storage.savedSiteId, 'SITE_2');
    });

    test(
      'falls back to first site when current and preloaded are missing',
      () async {
        final storage = _FakeSecureStorage();
        final sites = [
          const Site(siteId: 'SITE_A', siteName: 'A'),
          const Site(siteId: 'SITE_B', siteName: 'B'),
        ];

        final container = ProviderContainer(
          overrides: [
            secureStorageProvider.overrideWithValue(storage),
            appStartupDataProvider.overrideWith(
              (_) => const AppStartupData(selectedSiteId: 'SITE_MISSING'),
            ),
            siteListProvider.overrideWith((_) async => sites),
          ],
        );
        addTearDown(container.dispose);

        container.read(selectedSiteProvider);
        await Future<void>.delayed(Duration.zero);

        expect(container.read(selectedSiteIdProvider), 'SITE_A');
        expect(storage.savedSiteId, 'SITE_A');
      },
    );

    test('reselects available current site and persists it', () async {
      final storage = _FakeSecureStorage();
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          siteListProvider.overrideWith((_) async => const <Site>[]),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(selectedSiteProvider.notifier);
      await notifier.selectSite(const Site(siteId: 'SITE_X', siteName: 'X'));

      await notifier.updateFromSiteList(const [
        Site(siteId: 'SITE_X', siteName: 'X (new)'),
      ], null);

      expect(container.read(selectedSiteIdProvider), 'SITE_X');
      expect(storage.savedSiteId, 'SITE_X');
    });
  });

  group('SiteMemberInviteNotifier', () {
    test('returns noSiteSelected when site context is missing', () async {
      final container = ProviderContainer(
        overrides: [
          siteRepositoryProvider.overrideWithValue(_FakeSiteRepository()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(siteMemberInviteProvider.notifier);
      final result = await notifier.inviteMember(userId: 'USR_001');

      expect(result, isFalse);
      expect(
        container.read(siteMemberInviteProvider).errorType,
        SiteMemberInviteErrorType.noSiteSelected,
      );
    });

    test('maps invite conflict failure', () async {
      final repo = _FakeSiteRepository()
        ..inviteResult = const Left(ValidationFailure('INVITE_CONFLICT'));
      final container = ProviderContainer(
        overrides: [siteRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(siteMemberInviteProvider.notifier);
      final result = await notifier.inviteMember(
        siteId: 'SITE_1',
        userId: 'USR_001',
      );

      expect(result, isFalse);
      expect(
        container.read(siteMemberInviteProvider).errorType,
        SiteMemberInviteErrorType.conflict,
      );
    });
  });
}

class _FakeSecureStorage extends SecureStorage {
  String? savedSiteId;
  bool cleared = false;

  @override
  Future<void> saveSelectedSiteId(String siteId) async {
    savedSiteId = siteId;
  }

  @override
  Future<void> deleteSelectedSiteId() async {
    cleared = true;
    savedSiteId = null;
  }
}

class _FakeSiteRepository implements SiteRepository {
  Either<Failure, void> inviteResult = const Right(null);

  @override
  Future<Either<Failure, void>> inviteMember(
    String siteId,
    String userId,
  ) async {
    return inviteResult;
  }

  @override
  Future<Either<Failure, Site>> createSite(Site site) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Site>> getSiteById(String siteId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Site>>> getSites() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Site>> updateSite(String siteId, Site site) async {
    throw UnimplementedError();
  }
}
