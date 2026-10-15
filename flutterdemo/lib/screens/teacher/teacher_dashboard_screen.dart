import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Instructor! 🎓',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Here is the performance overview of your programs.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Metrics Grid
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
              value: '\$14,250.00',
              icon: Icons.account_balance_wallet_rounded,
              color: AppTheme.success,
            ),
            const SizedBox(height: 28),

            // Quick Actions Header
            const Text(
              'Admin Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            // Action 1: Cart Management
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(Icons.shopping_bag_outlined, color: AppTheme.primary),
                ),
                title: const Text('Cart & Enrollment Management', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('See learners who added courses or completed payment'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.cartManagement);
                },
              ),
            ),
            const SizedBox(height: 10),

            // Action 2: Add Program Mock
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF0FDF4),
                  child: Icon(Icons.add_circle_outline_rounded, color: AppTheme.success),
                ),
                title: const Text('Create New Program', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Publish new curriculum and set course pricing'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add Program feature planned for upcoming sprints.')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
