import 'package:flutter/material.dart';
import '../../models/program_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Screen 6: Program Details Screen (Learner Flow - Assigned: Sameer Rizwan)
/// Displays complete course details received dynamically from ProgramsListScreen.
class ProgramDetailsScreen extends StatefulWidget {
  final Program? program;

  const ProgramDetailsScreen({super.key, this.program});

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  bool _isBookmarked = false;

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mobile Dev':
        return Icons.phone_iphone_rounded;
      case 'Artificial Intelligence':
        return Icons.psychology_rounded;
      case 'UI/UX Design':
        return Icons.design_services_rounded;
      case 'Cloud Computing':
        return Icons.cloud_rounded;
      default:
        return Icons.flutter_dash;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read passed Program argument from navigation or widget property
    final routeProgram =
        ModalRoute.of(context)?.settings.arguments as Program?;
    final program = widget.program ?? routeProgram;

    final String title =
        program?.title ?? 'Flutter Mobile App Development';
    final String teacherName = program?.teacherName ?? 'Jerry Mentor';
    final String category = program?.category ?? 'Mobile Dev';
    final double price = program?.price ?? 49.99;
    final double rating = program?.rating ?? 4.9;
    final int studentsEnrolled = program?.studentsEnrolled ?? 140;
    final String description = (program?.description != null &&
            program!.description.trim().isNotEmpty)
        ? program.description
        : 'Master $category concepts and practical implementation from scratch. Learn directly from $teacherName through real-world projects, mentor feedback, and step-by-step guidance designed to build job-ready skills.';
    final List<String> whatIsIncluded = (program?.whatIsIncluded != null &&
            program!.whatIsIncluded.isNotEmpty)
        ? program.whatIsIncluded
        : [
            '40+ hours of structured video content',
            'Complete source code & project assets',
            'Direct 1-on-1 mentorship & weekly Q&A sessions',
            'Official Certificate of Completion from Excelerate',
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Program',
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Sharing link for "$title" copied!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
            },
          ),
          IconButton(
            icon: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppTheme.accent : null,
            ),
            tooltip: _isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
            onPressed: () {
              setState(() => _isBookmarked = !_isBookmarked);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(_isBookmarked
                        ? 'Saved "$title" to bookmarks'
                        : 'Removed "$title" from bookmarks'),
                    duration: const Duration(seconds: 2),
                  ),
                );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Container with Category Badge
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getCategoryIcon(category),
                      size: 80,
                      color: AppTheme.primary,
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title & Instructor
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person_pin_rounded,
                    size: 20, color: AppTheme.accent),
                const SizedBox(width: 6),
                Text(
                  'By $teacherName',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$rating ($studentsEnrolled learners)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 32),

            // Description
            const Text(
              'About This Program',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // What's Included
            const Text(
              "What's Included",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...whatIsIncluded.map((item) => _buildCheckItem(item)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Price',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary)),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: const Text('Add to Cart'),
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Added "$title" to your cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    Navigator.pushNamed(context, AppRoutes.cart);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.success, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
