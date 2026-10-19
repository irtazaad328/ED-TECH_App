/// Teacher authentication service for prototype and state management.
class TeacherAuthResult {
  final bool success;
  final String message;

  const TeacherAuthResult({
    required this.success,
    required this.message,
  });
}

class TeacherAuthService {
  TeacherAuthService._();
  static final TeacherAuthService instance = TeacherAuthService._();

  // Mock in-memory teacher credentials
  final Map<String, String> _teachers = {
    'teacher@edtech.com': 'password123',
    'admin@edtech.com': 'admin123',
  };

  /// Login validation.
  TeacherAuthResult login({
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();

    if (_teachers.containsKey(cleanEmail)) {
      if (_teachers[cleanEmail] == password) {
        return const TeacherAuthResult(
          success: true,
          message: 'Login successful! Welcome back.',
        );
      } else {
        return const TeacherAuthResult(
          success: false,
          message: 'Incorrect password. Please try again.',
        );
      }
    }

    // In prototype, register and allow login
    _teachers[cleanEmail] = password;
    return const TeacherAuthResult(
      success: true,
      message: 'Login successful!',
    );
  }

  /// Signup registration.
  TeacherAuthResult signUp({
    required String name,
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    _teachers[cleanEmail] = password;

    return TeacherAuthResult(
      success: true,
      message: 'Account created for $name! You can now log in.',
    );
  }
}
