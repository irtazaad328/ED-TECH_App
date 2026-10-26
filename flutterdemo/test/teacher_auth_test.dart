import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/routes/app_routes.dart';
import 'package:flutterdemo/screens/teacher/teacher_login_screen.dart';
import 'package:flutterdemo/screens/teacher/teacher_signup_screen.dart';

void main() {
  group('Teacher Login Form Validation & Loading State', () {
    testWidgets('Shows validation errors on empty login submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TeacherLoginScreen(),
          ),
        ),
      );

      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Shows invalid email pattern error on teacher login', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TeacherLoginScreen(),
          ),
        ),
      );

      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.enterText(emailField, 'teacher-invalid');

      final passwordField = find.widgetWithText(TextFormField, 'Password');
      await tester.enterText(passwordField, 'secret123');

      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Shows spinner and navigates on valid teacher login', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => const Scaffold(body: TeacherLoginScreen()),
            AppRoutes.teacherDashboard: (context) => const Scaffold(body: Text('Teacher Dashboard')),
          },
        ),
      );

      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.enterText(emailField, 'newteacher@edtech.com');

      final passwordField = find.widgetWithText(TextFormField, 'Password');
      await tester.enterText(passwordField, 'password123');

      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump();

      // Check for spinner inside the button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Fast forward simulated 1-second delay
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump(); // frame after delay
      await tester.pump(const Duration(milliseconds: 400)); // finish route transition

      expect(find.text('Teacher Dashboard'), findsOneWidget);
    });
  });

  group('Teacher Signup Form Validation & Loading State', () {
    testWidgets('Shows validation errors on empty teacher signup', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TeacherSignupScreen(),
          ),
        ),
      );

      final signupBtn = find.widgetWithText(ElevatedButton, 'Sign up');
      await tester.ensureVisible(signupBtn);
      await tester.tap(signupBtn);
      await tester.pump();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Shows spinner and navigates on valid teacher signup', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => const Scaffold(body: TeacherSignupScreen()),
            AppRoutes.teacherDashboard: (context) => const Scaffold(body: Text('Teacher Dashboard')),
          },
        ),
      );

      await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Aishika Pal');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'aishika_test@edtech.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'teacher123');

      final signupBtn = find.widgetWithText(ElevatedButton, 'Sign up');
      await tester.ensureVisible(signupBtn);
      await tester.tap(signupBtn);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Teacher Dashboard'), findsOneWidget);
    });
  });
}
