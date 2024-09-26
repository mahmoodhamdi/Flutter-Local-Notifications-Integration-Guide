import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification settings and time zones.
  static Future<void> init() async {
    try {
      const androidSettings =
          AndroidInitializationSettings("@mipmap/ic_launcher");
      const initSettings = InitializationSettings(android: androidSettings);
      await _notification.initialize(initSettings);
      tz.initializeTimeZones();
    } catch (e) {
      log("Error initializing notifications: $e");
    }
  }

  /// Show a basic notification with required title and body.
  static Future<void> showBasicNotification({
    required String title,
    required String body,
    int id = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
  }) async {
    try {
      await _notification.show(
        id,
        title,
        body,
        _buildNotificationDetails(
          channelId: "basic_notification",
          channelName: "My Basic Channel",
          importance: importance,
          priority: priority,
          silent: silent,
        ),
      );
      log("Basic notification shown: $title");
    } catch (e) {
      log("Error showing basic notification: $e");
    }
  }

  /// Show a repeating notification every minute.
  static Future<void> showRepeatingNotification({
    required String title,
    required String body,
    int id = 0,
    RepeatInterval repeatInterval = RepeatInterval.everyMinute,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
  }) async {
    try {
      await _notification.periodicallyShow(
        id,
        title,
        body,
        repeatInterval,
        _buildNotificationDetails(
          channelId: "repeating_notification",
          channelName: "My Repeating Channel",
          importance: importance,
          priority: priority,
          silent: silent,
        ),
      );
      log("Repeating notification shown: $title");
    } catch (e) {
      log("Error showing repeating notification: $e");
    }
  }

  /// Show a scheduled notification after a delay.
  static Future<void> showScheduleNotification({
    required String title,
    required String body,
    required Duration delay,
    int id = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
  }) async {
    try {
      await _notification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(delay),
        _buildNotificationDetails(
          channelId: "schedule_notification",
          channelName: "My Schedule Channel",
          importance: importance,
          priority: priority,
          silent: silent,
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      log("Scheduled notification shown: $title");
    } catch (e) {
      log("Error scheduling notification: $e");
    }
  }

  /// Cancel a specific notification by its ID.
  static Future<void> cancelNotification(int id) async {
    try {
      await _notification.cancel(id);
      log("Notification canceled: ID $id");
    } catch (e) {
      log("Error canceling notification: $e");
    }
  }

  /// Cancel all notifications.
  static Future<void> cancelAllNotifications() async {
    try {
      await _notification.cancelAll();
      log("All notifications canceled");
    } catch (e) {
      log("Error canceling all notifications: $e");
    }
  }

  /// Show a recurring notification with a customizable schedule (e.g., days, weeks).
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    int id = 0,
    int seconds = 0,
    int minutes = 0,
    int hours = 0,
    int days = 0,
    int weeks = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
  }) async {
    final totalDuration = Duration(
      seconds: seconds,
      minutes: minutes,
      hours: hours,
      days: days + (weeks * 7),
    );

    try {
      await showScheduleNotification(
        title: title,
        body: body,
        delay: totalDuration,
        id: id,
        importance: importance,
        priority: priority,
        silent: silent,
      );
      log("Scheduled notification created: $title");
    } catch (e) {
      log("Error scheduling recurring notification: $e");
    }
  }

  /// Helper function to build common notification details.
  static NotificationDetails _buildNotificationDetails({
    required String channelId,
    required String channelName,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
    bool silent = false,
    AndroidNotificationSound? sound,
  }) {
    var androidDetails = AndroidNotificationDetails(
      sound: sound ??
          RawResourceAndroidNotificationSound(
              'yaamsallyallaelnaby.mp3'.split('.').first),
      channelId,
      channelName,
      importance: importance,
      priority: priority,
      silent: silent,
    );
    return NotificationDetails(android: androidDetails);
  }
}
