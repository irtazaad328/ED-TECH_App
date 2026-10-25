import 'dart:math';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

// ======================================================================
// 1. DATA MODEL - holds the 3 dashboard numbers (no hardcoded UI values)
//    Tip: you can later move this to lib/models/dashboard_metrics.dart
// ======================================================================
class DashboardMetrics {
  final int activePrograms;
  final int totalLearners;
  final double totalRevenue;

  const DashboardMetrics({
    required this.activePrograms,
    required this.totalLearners,
    required this.totalRevenue,
  });

  // Ready for a real API / JSON response later
  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      activePrograms: json['activePrograms'] as int,
      totalLearners: json['totalLearners'] as int,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }
}

// ======================================================================
// 2. MOCK SERVICE - pretends to call an API (1 second delay).
//    First call returns your original numbers (4 / 360 / 14,250);
//    later calls change slightly so you can SEE refresh working.
// ======================================================================
class DashboardService {
  static int _calls = 0;

  static Future<DashboardMetrics> fetchMetrics() async {
    await Future.delayed(const Duration(seconds: 1));
    _calls++;
    final rnd = Random();
    final json = {
      'activePrograms': 4 + (_calls > 1 ? rnd.nextInt(3) : 0),
      'totalLearners': 360 + (_calls > 1 ? rnd.nextInt(40) : 0),
      'totalRevenue': 14250.0 + (_calls > 1 ? rnd.nextInt(1500) : 0),
    };
    return DashboardMetrics.fromJson(json);
  }
}

/// Screen 12: Teacher Dashboard
/// Welcome header, 3 DYNAMIC metric cards (loaded from a data model),
/// pull-to-refresh, and two quick actions.
/// StatefulWidget = a screen that can change (numbers load and refresh).
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

  // Used by pull-to-refresh, the reload icon and the Retry button
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
      // the error UI is shown by the FutureBuilder
    }
  }

  // Logout: go back to Role Selection and clear all earlier screens,
  // so the Back button can't return to the dashboard.
  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.roleSelection,
      (route) => false,
    );
  }

  // 14250 -> $14,250
  String _formatMoney(double v) {
    final s = v.toStringAsFixed(0);
    final withCommas =
        s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '\$$withCommas';
  }

  // The 3 metric cards, built from the loaded model
  Widget _buildMetrics(DashboardMetrics m) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'Active Programs',
                value: '${m.activePrograms}',
                icon: Icons.layers_rounded,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _MetricCard(
                title: 'Total Learners',
                value: '${m.totalLearners}',
                icon: Icons.people_alt_rounded,
                color: AppTheme.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _MetricCard(
          title: 'Total Revenue Earned',
          value: _formatMoney(m.totalRevenue),
          icon: Icons.account_balance_wallet_rounded,
          color: AppTheme.success,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // RefreshIndicator = pull down to reload
        child: RefreshIndicator(
          onRefresh: _reload,
          child: SingleChildScrollView(
            // Always scrollable so pull-to-refresh works even on tall screens
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- 1. HEADER: avatar + greeting + reload + logout ----------
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

                // ---------- 2. METRIC CARDS (dynamic) ----------
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),

                // FutureBuilder rebuilds this part for each state:
                // loading -> spinner, error -> retry, success -> cards
                FutureBuilder<DashboardMetrics>(
                  future: _metricsFuture,
                  builder: (context, snapshot) {
                    // LOADING
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    // ERROR
                    if (snapshot.hasError || !snapshot.hasData) {
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
                            const Icon(Icons.error_outline_rounded,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 10),
                            const Text(
                              'Could not load your dashboard stats.',
                              style: TextStyle(
                                  color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                              onPressed: _reload,
                            ),
                          ],
                        ),
                      );
                    }
                    // SUCCESS
                    return _buildMetrics(snapshot.data!);
                  },
                ),
                const SizedBox(height: 28),

                // ---------- 3. QUICK ACTIONS ----------
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),

                // Action 1: opens Screen 13 (Cart Management)
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

                // Action 2: Create New Program button (placeholder for now)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
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

/// One reusable stat card (icon, big number, label).
/// Built once here and used three times above, so we don't repeat code.
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
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