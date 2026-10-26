import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/teacher_auth_service.dart';
import 'widgets/auth_validators.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_isLoading) return;

    // Runs every validator in the Form; shows the error text under each field.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate a network request for 1 second while the spinner shows.
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final name = _nameController.text.trim();
    final result = TeacherAuthService.instance.signUp(
      name: name,
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);
    showAuthSnackBar(
      context,
      result.success
          ? 'Welcome, $name! Your account has been created.'
          : result.message,
      isSuccess: result.success,
    );

    if (result.success) {
      // Clear earlier screens so Back can't return to the signup form.
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.teacherDashboard,
        (route) => false,
      );
    }
  }

  void _googleSignUp() {
    showAuthSnackBar(
      context,
      'Google sign-up is not available in this prototype yet.',
      isInfo: true,
    );
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
                        validator: AuthValidators.fullName,
                      ),
                      const SizedBox(height: 22),
                      WireframeField(
                        controller: _emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: AuthValidators.email,
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
                        validator: AuthValidators.password,
                      ),
                      const SizedBox(height: 32),
                      BlackButton(
                        label: 'Sign up',
                        onPressed: _signUp,
                        isLoading: _isLoading,
                      ),
                      const OrText(),
                      OutlinedGoogleButton(
                        label: 'Sign up with google',
                        onPressed: _isLoading ? null : _googleSignUp,
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      SwitchAuthLink(
                        prompt: 'Have an account?',
                        action: 'Login',
                        onTap: () {
                          if (_isLoading) return;
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.teacherLogin);
                        },
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
