import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/notification.dart';
import '../../data/repositories/notification_repository.dart';
import '../../../recommendation/domain/entities/recommendation.dart';
import '../../../site/domain/entities/site.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../task/domain/entities/task.dart';
import '../../../task/presentation/providers/task_provider.dart';
import '../../../recommendation/presentation/providers/recommendation_hub_provider.dart';
import '../../../forum/domain/entities/post.dart';
import '../../../forum/presentation/providers/forum_provider.dart';
import '../../../dashboard/domain/entities/dashboard_entity.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final newNotificationEventProvider = StateProvider<AppNotification?>(
  (ref) => null,
);

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  final Ref _ref;
  final NotificationRepository _repository;

  Set<String> _seenIds = {};
  Map<String, (int, int)> _forumPostStats = {}; // postId -> (likes, comments)
  bool _isInitialized = false;

  NotificationNotifier(this._ref, this._repository) : super(const []);

  Future<void> loadNotifications() async {
    final list = await _repository.getNotifications();
    state = _sortNotifications(list);

    // Load seen IDs and forum stats from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _seenIds = (prefs.getStringList('local_seen_ids_v1') ?? []).toSet();

    final statsJson = prefs.getString('local_forum_stats_v1');
    if (statsJson != null) {
      try {
        final Map<String, dynamic> decoded = Map<String, dynamic>.from(
          jsonDecode(statsJson),
        );
        _forumPostStats = decoded.map((key, value) {
          final list = value as List;
          return MapEntry(key, (list[0] as int, list[1] as int));
        });
      } catch (_) {}
    }

    _isInitialized = true;
  }

  Future<void> _saveSeenIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('local_seen_ids_v1', _seenIds.toList());
  }

  Future<void> _saveForumStats() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _forumPostStats.map(
      (key, value) => MapEntry(key, [value.$1, value.$2]),
    );
    await prefs.setString('local_forum_stats_v1', jsonEncode(encoded));
  }

  void addNotification(AppNotification notification) {
    final newState = _sortNotifications([notification, ...state]);
    state = newState;
    _repository.saveNotifications(newState);

    // Emit event for in-app floating banner popup
    _ref.read(newNotificationEventProvider.notifier).state = notification;
  }

  void markAsRead(String id) {
    final newState = _sortNotifications(
      state.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList(),
    );
    state = newState;
    _repository.saveNotifications(newState);
  }

  void markAllAsRead() {
    final newState = _sortNotifications(
      state.map((n) => n.copyWith(isRead: true)).toList(),
    );
    state = newState;
    _repository.saveNotifications(newState);
  }

  void clearAll() {
    state = [];
    _repository.clearAll();
  }

  bool _isRecent(DateTime? timestamp) {
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp.toLocal()).inHours < 2;
  }

  List<AppNotification> _sortNotifications(
    List<AppNotification> notifications,
  ) {
    return [...notifications]..sort((left, right) {
      if (left.isRead != right.isRead) {
        return left.isRead ? 1 : -1;
      }
      return right.timestamp.compareTo(left.timestamp);
    });
  }

  // --- Detector Methods ---

  void checkForNewSites(List<Site> sites) {
    if (!_isInitialized) return;

    bool hasNew = false;
    final isFirstRun = _seenIds.isEmpty;

    for (final site in sites) {
      final id = site.siteId;
      if (!_seenIds.contains(id)) {
        _seenIds.add(id);
        hasNew = true;

        if (!isFirstRun && _isRecent(site.siteCreated)) {
          final notification = AppNotification(
            id: 'site_${id}_${DateTime.now().millisecondsSinceEpoch}',
            type: NotificationType.siteInvite,
            title: 'Undangan Site Baru',
            body: 'Anda sekarang dapat mengakses site "${site.displayName}"',
            timestamp: DateTime.now(),
            isRead: false,
            redirectPath: '/site/$id',
          );
          addNotification(notification);
        }
      }
    }

    if (hasNew) {
      _saveSeenIds();
    }
  }

  void checkForNewTasks(List<Task> tasks) {
    if (!_isInitialized) return;

    bool hasNew = false;
    final isFirstRun = _seenIds.isEmpty;

    for (final task in tasks) {
      final id = task.taskId;
      if (!_seenIds.contains(id)) {
        _seenIds.add(id);
        hasNew = true;

        if (!isFirstRun && _isRecent(task.createdAt)) {
          final notification = AppNotification(
            id: 'task_${id}_${DateTime.now().millisecondsSinceEpoch}',
            type: NotificationType.taskAssignment,
            title: 'Tugas Baru Ditugaskan',
            body: 'Tugas "${task.taskName}" telah ditambahkan ke jadwal Anda',
            timestamp: DateTime.now(),
            isRead: false,
            redirectPath: '/task/$id',
          );
          addNotification(notification);
        }
      }
    }

    if (hasNew) {
      _saveSeenIds();
    }
  }

  void checkForNewRecommendations(RecommendationDashboardSnapshot snapshot) {
    if (!_isInitialized) return;

    bool hasNew = false;
    final isFirstRun = _seenIds.isEmpty;

    hasNew =
        _checkRecommendationScope(
          scope: RecommendationScope.site,
          items: snapshot.siteItems,
          title: 'Rekomendasi Aksi',
          isFirstRun: isFirstRun,
        ) ||
        hasNew;
    hasNew =
        _checkRecommendationScope(
          scope: RecommendationScope.plant,
          items: snapshot.plantItems,
          title: 'Rekomendasi Tanaman',
          isFirstRun: isFirstRun,
        ) ||
        hasNew;
    hasNew =
        _checkRecommendationScope(
          scope: RecommendationScope.phase,
          items: snapshot.phaseSnapshot.items,
          title: 'Rekomendasi Fase Aktif',
          isFirstRun: isFirstRun,
        ) ||
        hasNew;

    if (hasNew) {
      _saveSeenIds();
    }
  }

  bool _checkRecommendationScope({
    required RecommendationScope scope,
    required List<Recommendation> items,
    required String title,
    required bool isFirstRun,
  }) {
    bool hasNew = false;

    for (final recommendation in items) {
      final seenKey = _recommendationSeenKey(scope, recommendation);
      if (_seenIds.contains(seenKey)) continue;

      _seenIds.add(seenKey);
      hasNew = true;

      if (!isFirstRun) {
        final notification = AppNotification(
          id: '${seenKey}_${DateTime.now().microsecondsSinceEpoch}',
          type: NotificationType.recommendation,
          title: title,
          body: recommendation.title,
          timestamp: DateTime.now(),
          isRead: false,
          redirectPath: '/recommendations?scope=${scope.queryValue}',
        );
        addNotification(notification);
      }
    }

    return hasNew;
  }

  String _recommendationSeenKey(
    RecommendationScope scope,
    Recommendation recommendation,
  ) {
    final id = recommendation.recommendationId.trim();
    if (id.isNotEmpty) return 'rec:${scope.queryValue}:$id';

    final createdAt = recommendation.createdAt?.toUtc().toIso8601String();
    return [
      'rec',
      scope.queryValue,
      recommendation.siteId?.trim() ?? '',
      recommendation.plantId?.trim() ?? '',
      recommendation.title.trim(),
      createdAt ?? 'no-date',
    ].join(':');
  }

  void checkForForumInteractions(List<Post> posts) {
    if (!_isInitialized) return;

    final currentUser = _ref.read(authProvider).user;
    if (currentUser == null) return;

    bool hasChanges = false;

    for (final post in posts) {
      final isOwnPost = post.userId == currentUser.userId;

      if (isOwnPost) {
        final lastStats = _forumPostStats[post.postId];
        if (lastStats != null) {
          final (lastLikes, lastComments) = lastStats;

          if (post.likeCount > lastLikes) {
            final notification = AppNotification(
              id: 'like_${post.postId}_${DateTime.now().millisecondsSinceEpoch}',
              type: NotificationType.forumInteraction,
              title: 'Postingan Anda Disukai',
              body: 'Seseorang menyukai postingan Anda: "${post.postTitle}"',
              timestamp: DateTime.now(),
              isRead: false,
              redirectPath: '/forum/post/${post.postId}',
            );
            addNotification(notification);
            hasChanges = true;
          }

          if (post.commentCount > lastComments) {
            final notification = AppNotification(
              id: 'comment_${post.postId}_${DateTime.now().millisecondsSinceEpoch}',
              type: NotificationType.forumInteraction,
              title: 'Komentar Baru',
              body:
                  'Seseorang mengomentari postingan Anda: "${post.postTitle}"',
              timestamp: DateTime.now(),
              isRead: false,
              redirectPath: '/forum/post/${post.postId}',
            );
            addNotification(notification);
            hasChanges = true;
          }
        }

        // Update stats
        _forumPostStats[post.postId] = (post.likeCount, post.commentCount);
        hasChanges = true;
      }
    }

    if (hasChanges) {
      _saveForumStats();
    }
  }

  void checkForSensorAlerts(EnvironmentalHealthEntity health) {
    if (!_isInitialized) return;

    bool hasNew = false;
    final isFirstRun = _seenIds.isEmpty;

    for (final sensor in health.sensors) {
      final stateKey = '${sensor.dsId}_${sensor.devId}_alert';

      if (sensor.persentase < 60) {
        if (!_seenIds.contains(stateKey)) {
          _seenIds.add(stateKey);
          hasNew = true;

          if (!isFirstRun) {
            final notification = AppNotification(
              id: 'alert_${sensor.dsId}_${DateTime.now().millisecondsSinceEpoch}',
              type: NotificationType.deviceAlert,
              title: 'Peringatan Sensor ${sensor.label}',
              body:
                  'Kondisi sensor ${sensor.label} terdeteksi tidak optimal (${sensor.readUpdateValue}${sensor.unit})',
              timestamp: DateTime.now(),
              isRead: false,
              redirectPath: '/',
            );
            addNotification(notification);
          }
        }
      } else {
        if (_seenIds.contains(stateKey)) {
          _seenIds.remove(stateKey);
          hasNew = true;
        }
      }
    }

    if (hasNew) {
      _saveSeenIds();
    }
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<AppNotification>>((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      final notifier = NotificationNotifier(ref, repository);

      // Load initial state
      notifier.loadNotifications();

      // Passive Listening to siteListProvider
      ref.listen<AsyncValue<List<Site>>>(siteListProvider, (prev, next) {
        next.whenData((sites) {
          notifier.checkForNewSites(sites);
        });
      });

      // Passive Listening to taskListProvider
      ref.listen<AsyncValue<List<Task>>>(taskListProvider, (prev, next) {
        next.whenData((tasks) {
          notifier.checkForNewTasks(tasks);
        });
      });

      // Passive Listening to recommendationHubDashboardSnapshotProvider
      ref.listen<AsyncValue<RecommendationDashboardSnapshot>>(
        recommendationHubDashboardSnapshotProvider,
        (prev, next) {
          next.whenData((snapshot) {
            notifier.checkForNewRecommendations(snapshot);
          });
        },
      );

      // Passive Listening to forumProvider
      ref.listen<ForumState>(forumProvider, (prev, next) {
        if (!next.isLoading && next.posts.isNotEmpty) {
          notifier.checkForForumInteractions(next.posts);
        }
      });

      // Passive Listening to environmentalHealthProvider
      ref.listen<AsyncValue<EnvironmentalHealthEntity?>>(
        environmentalHealthProvider,
        (prev, next) {
          next.whenData((health) {
            if (health != null) {
              notifier.checkForSensorAlerts(health);
            }
          });
        },
      );

      return notifier;
    });

// A provider for count of unread notifications
final unreadNotificationCountProvider = Provider<int>((ref) {
  final list = ref.watch(notificationProvider);
  return list.where((n) => !n.isRead).length;
});
