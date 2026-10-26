import 'package:flutter/material.dart';

/// Centralized form validation rules for Teacher Login and Signup.
class AuthValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates full name input.
  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Please enter your name';
    }
    if (v.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  /// Validates email address with standard regex.
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailRegExp.hasMatch(v)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password with minimum length of 6 characters.
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) {
      return 'Please enter your password';
    }
    if (v.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

/// Helper function to show styled SnackBars across Teacher Auth screens.
void showAuthSnackBar(
  BuildContext context,
  String message, {
  bool isSuccess = false,
  bool isInfo = false,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.hideCurrentSnackBar();

  Color backgroundColor;
  IconData iconData;

  if (isSuccess) {
    backgroundColor = const Color(0xFF10B981); // Emerald Green
    iconData = Icons.check_circle_rounded;
  } else if (isInfo) {
    backgroundColor = const Color(0xFF3B82F6); // Blue
    iconData = Icons.info_outline_rounded;
  } else {
    backgroundColor = const Color(0xFFEF4444); // Red
    iconData = Icons.error_outline_rounded;
  }

  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 3),
    ),
  );
}
