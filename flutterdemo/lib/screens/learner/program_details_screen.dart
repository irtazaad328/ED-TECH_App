import 'package:flutter/material.dart';
import '../../models/program_model.dart';
import '../../routes/app_routes.dart';
import '../../services/enrollment_service.dart';
import '../../theme/app_theme.dart';

/// Screen 6: Program Details Screen (Learner Flow - Assigned: Sameer Rizwan)
/// Displays complete course details received dynamically from ProgramsListScreen.
///
/// Week 4 polish (Idiris Hassan Mohamed):
///  - Dynamic "Enrolled" / "In Cart" state driven by [EnrollmentService].
///  - Expandable syllabus accordion (one module open at a time).
class ProgramDetailsScreen extends StatefulWidget {
  final Program? program;

  const ProgramDetailsScreen({super.key, this.program});

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  bool _isBookmarked = false;

  /// Index of the syllabus module currently expanded (null = all collapsed).
  int? _expandedModule;

  final EnrollmentService _enrollment = EnrollmentService.instance;

  static const List<SyllabusModule> _defaultSyllabus = [
    SyllabusModule(
      title: 'Module 1: Getting Started',
      duration: '2h 30m',
      lessons: [
        'Course overview & learning goals',
        'Setting up your tools',
        'Your first hands-on exercise',
      ],
    ),
    SyllabusModule(
      title: 'Module 2: Core Concepts',
      duration: '4h 15m',
      lessons: [
        'Key principles explained',
        'Guided walkthrough with your mentor',
        'Practice lab',
      ],
    ),
    SyllabusModule(
      title: 'Module 3: Real-World Project',
      duration: '5h 00m',
      lessons: [
        'Project brief & planning',
        'Build session',
        'Mentor review & feedback',
      ],
    ),
    SyllabusModule(
      title: 'Module 4: Certification',
      duration: '1h 30m',
      lessons: [
        'Final assessment',
        'Certificate of Completion',
      ],
    ),
  ];

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mobile Dev':
        return Icons.phone_iphone_rounded;
      case 'Artificial Intelligence':
        return Icons.psychology_rounded;
      case 'UI/UX Design':
        return Icons.design_services_rounded;
      case 'Cloud':
      case 'Cloud Computing':
        return Icons.cloud_rounded;
      default:
        return Icons.flutter_dash;
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // Read passed Program argument from navigation or widget property
    final routeProgram =
        ModalRoute.of(context)?.settings.arguments as Program?;
    final program = widget.program ?? routeProgram;

    final String programId =
        (program?.id != null && program!.id.isNotEmpty) ? program.id : 'p1';
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
    final List<SyllabusModule> syllabus =
        (program?.syllabus != null && program!.syllabus.isNotEmpty)
            ? program.syllabus
            : _defaultSyllabus;

    // The program that goes into the cart (fallback values when the screen
    // is opened without a Program, e.g. from the Home featured card).
    final Program cartProgram = program ??
        Program(
          id: programId,
          title: title,
          teacherName: teacherName,
          category: category,
          price: price,
          rating: rating,
          studentsEnrolled: studentsEnrolled,
          description: description,
          whatIsIncluded: whatIsIncluded,
          imageUrl: '',
          syllabus: syllabus,
        );

