import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/screens/teacher/cart_management_screen.dart';

void main() {
  Widget buildTestWidget() {
    return const MaterialApp(
      home: CartManagementScreen(),
    );
  }

  testWidgets('CartManagementScreen renders title, search bar, and filter chips',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Cart & Enrollment Pipeline'), findsOneWidget);
    expect(find.textContaining('All ('), findsOneWidget);
    expect(find.textContaining('In Cart ('), findsOneWidget);
    expect(find.textContaining('Paid ('), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Filter chips switch view between In Cart and Paid',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Tap 'In Cart (...)' ChoiceChip
    final inCartChip = find.byWidgetPredicate(
      (widget) => widget is ChoiceChip && widget.label is Text && ((widget.label as Text).data ?? '').contains('In Cart'),
    );
    expect(inCartChip, findsOneWidget);
    await tester.tap(inCartChip);
    await tester.pumpAndSettle();

    // Verify Sara Ahmed is visible (In Cart) and Ali Khan is filtered out
    expect(find.text('Sara Ahmed'), findsOneWidget);
    expect(find.text('Ali Khan'), findsNothing);

    // Tap 'Paid (...)' ChoiceChip
    final paidChip = find.byWidgetPredicate(
      (widget) => widget is ChoiceChip && widget.label is Text && ((widget.label as Text).data ?? '').contains('Paid'),
    );
    expect(paidChip, findsOneWidget);
    await tester.tap(paidChip);
    await tester.pumpAndSettle();

    // Verify Ali Khan is visible (Paid) and Sara Ahmed is filtered out
    expect(find.text('Ali Khan'), findsOneWidget);
    expect(find.text('Sara Ahmed'), findsNothing);
  });

  testWidgets('Search query filters students by name',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'John Doe');
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Ali Khan'), findsNothing);
  });

  testWidgets('Send Reminder button shows snackbar and toggles to Reminder Sent',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Switch to 'In Cart' tab so Send Reminder buttons are visible
    final inCartChip = find.byWidgetPredicate(
      (widget) => widget is ChoiceChip && widget.label is Text && ((widget.label as Text).data ?? '').contains('In Cart'),
    );
    await tester.tap(inCartChip);
    await tester.pumpAndSettle();

    // Find Send Reminder button for Sara Ahmed
    final reminderButtons = find.widgetWithText(TextButton, 'Send Reminder');
    expect(reminderButtons, findsWidgets);

    await tester.tap(reminderButtons.first);
    await tester.pumpAndSettle();

    // SnackBar should be displayed
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Payment reminder sent to'), findsOneWidget);

    // Button should now say 'Reminder Sent'
    expect(find.widgetWithText(TextButton, 'Reminder Sent'), findsOneWidget);
  });
}
