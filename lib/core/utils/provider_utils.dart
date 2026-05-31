import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/failures.dart';

extension AutoRetryRef on Ref {
  /// Executes an async function. If it throws an error/exception, schedules
  /// an automatic retry (invalidation of the provider) after [delay].
  Future<T> retryOnError<T>(
    FutureOr<T> Function() fetch, {
    Duration delay = const Duration(seconds: 5),
  }) async {
    try {
      return await fetch();
    } catch (e) {
      final retryDelay = _retryDelayFor(e, delay);
      if (retryDelay != null) {
        final timer = Timer(retryDelay, () {
          invalidateSelf();
        });
        onDispose(timer.cancel);
      }
      rethrow;
    }
  }

  Duration? _retryDelayFor(Object error, Duration fallbackDelay) {
    if (error is NetworkFailure) {
      return fallbackDelay < const Duration(seconds: 15)
          ? const Duration(seconds: 15)
          : fallbackDelay;
    }

    // Do not retry backend 4xx/5xx failures from UI providers. Realtime ticks
    // and manual retry are enough, and retrying server failures can amplify 500s.
    if (error is Failure) return null;

    return fallbackDelay;
  }
}
