import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications_feature/main.dart';

void main() {
  testWidgets('App renders home page with notification buttons',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Pump to allow async operations to complete
    await tester.pump(const Duration(milliseconds: 600));

    // Verify that the app title is displayed
    expect(find.text('Notification Center'), findsOneWidget);

    // Verify that the main heading is displayed
    expect(find.text('Manage Notifications'), findsOneWidget);

    // Verify that notification buttons are displayed
    expect(find.text('Basic Notification'), findsOneWidget);
    expect(find.text('Repeating Notification'), findsOneWidget);
    expect(find.text('Schedule Notification'), findsOneWidget);
    expect(find.text('Remove All Notifications'), findsOneWidget);
  });
}
