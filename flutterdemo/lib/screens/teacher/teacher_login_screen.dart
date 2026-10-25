import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/teacher_auth_service.dart';
import 'widgets/auth_validators.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;

    // Runs every validator in the Form; shows the error text under each field.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate a network request for 1 second while the spinner shows.
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final result = TeacherAuthService.instance.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);
    showAuthSnackBar(context, result.message, isSuccess: result.success);

    if (result.success) {
      Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
    }
  }

  void _googleLogin() {
    showAuthSnackBar(
      context,
      'Google sign-in is not available in this prototype yet.',
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
                        label: 'Login',
                        onPressed: _login,
                        isLoading: _isLoading,
                      ),
                      const OrText(),
                      OutlinedGoogleButton(
                        label: 'Continue with google',
                        onPressed: _isLoading ? null : _googleLogin,
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      SwitchAuthLink(
                        prompt: 'New here?',
                        action: 'Sign up',
                        onTap: () {
                          if (_isLoading) return;
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.teacherSignup);
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
