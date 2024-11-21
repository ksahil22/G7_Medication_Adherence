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

    testWidgets('AI Chat displays chat interface', (WidgetTester tester) async {
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

      // Simulate tapping on the "Chat AI" tab in the BottomNavigationBar.
      await tester.tap(find.text('Chat AI'));
      await tester.pumpAndSettle();

      // Verify that the ChatAIView is displayed.
      expect(find.text('Type your message....'), findsOneWidget);
    });
  });
}
