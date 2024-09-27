import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_feature/helpers/notification_helper.dart';
import 'package:flutter_local_notifications_feature/pages/home_page.dart';
import 'package:flutter_local_notifications_feature/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init(); // Ensure the init method is awaited
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.lightTheme, // Apply light theme here
      darkTheme: AppThemes.darkTheme, // Apply dark theme (optional)
      themeMode: ThemeMode
          .system, // Choose ThemeMode.light, ThemeMode.dark, or ThemeMode.system

      title: 'Flutter Local Notifications Feature',
      home: const MyHomePage(),
    );
  }
}
