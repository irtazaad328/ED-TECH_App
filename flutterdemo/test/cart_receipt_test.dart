import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/program_model.dart';
import 'package:flutterdemo/screens/learner/cart_screen.dart';
import 'package:flutterdemo/screens/learner/payment_screen.dart';
import 'package:flutterdemo/services/enrollment_service.dart';

void main() {
  Program testProgram(String id, String title, String teacher, double price) {
    return Program(
      id: id,
      title: title,
      teacherName: teacher,
      category: 'Mobile Dev',
      price: price,
      rating: 4.8,
      studentsEnrolled: 100,
      description: '',
      whatIsIncluded: const [],
      imageUrl: '',
    );
  }

  setUp(() {
    final service = EnrollmentService.instance;
    service.reset();
    service.addToCart(testProgram(
        'p1', 'Flutter Mobile App Development', 'Jerry Mentor', 49.99));
    service.addToCart(testProgram(
        'p2', 'Prompt Engineering & Research', 'Laviza Mentor', 39.99));
  });

  testWidgets('Valid promo code applies 10 percent discount',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Cart'), findsOneWidget);

    final promoField = find.byType(TextField);
    expect(promoField, findsWidgets);

    await tester.enterText(promoField.first, 'EXCELERATE10');
    tester.testTextInput.hide();

    final applyButton = find.text('Apply');
    expect(applyButton, findsOneWidget);

    await tester.ensureVisible(applyButton);
    await tester.tap(applyButton);
    await tester.pump();

    expect(
      find.textContaining('Promo code applied!'),
      findsOneWidget,
    );
  });

  testWidgets('Invalid promo code shows error message',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(
      const Size(1000, 1400),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    await tester.pumpAndSettle();

    final promoField = find.byType(TextField);
    expect(promoField, findsWidgets);

    await tester.enterText(promoField.first, 'WRONGCODE');

    tester.testTextInput.hide();

    final applyButton = find.text('Apply');

    await tester.ensureVisible(applyButton);
    await tester.tap(applyButton);
    await tester.pump();

    expect(
      find.text('Invalid promo code'),
      findsOneWidget,
    );
  });

  testWidgets('Promo code calculates correct final total',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: CartScreen()),
    );
    await tester.pumpAndSettle();

    final promoField = find.byType(TextField).first;
    await tester.enterText(promoField, 'EXCELERATE10');
    tester.testTextInput.hide();

    final applyButton = find.text('Apply');
    await tester.ensureVisible(applyButton);
    await tester.tap(applyButton);
    await tester.pump();

    expect(
      find.textContaining('75.98'),
      findsWidgets,
    );
  });

  testWidgets('Payment receipt displays discounted amount',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(
      const Size(1000, 1400),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(arguments: 75.98),
                    builder: (_) => const PaymentScreen(),
                  ),
                );
              },
              child: const Text('Open Payment'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Payment'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout & Payment'), findsOneWidget);

    final payButton = find.textContaining('Pay \$75.98');
    expect(payButton, findsOneWidget);

    await tester.ensureVisible(payButton);
    await tester.tap(payButton);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.text('Payment Successful!'), findsOneWidget);

    expect(
      find.textContaining('Amount Paid: \$75.98'),
      findsOneWidget,
    );

    expect(find.text('Go to Home Portal'), findsOneWidget);
  });
}
