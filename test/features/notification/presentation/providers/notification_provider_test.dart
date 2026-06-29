import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpulagromobile/features/notification/domain/entities/notification.dart';
import 'package:simpulagromobile/features/notification/presentation/providers/notification_provider.dart';
import 'package:simpulagromobile/core/providers/app_providers.dart';
import 'package:simpulagromobile/features/task/domain/entities/task.dart';
import 'package:simpulagromobile/features/task/presentation/providers/task_provider.dart';
import 'package:simpulagromobile/features/site/domain/entities/site.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';
import 'package:simpulagromobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:simpulagromobile/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:simpulagromobile/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:simpulagromobile/features/recommendation/domain/entities/recommendation.dart';
import 'package:simpulagromobile/features/recommendation/presentation/providers/recommendation_hub_provider.dart';
import 'package:simpulagromobile/features/auth/presentation/providers/auth_provider.dart';

import 'package:mocktail/mocktail.dart';
import 'package:simpulagromobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:simpulagromobile/features/forum/domain/repositories/forum_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockForumRepository extends Mock implements ForumRepository {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier() : super(MockAuthRepository());
}

class FakeForumNotifier extends ForumNotifier {
  FakeForumNotifier() : super(MockForumRepository());
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer createContainer({List<Site>? sites, List<Task>? tasks}) {
    return ProviderContainer(
      overrides: [
        siteListProvider.overrideWith((ref) => sites ?? <Site>[]),
        taskListProvider.overrideWith((ref) => tasks ?? <Task>[]),
        recommendationHubDashboardSnapshotProvider.overrideWith(
          (ref) => const RecommendationDashboardSnapshot(
            siteItems: [],
            plantItems: [],
            phaseSnapshot: RecommendationPhaseSnapshot(
              phaseId: null,
              phaseName: null,
              items: [],
            ),
          ),
        ),
        forumProvider.overrideWith((ref) => FakeForumNotifier()),
        environmentalHealthProvider.overrideWith(
          (ref) => const EnvironmentalHealthEntity(
            overallHealth: 100.0,
            totalSensors: 0,
            sensors: [],
          ),
        ),
        authProvider.overrideWith((ref) => FakeAuthNotifier()),
      ],
    );
  }

  Recommendation recommendation({required String id, required String title}) {
    return Recommendation(
      recommendationId: id,
      type: RecommendationType.general,
      title: title,
      description: '$title description',
      priority: RecommendationPriority.medium,
      createdAt: DateTime.now(),
    );
  }

  RecommendationDashboardSnapshot recommendationSnapshot({
    List<Recommendation> siteItems = const [],
    List<Recommendation> plantItems = const [],
    List<Recommendation> phaseItems = const [],
  }) {
    return RecommendationDashboardSnapshot(
      siteItems: siteItems,
      plantItems: plantItems,
      phaseSnapshot: RecommendationPhaseSnapshot(
        phaseId: 'phase_1',
        phaseName: 'Vegetatif',
        items: phaseItems,
      ),
    );
  }

  group('NotificationNotifier', () {
    test('initial state is empty', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      expect(container.read(notificationProvider), isEmpty);
    });

    test('adds and persists notifications', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      final notification = AppNotification(
        id: '1',
        type: NotificationType.general,
        title: 'Test Notification',
        body: 'This is a test notification',
        timestamp: DateTime.now(),
        isRead: false,
      );

      notifier.addNotification(notification);

      expect(container.read(notificationProvider), [notification]);
      expect(container.read(unreadNotificationCountProvider), 1);
    });

