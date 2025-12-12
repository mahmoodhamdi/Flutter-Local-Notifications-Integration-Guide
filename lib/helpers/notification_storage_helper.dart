import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications_feature/models/notification_record.dart';

/// Helper class for storing and retrieving notification history.
class NotificationStorageHelper {
  static const String _storageKey = 'notification_history';
  static const int _maxRecords = 100;

  /// Save a notification record to history.
  static Future<void> saveNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    required String type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getNotificationHistory();

      final newRecord = NotificationRecord(
        id: id,
        title: title,
        body: body,
        payload: payload,
        timestamp: DateTime.now(),
        type: type,
      );

      records.insert(0, newRecord);

      // Keep only the last _maxRecords
      if (records.length > _maxRecords) {
        records.removeRange(_maxRecords, records.length);
      }

      final jsonList = records.map((r) => r.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));

      log('Notification saved to history: $title');
    } catch (e) {
      log('Error saving notification to history: $e');
    }
  }

  /// Get all notification history records.
  static Future<List<NotificationRecord>> getNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => NotificationRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error getting notification history: $e');
      return [];
    }
  }

  /// Mark a notification as read.
  static Future<void> markAsRead(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getNotificationHistory();

      final index = records.indexWhere((r) => r.id == id);
      if (index != -1) {
        records[index] = records[index].copyWith(wasRead: true);

        final jsonList = records.map((r) => r.toJson()).toList();
        await prefs.setString(_storageKey, jsonEncode(jsonList));

        log('Notification marked as read: ID $id');
      }
    } catch (e) {
      log('Error marking notification as read: $e');
    }
  }

  /// Delete a specific notification from history.
  static Future<void> deleteNotification(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getNotificationHistory();

      records.removeWhere((r) => r.id == id);

      final jsonList = records.map((r) => r.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));

      log('Notification deleted from history: ID $id');
    } catch (e) {
      log('Error deleting notification from history: $e');
    }
  }

  /// Clear all notification history.
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      log('Notification history cleared');
    } catch (e) {
      log('Error clearing notification history: $e');
    }
  }

  /// Get unread notification count.
  static Future<int> getUnreadCount() async {
    final records = await getNotificationHistory();
    return records.where((r) => !r.wasRead).length;
  }

  /// Get notifications by type.
  static Future<List<NotificationRecord>> getNotificationsByType(
    String type,
  ) async {
    final records = await getNotificationHistory();
    return records.where((r) => r.type == type).toList();
  }

  /// Search notifications by title or body.
  static Future<List<NotificationRecord>> searchNotifications(
    String query,
  ) async {
    final records = await getNotificationHistory();
    final lowerQuery = query.toLowerCase();
    return records
        .where((r) =>
            r.title.toLowerCase().contains(lowerQuery) ||
            r.body.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
