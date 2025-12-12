import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_feature/pages/notification_history_page.dart';
import 'package:flutter_local_notifications_feature/pages/notification_page.dart';
import 'package:flutter_local_notifications_feature/pages/pending_notifications_page.dart';

/// Helper class for handling deep links from notifications.
class DeepLinkHelper {
  /// Parse payload and navigate to the appropriate page.
  ///
  /// Payload format examples:
  /// - `page:history` - Navigate to history page
  /// - `page:pending` - Navigate to pending notifications
  /// - `message:123` - Navigate to message with ID 123
  /// - `action:reply:Hello` - Handle reply action with text
  /// - Any other payload - Show notification details page
  static void handleDeepLink({
    required BuildContext context,
    required NotificationResponse response,
  }) {
    final payload = response.payload;
    final actionId = response.actionId;
    final inputText = response.input;

    log('DeepLink: payload=$payload, action=$actionId, input=$inputText');

    if (payload == null || payload.isEmpty) {
      _navigateToNotificationPage(context, response);
      return;
    }

    // Parse payload
    final parts = payload.split(':');
    final type = parts.isNotEmpty ? parts[0] : '';
    final value = parts.length > 1 ? parts[1] : '';

    switch (type) {
      case 'page':
        _handlePageNavigation(context, value, response);
        break;
      case 'message':
        _handleMessageNavigation(context, value, response);
        break;
      case 'action':
        _handleActionNavigation(context, parts, response);
        break;
      default:
        _navigateToNotificationPage(context, response);
    }
  }

  /// Handle page navigation based on payload.
  static void _handlePageNavigation(
    BuildContext context,
    String pageName,
    NotificationResponse response,
  ) {
    switch (pageName) {
      case 'history':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationHistoryPage(),
          ),
        );
        break;
      case 'pending':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PendingNotificationsPage(),
          ),
        );
        break;
      default:
        _navigateToNotificationPage(context, response);
    }
  }

  /// Handle message navigation (example for chat apps).
  static void _handleMessageNavigation(
    BuildContext context,
    String messageId,
    NotificationResponse response,
  ) {
    // In a real app, you would navigate to a specific message page
    // For demo purposes, we show the notification page with the message ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(
          payload: 'Message ID: $messageId',
          notificationId: response.id,
          actionId: response.actionId,
          inputText: response.input,
        ),
      ),
    );
  }

  /// Handle action navigation.
  static void _handleActionNavigation(
    BuildContext context,
    List<String> parts,
    NotificationResponse response,
  ) {
    final actionType = parts.length > 1 ? parts[1] : '';
    final actionData = parts.length > 2 ? parts.sublist(2).join(':') : '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(
          payload: 'Action: $actionType\nData: $actionData',
          notificationId: response.id,
          actionId: response.actionId,
          inputText: response.input,
        ),
      ),
    );
  }

  /// Default navigation to notification page.
  static void _navigateToNotificationPage(
    BuildContext context,
    NotificationResponse response,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(
          payload: response.payload,
          notificationId: response.id,
          actionId: response.actionId,
          inputText: response.input,
        ),
      ),
    );
  }

  /// Create a deep link payload for page navigation.
  static String createPagePayload(String pageName) => 'page:$pageName';

  /// Create a deep link payload for message navigation.
  static String createMessagePayload(String messageId) => 'message:$messageId';

  /// Create a deep link payload for action.
  static String createActionPayload(String actionType, [String? data]) {
    if (data != null) {
      return 'action:$actionType:$data';
    }
    return 'action:$actionType';
  }
}
