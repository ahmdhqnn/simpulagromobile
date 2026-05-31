const int maxHistoryRangeDays = 31;

List<T> sampleForChart<T>(List<T> items, {required int maxPoints}) {
  if (maxPoints <= 0) return <T>[];
  if (items.length <= maxPoints) return List<T>.of(items);
  if (maxPoints == 1) return <T>[items.last];

  final sampled = <T>[];
  final step = (items.length - 1) / (maxPoints - 1);

  for (var i = 0; i < maxPoints; i++) {
    final index = (i * step).round().clamp(0, items.length - 1);
    sampled.add(items[index]);
  }

  return sampled;
}

DateTime boundedHistoryStartDate(
  DateTime start,
  DateTime end, {
  int maxDays = maxHistoryRangeDays,
}) {
  if (start.isAfter(end)) return end;

  final maxDuration = Duration(days: maxDays);
  if (end.difference(start) <= maxDuration) return start;

  return end.subtract(maxDuration);
}

DateTime maxHistoryEndDate(
  DateTime start,
  DateTime now, {
  int maxDays = maxHistoryRangeDays,
}) {
  final maxEnd = start.add(Duration(days: maxDays));
  return maxEnd.isAfter(now) ? now : maxEnd;
}

Duration monitoringStaleThreshold(Duration refreshInterval) {
  return Duration(microseconds: refreshInterval.inMicroseconds * 2);
}

bool isMonitoringStale({
  required DateTime? lastUpdated,
  required DateTime now,
  required Duration refreshInterval,
}) {
  if (lastUpdated == null) return false;
  return now.difference(lastUpdated) >
      monitoringStaleThreshold(refreshInterval);
}
