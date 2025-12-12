import 'package:flutter/material.dart';

/// Reusable notification action button with icon support.
class NotificationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const NotificationButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          backgroundColor: backgroundColor ?? Colors.blueAccent,
          foregroundColor: foregroundColor ?? Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22),
              const SizedBox(width: 12),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}
