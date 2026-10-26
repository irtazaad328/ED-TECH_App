import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/screens/learner/cart_screen.dart';

void main() {
  Widget buildTestWidget() {
    return const MaterialApp(
      home: CartScreen(),
    );
  }

  testWidgets('CartScreen displays initial items and calculates subtotal, discount, and total',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('2 Programs in Cart'), findsOneWidget);
    expect(find.text('Flutter Mobile App Development'), findsOneWidget);
    expect(find.text('Prompt Engineering & Research'), findsOneWidget);

    // Initial Subtotal: 49.99 + 39.99 = 89.98
    expect(find.text('\$89.98'), findsOneWidget);
    // Discount: $5.00
    expect(find.text('-\$5.00'), findsOneWidget);
    // Total: 89.98 - 5.00 = 84.98
    expect(find.text('\$84.98'), findsOneWidget);
  });

  testWidgets('Deleting an item dynamically updates item count and total',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Tap delete on first item
    final deleteButtons = find.byIcon(Icons.delete_outline_rounded);
    expect(deleteButtons, findsNWidgets(2));
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    // Now 1 item left
    expect(find.text('1 Programs in Cart'), findsOneWidget);
    expect(find.text('Flutter Mobile App Development'), findsNothing);
    expect(find.text('Prompt Engineering & Research'), findsOneWidget);

    // Subtotal: 39.99, Total: 34.99
    expect(find.text('\$39.99'), findsWidgets);
    expect(find.text('\$34.99'), findsOneWidget);
  });

  testWidgets('Deleting all items displays empty state with Explore Programs button',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Remove first item
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();

    // Remove second item
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();

    // Empty state should be visible
    expect(find.text('Your Cart is Empty'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Explore Programs'), findsOneWidget);
  });
}
