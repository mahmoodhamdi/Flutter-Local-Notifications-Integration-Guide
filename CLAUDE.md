# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter demonstration project showcasing local notifications integration using `flutter_local_notifications` package. This is primarily an educational/guide repository for developers learning to implement notifications in Flutter apps.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze
```

## Architecture

### Core Structure

- **`lib/helpers/notification_helper.dart`** - Central notification management class with static methods for all notification operations (basic, scheduled, repeating notifications)
- **`lib/main.dart`** - App entry point; initializes notifications via `NotificationHelper.init()` before `runApp()`
- **`lib/pages/home_page.dart`** - Main UI with notification action buttons; sets up notification tap listener in `initState()`

### Notification Flow

1. `NotificationHelper.init()` initializes the plugin with Android settings and timezone data
2. `notificationResponseController` (StreamController) broadcasts notification tap events
3. UI components call static methods like `showBasicNotification()`, `showScheduleNotification()`, `showRepeatingNotification()`
4. Tap responses are handled via stream listener that navigates to `NotificationPage`

### Android Configuration

- Custom notification sound: `assets/audio/yaamsallyallaelnaby.mp3` (also in `android/app/src/main/res/raw/`)
- Desugaring enabled in `android/app/build.gradle` for backward compatibility
- Required permissions: `RECEIVE_BOOT_COMPLETED`, `SCHEDULE_EXACT_ALARM`

### Notification Channels

- `basic_notification` - For immediate notifications
- `repeating_notification` - For periodic notifications
- `schedule_notification` - For time-scheduled notifications

## Dependencies

- `flutter_local_notifications: ^19.5.0` - Core notification functionality
- `timezone: ^0.10.0` - Required for scheduled notifications with timezone support
- `flutter_lints: ^6.0.0` - Linting rules

## SDK Requirements

- Flutter SDK: `^3.6.0`
- Android: compileSdk 35, targetSdk 35, minSdk 21
- iOS: 13.0+
- Gradle: 8.11.1
- Android Gradle Plugin: 8.7.3
- Kotlin: 2.1.0
