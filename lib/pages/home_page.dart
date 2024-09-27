import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_feature/helpers/notification_helper.dart';
import 'package:flutter_local_notifications_feature/helpers/show_snack_bar_helper.dart';
import 'package:flutter_local_notifications_feature/pages/notification_page.dart';
import 'package:flutter_local_notifications_feature/widgets/notification_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();

    onNotificationTapListener();
  }

  void onNotificationTapListener() {
    NotificationHelper.notificationResponseController.stream
        .listen((notificationResponse) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotificationPage()));
    });
  }

  Future<void> _scheduleNotification() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 300),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime scheduledDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        int secondsUntilNotification =
            scheduledDateTime.difference(DateTime.now()).inSeconds;

        if (secondsUntilNotification > 0) {
          NotificationHelper.showScheduleNotification(
            delay: Duration(seconds: secondsUntilNotification),
            id: Random().nextInt(4294967),
            title: "Scheduled Notification",
            body: "This is a scheduled notification",
            payload: "payload",
          );
          showSnackBar(
              context: context,
              message: "Notification set for $scheduledDateTime");
        } else {
          showSnackBar(
              context: context,
              message:
                  "The selected time is in the past. Please choose a future time.");
        }
      } else {
        showSnackBar(context: context, message: "No time selected.");
      }
    } else {
      showSnackBar(context: context, message: "No date selected.");
    }
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header Card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        "Manage Notifications",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You can create, schedule, and manage notifications right here.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Notification buttons
              NotificationButton(
                label: "Basic Notification",
                onPressed: () {
                  NotificationHelper.showBasicNotification(
                    id: Random().nextInt(429496),
                    title: "Basic Notification",
                    body: "This is a basic notification",
                    payload: "payload",
                  );
                  showSnackBar(
                      context: context, message: "Basic notification shown");
                },
              ),
              NotificationButton(
                label: "Repeating Notification",
                onPressed: () {
                  NotificationHelper.showRepeatingNotification(
                      id: Random().nextInt(4294967),
                      title: "Repeating Notification",
                      body: "This is a repeating notification",
                      payload: "payload",
                      repeatInterval: RepeatInterval.everyMinute);
                  showSnackBar(
                      context: context, message: "Repeating notification set");
                },
              ),
              NotificationButton(
                label: "Schedule Notification",
                onPressed: _scheduleNotification,
              ),
              NotificationButton(
                label: "Remove Notifications",
                onPressed: () {
                  NotificationHelper.cancelAllNotifications();
                  showSnackBar(
                      context: context, message: "All notifications canceled");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
