import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Default custom notification sound name (without extension).
const String kDefaultSoundName = 'yaamsallyallaelnaby';

/// Helper class for managing local notifications across platforms.
class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  /// Stream controller for notification tap responses.
  /// Using broadcast to allow multiple listeners.
  static final StreamController<NotificationResponse>
      notificationResponseController =
      StreamController<NotificationResponse>.broadcast();

  /// Flag to track initialization status.
  static bool _isInitialized = false;

  /// Initialize the notification settings and time zones.
  static Future<void> init() async {
    if (_isInitialized) {
      log('NotificationHelper already initialized');
      return;
    }

    try {
      // Android initialization settings
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false, // We'll request manually
        requestBadgePermission: false,
        requestSoundPermission: false,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );

      // Combined initialization settings
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notification.initialize(
        initSettings,
        onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Initialize timezone data
      tz.initializeTimeZones();

      _isInitialized = true;
      log('NotificationHelper initialized successfully');
    } catch (e) {
      log('Error initializing notifications: $e');
    }
  }

  /// Callback for notification tap events.
  /// This is a top-level function to support background notifications.
  @pragma('vm:entry-point')
  static void _onNotificationTap(NotificationResponse notificationResponse) {
    notificationResponseController.add(notificationResponse);
  }

  /// Dispose of resources. Call this when the app is closing.
  static Future<void> dispose() async {
    await notificationResponseController.close();
    _isInitialized = false;
    log('NotificationHelper disposed');
  }

  /// Show a basic notification with required title and body.
  static Future<void> showBasicNotification({
    required String title,
    required String body,
    int id = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
    String? payload,
    String? soundName,
  }) async {
    try {
      await _notification.show(
        id,
        title,
        body,
        payload: payload,
        _buildNotificationDetails(
          channelId: 'basic_notification',
          channelName: 'Basic Notifications',
          channelDescription: 'Channel for basic notifications',
          importance: importance,
          priority: priority,
          silent: silent,
          soundName: soundName,
        ),
      );
      log('Basic notification shown: $title');
    } catch (e) {
      log('Error showing basic notification: $e');
    }
  }

  /// Show a repeating notification at specified interval.
  static Future<void> showRepeatingNotification({
    required String title,
    required String body,
    int id = 0,
    RepeatInterval repeatInterval = RepeatInterval.everyMinute,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
    String? payload,
    String? soundName,
  }) async {
    try {
      await _notification.periodicallyShow(
        id,
        title,
        body,
        repeatInterval,
        payload: payload,
        _buildNotificationDetails(
          channelId: 'repeating_notification',
          channelName: 'Repeating Notifications',
          channelDescription: 'Channel for repeating notifications',
          importance: importance,
          priority: priority,
          silent: silent,
          soundName: soundName,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      log('Repeating notification shown: $title');
    } catch (e) {
      log('Error showing repeating notification: $e');
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
    String? payload,
    String? soundName,
  }) async {
    try {
      final scheduledDate = tz.TZDateTime.now(tz.local).add(delay);

      await _notification.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        _buildNotificationDetails(
          channelId: 'schedule_notification',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          importance: importance,
          priority: priority,
          silent: silent,
          soundName: soundName ?? kDefaultSoundName,
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      log('Scheduled notification for: $scheduledDate');
    } catch (e) {
      log('Error scheduling notification: $e');
    }
  }

  /// Schedule a notification at a specific date and time.
  static Future<void> scheduleNotificationAt({
    required String title,
    required String body,
    required DateTime dateTime,
    int id = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool silent = false,
    String? payload,
    String? soundName,
  }) async {
    try {
      final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        log('Cannot schedule notification in the past');
        return;
      }

      await _notification.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        _buildNotificationDetails(
          channelId: 'schedule_notification',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          importance: importance,
          priority: priority,
          silent: silent,
          soundName: soundName ?? kDefaultSoundName,
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      log('Scheduled notification at: $scheduledDate');
    } catch (e) {
      log('Error scheduling notification: $e');
    }
  }

  /// Cancel a specific notification by its ID.
  static Future<void> cancelNotification(int id) async {
    try {
      await _notification.cancel(id);
      log('Notification canceled: ID $id');
    } catch (e) {
      log('Error canceling notification: $e');
    }
  }

  /// Cancel all notifications.
  static Future<void> cancelAllNotifications() async {
    try {
      await _notification.cancelAll();
      log('All notifications canceled');
    } catch (e) {
      log('Error canceling all notifications: $e');
    }
  }

  /// Get list of pending notifications.
  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    try {
      return await _notification.pendingNotificationRequests();
    } catch (e) {
      log('Error getting pending notifications: $e');
      return [];
    }
  }

  /// Get list of active notifications (shown but not dismissed).
  static Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      return await _notification.getActiveNotifications();
    } catch (e) {
      log('Error getting active notifications: $e');
      return [];
    }
  }

  /// Helper function to build notification details for both platforms.
  static NotificationDetails _buildNotificationDetails({
    required String channelId,
    required String channelName,
    String? channelDescription,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
    bool silent = false,
    String? soundName,
  }) {
    // Android notification details
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      silent: silent,
      playSound: !silent && soundName != null,
      sound: soundName != null
          ? RawResourceAndroidNotificationSound(soundName)
          : null,
      enableVibration: !silent,
      icon: '@mipmap/ic_launcher',
    );

    // iOS notification details
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: !silent,
      sound: soundName != null ? '$soundName.aiff' : null,
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }
}
