import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/main.dart';

void main() {
  testWidgets('Role Selection screen opens and navigates to Learner portal', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify Role Selection screen elements
    expect(find.text("I'm a Learner / Student"), findsOneWidget);
    expect(find.text("I'm a Teacher / Admin"), findsOneWidget);
    expect(find.text("I'm a Reviewer (Internal Team)"), findsOneWidget);

    // Tap Learner card
    await tester.tap(find.text("I'm a Learner / Student"));
    await tester.pumpAndSettle();

    // Verify Learner Sign In screen opens
    expect(find.text('Learner Sign In'), findsOneWidget);

    // Tap Sign In
    await tester.tap(find.text('Sign In as Learner'));
    await tester.pumpAndSettle();

    // Verify Learner Home Portal opens
    expect(find.text('Excelerate Learner Portal'), findsOneWidget);
  });

  testWidgets('Reviewer portal opens and shows pending requests', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap Reviewer card
    await tester.tap(find.text("I'm a Reviewer (Internal Team)"));
    await tester.pumpAndSettle();

    // Verify Reviewer portal
    expect(find.text('Reviewer Portal - Pending Teachers'), findsOneWidget);
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
  });
}
