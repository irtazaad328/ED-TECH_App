import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/program_model.dart';
import 'package:flutterdemo/screens/learner/program_details_screen.dart';

void main() {
  Widget buildTestWidget({Program? program}) {
    return MaterialApp(
      home: ProgramDetailsScreen(program: program),
    );
  }

  testWidgets('ProgramDetailsScreen renders default course details and price',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Program Details'), findsOneWidget);
    expect(find.text('Flutter Mobile App Development'), findsOneWidget);
    expect(find.text('By Jerry Mentor'), findsOneWidget);
    expect(find.text('Mobile Dev'), findsOneWidget);
    expect(find.text('\$49.99'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.text("What's Included"), findsOneWidget);
  });

  testWidgets('Bookmark button toggles bookmark state and shows snackbar',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final bookmarkButton = find.byIcon(Icons.bookmark_border_rounded);
    expect(bookmarkButton, findsOneWidget);

    await tester.tap(bookmarkButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Saved'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);

    // Tap again to remove bookmark
    await tester.tap(find.byIcon(Icons.bookmark_rounded));
    await tester.pumpAndSettle();

    expect(find.textContaining('Removed'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
  });

  testWidgets('Share button triggers sharing feedback snackbar',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final shareButton = find.byIcon(Icons.share_outlined);
    expect(shareButton, findsOneWidget);

    await tester.tap(shareButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Sharing link for'), findsOneWidget);
  });

  testWidgets('ProgramDetailsScreen renders custom dynamic Program model',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final customProgram = Program(
      id: 'ai-101',
      title: 'Deep Learning & Neural Networks',
      teacherName: 'Dr. Andrew Ng',
      category: 'Artificial Intelligence',
      price: 89.99,
      rating: 4.95,
      studentsEnrolled: 320,
      description: 'Comprehensive deep learning masterclass.',
      whatIsIncluded: ['12 practical coding labs', 'GPU cluster access'],
      imageUrl: '',
    );

    await tester.pumpWidget(buildTestWidget(program: customProgram));
    await tester.pumpAndSettle();

    expect(find.text('Deep Learning & Neural Networks'), findsOneWidget);
    expect(find.text('By Dr. Andrew Ng'), findsOneWidget);
    expect(find.text('Artificial Intelligence'), findsOneWidget);
    expect(find.text('\$89.99'), findsOneWidget);
    expect(find.text('12 practical coding labs'), findsOneWidget);
    expect(find.text('GPU cluster access'), findsOneWidget);
  });
}
