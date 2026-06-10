import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/events/widgets/shared_widgets.dart';
import 'package:alu_connect/features/events/screens/event_discovery.dart';

class EventCreatedScreen extends StatefulWidget {
  const EventCreatedScreen({super.key});

  @override
  State<EventCreatedScreen> createState() => _EventCreatedScreenState();
}

class _EventCreatedScreenState extends State<EventCreatedScreen> with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _slideController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation = CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(parent: _slideController, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 100), () => _scaleController.forward());
    Future.delayed(const Duration(milliseconds: 400), () => _slideController.forward());
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.05))),
                    Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.1))),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                      child: const Icon(Icons.check_rounded, color: AppColors.onPrimary, size: 40),
                    ),
                    Positioned(top: 2, right: 8, child: Icon(Icons.star_rounded, color: AppColors.primary, size: 10)),
                    Positioned(top: 12, left: 4, child: Icon(Icons.star_rounded, color: AppColors.primary, size: 6)),
                    Positioned(bottom: 6, right: 0, child: Icon(Icons.star_rounded, color: AppColors.primary, size: 8)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: const Column(
                    children: [
                      Text('Event Published!', style: TextStyle(color: AppColors.textPrimary, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                      SizedBox(height: 10),
                      Text(
                        'Your academic showcase is now live for\nthe ALU community to join.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                          child: const Text('Published', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Icon(Icons.people_outline_rounded, color: AppColors.textMuted, size: 40)),
                        ),
                        const SizedBox(height: 12),
                        const Text('Tech Innovations Summit\n2026', style: TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700, height: 1.3)),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.calendar_today_rounded, color: AppColors.textMuted, size: 13),
                            SizedBox(width: 5),
                            Text('Nov 12, 18:00', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            SizedBox(width: 12),
                            Icon(Icons.location_on_rounded, color: AppColors.textMuted, size: 13),
                            SizedBox(width: 5),
                            Text('Main Auditorium', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share_rounded, size: 16),
                              label: const Text('Share Event'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: const BorderSide(color: AppColors.border),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.person_add_rounded, size: 16),
                              label: const Text('Invite Peers'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: const BorderSide(color: AppColors.border),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AccentButton(label: 'Go to My Events', onPressed: () {}),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const EventDiscoveryScreen()),
                              (route) => false,
                        ),
                        child: const Text('Back to Discovery', style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
