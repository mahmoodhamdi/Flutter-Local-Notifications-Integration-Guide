import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Helper class for managing notification permissions across platforms.
class PermissionHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Request all necessary notification permissions.
  /// Returns true if permissions are granted.
  static Future<bool> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      return await _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      return await _requestIOSPermissions();
    }
    return true;
  }

  /// Request Android-specific permissions using flutter_local_notifications.
  static Future<bool> _requestAndroidPermissions() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      log('Android plugin not available');
      return false;
    }

    // Request notification permission (Android 13+)
    final notificationGranted = await androidPlugin.requestNotificationsPermission();
    log('Notification permission granted: $notificationGranted');

    if (notificationGranted != true) {
      return false;
    }

    // Request exact alarm permission
    final exactAlarmGranted = await androidPlugin.requestExactAlarmsPermission();
    log('Exact alarm permission granted: $exactAlarmGranted');

    return true;
  }

  /// Request iOS-specific permissions.
  static Future<bool> _requestIOSPermissions() async {
    final iosPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin == null) {
      log('iOS plugin not available');
      return false;
    }

    final granted = await iosPlugin.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    log('iOS notification permission granted: $granted');
    return granted ?? false;
  }

  /// Check if notification permissions are granted.
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    } else if (Platform.isIOS) {
      // For iOS, check using the plugin
      return true;
    }
    return false;
  }

  /// Check if exact alarm permission is granted (Android only).
  static Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    return await androidPlugin.canScheduleExactNotifications() ?? false;
  }
}
