import 'package:flutter/material.dart';

void  showSnackBar(
 
     {required String message, required BuildContext context, Color backgroundColor = Colors.blueAccent,
    Duration duration = const Duration(seconds: 3)}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating, // Makes it float above the bottom
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: duration,
    action: SnackBarAction(
      label: 'DISMISS',
      textColor: Colors.white,
      onPressed: () {
        // Code to dismiss the snack bar, or perform another action
      },
    ),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    elevation: 8, // Adds a shadow for better depth
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
