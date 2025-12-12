import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_feature/helpers/notification_helper.dart';
import 'package:flutter_local_notifications_feature/helpers/permission_helper.dart';
import 'package:flutter_local_notifications_feature/helpers/show_snack_bar_helper.dart';
import 'package:flutter_local_notifications_feature/pages/notification_page.dart';
import 'package:flutter_local_notifications_feature/pages/pending_notifications_page.dart';
import 'package:flutter_local_notifications_feature/widgets/header_card.dart';
import 'package:flutter_local_notifications_feature/widgets/notification_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Subscription to notification tap events - must be cancelled in dispose()
  StreamSubscription<NotificationResponse>? _notificationSubscription;

  /// Track if permissions have been requested
  bool _permissionsRequested = false;

  @override
  void initState() {
    super.initState();
    _setupNotificationListener();
    _requestPermissions();
  }

  @override
  void dispose() {
    // IMPORTANT: Cancel subscription to prevent memory leaks
    _notificationSubscription?.cancel();
    super.dispose();
  }

  /// Set up listener for notification tap events.
  void _setupNotificationListener() {
    _notificationSubscription =
        NotificationHelper.notificationResponseController.stream
            .listen((notificationResponse) {
      _handleNotificationTap(notificationResponse);
    });
  }

  /// Handle notification tap - navigate to notification page.
  void _handleNotificationTap(NotificationResponse response) {
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(
          payload: response.payload,
          notificationId: response.id,
        ),
      ),
    );
  }

  /// Request notification permissions on startup.
  Future<void> _requestPermissions() async {
    if (_permissionsRequested) return;
    _permissionsRequested = true;

    // Small delay to ensure the widget is fully mounted
    await Future.delayed(const Duration(milliseconds: 500));

    final granted = await PermissionHelper.requestNotificationPermissions();

    if (!granted && mounted) {
      showSnackBar(
        context: context,
        message: 'Please allow notifications to use this app.',
        backgroundColor: Colors.orange,
      );
    } else if (granted && mounted) {
      showSnackBar(
        context: context,
        message: 'Notifications enabled!',
        backgroundColor: Colors.green,
      );
    }
  }

  /// Show date and time picker for scheduling notifications.
  Future<void> _scheduleNotification() async {
    // Check permissions first
    final canSchedule = await PermissionHelper.canScheduleExactAlarms();
    if (!canSchedule) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Please grant exact alarm permission to schedule notifications.',
          backgroundColor: Colors.orange,
        );
      }
      await PermissionHelper.requestNotificationPermissions();
      return;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (pickedDate == null) {
      if (mounted) {
        showSnackBar(context: context, message: 'No date selected.');
      }
      return;
    }

    if (!mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) {
      if (mounted) {
        showSnackBar(context: context, message: 'No time selected.');
      }
      return;
    }

    final DateTime scheduledDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final int secondsUntilNotification =
        scheduledDateTime.difference(DateTime.now()).inSeconds;

    if (secondsUntilNotification <= 0) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Please choose a future time.',
          backgroundColor: Colors.red,
        );
      }
      return;
    }

    await NotificationHelper.showScheduleNotification(
      delay: Duration(seconds: secondsUntilNotification),
      id: Random().nextInt(100000),
      title: 'Scheduled Notification',
      body: 'This notification was scheduled for ${_formatDateTime(scheduledDateTime)}',
      payload: 'scheduled_${scheduledDateTime.millisecondsSinceEpoch}',
    );

    if (mounted) {
      showSnackBar(
        context: context,
        message: 'Notification scheduled for ${_formatDateTime(scheduledDateTime)}',
      );
    }
  }

  /// Format DateTime for display.
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Show basic notification.
  void _showBasicNotification() {
    NotificationHelper.showBasicNotification(
      id: Random().nextInt(100000),
      title: 'Basic Notification',
      body: 'This is a basic notification example.',
      payload: 'basic_notification',
    );
    showSnackBar(context: context, message: 'Basic notification shown');
  }

  /// Show repeating notification.
  void _showRepeatingNotification() {
    NotificationHelper.showRepeatingNotification(
      id: Random().nextInt(100000),
      title: 'Repeating Notification',
      body: 'This notification repeats every minute.',
      payload: 'repeating_notification',
      repeatInterval: RepeatInterval.everyMinute,
    );
    showSnackBar(context: context, message: 'Repeating notification set');
  }

  /// Cancel all notifications.
  void _cancelAllNotifications() {
    NotificationHelper.cancelAllNotifications();
    showSnackBar(context: context, message: 'All notifications canceled');
  }

  /// Navigate to pending notifications page.
  void _viewPendingNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PendingNotificationsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Notification Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: _viewPendingNotifications,
            tooltip: 'View Pending Notifications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Using the HeaderCard widget
              const HeaderCard(),
              const SizedBox(height: 24),

              // Notification buttons with icons
              NotificationButton(
                icon: Icons.notifications_active,
                label: 'Basic Notification',
                onPressed: _showBasicNotification,
              ),
              NotificationButton(
                icon: Icons.repeat,
                label: 'Repeating Notification',
                onPressed: _showRepeatingNotification,
              ),
              NotificationButton(
                icon: Icons.schedule,
                label: 'Schedule Notification',
                onPressed: _scheduleNotification,
              ),
              NotificationButton(
                icon: Icons.list_alt,
                label: 'View Pending Notifications',
                onPressed: _viewPendingNotifications,
                backgroundColor: Colors.teal,
              ),
              const SizedBox(height: 8),
              NotificationButton(
                icon: Icons.clear_all,
                label: 'Remove All Notifications',
                onPressed: _cancelAllNotifications,
                backgroundColor: Colors.red[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
