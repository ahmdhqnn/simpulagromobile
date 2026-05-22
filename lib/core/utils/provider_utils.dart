import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      final timer = Timer(delay, () {
        invalidateSelf();
      });
      onDispose(timer.cancel);
      rethrow;
    }
  }
}
