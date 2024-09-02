import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_feature/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init(); // Ensure the init method is awaited
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Local Notifications Feature',
      home: MyHomePage(title: 'Flutter Local Notifications Feature'),
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
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                NotificationHelper.scheduleNotification(
                  title: "Notification",
                  body: "my app Notification",         
                 seconds: 1,
                );
              },
              child: const Text("Set Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationHelper().cancelAllNotifications();
              },
              child: const Text("Remove Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationHelper.schedulePeriodicNotification(
                  title: "Periodic Notification",
                  body: "my app Periodic Notification",
                  repeatInterval: RepeatInterval.everyMinute,

                );
              },
              child: const Text("Set Periodic Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
