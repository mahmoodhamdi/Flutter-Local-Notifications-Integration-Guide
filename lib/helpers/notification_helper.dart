import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Interface for notification services
abstract class INotificationService {
  Future<void> init();
  Future<void> showNotification(NotificationRequest request);
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotifications();
}

// Data class for notification requests
class NotificationRequest {
  final int id;
  final String title;
  final String body;
  final NotificationDetails details;
  final DateTime? scheduledDate;
  final RepeatInterval? repeatInterval;

  NotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.details,
    this.scheduledDate,
    this.repeatInterval,
  });
}

// Implementation of the notification service
class NotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _notifications;

  NotificationService(this._notifications);

  @override
  Future<void> init() async {
    try {
      const androidSettings =
          AndroidInitializationSettings("@mipmap/ic_launcher");
      const initSettings = InitializationSettings(android: androidSettings);
      await _notifications.initialize(initSettings);
      tz.initializeTimeZones();
    } catch (e) {
      log("Error initializing notifications: $e");
    }
  }

  @override
  Future<void> showNotification(NotificationRequest request) async {
    try {
      if (request.scheduledDate != null) {
        await _showScheduledNotification(request);
      } else if (request.repeatInterval != null) {
        await _showRepeatingNotification(request);
      } else {
        await _showImmediateNotification(request);
      }
      log("Notification shown: ${request.title}");
    } catch (e) {
      log("Error showing notification: $e");
    }
  }

  Future<void> _showImmediateNotification(NotificationRequest request) async {
    await _notifications.show(
      request.id,
      request.title,
      request.body,
      request.details,
    );
  }

  Future<void> _showScheduledNotification(NotificationRequest request) async {
    await _notifications.zonedSchedule(
      request.id,
      request.title,
      request.body,
      tz.TZDateTime.from(request.scheduledDate!, tz.local),
      request.details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _showRepeatingNotification(NotificationRequest request) async {
    await _notifications.periodicallyShow(
      request.id,
      request.title,
      request.body,
      request.repeatInterval!,
      request.details,
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
      log("Notification canceled: ID $id");
    } catch (e) {
      log("Error canceling notification: $e");
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      log("All notifications canceled");
    } catch (e) {
      log("Error canceling all notifications: $e");
    }
  }
}

// Factory for creating notification details
class NotificationDetailsFactory {
  static NotificationDetails create({
    required String channelId,
    required String channelName,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
    bool silent = false,
    AndroidNotificationSound? sound,
  }) {
    var androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: importance,
      priority: priority,
      silent: silent,
      sound:
          sound ?? RawResourceAndroidNotificationSound('yaamsallyallaelnaby'),
    );
    return NotificationDetails(android: androidDetails);
  }
}

// Helper class for easy access to common notification configurations
class NotificationHelper {
  static final INotificationService _service =
      NotificationService(FlutterLocalNotificationsPlugin());

  static Future<void> init() => _service.init();

  static Future<void> showBasicNotification({
    required String title,
    required String body,
    int id = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
  }) async {
    final details = NotificationDetailsFactory.create(
      channelId: "basic_notification",
      channelName: "My Basic Channel",
      importance: importance,
      priority: priority,
      silent: silent,
    );

    final request = NotificationRequest(
      id: id,
      title: title,
      body: body,
      details: details,
    );

    await _service.showNotification(request);
  }

  static Future<void> showRepeatingNotification({
    required String title,
    required String body,
    int id = 0,
    RepeatInterval repeatInterval = RepeatInterval.everyMinute,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
  }) async {
    final details = NotificationDetailsFactory.create(
      channelId: "repeating_notification",
      channelName: "My Repeating Channel",
      importance: importance,
      priority: priority,
      silent: silent,
    );

    final request = NotificationRequest(
      id: id,
      title: title,
      body: body,
      details: details,
      repeatInterval: repeatInterval,
    );

    await _service.showNotification(request);
  }

  static Future<void> showScheduledNotification({
    required String title,
    required String body,
    required Duration delay,
    int id = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
  }) async {
    final details = NotificationDetailsFactory.create(
      channelId: "schedule_notification",
      channelName: "My Schedule Channel",
      importance: importance,
      priority: priority,
      silent: silent,
    );

    final request = NotificationRequest(
      id: id,
      title: title,
      body: body,
      details: details,
      scheduledDate: DateTime.now().add(delay),
    );

    await _service.showNotification(request);
  }

  static Future<void> cancelNotification(int id) =>
      _service.cancelNotification(id);

  static Future<void> cancelAllNotifications() =>
      _service.cancelAllNotifications();
}
