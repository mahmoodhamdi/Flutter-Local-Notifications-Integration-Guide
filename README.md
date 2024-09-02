# 🚀 Flutter Local Notifications Integration Guide

Welcome to the **Flutter Local Notifications Integration Guide**! This resource is crafted to help developers seamlessly add local notifications to their Flutter applications. Whether you're looking to send alerts, reminders, or messages, this guide provides everything you need—from setup to advanced customization.

## 📋 Key Features

- Comprehensive setup instructions for Android and iOS
- Code examples for both basic and advanced notifications
- Best practices for notification management and user engagement
- Troubleshooting tips and common pitfalls to avoid

## ✨ Features

### Implemented Features

- [x] Display basic notifications
- [x] Schedule notifications
- [x] Customize notification appearance (title, body, icon)
- [x] Cancel all notifications
- [x] Periodic notifications

### Future Enhancements

- [ ] Group notifications
- [ ] Progress notifications
- [ ] Media style notifications
- [ ] Big picture notifications
- [ ] Inbox style notifications
- [ ] iOS-specific features (attachments, critical alerts)
- [ ] Notification actions and buttons

## 🚀 Getting Started

Integrating local notifications into your Flutter project is easy! Follow the steps below to get started.

### 1. Add the flutter_local_notifications Package

Add the package to your **pubspec.yaml** file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: latest_version
```

Install the package by running:

```bash
flutter pub get
```

### 2. Android Configuration

#### Add Permissions

Edit your **android/app/src/main/AndroidManifest.xml** file to include the necessary permissions:

**note*
it will be above the ***application*** tag

```xml

    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <!-- Other permissions if necessary -->

```

- `android.permission.RECEIVE_BOOT_COMPLETED`: Ensures notifications are rescheduled after device reboot.
- `android.permission.SCHEDULE_EXACT_ALARM`: Allows for precise alarm scheduling.

#### Add Receivers

Insert the following receivers before the end of the ***application*** tag:

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

### 3. Create a Notification Helper Class

Create a ***notification_helper.dart***  file:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() async {
    await _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      ),
    );
    tz.initializeTimeZones();
  }

  static scheduleNotification(
    String title,
    String body,
    int seconds,
  ) async {
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
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static cancelAllNotifications() {
    _notification.cancelAll();
  }
}
```

### 4. Implement Notifications in `main.dart`

In your main.dart file:

```dart
import 'package:flutter/material.dart';
import 'notification_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: 'Local Notification Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                NotificationHelper.scheduleNotification(
                  "Test Notification",
                  "This is a test notification",
                  5,
                );
              },
              child: const Text("Set Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationHelper.cancelAllNotifications();
              },
              child: const Text("Remove Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎉 You're All Set

You have successfully integrated local notifications into your Flutter app! For more advanced features and configurations, check out the official [Flutter Local Notifications Plugin Documentation](https://pub.dev/packages/flutter_local_notifications).

If you found this guide helpful, **star this repository** ⭐ on GitHub to show your support!
