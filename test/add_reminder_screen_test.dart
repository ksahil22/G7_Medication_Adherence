import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medication_adherence_app/views/home_screen.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('Widget Test', () {
    late MockFirebaseAuth mockAuth;
    late FakeFirebaseFirestore mockFirestore;

    setUp(() async {
      // Initialize mock services
      mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(
          uid: 'testUser',
          email: 'test@example.com',
          displayName: 'Test User',
        ),
      );
      mockFirestore = FakeFirebaseFirestore();
    });

    testWidgets('Add Reminders displays a form to create reminders',
        (WidgetTester tester) async {
      // Build the widget and pump it into the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            auth: mockAuth,
            firestore: mockFirestore,
            enableNotifications: false,
          ),
        ),
      );

      // Simulate tapping on the "Reminder" tab in the BottomNavigationBar.
      await tester.tap(find.text('Reminder'));
      await tester.pumpAndSettle();

      // Test if TextFields are present
      expect(find.byType(TextField), findsNWidgets(2));

      // Test for Medication Name TextField
      final medicationNameTextField =
          find.widgetWithText(TextField, 'Enter Medication Name');
      expect(medicationNameTextField, findsOneWidget);
      await tester.enterText(medicationNameTextField, 'Aspirin');
      expect(find.text('Aspirin'), findsOneWidget);

      // Test for Type TextField
      final typeTextField = find.widgetWithText(TextField, 'Type');
      expect(typeTextField, findsOneWidget);
      await tester.enterText(typeTextField, 'Normal');
      expect(find.text('Normal'), findsOneWidget);

      // Tap the 'Pick Date' button to show the date picker
      await tester.tap(find.text('Select Date & Time'));
      await tester.pumpAndSettle();

      // Ensure the date picker dialog is shown
      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Simulate picking a date (e.g., the 30th of the current month)
      await tester.tap(find.text('20'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Ensure the time picker dialog is shown
      expect(find.byType(TimePickerDialog), findsOneWidget);

      await tester.pumpAndSettle();
      // Simulate picking a time
      // final hour = find.text('11'); // FIX ME
      // final minute = find.text('55');
      // expect(hour, findsOneWidget);
      // expect(minute, findsOneWidget);
      // await tester.tap(find.text('11'));
      // await tester.tap(find.text('55'));
      await tester.tap(find.text('PM'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify the date and time is picked correctly
      expect(find.textContaining('20/'), findsOneWidget);
      expect(find.textContaining(' PM'), findsOneWidget);

      // Verify that the ReminderView is displayed.
      expect(find.text('Add'), findsOneWidget);
    });
  });
}
