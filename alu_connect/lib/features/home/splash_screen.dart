import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/login_screen.dart';
import 'package:alu_connect/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // ── Animation controllers ───────────────────────────────────
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _taglineController;
  late final AnimationController _barController;

  // ── Animations ──────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoGlow;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _barWidth;

  @override
  void initState() {
    super.initState();

    // Make status bar transparent over splash
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // Logo: scale up + fade in (0 → 600ms)
    _logoController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.6)));
    _logoGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: const Interval(0.4, 1.0)));

    // App name: slide up + fade (400ms after logo starts)
    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textSlide = Tween<Offset>(
        begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    // Tagline: fade in after name
    _taglineController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _taglineController, curve: Curves.easeIn));

    // Loading bar: fills from 0 → full (runs while checking auth)
    _barController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _barWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _barController, curve: Curves.easeInOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    // 1. Logo appears
    await _logoController.forward();

    // 2. App name slides up
    await Future.delayed(const Duration(milliseconds: 100));
    await _textController.forward();

    // 3. Tagline fades in + loading bar starts simultaneously
    await Future.delayed(const Duration(milliseconds: 80));
    _taglineController.forward();
    _barController.forward();

    // 4. Check auth state while bar animates
    await _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for the loading bar to finish
    await _barController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // TODO: Replace with real auth check, e.g.:
    // final user = FirebaseAuth.instance.currentUser;
    // final isLoggedIn = user != null;
    const isLoggedIn = false; // always show login for now

    Navigator.pushReplacement(
      context,
      isLoggedIn ? revealRoute(MainNavigation()) : fadeRoute(const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: Stack(
        children: [

          // ── Background radial glow ──────────────────────────
          AnimatedBuilder(
            animation: _logoGlow,
            builder: (_, __) => Positioned(
              top: size.height * 0.25,
              left: size.width / 2 - 160,
              child: Opacity(
                opacity: _logoGlow.value * 0.6,
                child: Container(
                  width: 320, height: 320,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x33F5C842), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Centered content ────────────────────────────────
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Logo mark
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, child) => FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(scale: _logoScale, child: child),
                  ),
                  child: Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C842),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF5C842).withOpacity(0.4),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Color(0xFF0D0F14),
                      size: 44,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // App name
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: const Text(
                      'ALU Connect+',
                      style: TextStyle(
                        color: Color(0xFFF0EDE4),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                FadeTransition(
                  opacity: _taglineFade,
                  child: const Text(
                    'Your digital campus, connected.',
                    style: TextStyle(
                      color: Color(0xFF8A8D99),
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Loading bar at bottom ───────────────────────────
          Positioned(
            bottom: 60,
            left: 48,
            right: 48,
            child: Column(
              children: [
                // Track
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2030),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: AnimatedBuilder(
                    animation: _barWidth,
                    builder: (_, __) => FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _barWidth.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC9A227), Color(0xFFF5C842)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF5C842).withOpacity(0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Version tag
                FadeTransition(
                  opacity: _taglineFade,
                  child: const Text(
                    'African Leadership University · v1.0',
                    style: TextStyle(color: Color(0xFF3A3D4A), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}