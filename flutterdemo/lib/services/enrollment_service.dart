import 'package:flutter/foundation.dart';
import '../models/program_model.dart';

/// Lightweight in-memory store for the learner's cart and enrolments.
///
/// Screens listen to [cart] / [enrolled] (e.g. with `ValueListenableBuilder`
/// or `AnimatedBuilder`) so the cart, the Home portal and the Program Details
/// badge all update the moment the state changes.
class EnrollmentService {
  EnrollmentService._();

  static final EnrollmentService instance = EnrollmentService._();

  /// Programs the learner has added to the cart but not paid for yet.
  final ValueNotifier<List<Program>> cart = ValueNotifier<List<Program>>([]);

  /// Programs the learner has paid for.
  final ValueNotifier<List<Program>> enrolled =
      ValueNotifier<List<Program>>([]);

  /// Fires whenever either the cart or the enrolments change.
  late final Listenable changes = Listenable.merge([cart, enrolled]);

  bool isEnrolled(String programId) =>
      enrolled.value.any((p) => p.id == programId);

  bool isInCart(String programId) => cart.value.any((p) => p.id == programId);

  double get cartSubtotal =>
      cart.value.fold(0.0, (sum, program) => sum + program.price);

  void addToCart(Program program) {
    if (isEnrolled(program.id) || isInCart(program.id)) return;
    cart.value = [...cart.value, program];
  }

  void removeFromCart(String programId) {
    cart.value = cart.value.where((p) => p.id != programId).toList();
  }

  void enroll(Program program) {
    if (!isEnrolled(program.id)) {
      enrolled.value = [...enrolled.value, program];
    }
    removeFromCart(program.id);
  }

  /// Called on payment success: every program in the cart becomes enrolled.
  void checkoutCart() {
    if (cart.value.isEmpty) return;
    final newOnes = cart.value.where((p) => !isEnrolled(p.id));
    enrolled.value = [...enrolled.value, ...newOnes];
    cart.value = [];
  }

  /// Clears all state. Intended for tests.
  @visibleForTesting
  void reset() {
    enrolled.value = [];
    cart.value = [];
  }
}
