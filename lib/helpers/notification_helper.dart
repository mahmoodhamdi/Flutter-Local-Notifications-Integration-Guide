import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_feature/helpers/notification_storage_helper.dart';
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

      // Save to history
      await NotificationStorageHelper.saveNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
        type: 'basic',
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

      // Save to history
      await NotificationStorageHelper.saveNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
        type: 'repeating',
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

      // Save to history
      await NotificationStorageHelper.saveNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
        type: 'scheduled',
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

  /// Show a notification with a big picture (image).
  /// [bigPicturePath] should be a file path on the device.
  /// For drawable resources, use [showBigPictureFromDrawable].
  static Future<void> showBigPictureNotification({
    required String title,
    required String body,
    required String bigPicturePath,
    int id = 0,
    String? payload,
    String? summaryText,
    bool hideExpandedLargeIcon = false,
  }) async {
    try {
      final BigPictureStyleInformation bigPictureStyle =
          BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        contentTitle: title,
        summaryText: summaryText ?? body,
        hideExpandedLargeIcon: hideExpandedLargeIcon,
      );

      final androidDetails = AndroidNotificationDetails(
        'big_picture_notification',
        'Big Picture Notifications',
        channelDescription: 'Channel for notifications with images',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyle,
        icon: '@mipmap/ic_launcher',
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await _notification.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload,
      );

      log('Big picture notification shown: $title');
    } catch (e) {
      log('Error showing big picture notification: $e');
    }
  }

  /// Show a notification with a big picture from drawable resources.
  /// [drawableName] is the name of the drawable in res/drawable folder.
  static Future<void> showBigPictureFromDrawable({
    required String title,
    required String body,
    required String drawableName,
    int id = 0,
    String? payload,
    String? summaryText,
  }) async {
    try {
      final BigPictureStyleInformation bigPictureStyle =
          BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(drawableName),
        contentTitle: title,
        summaryText: summaryText ?? body,
      );

      final androidDetails = AndroidNotificationDetails(
        'big_picture_notification',
        'Big Picture Notifications',
        channelDescription: 'Channel for notifications with images',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyle,
        largeIcon: DrawableResourceAndroidBitmap(drawableName),
        icon: '@mipmap/ic_launcher',
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await _notification.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload,
      );

      log('Big picture from drawable shown: $title');
    } catch (e) {
      log('Error showing big picture notification: $e');
    }
  }

  /// Show a notification with progress bar.
  static Future<void> showProgressNotification({
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
    int id = 0,
    bool indeterminate = false,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'progress_notification',
        'Progress Notifications',
        channelDescription: 'Channel for progress notifications',
        importance: Importance.low,
        priority: Priority.low,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress,
        indeterminate: indeterminate,
        ongoing: progress < maxProgress,
        autoCancel: progress >= maxProgress,
        icon: '@mipmap/ic_launcher',
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
      );

      await _notification.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
      );

      log('Progress notification shown: $progress/$maxProgress');
    } catch (e) {
      log('Error showing progress notification: $e');
    }
  }

  /// Action IDs for notification buttons
  static const String actionReply = 'reply_action';
  static const String actionMarkRead = 'mark_read_action';
  static const String actionDismiss = 'dismiss_action';

  /// Show a notification with action buttons.
  /// Actions are only supported on Android.
  static Future<void> showNotificationWithActions({
    required String title,
    required String body,
    int id = 0,
    String? payload,
    bool showReplyAction = true,
    bool showMarkReadAction = true,
  }) async {
    try {
      final List<AndroidNotificationAction> actions = [];

      if (showReplyAction) {
        actions.add(
          AndroidNotificationAction(
            actionReply,
            'Reply',
            inputs: [
              const AndroidNotificationActionInput(
                label: 'Type a message...',
              ),
            ],
            showsUserInterface: true,
          ),
        );
      }

      if (showMarkReadAction) {
        actions.add(
          const AndroidNotificationAction(
            actionMarkRead,
            'Mark as Read',
            cancelNotification: true,
          ),
        );
      }

      actions.add(
        const AndroidNotificationAction(
          actionDismiss,
          'Dismiss',
          cancelNotification: true,
        ),
      );

      final androidDetails = AndroidNotificationDetails(
        'action_notification',
        'Action Notifications',
        channelDescription: 'Channel for notifications with action buttons',
        importance: Importance.max,
        priority: Priority.high,
        actions: actions,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await _notification.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload,
      );

      // Save to history
      await NotificationStorageHelper.saveNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
        type: 'action',
      );

      log('Notification with actions shown: $title');
    } catch (e) {
      log('Error showing notification with actions: $e');
    }
  }

  /// Show grouped notifications (summary + individual).
  /// [groupKey] is used to group related notifications.
  static Future<void> showGroupedNotification({
    required String groupKey,
    required String title,
    required String body,
    required int id,
    String? payload,
    bool isSummary = false,
    List<String>? inboxLines,
  }) async {
    try {
      StyleInformation? styleInformation;

      if (isSummary && inboxLines != null && inboxLines.isNotEmpty) {
        styleInformation = InboxStyleInformation(
          inboxLines,
          contentTitle: title,
          summaryText: '${inboxLines.length} messages',
        );
      }

      final androidDetails = AndroidNotificationDetails(
        'grouped_notification',
        'Grouped Notifications',
        channelDescription: 'Channel for grouped notifications',
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey,
        setAsGroupSummary: isSummary,
        styleInformation: styleInformation,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        threadIdentifier: 'grouped_thread',
      );

      await _notification.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload,
      );

      // Save to history (only for non-summary notifications)
      if (!isSummary) {
        await NotificationStorageHelper.saveNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
          type: 'grouped',
        );
      }

      log('Grouped notification shown: $title (summary: $isSummary)');
    } catch (e) {
      log('Error showing grouped notification: $e');
    }
  }

  /// Show multiple notifications as a group with a summary.
  /// This is a convenience method that creates both individual and summary notifications.
  static Future<void> showNotificationGroup({
    required String groupKey,
    required List<Map<String, String>> notifications,
    required String summaryTitle,
    int startId = 1000,
  }) async {
    try {
      // Show individual notifications
      for (int i = 0; i < notifications.length; i++) {
        final notification = notifications[i];
        await showGroupedNotification(
          groupKey: groupKey,
          title: notification['title'] ?? 'Notification',
          body: notification['body'] ?? '',
          id: startId + i,
          payload: notification['payload'],
          isSummary: false,
        );
      }

      // Show summary notification
      final inboxLines = notifications
          .map((n) => '${n['title']}: ${n['body']}')
          .toList();

      await showGroupedNotification(
        groupKey: groupKey,
        title: summaryTitle,
        body: '${notifications.length} new notifications',
        id: startId + notifications.length,
        isSummary: true,
        inboxLines: inboxLines,
      );

      log('Notification group shown: $summaryTitle with ${notifications.length} items');
    } catch (e) {
      log('Error showing notification group: $e');
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
