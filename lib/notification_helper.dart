import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() async {
    await _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    ));
    tz.initializeTimeZones();
  }

  static scheduleNotification(
      {required String title,
      required String body,
      int seconds = 0,
      int minutes = 0,
      int hours = 0,
      int days = 0,
      int weeks = 0}) async {
    var androidDetails = const AndroidNotificationDetails(
      "important_notification",
      "My Channel",
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);
    await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(
        seconds: seconds +
          (  minutes * 60) +
           ( hours * 60 * 60) +
           ( days * 60 * 60 * 24) +
           ( weeks * 60 * 60 * 24 * 7),
      )),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static schedulePeriodicNotification({
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
  }) async {
    var androidDetails = const AndroidNotificationDetails(
      "important_periodic_notification",
      "My Periodic Channel",
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    await _notification.periodicallyShow(
      1,
      title,
      body,
      repeatInterval,
      notificationDetails,
    );
  }

  cancelAllNotifications() {
    _notification.cancelAll();
  }
}
