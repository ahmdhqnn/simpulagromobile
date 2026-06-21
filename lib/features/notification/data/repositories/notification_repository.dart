import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/notification.dart';

class NotificationRepository {
  static const String _storageKey = 'local_notifications_v1';

  Future<List<AppNotification>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr == null) return [];

      final List<dynamic> decoded = jsonDecode(jsonStr);
      final list = decoded
          .map((item) => AppNotification.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      // Filter out notifications older than 24 hours
      final now = DateTime.now();
      final filteredList = list.where((notification) {
        return now.difference(notification.timestamp).inHours < 24;
      }).toList();

      // If we filtered out some items, update the local storage
      if (filteredList.length < list.length) {
        await saveNotifications(filteredList);
      }

      // Sort notifications by timestamp descending (newest first)
      filteredList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return filteredList;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveNotifications(List<AppNotification> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(notifications.map((n) => n.toJson()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (_) {
      // Fail silently
    }
  }

  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (_) {
      // Fail silently
    }
  }
}
