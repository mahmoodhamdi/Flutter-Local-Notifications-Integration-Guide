# Flutter Local Notifications Integration Guide

A comprehensive guide and demo application for integrating local notifications in Flutter apps. This project serves as a practical reference for developers looking to implement notifications on both Android and iOS platforms.

[![Flutter](https://img.shields.io/badge/Flutter-3.6+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

## Features

### Implemented
- [x] Basic instant notifications
- [x] Scheduled notifications with date/time picker
- [x] Repeating/periodic notifications
- [x] Custom notification sounds
- [x] Cancel all notifications
- [x] Handle notification tap responses
- [x] Stream-based notification event handling
- [x] iOS full support with DarwinInitializationSettings
- [x] Runtime permission requests (Android 13+)
- [x] View pending/scheduled notifications list
- [x] Cancel specific notification by ID
- [x] Big picture notifications (file path & drawable)
- [x] Progress bar notifications

### Roadmap
- [ ] Notification action buttons (Reply, Mark as Read)
- [ ] Grouped notifications
- [ ] Inbox style notifications
- [ ] Deep linking from notifications
- [ ] Notification history/log

## Requirements

| Platform | Minimum Version |
|----------|-----------------|
| Flutter SDK | 3.6.0+ |
| Dart SDK | 3.6.0+ |
| Android | API 21 (Android 5.0) |
| iOS | 13.0+ |

## Quick Start

### 1. Add Dependencies

```yaml
dependencies:
  flutter_local_notifications: ^19.5.0
  timezone: ^0.10.0
```

```bash
flutter pub get
```

### 2. Android Setup

#### AndroidManifest.xml
Add permissions above the `<application>` tag:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

Add receivers inside `<application>` tag:

```xml
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

#### build.gradle (app level)
Enable desugaring for scheduled notifications:

```gradle
android {
    compileSdk = 35

    compileOptions {
        coreLibraryDesugaringEnabled true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        minSdk = 21
        targetSdk = 35
        multiDexEnabled true
    }
}

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
}
```

### 3. Initialize Notifications

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Android settings
    const androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

    // iOS settings (recommended)
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notification.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    tz.initializeTimeZones();
  }
}
```

## Usage Examples

### Basic Notification

```dart
await NotificationHelper.showBasicNotification(
  id: 1,
  title: "Hello!",
  body: "This is a basic notification",
  payload: "custom_data",
);
```

### Scheduled Notification

```dart
await NotificationHelper.showScheduleNotification(
  id: 2,
  title: "Reminder",
  body: "Don't forget your task!",
  delay: Duration(hours: 1),
);
```

### Repeating Notification

```dart
await NotificationHelper.showRepeatingNotification(
  id: 3,
  title: "Daily Reminder",
  body: "Time to check in!",
  repeatInterval: RepeatInterval.daily,
);
```

### Handle Notification Taps

```dart
@override
void initState() {
  super.initState();
  _subscription = NotificationHelper.notificationResponseController.stream
      .listen((response) {
        // Navigate or handle the tap
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => NotificationDetailsPage(payload: response.payload),
        ));
      });
}

@override
void dispose() {
  _subscription?.cancel(); // Important: prevent memory leaks!
  super.dispose();
}
```

### Custom Sound

Place your sound file in `android/app/src/main/res/raw/` (e.g., `custom_sound.mp3`)

```dart
NotificationHelper.showBasicNotification(
  id: 4,
  title: "Custom Sound",
  body: "This notification has a custom sound!",
  sound: RawResourceAndroidNotificationSound('custom_sound'), // No extension!
);
```

### Big Picture Notification

```dart
// From file path
await NotificationHelper.showBigPictureNotification(
  id: 5,
  title: "New Photo",
  body: "Check out this amazing picture!",
  bigPicturePath: "/path/to/image.jpg",
  summaryText: "Photo from vacation",
);

// From drawable resource
await NotificationHelper.showBigPictureFromDrawable(
  id: 6,
  title: "App Update",
  body: "New features available!",
  drawableName: "update_banner",
);
```

### Progress Notification

```dart
// Show progress (useful for downloads, uploads, etc.)
for (int i = 0; i <= 100; i += 10) {
  await NotificationHelper.showProgressNotification(
    id: 7,
    title: "Downloading...",
    body: "$i% complete",
    progress: i,
    maxProgress: 100,
  );
  await Future.delayed(Duration(milliseconds: 500));
}

// Indeterminate progress (unknown duration)
await NotificationHelper.showProgressNotification(
  id: 8,
  title: "Processing...",
  body: "Please wait",
  progress: 0,
  maxProgress: 100,
  indeterminate: true,
);
```

### View Pending Notifications

```dart
// Get list of scheduled notifications
final pendingNotifications = await NotificationHelper.getPendingNotifications();
for (final notification in pendingNotifications) {
  print('ID: ${notification.id}, Title: ${notification.title}');
}

// Cancel specific notification
await NotificationHelper.cancelNotification(notificationId);
```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── helpers/
│   ├── notification_helper.dart   # Core notification logic
│   ├── permission_helper.dart     # Permission management
│   └── show_snack_bar_helper.dart # UI helper
├── pages/
│   ├── home_page.dart             # Main UI with buttons
│   ├── notification_page.dart     # Notification details
│   └── pending_notifications_page.dart # View scheduled notifications
├── widgets/
│   ├── notification_button.dart   # Reusable button with icon
│   └── header_card.dart           # Header card widget
└── theme/
    └── theme.dart                 # App theming
```

## Notification Channels

| Channel ID | Purpose |
|------------|---------|
| `basic_notification` | Instant notifications |
| `repeating_notification` | Periodic notifications |
| `schedule_notification` | Time-scheduled notifications |
| `big_picture_notification` | Notifications with images |
| `progress_notification` | Progress bar notifications |

## Common Issues & Solutions

### Notifications not showing on Android 13+
Request POST_NOTIFICATIONS permission at runtime:
```dart
final plugin = FlutterLocalNotificationsPlugin();
await plugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
```

### Scheduled notifications not working
1. Ensure desugaring is enabled in build.gradle
2. Call `tz.initializeTimeZones()` before scheduling
3. Check that `SCHEDULE_EXACT_ALARM` permission is granted

### Custom sound not playing
1. File must be in `res/raw/` folder
2. Use lowercase filename with underscores
3. Don't include file extension in code

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Resources

- [flutter_local_notifications Documentation](https://pub.dev/packages/flutter_local_notifications)
- [Flutter Official Documentation](https://docs.flutter.dev/)
- [Android Notification Guide](https://developer.android.com/develop/ui/views/notifications)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Mahmoud Hamdy**
- GitHub: [@mahmoodhamdi](https://github.com/mahmoodhamdi)
- Email: hmdy7486@gmail.com

---

If you found this guide helpful, please give it a star on GitHub!

---

> مَن قالَ: لا إلَهَ إلَّا اللَّهُ، وحْدَهُ لا شَرِيكَ له، له المُلْكُ وله الحَمْدُ، وهو علَى كُلِّ شَيءٍ قَدِيرٌ، في يَومٍ مِئَةَ مَرَّةٍ؛ كانَتْ له عَدْلَ عَشْرِ رِقابٍ، وكُتِبَتْ له مِئَةُ حَسَنَةٍ، ومُحِيَتْ عنْه مِئَةُ سَيِّئَةٍ، وكانَتْ له حِرْزًا مِنَ الشَّيْطانِ يَومَهُ ذلكَ حتَّى يُمْسِيَ، ولَمْ يَأْتِ أحَدٌ بأَفْضَلَ ممَّا جاءَ به، إلَّا أحَدٌ عَمِلَ أكْثَرَ مِن ذلكَ.
>
> — صحيح البخاري
