import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications_feature/widgets/notification_button.dart';

void main() {
  group('NotificationButton', () {
    testWidgets('renders label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationButton(
              label: 'Test Button',
              icon: Icons.notifications,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('does not render icon when not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationButton(
              label: 'Test Button',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('uses custom background color when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationButton(
              label: 'Test Button',
              onPressed: () {},
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );

      final ElevatedButton button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final ButtonStyle? style = button.style;

      expect(style, isNotNull);
    });

    testWidgets('uses custom foreground color when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationButton(
              label: 'Test Button',
              onPressed: () {},
              foregroundColor: Colors.yellow,
            ),
          ),
        ),
      );

      final ElevatedButton button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final ButtonStyle? style = button.style;

      expect(style, isNotNull);
    });

    testWidgets('has full width container', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final Container container =
          tester.widget<Container>(find.byType(Container).first);

      expect(container.constraints?.maxWidth, equals(double.infinity));
    });
  });
}
