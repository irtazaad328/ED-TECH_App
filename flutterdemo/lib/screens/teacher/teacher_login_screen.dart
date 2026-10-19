import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/teacher_auth_service.dart';
import 'widgets/auth_widgets.dart';

/// Admin Login (Figma: Team 6 Wireframes > Aishika > "Admin Login").
/// Logo, "Teacher Login" title, Email, Password, Login, or,
/// Continue with Google, and a "New here? Sign up" link.
class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _login() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final result = TeacherAuthService.instance.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (result.success) {
      Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
    } else {
      _showMessage(result.message);
    }
  }

  void _googleLogin() {
    _showMessage('Google sign-in is not available in this prototype yet.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AuthColors.ink),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Center(child: LogoBox()),
                      const SizedBox(height: 28),
                      const Text(
                        'Teacher Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          color: AuthColors.ink,
                        ),
                      ),
                      const SizedBox(height: 28),
                      WireframeField(
                        controller: _emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Please enter your email';
                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      WireframeField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscure: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AuthColors.border,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          final value = v ?? '';
                          if (value.isEmpty) return 'Please enter your password';
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      BlackButton(label: 'Login', onPressed: _login),
                      const OrText(),
                      OutlinedGoogleButton(
                        label: 'Continue with google',
                        onPressed: _googleLogin,
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      SwitchAuthLink(
                        prompt: 'New here?',
                        action: 'Sign up',
                        onTap: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.teacherSignup),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
