import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/routes/app_routes.dart';
import 'package:flutterdemo/screens/learner/feedback_screen.dart';

void main() {
  Future<void> useTallSurface(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  Widget buildFeedbackApp({String? courseTitle}) {
    return MaterialApp(
      routes: {
        '/': (context) => FeedbackScreen(initialCourseTitle: courseTitle),
        AppRoutes.learnerHome: (context) =>
            const Scaffold(body: Text('Learner Home Screen')),
      },
    );
  }

  testWidgets('FeedbackScreen renders title, 5 stars, dropdown and form fields',
      (WidgetTester tester) async {
    await useTallSurface(tester);
    await tester.pumpWidget(buildFeedbackApp(courseTitle: 'Flutter Masterclass'));
    await tester.pumpAndSettle();

    expect(find.text('Course & App Feedback'), findsOneWidget);
    expect(find.text('Flutter Masterclass'), findsOneWidget);
    expect(find.text('5 of 5 Stars'), findsOneWidget);
    expect(find.byKey(const ValueKey('feedback_category_dropdown')), findsOneWidget);
    expect(find.byKey(const ValueKey('feedback_name_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('feedback_comment_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('submit_feedback_button')), findsOneWidget);
  });

  testWidgets('Validates short or empty review comments',
      (WidgetTester tester) async {
    await useTallSurface(tester);
    await tester.pumpWidget(buildFeedbackApp());
    await tester.pumpAndSettle();

    final nameField = find.byKey(const ValueKey('feedback_name_field'));
    final commentField = find.byKey(const ValueKey('feedback_comment_field'));
    final submitButton = find.byKey(const ValueKey('submit_feedback_button'));

    // Enter empty name and short comment
    await tester.enterText(nameField, '');
    await tester.enterText(commentField, 'short');
    tester.testTextInput.hide();

    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Please provide your name'), findsOneWidget);
    expect(find.text('Feedback must be at least 10 characters long'), findsOneWidget);
  });

  testWidgets('Selecting stars updates rating and valid submit shows Thank You dialog',
      (WidgetTester tester) async {
    await useTallSurface(tester);
    await tester.pumpWidget(buildFeedbackApp());
    await tester.pumpAndSettle();

    // Tap 4th star
    final star4 = find.byKey(const ValueKey('star_4'));
    await tester.ensureVisible(star4);
    await tester.tap(star4);
    await tester.pump();

    expect(find.text('4 of 5 Stars'), findsOneWidget);

    final nameField = find.byKey(const ValueKey('feedback_name_field'));
    final commentField = find.byKey(const ValueKey('feedback_comment_field'));
    final submitButton = find.byKey(const ValueKey('submit_feedback_button'));

    await tester.enterText(nameField, 'Fatima Zahid');
    await tester.enterText(commentField, 'Outstanding course content and great mentors!');
    tester.testTextInput.hide();

    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);

    // Spinner shows
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for submission completion
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.text('Thank You!'), findsOneWidget);
    expect(find.textContaining('Your feedback has been successfully submitted'), findsOneWidget);

    // Tapping 'Back to Home' navigates to Learner Home
    final backHomeBtn = find.byKey(const ValueKey('return_home_button'));
    expect(backHomeBtn, findsOneWidget);
    await tester.tap(backHomeBtn);
    await tester.pumpAndSettle();

    expect(find.text('Learner Home Screen'), findsOneWidget);
  });
}
