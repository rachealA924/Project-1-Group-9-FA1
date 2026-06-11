import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/auth_service.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/onboarding_interests_screen.dart';
import 'package:alu_connect/features/home/user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSSO() async {
    final err = _auth.validateEmail(_emailController.text);
    if (err != null) { setState(() => _emailError = err); return; }
    setState(() { _loading = true; _emailError = null; });
    final result = await _auth.signInWithEmail(_emailController.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      UserSession().setFromLogin(email: _emailController.text.trim());
      Navigator.push(context, fadeRoute(const OnboardingInterestsScreen()));
    } else {
      setState(() => _emailError = result.errorMessage);
    }
  }

  Future<void> _handleGoogle() async {
    setState(() => _loading = true);
    final result = await _auth.signInWithGoogle();
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      // Uses real name + photo from Google account
      // (or mock values while package is not yet integrated)
      UserSession().setFromLogin(
        email: result.email ?? 'student@alustudent.com',
        name: result.name,
        googlePhotoUrl: result.photoUrl,
        fromGoogle: true,
      );
      Navigator.push(context, fadeRoute(const OnboardingInterestsScreen()));
    } else {
      _showSnack(result.errorMessage ?? 'Google sign-in failed');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Color(0xFFF0EDE4))),
      backgroundColor: const Color(0xFF1C2030),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: AbsorbPointer(
        absorbing: _loading,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 40,
                    child: Container(
                      width: 240, height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          const Color(0xFFF5C842).withOpacity(0.15), Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5C842),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(
                            color: const Color(0xFFF5C842).withOpacity(0.35),
                            blurRadius: 32, offset: const Offset(0, 8),
                          )],
                        ),
                        child: const Icon(Icons.school_rounded, color: Color(0xFF0D0F14), size: 36),
                      ),
                      const SizedBox(height: 20),
                      const Text('ALU Connect+', style: TextStyle(
                        color: Color(0xFFF0EDE4), fontSize: 24,
                        fontWeight: FontWeight.w700, letterSpacing: -0.5,
                      )),
                      const SizedBox(height: 6),
                      const Text('Secure access to your digital campus',
                          style: TextStyle(color: Color(0xFF8A8D99), fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ALU Email Address', style: TextStyle(
                        color: Color(0xFF8A8D99), fontSize: 12, letterSpacing: 0.3)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Color(0xFFF0EDE4), fontSize: 14),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) { if (_emailError != null) setState(() => _emailError = null); },
                      decoration: InputDecoration(
                        hintText: 'you@alustudent.com',
                        hintStyle: const TextStyle(color: Color(0xFF8A8D99)),
                        prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF8A8D99), size: 18),
                        errorText: _emailError,
                        errorStyle: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 11),
                        filled: true,
                        fillColor: const Color(0xFF1C2030),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: const Color(0xFFF5C842).withOpacity(0.15))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _emailError != null
                                ? const Color(0xFFFF6B6B)
                                : const Color(0xFFF5C842).withOpacity(0.15))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: const Color(0xFFF5C842).withOpacity(0.5))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Accepted: @alustudent.com · @alueducation.com · @si.alueducation.com',
                      style: TextStyle(color: Color(0xFF5A5D6A), fontSize: 10.5),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _handleSSO,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5C842),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(Color(0xFF0D0F14))))
                            : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.login_rounded, size: 18, color: Color(0xFF0D0F14)),
                                SizedBox(width: 8),
                                Text('Log in via ALU SSO', style: TextStyle(
                                    color: Color(0xFF0D0F14), fontSize: 14, fontWeight: FontWeight.w600)),
                              ]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: Divider(color: const Color(0xFFF5C842).withOpacity(0.15))),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or', style: TextStyle(color: Color(0xFF8A8D99), fontSize: 12))),
                      Expanded(child: Divider(color: const Color(0xFFF5C842).withOpacity(0.15))),
                    ]),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _loading ? null : _handleGoogle,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFFF5C842).withOpacity(0.15)),
                          backgroundColor: const Color(0xFF1C2030),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SizedBox(width: 18, height: 18, child: CustomPaint(painter: _GoogleIconPainter())),
                          const SizedBox(width: 10),
                          const Text('Continue with Google', style: TextStyle(
                              color: Color(0xFFF0EDE4), fontSize: 14, fontWeight: FontWeight.w500)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2; final cy = size.height / 2; final r = size.width / 2;
    final paints = [Paint()..color = const Color(0xFF4285F4), Paint()..color = const Color(0xFF34A853),
      Paint()..color = const Color(0xFFFBBC05), Paint()..color = const Color(0xFFEA4335)];
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), -1.57, 3.14, false,
        paints[0]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 1.57, 1.57, false,
        paints[1]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 3.14, 0.79, false,
        paints[2]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);
    canvas.drawRect(Rect.fromLTWH(cx, cy - size.height * 0.12, r * 0.85, size.height * 0.24),
        paints[0]..style = PaintingStyle.fill);
  }
  @override bool shouldRepaint(_) => false;
}