    // Rebuild whenever enrolment or cart state changes.
    return AnimatedBuilder(
      animation: _enrollment.changes,
      builder: (context, _) {
        final bool isEnrolled = _enrollment.isEnrolled(programId);
        final bool isInCart = _enrollment.isInCart(programId);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Program Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Share Program',
                onPressed: () =>
                    _showSnack('Sharing link for "$title" copied!'),
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
                  _showSnack(_isBookmarked
                      ? 'Saved "$title" to bookmarks'
                      : 'Removed "$title" from bookmarks');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(category, isEnrolled),
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
                    Expanded(
                      child: Text(
                        'By $teacherName',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($studentsEnrolled learners)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (isEnrolled) ...[
                  const SizedBox(height: 14),
                  _buildEnrolledNotice(),
                ],
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
                const SizedBox(height: 24),

                // Syllabus accordion
                _buildSyllabusHeader(syllabus),
                const SizedBox(height: 12),
                _buildSyllabus(syllabus, isEnrolled),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(
            program: cartProgram,
            title: title,
            price: price,
            isEnrolled: isEnrolled,
            isInCart: isInCart,
            firstModule: syllabus.first.title,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Banner & enrolled state
  // ---------------------------------------------------------------------------

  Widget _buildBanner(String category, bool isEnrolled) {
    return Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          Positioned(
            top: 14,
            left: 14,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: isEnrolled
                  ? const _EnrolledBadge(key: ValueKey('enrolled-badge'))
                  : const SizedBox.shrink(key: ValueKey('no-badge')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrolledNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.35)),
      ),
      child: const Row(
        children: [
          Icon(Icons.school_rounded, color: AppTheme.success, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "You're enrolled in this program. All lessons are unlocked.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Syllabus accordion
  // ---------------------------------------------------------------------------

  Widget _buildSyllabusHeader(List<SyllabusModule> syllabus) {
    final int lessonCount =
        syllabus.fold(0, (sum, module) => sum + module.lessons.length);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Syllabus',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          '${syllabus.length} modules • $lessonCount lessons',
          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSyllabus(List<SyllabusModule> syllabus, bool isEnrolled) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < syllabus.length; i++) ...[
            if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
            _buildModuleTile(i, syllabus[i], isEnrolled),
          ],
        ],
      ),
    );
  }

  Widget _buildModuleTile(int index, SyllabusModule module, bool isEnrolled) {
    final bool expanded = _expandedModule == index;
    final String meta = [
      '${module.lessons.length} lessons',
      if (module.duration.isNotEmpty) module.duration,
    ].join(' • ');

    return Column(
      children: [
        Semantics(
          button: true,
          expanded: expanded,
          child: InkWell(
            key: ValueKey('syllabus-module-$index'),
            onTap: () => setState(
                () => _expandedModule = expanded ? null : index),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: expanded
                        ? AppTheme.primary
                        : AppTheme.primary.withValues(alpha: 0.08),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: expanded ? Colors.white : AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meta,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more_rounded,
                        color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? Container(
                  width: double.infinity,
                  color: AppTheme.background,
                  padding: const EdgeInsets.fromLTRB(56, 4, 14, 12),
                  child: Column(
                    children: [
                      for (int l = 0; l < module.lessons.length; l++)
                        _buildLessonRow(
                          module.lessons[l],
                          // First lesson of the first module is a free preview.
                          unlocked: isEnrolled || (index == 0 && l == 0),
                          isPreview: !isEnrolled && index == 0 && l == 0,
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget _buildLessonRow(String lesson,
      {required bool unlocked, required bool isPreview}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(
            unlocked ? Icons.play_circle_outline_rounded : Icons.lock_outline,
            size: 18,
            color: unlocked ? AppTheme.accent : AppTheme.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              lesson,
              style: TextStyle(
                fontSize: 13,
                color:
                    unlocked ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ),
          if (isPreview)
            const Text(
              'Preview',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.accent,
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom action bar
  // ---------------------------------------------------------------------------

  Widget _buildBottomBar({
    required Program program,
    required String title,
    required double price,
    required bool isEnrolled,
    required bool isInCart,
    required String firstModule,
  }) {
    final Widget leading = isEnrolled
        ? const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status',
                  style:
                      TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              Text(
                'Enrolled',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.success,
                ),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Price',
                  style:
                      TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          );

    final Widget action;
    if (isEnrolled) {
      action = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
        icon: const Icon(Icons.play_arrow_rounded, size: 20),
        label: const Text('Continue Learning'),
        onPressed: () => _showSnack('Opening "$firstModule"...'),
      );
    } else if (isInCart) {
      action = OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 18),
        label: const Text('In Cart • View'),
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
      );
    } else {
      action = ElevatedButton.icon(
        icon: const Icon(Icons.shopping_cart_outlined, size: 18),
        label: const Text('Add to Cart'),
        onPressed: () {
          _enrollment.addToCart(program);
          _showSnack('Added "$title" to your cart!');
          Navigator.pushNamed(context, AppRoutes.cart);
        },
      );
    }

    return Container(
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
            leading,
            const SizedBox(width: 24),
            Expanded(child: action),
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
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.success, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

/// Green pill shown on the banner once the learner is enrolled.
class _EnrolledBadge extends StatelessWidget {
  const _EnrolledBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.success,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.success.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            'Enrolled',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
