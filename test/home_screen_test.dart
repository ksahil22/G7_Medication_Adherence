import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medication_adherence_app/screens/home_screen.dart';
import 'package:medication_adherence_app/components/reminder_card.dart';

void main() {
  testWidgets('HomeScreen displays welcome message and reminders',
      (WidgetTester tester) async {
    // Build the HomeScreen widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify that the AppBar displays the correct title.
    expect(find.text('MediAlert'), findsOneWidget);

    // Verify that the welcome message is displayed.
    expect(find.text('Welcome Gracy!'), findsOneWidget);

    // Verify that the "Current Reminders" label is displayed.
    expect(find.text('Current Reminders'), findsOneWidget);

    // Verify that the reminder cards are displayed with the correct details.
    expect(find.byType(ReminderCard), findsNWidgets(2));
    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('9:00 AM'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);
    expect(find.text('2:00 PM'), findsOneWidget);

    // Verify that the BottomNavigationBar is present with correct items.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Reminder'), findsOneWidget);
    expect(find.text('Chat AI'), findsOneWidget);

    // Simulate tapping on the "Reminder" tab in the BottomNavigationBar.
    await tester.tap(find.text('Reminder'));
    await tester.pumpAndSettle();

    // Verify that the ReminderView is displayed.
    expect(find.text('Add'), findsOneWidget);

    // Simulate tapping on the "Chat AI" tab in the BottomNavigationBar.
    await tester.tap(find.text('Chat AI'));
    await tester.pumpAndSettle();

    // Verify that the ChatAIView is displayed.
    expect(find.text('Type your message....'), findsOneWidget);
  });
}
