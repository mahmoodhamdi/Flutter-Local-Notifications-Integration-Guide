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

```xml
<manifest>
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
  <!-- Other permissions if necessary -->
</manifest>
```

- `android.permission.RECEIVE_BOOT_COMPLETED`: Ensures notifications are rescheduled after device reboot.
- `android.permission.SCHEDULE_EXACT_ALARM`: Allows for precise alarm scheduling.

#### Add Receivers

Insert the following receivers before the end of the **application** tag:

```xml
<application>
  <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
  <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
      <action android:name="android.intent.action.BOOT_COMPLETED"/>
      <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
      <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
      <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
  </receiver>
</application>
```

### 3. Gradle Setup

To ensure compatibility with scheduled notifications and desugaring, update your `android/app/build.gradle` file as follows:

```groovy
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

**Note:** The plugin uses Android Gradle Plugin (AGP) 7.3.1 or higher, so ensure your `android/build.gradle` has the correct classpath:

```groovy
buildscript {
  dependencies {
    classpath 'com.android.tools.build:gradle:7.3.1'
  }
}
```

### 4. AndroidManifest.xml Setup

Include the following permissions and receivers in your `AndroidManifest.xml`:

```xml
<manifest>
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
  <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />

  <application>
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
      <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
      </intent-filter>
    </receiver>
  </application>
</manifest>
```

For full-screen intents and notification actions, add these permissions and receivers as needed:

```xml
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver" />
```

### 5. Creating the Notification Helper Class

For a detailed implementation, refer to the [notification_helper.dart](./lib/notification_helper.dart) file.

### 6. Implementing Notification UI Components

For a step-by-step guide, see the [main.dart](./lib/main.dart) file.

## 🎉 Congratulations

You’ve successfully integrated local notifications into your Flutter app! For more advanced features and customization options, be sure to check out the official [Flutter Local Notifications Plugin Documentation](https://pub.dev/packages/flutter_local_notifications).

If you found this guide helpful, don’t forget to ⭐ star this repository on GitHub to show your support!

Thank you for reading!

---

وَصَلَّى اللَّهُ وَسَلَّمَ عَلَى نَبِيِّنَا مُحَمَّدٍ وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ

---
