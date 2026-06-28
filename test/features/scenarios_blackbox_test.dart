import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:dartz/dartz.dart' as dz hide Task;

import 'package:simpulagromobile/core/providers/app_startup_provider.dart';
import 'package:simpulagromobile/core/providers/core_providers.dart';
import 'package:simpulagromobile/core/network/paginated_result.dart';
import 'package:simpulagromobile/core/storage/secure_storage.dart';
import 'package:simpulagromobile/features/auth/presentation/screens/login_screen.dart';
import 'package:simpulagromobile/features/auth/domain/constants/auth_failure_messages.dart';
import 'package:simpulagromobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:simpulagromobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:simpulagromobile/features/auth/domain/entities/user.dart';
import 'package:simpulagromobile/shared/widgets/info_state_widget.dart';
import 'package:simpulagromobile/features/dashboard/presentation/widgets/sensor_status_card.dart';
import 'package:simpulagromobile/features/agro/presentation/widgets/environmental_health_widget.dart';
import 'package:simpulagromobile/features/agro/domain/entities/agro_entity.dart';
import 'package:simpulagromobile/features/task/presentation/providers/task_provider.dart';
import 'package:simpulagromobile/features/task/domain/repositories/task_repository.dart';
import 'package:simpulagromobile/features/task/domain/entities/task.dart';
import 'package:simpulagromobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:simpulagromobile/features/forum/domain/repositories/forum_repository.dart';
import 'package:simpulagromobile/features/forum/domain/entities/post.dart';
import 'package:simpulagromobile/features/site/presentation/providers/site_provider.dart';

import 'package:simpulagromobile/core/error/failures.dart';
import 'package:simpulagromobile/l10n/app_localizations.dart';

// Mock Repository definitions
class MockAuthRepository extends Mock implements AuthRepository {}

class MockTaskRepository extends Mock implements TaskRepository {}

class MockForumRepository extends Mock implements ForumRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

Widget _localizedApp({required Widget home}) {
  return MaterialApp(
    locale: const Locale('id'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

Widget _localizedRouterApp({required GoRouter router}) {
  return MaterialApp.router(
    locale: const Locale('id'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: router,
  );
}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockTaskRepository mockTaskRepository;
  late MockForumRepository mockForumRepository;
  late MockSecureStorage mockSecureStorage;

  setUpAll(() {
    registerFallbackValue(TaskStatus.pending);
    registerFallbackValue(
      const Task(
        taskId: 'dummy',
        taskName: 'dummy',
        taskType: TaskType.watering,
        taskStatus: TaskStatus.pending,
        taskPriority: TaskPriority.medium,
      ),
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTaskRepository = MockTaskRepository();
    mockForumRepository = MockForumRepository();
    mockSecureStorage = MockSecureStorage();

    // Stub SecureStorage mock
    when(
      () => mockSecureStorage.getSelectedSiteId(),
    ).thenAnswer((_) async => 'SITE_001');
    when(
      () => mockSecureStorage.saveSelectedSiteId(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockSecureStorage.deleteSelectedSiteId(),
    ).thenAnswer((_) async {});
  });

  group('Scenario 1: Auth Credential Failure AlertDialog warning', () {
    testWidgets('Displays AlertDialog upon invalid login credentials', (
      WidgetTester tester,
    ) async {
      when(
        () => mockAuthRepository.login('invalid_user', 'wrong_pass'),
      ).thenAnswer(
        (_) async => const dz.Left(AuthFailure('Username atau Password salah')),
      );

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _localizedApp(home: const LoginScreen()),
        ),
      );

      // Verify page loaded
      expect(find.text("Masa Depan\nBertani, Hari Ini."), findsOneWidget);
      expect(find.text('Lupa Password?'), findsNothing);

      // Input invalid credentials
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      await tester.enterText(textFields.at(0), 'invalid_user');
      await tester.enterText(textFields.at(1), 'wrong_pass');

      // Click sign in button
      final signInButton = find.text('Masuk');
      await tester.tap(signInButton);

      // Let state notifier and dialogue show up
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify that AlertDialog was displayed with error message
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Gagal Login'), findsOneWidget);
      expect(find.text(AuthFailureMessages.invalidCredentials), findsOneWidget);

      // Verify we can dismiss it
      await tester.tap(find.text('OK'));
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Back button navigates to onboarding route', (
      WidgetTester tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Onboarding Route'))),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _localizedRouterApp(router: router),
        ),
      );

      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.tap(find.byKey(const Key('loginBackButton')));
      await tester.pumpAndSettle();

      expect(find.text('Onboarding Route'), findsOneWidget);
    });
  });

  group('Scenario 2: Auth Credential Success state transitions', () {
    test(
      'Authentication success updates state status to authenticated',
      () async {
        const mockUser = User(
          userId: 'USR_007',
          userName: 'Admin Agro',
          roleId: 'ROLE001',
        );

        when(
          () => mockAuthRepository.login('admin', 'password123'),
        ).thenAnswer((_) async => const dz.Right(mockUser));
        when(
          () => mockAuthRepository.getPermissions(),
        ).thenAnswer((_) async => const dz.Right(['read:site', 'write:site']));

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ],
        );

        final notifier = container.read(authProvider.notifier);
        expect(
          container.read(authProvider).status,
          equals(AuthStatus.unauthenticated),
        );

        final success = await notifier.login('admin', 'password123');

        expect(success, isTrue);
        expect(
          container.read(authProvider).status,
          equals(AuthStatus.authenticated),
        );
        expect(container.read(authProvider).user?.userId, equals('USR_007'));
        expect(container.read(authProvider).isAdmin, isTrue);
      },
    );
  });

  group('Scenario 3: Loading Card Widget skeleton shimmer rendering', () {
    testWidgets('LoadingCardWidget renders Shimmer animations', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingCardWidget(height: 120))),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('Scenario 4: Continuous Monitoring realtime alerts threshold logic', () {
    testWidgets(
      'SensorStatusCard reactively changes badge label and colors based on thresholds',
      (WidgetTester tester) async {
        // 1. Test Optimal threshold (>= 80)
        await tester.pumpWidget(
          _localizedApp(
            home: const Scaffold(
              body: SensorStatusCard(
                label: 'Suhu Udara',
                value: '28.5',
                unit: '°C',
                persentase: 85.0,
              ),
            ),
          ),
        );
        expect(find.text('Optimal'), findsOneWidget);
        expect(find.text('Suhu Udara'), findsOneWidget);
        expect(find.text('28.5'), findsOneWidget);

        // 2. Test Cukup threshold (60 - 79)
        await tester.pumpWidget(
          _localizedApp(
            home: const Scaffold(
              body: SensorStatusCard(
                label: 'Suhu Udara',
                value: '26.0',
                unit: '°C',
                persentase: 65.0,
              ),
            ),
          ),
        );
        expect(find.text('Cukup'), findsOneWidget);

        // 3. Test Kurang threshold (40 - 59)
        await tester.pumpWidget(
          _localizedApp(
            home: const Scaffold(
              body: SensorStatusCard(
                label: 'Suhu Udara',
                value: '22.0',
                unit: '°C',
                persentase: 45.0,
              ),
            ),
          ),
        );
        expect(find.text('Kurang'), findsOneWidget);

        // 4. Test Kritis threshold (< 40)
        await tester.pumpWidget(
          _localizedApp(
            home: const Scaffold(
              body: SensorStatusCard(
                label: 'Suhu Udara',
                value: '15.0',
                unit: '°C',
                persentase: 20.0,
              ),
            ),
          ),
        );
        expect(find.text('Kritis'), findsOneWidget);
      },
    );
  });

  group(
    'Scenario 5: EnvironmentalHealthWidget CircularPercentIndicator rendering',
    () {
      testWidgets(
        'Renders three circular percent indicators for VDP, GDD, and ETC metrics',
        (WidgetTester tester) async {
          const mockAgroData = AgroEntity(
            vdp: VdpEntity(vdp: 0.8),
            gdd: GddEntity(totalGDD: 2200),
            etc: [EtcDailyEntity(waterNeeds: 4.5)],
          );

          await tester.pumpWidget(
            _localizedApp(
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: EnvironmentalHealthWidget(agroData: mockAgroData),
                ),
              ),
            ),
          );

          // Check title and score details are rendered
          expect(find.text('Kesehatan Lingkungan'), findsOneWidget);
          expect(find.text('Skor Kesehatan Lingkungan'), findsOneWidget);
          expect(find.text('Sangat Baik'), findsOneWidget);

          // Check CircularPercentIndicator widgets (should be 3 of them)
          expect(find.byType(CircularPercentIndicator), findsNWidgets(3));
          expect(find.text('VPD'), findsOneWidget);
          expect(find.text('GDD'), findsOneWidget);
          expect(find.text('ETC'), findsOneWidget);
        },
      );
    },
  );

  group('Scenario 6: Task status PATCH updates and list invalidation', () {
    test(
      'updateTaskStatus successfully patches status, updates list and refreshes detail',
      () async {
        const initialTask = Task(
          taskId: 'TSK_001',
          taskName: 'Siram Tanaman',
          taskType: TaskType.watering,
          taskStatus: TaskStatus.pending,
          taskPriority: TaskPriority.medium,
          siteId: 'SITE_001',
        );

        const completedTask = Task(
          taskId: 'TSK_001',
          taskName: 'Siram Tanaman',
          taskType: TaskType.watering,
          taskStatus: TaskStatus.complite,
          taskPriority: TaskPriority.medium,
          siteId: 'SITE_001',
        );

        // Mock repo returning list of tasks
        when(
          () => mockTaskRepository.getTasks('SITE_001'),
        ).thenAnswer((_) async => const dz.Right([initialTask]));

        // Mock repo updateTaskStatus returning patched task
        when(
          () => mockTaskRepository.updateTaskStatus(
            'SITE_001',
            'TSK_001',
            TaskStatus.complite,
          ),
        ).thenAnswer((_) async => const dz.Right(completedTask));

        final container = ProviderContainer(
          overrides: [
            taskRepositoryProvider.overrideWithValue(mockTaskRepository),
            secureStorageProvider.overrideWithValue(mockSecureStorage),
            appStartupDataProvider.overrideWithValue(
              const AppStartupData(selectedSiteId: 'SITE_001'),
            ),
            selectedSiteIdProvider.overrideWithValue('SITE_001'),
          ],
        );

        // Trigger initial loading
        var tasks = await container.read(taskListProvider.future);
        expect(tasks.first.taskStatus, equals(TaskStatus.pending));

        // Execute status update PATCH
        final repository = container.read(taskRepositoryProvider);
        final result = await repository.updateTaskStatus(
          'SITE_001',
          'TSK_001',
          TaskStatus.complite,
        );

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Should have succeeded'), (updated) {
          expect(updated.taskStatus, equals(TaskStatus.complite));
        });

        // Invalidate provider to trigger refresh
        container.invalidate(taskListProvider);

        // Update getTasks mock to return completed task list after patch
        when(
          () => mockTaskRepository.getTasks('SITE_001'),
        ).thenAnswer((_) async => const dz.Right([completedTask]));

        tasks = await container.read(taskListProvider.future);
        expect(tasks.first.taskStatus, equals(TaskStatus.complite));
      },
    );
  });

  group('Scenario 7: Forum lazy pagination / infinite scroll', () {
    test(
      'ForumNotifier loadPosts fetches sequential pages and handles pagination flags',
      () async {
        final page1Posts = List.generate(
          20,
          (index) => Post(
            postId: 'POST_$index',
            postTitle: 'Title $index',
            userId: 'USR_001',
            postContent: 'Content $index',
            likeCount: 0,
            commentCount: 0,
            shareCount: 0,
            isLiked: false,
            createdAt: DateTime.now(),
            user: const PostUser(userId: 'USR_001', userName: 'John'),
          ),
        );

        final page2Posts = List.generate(
          5,
          (index) => Post(
            postId: 'POST_${index + 20}',
            postTitle: 'Title ${index + 20}',
            userId: 'USR_001',
            postContent: 'Content ${index + 20}',
            likeCount: 0,
            commentCount: 0,
            shareCount: 0,
            isLiked: false,
            createdAt: DateTime.now(),
            user: const PostUser(userId: 'USR_001', userName: 'John'),
          ),
        );

        when(
          () => mockForumRepository.getPaginatedPosts(page: 1, limit: 20),
        ).thenAnswer(
          (_) async => dz.Right(
            PaginatedResult.fromItems(
              page1Posts,
              page: 1,
              limit: 20,
              meta: const {'page': 1, 'limit': 20, 'total_pages': 2},
            ),
          ),
        );
        when(
          () => mockForumRepository.getPaginatedPosts(page: 2, limit: 20),
        ).thenAnswer(
          (_) async => dz.Right(
            PaginatedResult.fromItems(
              page2Posts,
              page: 2,
              limit: 20,
              meta: const {'page': 2, 'limit': 20, 'total_pages': 2},
            ),
          ),
        );

        final container = ProviderContainer(
          overrides: [
            forumRepositoryProvider.overrideWithValue(mockForumRepository),
          ],
        );

        final notifier = container.read(forumProvider.notifier);

        // Load Page 1
        await notifier.loadPosts(refresh: true);
        expect(container.read(forumProvider).posts.length, equals(20));
        expect(container.read(forumProvider).currentPage, equals(2));
        expect(container.read(forumProvider).hasMore, isTrue);

        // Load Page 2
        await notifier.loadPosts();
        expect(container.read(forumProvider).posts.length, equals(25));
        expect(container.read(forumProvider).currentPage, equals(3));
        // Page 2 has only 5 items (< 20 limit), so hasMore becomes false
        expect(container.read(forumProvider).hasMore, isFalse);
      },
    );
  });

  group(
    'Scenario 8 & 9 & 10: Critical offline connection handling & recommendations',
    () {
      test(
        'Maps socket timeout / offline exceptions to friendly network message',
        () async {
          // Offline/Timeout simulation throwing SocketException equivalent error
          when(() => mockAuthRepository.login('admin', 'timeout')).thenAnswer(
            (_) async =>
                const dz.Left(NetworkFailure('Tidak Ada Koneksi Internet')),
          );

          final container = ProviderContainer(
            overrides: [
              authRepositoryProvider.overrideWithValue(mockAuthRepository),
            ],
          );

          final notifier = container.read(authProvider.notifier);
          final result = await notifier.login('admin', 'timeout');

          expect(result, isFalse);
          expect(
            container.read(authProvider).error,
            equals(AuthFailureMessages.network),
          );
        },
      );

      test(
        'Expired session error handling maps correctly (Scenario 9)',
        () async {
          const mockUser = User(
            userId: 'USR_007',
            userName: 'Admin Agro',
            roleId: 'ROLE001',
          );

          when(
            () => mockAuthRepository.login('admin', 'password123'),
          ).thenAnswer((_) async => const dz.Right(mockUser));
          when(
            () => mockAuthRepository.getPermissions(),
          ).thenAnswer((_) async => const dz.Right(['read:site']));
          when(
            () => mockAuthRepository.logout(),
          ).thenAnswer((_) async => const dz.Right(null));

          final container = ProviderContainer(
            overrides: [
              authRepositoryProvider.overrideWithValue(mockAuthRepository),
            ],
          );

          final notifier = container.read(authProvider.notifier);

          // Login first to set status to authenticated
          await notifier.login('admin', 'password123');
          expect(
            container.read(authProvider).status,
            equals(AuthStatus.authenticated),
          );

          // Simulate session expiry trigger
          await notifier.handleSessionExpired();

          expect(
            container.read(authProvider).status,
            equals(AuthStatus.unauthenticated),
          );
          expect(
            container.read(authProvider).error,
            contains('Sesi Anda telah berakhir'),
          );
          verify(() => mockAuthRepository.logout()).called(1);
        },
      );
    },
  );
}
