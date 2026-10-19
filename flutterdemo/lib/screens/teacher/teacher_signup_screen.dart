import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/teacher_auth_service.dart';
import 'widgets/auth_widgets.dart';

/// Admin Signup (Figma: Team 6 Wireframes > Aishika > "Admin Signup").
/// "Create account" title, Name, Email, Password, Sign up, or,
/// Sign up with Google, and a "Have an account? Login" link.
class TeacherSignupScreen extends StatefulWidget {
  const TeacherSignupScreen({super.key});

  @override
  State<TeacherSignupScreen> createState() => _TeacherSignupScreenState();
}

class _TeacherSignupScreenState extends State<TeacherSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _signUp() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final result = TeacherAuthService.instance.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    _showMessage(result.message);
    if (result.success) {
      Navigator.pushReplacementNamed(context, AppRoutes.teacherLogin);
    }
  }

  void _googleSignUp() {
    _showMessage('Google sign-up is not available in this prototype yet.');
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
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w500,
                          color: AuthColors.ink,
                        ),
                      ),
                      const SizedBox(height: 40),
                      WireframeField(
                        controller: _nameController,
                        hint: 'Name',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 22),
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
                          if (value.isEmpty) return 'Please enter a password';
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      BlackButton(label: 'Sign up', onPressed: _signUp),
                      const OrText(),
                      OutlinedGoogleButton(
                        label: 'Sign up with google',
                        onPressed: _googleSignUp,
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      SwitchAuthLink(
                        prompt: 'Have an account?',
                        action: 'Login',
                        onTap: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.teacherLogin),
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
