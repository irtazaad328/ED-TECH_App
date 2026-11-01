import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// User Profile & Settings screen (shared by Learners and Teachers).
/// Shows name, email, role badge and course count, a Preferences section
/// (notifications + dark mode, both UI-only for now) and a Logout button.
class ProfileSettingsScreen extends StatefulWidget {
  final UserProfile profile;

  const ProfileSettingsScreen({super.key, required this.profile});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false; // dummy: does not change the app theme yet

  UserProfile get _profile => widget.profile;

  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Logout Confirmation'),
          content: Text(
            'Are you sure you want to log out of your '
            '${_profile.isTeacher ? 'teacher' : 'student'} account?',
          ),
          actions: [
            TextButton(
              key: const ValueKey('cancel_logout_button'),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              key: const ValueKey('confirm_logout_button'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.pop(dialogContext); // close the dialog
                // Go to Role Selection and clear every earlier screen so
                // the Back button cannot return to a logged-in page.
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.roleSelection,
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  String get _initial {
    final name = _profile.name.trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildCourseCountCard(),
            const SizedBox(height: 24),
            const Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            _buildPreferencesCard(),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              key: const ValueKey('logout_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _confirmLogout,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primary,
              child: Text(
                _initial,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _profile.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _profile.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              key: const ValueKey('role_badge'),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _profile.roleLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCountCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book_rounded, color: AppTheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _profile.courseCountLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              '${_profile.courseCount}',
              key: const ValueKey('course_count'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            key: const ValueKey('notifications_switch'),
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Course updates and announcements'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          const Divider(height: 1),
          SwitchListTile(
            key: const ValueKey('dark_mode_switch'),
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            subtitle: const Text('Preview only. The app theme does not change yet'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
        ],
      ),
    );
  }
}
