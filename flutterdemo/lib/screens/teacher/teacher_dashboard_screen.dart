import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Screen 12: Teacher Dashboard
/// Shows a welcome header, three metric cards and two quick actions.
/// StatelessWidget = a screen that never changes by itself (the numbers are fixed for now).
class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  // Logout: go back to Role Selection and clear all earlier screens,
  // so the Back button can't return to the dashboard.
  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.roleSelection,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- 1. HEADER: avatar + greeting + logout ----------
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
                    tooltip: 'Logout',
                    icon: const Icon(Icons.logout_rounded),
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ---------- 2. METRIC CARDS ----------
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Expanded(
                    child: _MetricCard(
                      title: 'Active Programs',
                      value: '4',
                      icon: Icons.layers_rounded,
                      color: AppTheme.primary,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _MetricCard(
                      title: 'Total Learners',
                      value: '360',
                      icon: Icons.people_alt_rounded,
                      color: AppTheme.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _MetricCard(
                title: 'Total Revenue Earned',
                value: '\$14,250',
                icon: Icons.account_balance_wallet_rounded,
                color: AppTheme.success,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.cartManagement),
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