import 'package:flutter/foundation.dart';

/// Lightweight in-memory store for the learner's cart and enrolments.
///
/// Screens listen to [enrolledIds] / [cartIds] with a `ValueListenableBuilder`
/// so badges and buttons update the moment the state changes (e.g. after a
/// successful payment).
class EnrollmentService {
  EnrollmentService._();

  static final EnrollmentService instance = EnrollmentService._();

  final ValueNotifier<Set<String>> enrolledIds =
      ValueNotifier<Set<String>>(<String>{});
  final ValueNotifier<Set<String>> cartIds =
      ValueNotifier<Set<String>>(<String>{});

  bool isEnrolled(String programId) => enrolledIds.value.contains(programId);

  bool isInCart(String programId) => cartIds.value.contains(programId);

  void addToCart(String programId) {
    if (isEnrolled(programId) || isInCart(programId)) return;
    cartIds.value = {...cartIds.value, programId};
  }

  void removeFromCart(String programId) {
    cartIds.value = {...cartIds.value}..remove(programId);
  }

  void enroll(String programId) {
    enrolledIds.value = {...enrolledIds.value, programId};
    removeFromCart(programId);
  }

  /// Called on payment success: every program in the cart becomes enrolled.
  void checkoutCart() {
    if (cartIds.value.isEmpty) return;
    enrolledIds.value = {...enrolledIds.value, ...cartIds.value};
    cartIds.value = <String>{};
  }

  /// Clears all state. Intended for tests.
  @visibleForTesting
  void reset() {
    enrolledIds.value = <String>{};
    cartIds.value = <String>{};
  }
}
