import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CartManagementScreen extends StatelessWidget {
  const CartManagementScreen({super.key});

  final List<Map<String, String>> enrollments = const [
    {
      'studentName': 'Ali Khan',
      'email': 'ali.khan@example.com',
      'program': 'Flutter Mobile App Development',
      'status': 'Paid',
      'date': 'Oct 14, 2026',
    },
    {
      'studentName': 'Sara Ahmed',
      'email': 'sara.a@example.com',
      'program': 'Flutter Mobile App Development',
      'status': 'In Cart',
      'date': 'Oct 15, 2026',
    },
    {
      'studentName': 'David Miller',
      'email': 'david.m@example.com',
      'program': 'Prompt Engineering & Research',
      'status': 'Paid',
      'date': 'Oct 13, 2026',
    },
    {
      'studentName': 'Zainab Fatima',
      'email': 'zainab.f@example.com',
      'program': 'UI/UX Design with Figma',
      'status': 'In Cart',
      'date': 'Oct 15, 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart & Enrollment Management'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: enrollments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = enrollments[index];
          final isPaid = item['status'] == 'Paid';

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['studentName']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPaid ? AppTheme.success.withOpacity(0.12) : AppTheme.warning.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['status']!,
                          style: TextStyle(
                            color: isPaid ? AppTheme.success : AppTheme.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['email']!,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['program']!,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        item['date']!,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
