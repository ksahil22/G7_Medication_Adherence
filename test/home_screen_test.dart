import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medication_adherence_app/model/reminder_model.dart';
import 'package:medication_adherence_app/views/home_screen.dart';
import 'package:medication_adherence_app/components/reminder_card.dart';
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

    testWidgets('HomeScreen displays welcome message and reminders',
        (WidgetTester tester) async {
      // Add mock Firestore data
      DateTime dateTime1 = DateTime(2034, 11, 12, 9, 0);
      ReminderModel reminder1 = ReminderModel(
          medicineName: 'Aspirin',
          medicineType: 'Normal',
          pillCount: 1,
          medicinePower: 'mg',
          dateTime: dateTime1);
      DateTime dateTime2 = DateTime(2034, 11, 12, 14, 0);
      ReminderModel reminder2 = ReminderModel(
          medicineName: 'Paracetamol',
          medicineType: 'Normal',
          pillCount: 1,
          medicinePower: 'mg',
          dateTime: dateTime2);
      await mockFirestore
          .collection('users')
          .doc('testUser')
          .collection('reminder')
          .doc()
          .set(reminder1.toMap());
      await mockFirestore
          .collection('users')
          .doc('testUser')
          .collection('reminder')
          .doc()
          .set(reminder2.toMap());

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
      // Allow time for async operations to complete
      await tester.pumpAndSettle();

      // Verify that the AppBar displays the correct title.
      expect(find.text('MediAlert'), findsOneWidget);

      // Verify that the reminder cards are displayed with the correct details.
      expect(find.byType(ReminderCard), findsNWidgets(2));
      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Nov 12, 09:00 AM'), findsOneWidget);
      expect(find.text('Paracetamol'), findsOneWidget);
      expect(find.text('Nov 12, 02:00 PM'), findsOneWidget);

      // Verify that the BottomNavigationBar is present with correct items.
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Reminder'), findsOneWidget);
      expect(find.text('Chat AI'), findsOneWidget);

      // Simulate tapping on the "Reminder" tab in the BottomNavigationBar.
      await tester.tap(find.text('Reminder'));
      await tester.pumpAndSettle();

      // Simulate tapping on the "Chat AI" tab in the BottomNavigationBar.
      await tester.tap(find.text('Chat AI'));
      await tester.pumpAndSettle();
    });
  });
}
