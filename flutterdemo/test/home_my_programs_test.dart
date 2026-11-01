import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/program_model.dart';
import 'package:flutterdemo/screens/learner/home_screen.dart';
import 'package:flutterdemo/services/enrollment_service.dart';

void main() {
  const program = Program(
    id: 'p3',
    title: 'UI/UX Mobile Design with Figma',
    teacherName: 'Excelerate Design Team',
    category: 'UI/UX Design',
    price: 29.99,
    rating: 4.7,
    studentsEnrolled: 95,
    description: '',
    whatIsIncluded: [],
    imageUrl: '',
  );

  setUp(() => EnrollmentService.instance.reset());

  testWidgets('My Programs is hidden until the learner pays for a program',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: LearnerHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('My Programs'), findsNothing);

    // Add to cart, then pay.
    EnrollmentService.instance.addToCart(program);
    await tester.pumpAndSettle();
    expect(find.textContaining('My Programs'), findsNothing);
    expect(find.text('1'), findsOneWidget); // cart badge

    EnrollmentService.instance.checkoutCart();
    await tester.pumpAndSettle();

    expect(find.text('My Programs (1)'), findsOneWidget);
    expect(find.text('UI/UX Mobile Design with Figma'), findsOneWidget);
    expect(find.text('1'), findsNothing); // cart is empty again
  });

  test('Each learner only sees their own cart and programs', () {
    final service = EnrollmentService.instance;
    const other = Program(
      id: 'p2',
      title: 'Prompt Engineering & Research Integration',
      teacherName: 'Laviza Mentor',
      category: 'Artificial Intelligence',
      price: 39.99,
      rating: 4.8,
      studentsEnrolled: 220,
      description: '',
      whatIsIncluded: [],
      imageUrl: '',
    );

    // std@gmail.com buys the Figma course and leaves AI in the cart.
    service.signIn('std@gmail.com');
    service.addToCart(program);
    service.checkoutCart();
    service.addToCart(other);
    expect(service.isEnrolled('p3'), isTrue);
    expect(service.isInCart('p2'), isTrue);

    // student@gmail.com starts with nothing.
    service.signOut();
    service.signIn('student@gmail.com');
    expect(service.enrolled.value, isEmpty);
    expect(service.cart.value, isEmpty);
    expect(service.isEnrolled('p3'), isFalse);

    // Back to std@gmail.com (any capitalisation): their data is still there.
    service.signOut();
    service.signIn('STD@gmail.com');
    expect(service.isEnrolled('p3'), isTrue);
    expect(service.isInCart('p2'), isTrue);
  });

  testWidgets('Home greets the signed-in learner by name',
      (WidgetTester tester) async {
    EnrollmentService.instance.signIn('std@gmail.com');
    await tester.pumpWidget(const MaterialApp(home: LearnerHomeScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Hello, std! 👋'), findsOneWidget);
  });
}
