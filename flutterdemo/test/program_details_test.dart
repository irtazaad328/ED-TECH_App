import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/program_model.dart';
import 'package:flutterdemo/screens/learner/program_details_screen.dart';
import 'package:flutterdemo/services/enrollment_service.dart';

void main() {
  Widget buildTestWidget({Program? program}) {
    return MaterialApp(
      home: ProgramDetailsScreen(program: program),
      routes: {
        '/cart': (context) => const Scaffold(body: Text('Cart Placeholder')),
      },
    );
  }

  setUp(() => EnrollmentService.instance.reset());

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

  // ---------------------------------------------------------------------------
  // Week 4: Enrolled badge state
  // ---------------------------------------------------------------------------

  testWidgets('Enrolled badge is hidden until the learner is enrolled',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Enrolled'), findsNothing);
    expect(find.text('Add to Cart'), findsOneWidget);

    // Enrol while the screen is open: the UI should update live.
    EnrollmentService.instance.enroll('p1');
    await tester.pumpAndSettle();

    // Badge on the banner + status in the bottom bar.
    expect(find.text('Enrolled'), findsNWidgets(2));
    expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
    expect(find.text('Continue Learning'), findsOneWidget);
    expect(find.text('Add to Cart'), findsNothing);
    expect(find.text('\$49.99'), findsNothing);
  });

  testWidgets('Add to Cart then checkout flips the screen to Enrolled',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Cart Placeholder'), findsOneWidget);
    expect(EnrollmentService.instance.isInCart('p1'), isTrue);

    // Back on the details screen the button now reflects the cart state.
    Navigator.of(tester.element(find.text('Cart Placeholder'))).pop();
    await tester.pumpAndSettle();
    expect(find.text('In Cart • View'), findsOneWidget);

    // Simulate a successful payment.
    EnrollmentService.instance.checkoutCart();
    await tester.pumpAndSettle();
    expect(find.text('Continue Learning'), findsOneWidget);
    expect(EnrollmentService.instance.isInCart('p1'), isFalse);
  });

  // ---------------------------------------------------------------------------
  // Week 4: Syllabus accordion
  // ---------------------------------------------------------------------------

  final syllabusProgram = Program(
    id: 'p9',
    title: 'Test Program',
    teacherName: 'Test Mentor',
    category: 'Mobile Dev',
    price: 10,
    rating: 4.5,
    studentsEnrolled: 10,
    description: 'desc',
    whatIsIncluded: const ['Item'],
    imageUrl: '',
    syllabus: const [
      SyllabusModule(
          title: 'Week 1: Basics', duration: '1h', lessons: ['Intro', 'Setup']),
      SyllabusModule(
          title: 'Week 2: Advanced', duration: '2h', lessons: ['Deep Dive']),
    ],
  );

  testWidgets('Syllabus renders modules collapsed with summary counts',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget(program: syllabusProgram));
    await tester.pumpAndSettle();

    expect(find.text('Syllabus'), findsOneWidget);
    expect(find.text('2 modules • 3 lessons'), findsOneWidget);
    expect(find.text('Week 1: Basics'), findsOneWidget);
    expect(find.text('Week 2: Advanced'), findsOneWidget);
    expect(find.text('Intro'), findsNothing);
    expect(find.text('Deep Dive'), findsNothing);
  });

  testWidgets('Syllabus accordion opens one module at a time',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget(program: syllabusProgram));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Week 1: Basics'));
    await tester.pumpAndSettle();
    expect(find.text('Intro'), findsOneWidget);
    expect(find.text('Setup'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);

    // Opening module 2 collapses module 1.
    await tester.tap(find.text('Week 2: Advanced'));
    await tester.pumpAndSettle();
    expect(find.text('Deep Dive'), findsOneWidget);
    expect(find.text('Intro'), findsNothing);

    // Tapping the open module collapses it.
    await tester.tap(find.text('Week 2: Advanced'));
    await tester.pumpAndSettle();
    expect(find.text('Deep Dive'), findsNothing);
  });

  testWidgets('Lessons are locked until enrolled, then unlocked',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget(program: syllabusProgram));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Week 1: Basics'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.lock_outline), findsOneWidget); // 'Setup'

    EnrollmentService.instance.enroll('p9');
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.lock_outline), findsNothing);
    expect(find.text('Preview'), findsNothing);
  });

  test('Program.fromJson parses syllabus modules', () {
    final program = Program.fromJson({
      'id': 'x',
      'syllabus': [
        {
          'title': 'M1',
          'duration': '1h',
          'lessons': ['A', 'B']
        }
      ],
    });
    expect(program.syllabus, hasLength(1));
    expect(program.syllabus.first.title, 'M1');
    expect(program.syllabus.first.lessons, ['A', 'B']);
    expect(Program.fromJson({'id': 'y'}).syllabus, isEmpty);
  });
}
