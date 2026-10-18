import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Screen 8: Payment Screen (Learner Flow)
/// Provides selectable payment options with dedicated forms for Cards, Bank Transfers, and Mobile Wallets.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0; // 0: Card, 1: Bank, 2: Mobile Wallet

  // Card Controllers
  final _cardNumberController = TextEditingController(text: '4532 8821 9021 3341');
  final _expiryController = TextEditingController(text: '08/28');
  final _cvvController = TextEditingController(text: '342');
  final _cardNameController = TextEditingController(text: 'Ali Khan');

  // Bank Transfer Controllers
  String _selectedBank = 'Meezan Bank';
  final _bankSenderNameController = TextEditingController(text: 'Ali Khan');
  final _bankTransactionIdController = TextEditingController(text: 'TRX-9823412');

  // Mobile Wallet Controllers
  String _selectedWallet = 'JazzCash'; // 'JazzCash', 'EasyPaisa', 'SadaPay', 'NayaPay'
  final _mobileNumberController = TextEditingController(text: '0300 1234567');
  final _cnicLastDigitsController = TextEditingController(text: '78219');

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNameController.dispose();
    _bankSenderNameController.dispose();
    _bankTransactionIdController.dispose();
    _mobileNumberController.dispose();
    _cnicLastDigitsController.dispose();
    super.dispose();
  }

  void _processPayment(double amount) {
    String paymentDetail = '';
    if (_selectedMethod == 0) {
      paymentDetail = 'Card (ending in ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)})';
    } else if (_selectedMethod == 1) {
      paymentDetail = '$_selectedBank Transfer (Ref: ${_bankTransactionIdController.text})';
    } else {
      paymentDetail = '$_selectedWallet (${_mobileNumberController.text})';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have successfully enrolled in your programs.\nPaid via: $paymentDetail',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Amount Paid: \$${amount.toStringAsFixed(2)}  •  Invoice: #EDT-2026-9812',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.learnerHome,
                      (route) => false,
                    );
                  },
                  child: const Text('Go to Home Portal'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount =
        (ModalRoute.of(context)?.settings.arguments as double?) ?? 84.99;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Total Payable Amount',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Excelerate Learning',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Header
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildMethodOption(
              index: 0,
              icon: Icons.credit_card_rounded,
              title: 'Credit / Debit Card',
              subtitle: 'Visa, MasterCard, UnionPay',
            ),
            const SizedBox(height: 10),
            _buildMethodOption(
              index: 1,
              icon: Icons.account_balance_rounded,
              title: 'Direct Bank Transfer',
              subtitle: 'Meezan, HBL, Allied, Standard Chartered',
            ),
            const SizedBox(height: 10),
            _buildMethodOption(
              index: 2,
              icon: Icons.phone_android_rounded,
              title: 'Mobile Wallet',
              subtitle: 'JazzCash, EasyPaisa, SadaPay, NayaPay',
            ),
            const SizedBox(height: 24),

            // Form 0: Credit / Debit Card
            if (_selectedMethod == 0) ...[
              const Text(
                'Credit/Debit Card Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _cardNameController,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.payment_rounded),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'Expires (MM/YY)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'CVV / CVC',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Form 1: Direct Bank Transfer
            if (_selectedMethod == 1) ...[
              const Text(
                'Bank Transfer Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Official Institute Account:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    SizedBox(height: 4),
                    Text('Bank: Meezan Bank Ltd (Islamic Banking)', style: TextStyle(fontSize: 13)),
                    Text('Title: Excelerate EdTech Global Inc.', style: TextStyle(fontSize: 13)),
                    Text('IBAN: PK82MEZN0001298412847120', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Bank Name Selector
              DropdownButtonFormField<String>(
                value: _selectedBank,
                decoration: InputDecoration(
                  labelText: 'Sending From Bank',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.account_balance_outlined),
                ),
                items: ['Meezan Bank', 'HBL', 'Bank Alfalah', 'Standard Chartered', 'Allied Bank']
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBank = val);
                },
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _bankSenderNameController,
                decoration: InputDecoration(
                  labelText: 'Sender Account Holder Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _bankTransactionIdController,
                decoration: InputDecoration(
                  labelText: 'Transaction Reference / Deposit Slip ID',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.receipt_long_rounded),
                ),
              ),
            ],

            // Form 2: Mobile Wallet (JazzCash / EasyPaisa / SadaPay)
            if (_selectedMethod == 2) ...[
              const Text(
                'Mobile Wallet Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Wallet Provider Chips
              Row(
                children: ['JazzCash', 'EasyPaisa', 'SadaPay', 'NayaPay'].map((wallet) {
                  final isSelected = _selectedWallet == wallet;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(wallet),
                      selected: isSelected,
                      selectedColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedWallet = wallet);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Mobile Number Input
              TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: '$_selectedWallet Account Mobile Number',
                  hintText: '03XX-XXXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone_iphone_rounded),
                ),
              ),
              const SizedBox(height: 14),

              // CNIC Verification Input
              TextField(
                controller: _cnicLastDigitsController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Account CNIC (Last 6 Digits for OTP authorization)',
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'A prompt will be sent to your $_selectedWallet app to enter your MPIN and confirm.',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
            const SizedBox(height: 32),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_outline_rounded),
                label: Text(
                  'Pay \$${totalAmount.toStringAsFixed(2)} Now',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _processPayment(totalAmount),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodOption({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = _selectedMethod == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = index;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isSelected
                  ? AppTheme.primary.withOpacity(0.12)
                  : Colors.grey.shade100,
              child: Icon(icon,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppTheme.primary : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