    test('marks notification as read', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      final notification = AppNotification(
        id: '1',
        type: NotificationType.general,
        title: 'Test Notification',
        body: 'This is a test notification',
        timestamp: DateTime.now(),
        isRead: false,
      );

      notifier.addNotification(notification);
      expect(container.read(unreadNotificationCountProvider), 1);

      notifier.markAsRead('1');
      expect(container.read(unreadNotificationCountProvider), 0);
      expect(container.read(notificationProvider).first.isRead, isTrue);
    });

    test('moves read notifications below unread notifications', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      final olderUnread = AppNotification(
        id: 'older',
        type: NotificationType.general,
        title: 'Older Notification',
        body: 'Older unread notification',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      );
      final newerUnread = AppNotification(
        id: 'newer',
        type: NotificationType.general,
        title: 'Newer Notification',
        body: 'Newer unread notification',
        timestamp: DateTime.now(),
        isRead: false,
      );

      notifier.addNotification(olderUnread);
      notifier.addNotification(newerUnread);
      expect(
        container
            .read(notificationProvider)
            .map((notification) => notification.id),
        ['newer', 'older'],
      );

      notifier.markAsRead('newer');
      expect(
        container
            .read(notificationProvider)
            .map((notification) => notification.id),
        ['older', 'newer'],
      );
    });

    test('clears all notifications', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      final notification = AppNotification(
        id: '1',
        type: NotificationType.general,
        title: 'Test Notification',
        body: 'This is a test notification',
        timestamp: DateTime.now(),
        isRead: false,
      );

      notifier.addNotification(notification);
      expect(container.read(notificationProvider), isNotEmpty);

      notifier.clearAll();
      expect(container.read(notificationProvider), isEmpty);
    });

    test('does not trigger notification on first run (warmup cache)', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      final sites = [const Site(siteId: 'site_1', siteName: 'Site 1')];

      notifier.checkForNewSites(sites);
      expect(
        container.read(notificationProvider),
        isEmpty,
      ); // empty because first-run cache warmup
    });

    test('triggers notification on subsequent runs for new items', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      // Warmup
      notifier.checkForNewSites([
        Site(siteId: 'site_1', siteName: 'Site 1', siteCreated: DateTime.now()),
      ]);

      // Add a new site
      notifier.checkForNewSites([
        Site(siteId: 'site_1', siteName: 'Site 1', siteCreated: DateTime.now()),
        Site(siteId: 'site_2', siteName: 'Site 2', siteCreated: DateTime.now()),
      ]);

      expect(container.read(notificationProvider).length, 1);
      expect(
        container.read(notificationProvider).first.type,
        NotificationType.siteInvite,
      );
      expect(
        container.read(notificationProvider).first.redirectPath,
        '/site/site_2',
      );
    });

    test('detects new tasks', () async {
      final container = createContainer();
      final notifier = container.read(notificationProvider.notifier);
      await notifier.loadNotifications();

      // Warmup
      notifier.checkForNewTasks([
        Task(
          taskId: 'task_1',
          taskName: 'Task 1',
          taskType: TaskType.watering,
          taskStatus: TaskStatus.pending,
          taskPriority: TaskPriority.medium,
          createdAt: DateTime.now(),
        ),
      ]);

      // Add a new task
      notifier.checkForNewTasks([
        Task(
          taskId: 'task_1',
          taskName: 'Task 1',
          taskType: TaskType.watering,
          taskStatus: TaskStatus.pending,
          taskPriority: TaskPriority.medium,
          createdAt: DateTime.now(),
        ),
        Task(
          taskId: 'task_2',
          taskName: 'Task 2',
          taskType: TaskType.fertilizing,
          taskStatus: TaskStatus.progress,
          taskPriority: TaskPriority.high,
          createdAt: DateTime.now(),
        ),
      ]);

      expect(container.read(notificationProvider).length, 1);
      expect(
        container.read(notificationProvider).first.type,
        NotificationType.taskAssignment,
      );
      expect(
        container.read(notificationProvider).first.redirectPath,
        '/task/task_2',
      );
    });

    test(
      'detects recommendation action, plant, and phase scopes separately',
      () async {
        final container = createContainer();
        final notifier = container.read(notificationProvider.notifier);
        await notifier.loadNotifications();

        notifier.checkForNewRecommendations(
          recommendationSnapshot(
            siteItems: [recommendation(id: 'old_action', title: 'Old action')],
            plantItems: [recommendation(id: 'old_plant', title: 'Old plant')],
            phaseItems: [recommendation(id: 'old_phase', title: 'Old phase')],
          ),
        );
        expect(container.read(notificationProvider), isEmpty);

        notifier.checkForNewRecommendations(
          recommendationSnapshot(
            siteItems: [
              recommendation(id: 'old_action', title: 'Old action'),
              recommendation(id: 'shared_rec', title: 'Action recommendation'),
            ],
            plantItems: [
              recommendation(id: 'old_plant', title: 'Old plant'),
              recommendation(id: 'shared_rec', title: 'Plant recommendation'),
            ],
            phaseItems: [
              recommendation(id: 'old_phase', title: 'Old phase'),
              recommendation(id: 'shared_rec', title: 'Phase recommendation'),
            ],
          ),
        );

        final notifications = container.read(notificationProvider);
        expect(notifications.length, 3);
        expect(
          notifications.map((notification) => notification.title),
          containsAll([
            'Rekomendasi Aksi',
            'Rekomendasi Tanaman',
            'Rekomendasi Fase Aktif',
          ]),
        );
        expect(
          notifications.map((notification) => notification.redirectPath),
          containsAll([
            '/recommendations?scope=site',
            '/recommendations?scope=plant',
            '/recommendations?scope=phase',
          ]),
        );
      },
    );

    test(
      'does not add notification when notifications are disabled in settings',
      () async {
        final container = ProviderContainer(
          overrides: [
            siteListProvider.overrideWith((ref) => <Site>[]),
            taskListProvider.overrideWith((ref) => <Task>[]),
            recommendationHubDashboardSnapshotProvider.overrideWith(
              (ref) => const RecommendationDashboardSnapshot(
                siteItems: [],
                plantItems: [],
                phaseSnapshot: RecommendationPhaseSnapshot(
                  phaseId: null,
                  phaseName: null,
                  items: [],
                ),
              ),
            ),
            forumProvider.overrideWith((ref) => FakeForumNotifier()),
            environmentalHealthProvider.overrideWith(
              (ref) => const EnvironmentalHealthEntity(
                overallHealth: 100.0,
                totalSensors: 0,
                sensors: [],
              ),
            ),
            authProvider.overrideWith((ref) => FakeAuthNotifier()),
            appSettingsProvider.overrideWith(
              () => _TestAppSettings({
                ...AppSettings.defaults,
                'notifications': false,
              }),
            ),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(notificationProvider.notifier);
        await notifier.loadNotifications();

        final notification = AppNotification(
          id: '1',
          type: NotificationType.general,
          title: 'Test Notification',
          body: 'This is a test notification',
          timestamp: DateTime.now(),
          isRead: false,
        );

        notifier.addNotification(notification);

        expect(container.read(notificationProvider), isEmpty);
        expect(container.read(unreadNotificationCountProvider), 0);
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
