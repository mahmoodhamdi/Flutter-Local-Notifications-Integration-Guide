# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2025-12-13

### Added
- **Phase 5: Advanced Features**
  - Notification history with persistent storage
  - NotificationHistoryPage with search and filter
  - NotificationStorageHelper for managing history
  - NotificationRecord model for history records
  - Automatic saving of notifications to history
  - Unread notification tracking
  - Filter by notification type

### Changed
- Added shared_preferences dependency for history storage
- Updated project structure with models folder

---

## [2.0.0] - 2025-12-13

### Added
- **Phase 1: Critical Bug Fixes**
  - iOS full support with DarwinInitializationSettings
  - Runtime permission requests for Android 13+
  - Proper memory management with StreamController disposal
  - PermissionHelper class for handling notification permissions

- **Phase 2: Feature Improvements**
  - PendingNotificationsPage to view and cancel scheduled notifications
  - Big picture notifications (from file path and drawable resources)
  - Progress bar notifications
  - Icon support in NotificationButton widget
  - Enhanced UI with icons on all buttons

- **Phase 3: Advanced Features**
  - Notification action buttons (Reply, Mark as Read, Dismiss)
  - Grouped notifications with inbox style
  - Enhanced NotificationPage showing action and reply details
  - Action and grouped notification buttons in home page

- **Phase 4: Testing & Documentation**
  - Comprehensive widget tests for NotificationButton
  - Widget tests for NotificationPage
  - Widget tests for PendingNotificationsPage
  - Widget tests for HeaderCard
  - This CHANGELOG file

### Changed
- Updated to Flutter SDK 3.6+
- Updated to flutter_local_notifications ^19.5.0
- Updated Android compileSdk to 35
- Updated Android targetSdk to 35
- Updated Android Gradle Plugin to 8.7.3
- Updated Kotlin to 2.1.0
- Updated iOS deployment target to 13.0
- Fixed CardTheme to CardThemeData API change
- Fixed deprecated withOpacity to withValues

### Fixed
- Memory leak in StreamController (now properly disposed)
- Memory leak in StreamSubscription (now cancelled in dispose)
- Sound file name (removed .mp3 extension)
- Notifications not appearing on Android 13+ (permission handling)
- OnBackInvokedCallback warning

### Removed
- Deprecated uiLocalNotificationDateInterpretation parameter
- permission_handler dependency (using native flutter_local_notifications methods)

## [1.0.0] - Initial Release

### Added
- Basic instant notifications
- Scheduled notifications with date/time picker
- Repeating/periodic notifications
- Custom notification sounds
- Cancel all notifications
- Handle notification tap responses
- Stream-based notification event handling
