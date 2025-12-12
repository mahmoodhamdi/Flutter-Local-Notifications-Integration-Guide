import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications_feature/widgets/header_card.dart';

void main() {
  group('HeaderCard', () {
    testWidgets('renders title text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderCard(),
          ),
        ),
      );

      expect(find.text('Manage Notifications'), findsOneWidget);
    });

    testWidgets('renders description text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderCard(),
          ),
        ),
      );

      expect(
        find.text('Create, schedule, and manage notifications right here.'),
        findsOneWidget,
      );
    });

    testWidgets('renders notification icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderCard(),
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('is wrapped in a Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderCard(),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Card has white background color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderCard(),
          ),
        ),
      );

      final Card card = tester.widget<Card>(find.byType(Card));
      expect(card.color, equals(Colors.white));
    });

    testWidgets('Card has elevation of 4', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderCard(),
          ),
        ),
      );

      final Card card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(4));
    });

    testWidgets('icon has correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderCard(),
          ),
        ),
      );

      final Icon icon =
          tester.widget<Icon>(find.byIcon(Icons.notifications_outlined));
      expect(icon.size, equals(48));
    });
  });
}
