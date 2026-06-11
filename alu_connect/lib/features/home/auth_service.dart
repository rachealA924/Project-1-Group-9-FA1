/// auth_service.dart
import 'package:google_sign_in/google_sign_in.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final String? name;
  final String? photoUrl;
  final String? email;

  const AuthResult.ok({this.name, this.photoUrl, this.email})
      : success = true, errorMessage = null;
  const AuthResult.fail(this.errorMessage)
      : success = false, name = null, photoUrl = null, email = null;
}

class AuthService {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  // Allowed ALU domains 
  static const _allowedDomains = [
    'alustudent.com',
    'alueducation.com',
    'si.alueducation.com',
  ];

  String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return 'Please enter your ALU email address';
    final basicEmail = RegExp(r'^[\w.+\-]+@[\w.\-]+\.[a-zA-Z]{2,}$');
    if (!basicEmail.hasMatch(trimmed)) return 'Please enter a valid email address';
    final domain = trimmed.split('@').last.toLowerCase();
    if (!_allowedDomains.contains(domain)) {
      return 'Use your ALU email (@alustudent.com, @alueducation.com, or @si.alueducation.com)';
    }
    return null;
  }

  String roleFromEmail(String email) {
    final domain = email.trim().split('@').last.toLowerCase();
    if (domain == 'alustudent.com') return 'student';
    if (domain == 'si.alueducation.com') return 'faculty';
    if (domain == 'alueducation.com') return 'staff';
    return 'student';
  }

  Future<AuthResult> signInWithEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final err = validateEmail(email);
    if (err != null) return AuthResult.fail(err);
    return const AuthResult.ok();
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
       final GoogleSignInAccount? account = await _googleSignIn.signIn();
       if (account == null) return AuthResult.fail('Sign-in cancelled');
       return AuthResult.ok(
         name: account.displayName,
         photoUrl: account.photoUrl,
         email: account.email,
       );
     } catch (e) {
       return AuthResult.fail('Google sign-in failed: $e');
     }

  }
}