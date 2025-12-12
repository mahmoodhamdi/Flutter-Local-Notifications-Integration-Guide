import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications_feature/pages/notification_page.dart';

void main() {
  group('NotificationPage', () {
    testWidgets('renders with default values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(),
        ),
      );

      expect(find.text('Notification Details'), findsOneWidget);
      expect(find.text('Notification Received'), findsOneWidget);
      expect(find.text('N/A'), findsOneWidget); // Default notification ID
      expect(find.text('No payload'), findsOneWidget);
    });

    testWidgets('displays notification ID when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(notificationId: 12345),
        ),
      );

      expect(find.text('12345'), findsOneWidget);
    });

    testWidgets('displays payload when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(payload: 'test_payload_data'),
        ),
      );

      expect(find.text('test_payload_data'), findsOneWidget);
    });

    testWidgets('displays action ID when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(actionId: 'reply_action'),
        ),
      );

      expect(find.text('Reply'), findsOneWidget);
    });

    testWidgets('displays mark as read action correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(actionId: 'mark_read_action'),
        ),
      );

      expect(find.text('Mark as Read'), findsOneWidget);
    });

    testWidgets('displays dismiss action correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(actionId: 'dismiss_action'),
        ),
      );

      expect(find.text('Dismiss'), findsOneWidget);
    });

    testWidgets('displays input text when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(
            inputText: 'User reply message',
          ),
        ),
      );

      expect(find.text('User reply message'), findsOneWidget);
      expect(find.text('Reply Text'), findsOneWidget);
    });

    testWidgets('does not display input section when inputText is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(
            inputText: '',
          ),
        ),
      );

      expect(find.text('Reply Text'), findsNothing);
    });

    testWidgets('Go Back button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
              child: const Text('Navigate'),
            ),
          ),
        ),
      );

      // Navigate to NotificationPage
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Verify we're on NotificationPage
      expect(find.text('Notification Details'), findsOneWidget);

      // Tap Go Back button
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();

      // Verify we're back
      expect(find.text('Notification Details'), findsNothing);
      expect(find.text('Navigate'), findsOneWidget);
    });

    testWidgets('displays all info when all parameters provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationPage(
            notificationId: 99,
            payload: 'full_test_payload',
            actionId: 'reply_action',
            inputText: 'Hello World',
          ),
        ),
      );

      expect(find.text('99'), findsOneWidget);
      expect(find.text('full_test_payload'), findsOneWidget);
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });
  });
}
