import 'package:flutter/foundation.dart';
import '../models/program_model.dart';

/// Lightweight in-memory store for each learner's cart and enrolments.
///
/// Every learner (identified by email) has their own cart and their own list
/// of enrolled programs. Login / signup call [signIn], logout calls
/// [signOut]. [cart] and [enrolled] always reflect the learner who is
/// currently signed in, so screens can listen to them (e.g. with
/// `ValueListenableBuilder` or `AnimatedBuilder`) and update instantly.
///
/// Data lives in memory only, so it resets when the app restarts.
class EnrollmentService {
  EnrollmentService._();

  static final EnrollmentService instance = EnrollmentService._();

  /// Key used when nobody is signed in (e.g. widget tests, or opening a
  /// screen directly).
  static const String _guestKey = '__guest__';

  final Map<String, List<Program>> _cartsByUser = {};
  final Map<String, List<Program>> _enrolledByUser = {};

  String? _currentUser;

  /// Programs the signed-in learner has added to the cart but not paid for.
  final ValueNotifier<List<Program>> cart = ValueNotifier<List<Program>>([]);

  /// Programs the signed-in learner has paid for.
  final ValueNotifier<List<Program>> enrolled =
      ValueNotifier<List<Program>>([]);

  /// Fires whenever either the cart or the enrolments change.
  late final Listenable changes = Listenable.merge([cart, enrolled]);

  /// Email of the learner who is signed in, or null.
  String? get currentUser => _currentUser;

  String get _key => _currentUser ?? _guestKey;

  // ---------------------------------------------------------------------------
  // Session
  // ---------------------------------------------------------------------------

  /// Switches to [email]'s cart and enrolments (created empty the first time).
  void signIn(String email) {
    _currentUser = email.trim().toLowerCase();
    _loadCurrentUser();
  }

  /// Signs out. The learner's data is kept for when they sign in again.
  void signOut() {
    _currentUser = null;
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    cart.value = List.of(_cartsByUser[_key] ?? const <Program>[]);
    enrolled.value = List.of(_enrolledByUser[_key] ?? const <Program>[]);
  }

  void _setCart(List<Program> programs) {
    _cartsByUser[_key] = programs;
    cart.value = List.of(programs);
  }

  void _setEnrolled(List<Program> programs) {
    _enrolledByUser[_key] = programs;
    enrolled.value = List.of(programs);
  }

  // ---------------------------------------------------------------------------
  // Cart & enrolment (always for the signed-in learner)
  // ---------------------------------------------------------------------------

  bool isEnrolled(String programId) =>
      enrolled.value.any((p) => p.id == programId);

  bool isInCart(String programId) => cart.value.any((p) => p.id == programId);

  double get cartSubtotal =>
      cart.value.fold(0.0, (sum, program) => sum + program.price);

  void addToCart(Program program) {
    if (isEnrolled(program.id) || isInCart(program.id)) return;
    _setCart([...cart.value, program]);
  }

  void removeFromCart(String programId) {
    _setCart(cart.value.where((p) => p.id != programId).toList());
  }

  void enroll(Program program) {
    if (!isEnrolled(program.id)) {
      _setEnrolled([...enrolled.value, program]);
    }
    removeFromCart(program.id);
  }

  /// Called on payment success: every program in the cart becomes enrolled.
  void checkoutCart() {
    if (cart.value.isEmpty) return;
    final newOnes = cart.value.where((p) => !isEnrolled(p.id));
    _setEnrolled([...enrolled.value, ...newOnes]);
    _setCart([]);
  }

  /// Clears all learners and signs out. Intended for tests.
  @visibleForTesting
  void reset() {
    _cartsByUser.clear();
    _enrolledByUser.clear();
    _currentUser = null;
    _loadCurrentUser();
  }
}
