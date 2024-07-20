import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercalendar_app/firebase_options.dart'; // Ensure this import path is correct
import 'package:fluttercalendar_app/students/view/studentLoginScreen.dart';
import 'package:mockito/mockito.dart';

// Mock class for FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  group('StudentLoginPage', () {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final auth = MockFirebaseAuth();
    final loginPage = StudentLoginPage();

    setUp(() {
      emailController.text = 'invalid@example.com';
      passwordController.text = 'wrongpassword';
    });

    testWidgets('invalid login shows error dialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => loginPage,
        ),
      ));

      await tester.enterText(find.byType(TextField).first, 'invalid@example.com');
      await tester.enterText(find.byType(TextField).last, 'wrongpassword');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect email or password. Please try again.'), findsOneWidget);
    });
  });
}
