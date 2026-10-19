import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/common/login_screen.dart';
import 'screens/common/role_selection_screen.dart';
import 'screens/common/signup_screen.dart';
import 'screens/learner/cart_screen.dart';
import 'screens/learner/home_screen.dart';
import 'screens/learner/payment_screen.dart';
import 'screens/learner/program_details_screen.dart';
import 'screens/learner/programs_list_screen.dart';
import 'screens/teacher/cart_management_screen.dart';
import 'screens/teacher/teacher_dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EdTechApp());
}

class EdTechApp extends StatelessWidget {
  const EdTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ed Tech - Team 6',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.roleSelection: (context) => const RoleSelectionScreen(),
        AppRoutes.learnerLogin: (context) => const LoginScreen(isTeacher: false),
        AppRoutes.learnerSignup: (context) => const SignupScreen(isTeacher: false),
        AppRoutes.teacherLogin: (context) => const LoginScreen(isTeacher: true),
        AppRoutes.teacherSignup: (context) => const SignupScreen(isTeacher: true),
        AppRoutes.learnerHome: (context) => const LearnerHomeScreen(),
        AppRoutes.programsList: (context) => const ProgramsListScreen(),
        AppRoutes.programDetails: (context) => const ProgramDetailsScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
        AppRoutes.payment: (context) => const PaymentScreen(),
        AppRoutes.teacherDashboard: (context) => const TeacherDashboardScreen(),
        AppRoutes.cartManagement: (context) => const CartManagementScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo1.png',
                height: 220,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.school_rounded, size: 100, color: AppTheme.primary),
              ),
              const SizedBox(height: 36),
              const Text(
                'Welcome to Ed Tech',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Discover programs, learn new skills, and connect teachers with learners.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}