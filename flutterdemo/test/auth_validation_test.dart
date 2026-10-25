import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/routes/app_routes.dart';
import 'package:flutterdemo/screens/common/login_screen.dart';
import 'package:flutterdemo/screens/common/signup_screen.dart';

void main() {
  group('Learner Login Form Validation & Loading State', () {
    testWidgets('Shows validation errors on empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoginScreen(isTeacher: false),
          ),
        ),
      );

      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump();

      expect(find.text('Email address is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Shows invalid email format error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoginScreen(isTeacher: false),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'invalid-email',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump();

      expect(
        find.text('Please enter a valid email address (e.g. name@domain.com)'),
        findsOneWidget,
      );
    });

    testWidgets('Shows loading spinner upon valid submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => const LoginScreen(isTeacher: false),
            AppRoutes.learnerHome: (context) => const Scaffold(body: Text('Home Screen')),
          },
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'fatima@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump();

      // CircularProgressIndicator should be visible inside the button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Advance past delay
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();
    });
  });

  group('Learner Signup Form Validation & Loading State', () {
    testWidgets('Shows validation errors on empty submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignupScreen(isTeacher: false),
          ),
        ),
      );

      final signupBtn = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(signupBtn);
      await tester.tap(signupBtn);
      await tester.pump();

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email address is required'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('Checks password confirmation matching', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignupScreen(isTeacher: false),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Fatima Zahid',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'fatima@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'password999',
      );

      final signupBtn = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(signupBtn);
      await tester.tap(signupBtn);
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Shows loading spinner upon valid signup', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => const SignupScreen(isTeacher: false),
            AppRoutes.learnerHome: (context) => const Scaffold(body: Text('Home Screen')),
          },
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Fatima Zahid',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'fatima@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'password123',
      );

      final signupBtn = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(signupBtn);
      await tester.tap(signupBtn);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pumpAndSettle();
    });
  });
}
