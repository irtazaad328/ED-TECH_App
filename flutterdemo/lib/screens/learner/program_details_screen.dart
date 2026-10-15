import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Container
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.flutter_dash, size: 80, color: AppTheme.primary),
              ),
            ),
            const SizedBox(height: 20),

            // Title & Instructor
            const Text(
              'Flutter Mobile App Development',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.person_pin_rounded, size: 18, color: AppTheme.accent),
                SizedBox(width: 6),
                Text('By Jerry Mentor', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                Spacer(),
                Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text('4.9 (140 learners)', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 32),

            // Description
            const Text(
              'About This Program',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Learn cross-platform mobile application development from scratch using Flutter and Dart. Build real-world portfolio projects, master state management, and integrate REST APIs.',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),

            // What's Included
            const Text(
              "What's Included",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCheckItem('40+ hours on-demand video lectures'),
            _buildCheckItem('Full GitHub repository code assets'),
            _buildCheckItem('Direct 1-on-1 mentorship & weekly action meetings'),
            _buildCheckItem('Certificate of Completion from Excelerate'),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Total Price', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                Text(
                  '\$49.99',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
