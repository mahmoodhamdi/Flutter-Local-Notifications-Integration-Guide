import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications_feature/pages/pending_notifications_page.dart';

void main() {
  group('PendingNotificationsPage', () {
    testWidgets('renders app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PendingNotificationsPage(),
        ),
      );

      // Wait for loading
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Pending Notifications'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PendingNotificationsPage(),
        ),
      );

      // Before pump completes, should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows refresh button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PendingNotificationsPage(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows empty state when no notifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PendingNotificationsPage(),
        ),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      expect(find.text('No Pending Notifications'), findsOneWidget);
      expect(find.text('Schedule a notification to see it here'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_off_outlined), findsOneWidget);
    });

    testWidgets('app bar has correct background color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PendingNotificationsPage(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final AppBar appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Colors.blueGrey[900]));
    });
  });
}
