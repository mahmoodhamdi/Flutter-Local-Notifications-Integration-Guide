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
- [x] Custom notification sounds
- [x] Handle notification taps and responses

### Future Enhancements

- [ ] Schedule repeating notifications
- [ ] Group notifications
- [ ] Progress notifications
- [ ] Media style notifications
- [ ] Big picture notifications
- [ ] Inbox style notifications
- [ ] iOS-specific features (attachments, critical alerts)
- [ ] Notification actions and buttons

---

## 🚀 Getting Started

Integrating local notifications into your Flutter project is easy! Follow the steps below to get started.

### 1. Add the `flutter_local_notifications` Package

Add the package to your **pubspec.yaml** file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: latest_version
  timezone: latest_version
```

Install the package by running:

```bash
flutter pub get
```

### 2. Android Configuration

#### Add Permissions

Edit your **android/app/src/main/AndroidManifest.xml** file to include the necessary permissions:

**Note:** Add these permissions above the `<application>` tag.

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<!-- Other permissions if necessary -->
```

- `android.permission.RECEIVE_BOOT_COMPLETED`: Ensures notifications are rescheduled after device reboot.
- `android.permission.SCHEDULE_EXACT_ALARM`: Allows for precise alarm scheduling.

#### Add Receivers

Insert the following receivers before the end of the `<application>` tag:

```xml
<meta-data android:name="flutterEmbedding" android:value="2" />
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

### 3. Gradle Setup

For scheduled notifications to be compatible with older Android versions, you need to enable **desugaring**. Update your application's Gradle file `android/app/build.gradle` as follows:

```gradle
android {
  defaultConfig {
    multiDexEnabled true
  }

  compileOptions {
    coreLibraryDesugaringEnabled true
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }
}

dependencies {
  coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.2.2'
}
```

Make sure your project is using **Android Gradle Plugin 7.3.1 or higher**.

If your Flutter app crashes on Android 12L or later when desugaring is enabled, you may need to add the following dependencies:

```gradle
dependencies {
    implementation 'androidx.window:window:1.0.0'
    implementation 'androidx.window:window-java:1.0.0'
}
```

Additionally, ensure your `compileSdk` is set to at least 34 in your Gradle configuration:

```gradle
android {
    compileSdk 34
}
```

### 4. Custom Notification Sound Setup

You can now customize notification sounds with this setup.

#### Add Sound File

Add your custom notification sound file to the following locations in your project:

- **Flutter assets**: Place your sound file in `assets/audio/`
- **Android raw resources**: Add your sound file to `android/app/src/main/res/raw/`

Ensure that the sound file follows these conditions:

- File format: `.mp3`
- File name: Use lowercase letters and underscores (e.g., `yaamsallyallaelnaby.mp3`).

#### Update `pubspec.yaml`

Configure the sound asset in your `pubspec.yaml` file under the `assets` section:

```yaml
flutter:
  assets:
    - assets/audio/
```

#### Custom Sound Notification

The custom sound feature is already integrated into the notification helper function. By default, the notification will play the custom sound file `yaamsallyallaelnaby.mp3`. You can specify the sound file or let it use the default one as follows:

```dart
NotificationHelper.showBasicNotification(
  id: Random().nextInt(1 << 32),
  title: "Custom Sound Notification",
  body: "This notification has a custom sound!",
  sound: RawResourceAndroidNotificationSound('yaamsallyallaelnaby'),
);
```

If no sound is provided, the default sound (`yaamsallyallaelnaby.mp3`) will be used.

---

### 5. Initialize Notifications and Time Zones

You must initialize the notification plugin along with time zone settings.

#### Initialization

In your `NotificationHelper`, initialize the notification settings and time zones as shown below:

```dart
class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification settings and time zones.
  static Future<void> init() async {
    try {
      const androidSettings =
          AndroidInitializationSettings("@mipmap/ic_launcher");
      const initSettings = InitializationSettings(android: androidSettings);
      await _notification.initialize(
        initSettings,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap,
        onDidReceiveNotificationResponse: onNotificationTap,
      );
      tz.initializeTimeZones();
    } catch (e) {
      log("Error initializing notifications: $e");
    }
  }
}
```

### 6. Handle Notification Taps

You can now respond to user interactions when they tap on notifications. The tap listener and response handlers are integrated into the notification helper. This allows you to perform actions like navigation when the notification is tapped.

#### Setup the Notification Tap Listener

Set up a tap listener to perform actions when a user taps on a notification:

```dart
class NotificationHelper {
  static StreamController<NotificationResponse> notificationResponseController =
      StreamController<NotificationResponse>.broadcast();

  /// Add the response to the stream on notification tap.
  static void onNotificationTap(
    NotificationResponse notificationResponse,
  ) {
    notificationResponseController.add(notificationResponse);
  }

  void onNotificationTapListener() {
    NotificationHelper.notificationResponseController.stream
        .listen((notificationResponse) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotificationPage()));
    });
  }
}
```

Make sure you initialize this listener in your `initState`:

```dart
@override
void initState() {
  super.initState();
  onNotificationTapListener();  // Listen for notification taps
}
```

This will navigate to a specific page when the user taps on the notification.

---

## 🎉 Congratulations

You’ve successfully integrated local notifications into your Flutter app! For more advanced features and customization options, be sure to check out the official [Flutter Local Notifications Plugin Documentation](https://pub.dev/packages/flutter_local_notifications).

If you found this guide helpful, don’t forget to ⭐ star this repository on GitHub to show your support!

Thank you for reading!

---

#### وَصَلَّى اللَّهُ وَسَلَّمَ عَلَى نَبِيِّنَا مُحَمَّدٍ وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ
