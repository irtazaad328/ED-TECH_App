import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/enrollment_service.dart';
import '../../theme/app_theme.dart';

/// Screen: Course & App Feedback Form (Assigned: Fatima Zahid - Week 4)
/// Provides interactive 5-star rating, category dropdown, multi-line review input,
/// form validation, loading indicator, and thank-you confirmation.
class FeedbackScreen extends StatefulWidget {
  final String? initialCourseTitle;

  const FeedbackScreen({super.key, this.initialCourseTitle});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();

  int _rating = 5;
  String _category = 'Course Content';
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Course Content',
    'Mentor Guidance',
    'App Experience',
    'Curriculum & Projects',
    'Bug Report / Suggestion',
  ];

  @override
  void initState() {
    super.initState();
    final email = EnrollmentService.instance.currentUser;
    if (email != null && email.isNotEmpty && email.contains('@')) {
      _nameController.text = email.split('@').first;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating (1 to 5).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API network submission delay
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 44,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank You!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your feedback has been successfully submitted and helps us improve our courses.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const ValueKey('return_home_button'),
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.learnerHome,
                    (route) => false,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.initialCourseTitle ?? 'Flutter Mobile App Development';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course & App Feedback'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.rate_review_rounded,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Program Evaluation',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                course,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Star Rating Section
                const Text(
                  'How would you rate your experience?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starNum = index + 1;
                    return IconButton(
                      key: ValueKey('star_$starNum'),
                      iconSize: 38,
                      icon: Icon(
                        starNum <= _rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: starNum <= _rating ? AppTheme.accent : Colors.grey.shade400,
                      ),
                      onPressed: () => setState(() => _rating = starNum),
                    );
                  }),
                ),
                Center(
                  child: Text(
                    '$_rating of 5 Stars',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Category Dropdown
                const Text(
                  'Feedback Category',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  key: const ValueKey('feedback_category_dropdown'),
                  value: _category,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
                const SizedBox(height: 20),

                // Name / Learner Field
                const Text(
                  'Your Name',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const ValueKey('feedback_name_field'),
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name or handle',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please provide your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Review Comments
                const Text(
                  'Your Review / Comments',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const ValueKey('feedback_comment_field'),
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'What did you like about this course or what could be improved? (Min 10 characters)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your feedback comments';
                    }
                    if (v.trim().length < 10) {
                      return 'Feedback must be at least 10 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    key: const ValueKey('submit_feedback_button'),
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Submit Feedback',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
