import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/main.dart';

void main() {
  testWidgets('Welcome screen loads and displays Get Started', (WidgetTester tester) async {
    await tester.pumpWidget(const EdTechApp());

    // Verify Welcome screen elements
    expect(find.text('Welcome to Ed Tech'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
