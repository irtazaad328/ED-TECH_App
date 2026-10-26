import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/screens/learner/payment_screen.dart';

Widget _buildPaymentApp() {
  return MaterialApp(
    home: const Scaffold(
      body: PaymentScreen(),
    ),
  );
}

void main() {
  group('Payment & Checkout Form Validation (Akshata)', () {
    testWidgets('Validates Card fields when empty', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildPaymentApp());
      await tester.pumpAndSettle();

      // Clear card fields
      final nameField = find.widgetWithText(TextFormField, 'Cardholder Name');
      await tester.enterText(nameField, '');

      final numberField = find.widgetWithText(TextFormField, 'Card Number (16 digits)');
      await tester.enterText(numberField, '');

      final expiryField = find.widgetWithText(TextFormField, 'Expires (MM/YY)');
      await tester.enterText(expiryField, '');

      final cvvField = find.widgetWithText(TextFormField, 'CVV / CVC');
      await tester.enterText(cvvField, '');

      final payBtn = find.byType(ElevatedButton);
      await tester.tap(payBtn);
      await tester.pump();

      expect(find.text('Please enter cardholder name'), findsOneWidget);
      expect(find.text('Please enter card number'), findsOneWidget);
      expect(find.text('Enter expiry'), findsOneWidget);
      expect(find.text('Enter CVV'), findsOneWidget);
    });

    testWidgets('Validates invalid card number and invalid MM/YY', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildPaymentApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Cardholder Name'), 'Akshata');
      await tester.enterText(find.widgetWithText(TextFormField, 'Card Number (16 digits)'), '1234');
      await tester.enterText(find.widgetWithText(TextFormField, 'Expires (MM/YY)'), '99/99');
      await tester.enterText(find.widgetWithText(TextFormField, 'CVV / CVC'), '12');

      final payBtn = find.byType(ElevatedButton);
      await tester.tap(payBtn);
      await tester.pump();

      expect(find.text('Enter a valid 16-digit card number'), findsOneWidget);
      expect(find.text('Invalid MM/YY format'), findsOneWidget);
      expect(find.text('3-4 digits required'), findsOneWidget);
    });

    testWidgets('Shows loading spinner and success dialog on valid card payment', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildPaymentApp());
      await tester.pumpAndSettle();

      final payBtn = find.byType(ElevatedButton);
      await tester.tap(payBtn);
      await tester.pump();

      // Verify CircularProgressIndicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Fast forward past payment gateway delay
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();

      // Check success popup
      expect(find.text('Payment Successful!'), findsOneWidget);
      expect(find.text('Go to Home Portal'), findsOneWidget);
    });

    testWidgets('Validates mobile wallet phone number', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildPaymentApp());
      await tester.pumpAndSettle();

      // Select Mobile Wallet method (index 2)
      final walletOption = find.text('Mobile Wallet');
      await tester.tap(walletOption);
      await tester.pumpAndSettle();

      final mobileField = find.widgetWithText(TextFormField, 'JazzCash Account Mobile Number');
      await tester.enterText(mobileField, 'invalid-num');

      final payBtn = find.byType(ElevatedButton);
      await tester.tap(payBtn);
      await tester.pump();

      expect(find.text('Enter a valid 11-digit mobile number (e.g. 03001234567)'), findsOneWidget);
    });
  });
}
