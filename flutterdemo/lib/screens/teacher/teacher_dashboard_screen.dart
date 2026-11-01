import 'dart:math';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

// ======================================================================
// 1. DATA MODELS
// ======================================================================

/// One course's enrollment numbers (drives the progress bars)
class CourseEnrollment {
  final String name;
  final int enrolled;
  final int capacity;

  const CourseEnrollment({
    required this.name,
    required this.enrolled,
    required this.capacity,
  });

  factory CourseEnrollment.fromJson(Map<String, dynamic> json) {
    return CourseEnrollment(
      name: json['name'] as String,
      enrolled: json['enrolled'] as int,
      capacity: json['capacity'] as int,
    );
  }

  // 0.0 to 1.0 for the progress bar
  double get progress => capacity == 0 ? 0 : (enrolled / capacity).clamp(0, 1);
}

/// The 3 KPI numbers + the per-course breakdown
class DashboardMetrics {
  final double totalEarnings;
  final int activeStudents;
  final double courseRating;
  final List<CourseEnrollment> courses;

  const DashboardMetrics({
    required this.totalEarnings,
    required this.activeStudents,
    required this.courseRating,
    required this.courses,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      activeStudents: json['activeStudents'] as int,
      courseRating: (json['courseRating'] as num).toDouble(),
      courses: (json['courses'] as List)
          .map((c) => CourseEnrollment.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ======================================================================
// 2. MOCK SERVICE (pretends to be an API, 1 second delay)
//    First load = $12,450 / 1,280 / 4.8. Refreshes change slightly.
// ======================================================================
class DashboardService {
  static int _calls = 0;

  // Used by tests so every test starts from the "first load" numbers
  static void reset() => _calls = 0;

  static Future<DashboardMetrics> fetchMetrics() async {
    await Future.delayed(const Duration(seconds: 1));
    _calls++;
    final bump = _calls > 1 ? Random().nextInt(5) + 1 : 0;
    return DashboardMetrics.fromJson({
      'totalEarnings': 12450.0 + bump * 45,
      'activeStudents': 1280 + bump,
      'courseRating': 4.8,
      'courses': [
        {'name': 'Mobile Dev with Flutter', 'enrolled': 420 + bump, 'capacity': 500},
        {'name': 'AI & Machine Learning', 'enrolled': 360, 'capacity': 450},
        {'name': 'UI/UX Design', 'enrolled': 280, 'capacity': 400},
        {'name': 'Cloud Computing', 'enrolled': 220, 'capacity': 350},
      ],
    });
  }
}

/// Screen 12: Teacher Dashboard (Week 4: analytics + KPI polish)
class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  late Future<DashboardMetrics> _metricsFuture;

  @override
  void initState() {
    super.initState();
    _metricsFuture = DashboardService.fetchMetrics();
  }

  // Pull-to-refresh, reload icon and Retry button all use this
  Future<void> _reload() async {
    final newFuture = DashboardService.fetchMetrics();
    setState(() => _metricsFuture = newFuture);
    try {
      await newFuture;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dashboard updated')),
        );
      }
    } catch (_) {
      // error UI is shown by the FutureBuilder
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.roleSelection,
      (route) => false,
    );
  }

  // 12450 -> 12,450
  String _commas(num v) {
    return v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  // The 3 KPI cards
  Widget _buildKpis(DashboardMetrics m) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                title: 'Total Earnings',
                value: '\$${_commas(m.totalEarnings)}',
                icon: Icons.account_balance_wallet_rounded,
                color: AppTheme.success,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _KpiCard(
                title: 'Active Students',
                value: _commas(m.activeStudents),
                icon: Icons.people_alt_rounded,
                color: AppTheme.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _KpiCard(
          title: 'Course Rating',
          value: '${m.courseRating.toStringAsFixed(1)} ★',
          icon: Icons.star_rounded,
          color: AppTheme.primary,
        ),
      ],
    );
  }

  // Course-wise enrollment progress bars
  Widget _buildEnrollment(DashboardMetrics m) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          for (int i = 0; i < m.courses.length; i++) ...[
            _EnrollmentRow(course: m.courses[i]),
            if (i != m.courses.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            'Could not load your dashboard stats.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            onPressed: _reload,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _reload,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- 1. HEADER ----------
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: AppTheme.primary,
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Instructor!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Here is an overview of your programs',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Reload',
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: _reload,
                    ),
                    IconButton(
                      tooltip: 'Logout',
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ---------- 2 + 3. KPI CARDS and ENROLLMENT BARS ----------
                // One FutureBuilder feeds both sections
                FutureBuilder<DashboardMetrics>(
                  future: _metricsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 260,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _buildError();
                    }
                    final m = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Overview'),
                        const SizedBox(height: 14),
                        _buildKpis(m),
                        const SizedBox(height: 28),
                        _sectionTitle('Enrollment Performance'),
                        const SizedBox(height: 14),
                        _buildEnrollment(m),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // ---------- 4. QUICK ACTIONS ----------
                _sectionTitle('Quick Actions'),
                const SizedBox(height: 14),

                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(Icons.shopping_bag_outlined,
                          color: AppTheme.primary),
                    ),
                    title: const Text(
                      'Cart & Enrollment Management',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                        'See who added programs to cart or has paid'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.cartManagement),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    label: const Text('Create New Program'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Create Program is coming soon!'),
                        ),
                      );
                    },
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

/// One KPI card (icon, big value, label)
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// One course row: name, "enrolled / capacity", and a progress bar
class _EnrollmentRow extends StatelessWidget {
  final CourseEnrollment course;

  const _EnrollmentRow({required this.course});

  @override
  Widget build(BuildContext context) {
    final percent = (course.progress * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                course.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              '${course.enrolled}/${course.capacity} ($percent%)',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: course.progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ],
    );
  }
}
