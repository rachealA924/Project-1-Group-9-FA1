/// auth_service.dart
/// Mock authentication service.
/// Replace the body of [signInWithEmail] and [signInWithGoogle]
/// with your real backend / Firebase calls.

class AuthResult {
  final bool success;
  final String? errorMessage;
  const AuthResult.ok() : success = true, errorMessage = null;
  const AuthResult.fail(this.errorMessage) : success = false;
}

class AuthService {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  // ── Allowed ALU domains ─────────────────────────────────────
  // @alustudent.com        — student accounts
  // @alueducation.com      — staff / faculty accounts
  // @si.alueducation.com   — School of Integrated Design accounts

  static const _allowedDomains = [
    'alustudent.com',
    'alueducation.com',
    'si.alueducation.com',
  ];

  // ── Validation ──────────────────────────────────────────────

  /// Returns null if valid, or a descriptive error string.
  String? validateEmail(String email) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) return 'Please enter your ALU email address';

    // Basic email structure check
    final basicEmail = RegExp(r'^[\w.+\-]+@[\w.\-]+\.[a-zA-Z]{2,}$');
    if (!basicEmail.hasMatch(trimmed)) return 'Please enter a valid email address';

    // Must be one of the ALU domains
    final domain = trimmed.split('@').last.toLowerCase();
    if (!_allowedDomains.contains(domain)) {
      return 'Use your ALU email (@alustudent.com, @alueducation.com, or @si.alueducation.com)';
    }

    return null;
  }

  /// Returns the role inferred from the email domain.
  String roleFromEmail(String email) {
    final domain = email.trim().split('@').last.toLowerCase();
    if (domain == 'alustudent.com') return 'student';
    if (domain == 'si.alueducation.com') return 'faculty';
    if (domain == 'alueducation.com') return 'staff';
    return 'student';
  }

  // ── Mock sign-in ────────────────────────────────────────────

  /// Simulates a network call (~1.2 s delay).
  Future<AuthResult> signInWithEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final err = validateEmail(email);
    if (err != null) return AuthResult.fail(err);

    // TODO: replace with real SSO call, e.g:
    // await FirebaseAuth.instance.signInWithEmailLink(...)
    return const AuthResult.ok();
  }

  /// Simulates Google OAuth (~1 s delay).
  Future<AuthResult> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // TODO: replace with google_sign_in package
    // The Google account's email will still be validated server-side
    return const AuthResult.ok();
  }
}