import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/home_screen.dart';

class OnboardingCampusScreen extends StatefulWidget {
  final List<String> interests;
  const OnboardingCampusScreen({super.key, required this.interests});

  @override
  State<OnboardingCampusScreen> createState() => _OnboardingCampusScreenState();
}

class _OnboardingCampusScreenState extends State<OnboardingCampusScreen> {
  String _selectedCampus = 'rwanda';

  void _completeSetup() {
    Navigator.pushAndRemoveUntil(
      context,
      revealRoute(HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackButton(onTap: () => Navigator.pop(context)),
                  TextButton(
                    onPressed: _completeSetup,
                    child: const Text('SKIP', style: TextStyle(
                      color: Color(0xFF8A8D99), fontSize: 13, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select your campus', style: TextStyle(
                      color: Color(0xFFF0EDE4), fontSize: 26,
                      fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1.2,
                    )),
                    const SizedBox(height: 8),
                    const Text(
                      'Tailor your Connect+ experience with localized news, events, and community access.',
                      style: TextStyle(color: Color(0xFF8A8D99), fontSize: 13, height: 1.55),
                    ),
                    const SizedBox(height: 28),

                    // FIX 1: removed duplicate imagePath — use the asset path when your
                    // image is ready, or keep null to show the placeholder.
                    _CampusCard(
                      id: 'rwanda',
                      name: 'ALU Rwanda',
                      location: 'Kigali Innovation City',
                      imagePath: 'assets/ALU RWA campus.png', // set null to use placeholder
                      placeholderIcon: Icons.location_city_rounded,
                      placeholderColor: const Color(0xFF1C2440),
                      isSelected: _selectedCampus == 'rwanda',
                      onTap: () => setState(() => _selectedCampus = 'rwanda'),
                    ),
                    const SizedBox(height: 12),

                    _CampusCard(
                      id: 'mauritius',
                      name: 'ALC Mauritius',
                      location: 'Pamplemousses',
                      imagePath: 'assets/Mauritius Campus.png', // set null to use placeholder
                      placeholderIcon: Icons.account_balance_rounded,
                      placeholderColor: const Color(0xFF1A2430),
                      isSelected: _selectedCampus == 'mauritius',
                      onTap: () => setState(() => _selectedCampus = 'mauritius'),
                    ),
                    const SizedBox(height: 12),

                    _RemoteCampusCard(
                      isSelected: _selectedCampus == 'remote',
                      onTap: () => setState(() => _selectedCampus = 'remote'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Footer
            _OnboardingFooter(
              currentStep: 1,
              totalSteps: 2,
              buttonLabel: 'Complete Setup',
              onTap: _completeSetup,
            ),
          ],
        ),
      ),
    );
  }
}

// FIX 2: imagePath is now String? (nullable) so null is a valid value
class _CampusCard extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String? imagePath; // nullable — null shows the placeholder
  final IconData placeholderIcon;
  final Color placeholderColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _CampusCard({
    required this.id,
    required this.name,
    required this.location,
    required this.imagePath,
    required this.placeholderIcon,
    required this.placeholderColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF5C842)
                : const Color(0xFFF5C842).withOpacity(0.15),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Image area
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: imagePath != null
                      ? Image.asset(
                          imagePath!,
                          width: double.infinity,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _Placeholder(
                            color: placeholderColor,
                            icon: placeholderIcon,
                          ),
                        )
                      : _Placeholder(
                          color: placeholderColor,
                          icon: placeholderIcon,
                        ),
                ),

                // Info row
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF141720),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(
                        color: Color(0xFFF0EDE4),
                        fontSize: 14, fontWeight: FontWeight.w600,
                      )),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on_rounded,
                            color: Color(0xFF8A8D99), size: 12),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(
                            color: Color(0xFF8A8D99), fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),

            // Checkmark when selected
            if (isSelected)
              Positioned(
                top: 10, right: 10,
                child: Container(
                  width: 24, height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5C842), shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded,
                      color: Color(0xFF0D0F14), size: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// FIX 3: placeholder no longer shows hardcoded Mauritius path text
class _Placeholder extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _Placeholder({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      color: color,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.04,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, mainAxisSpacing: 2, crossAxisSpacing: 2),
              itemCount: 64,
              itemBuilder: (_, __) => Container(color: const Color(0xFFF5C842)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF5C842).withOpacity(0.08),
                  Colors.transparent,
                  const Color(0xFFF5C842).withOpacity(0.05),
                ],
              ),
            ),
          ),
          Icon(icon, color: const Color(0xFFF5C842).withOpacity(0.35), size: 40),
        ],
      ),
    );
  }
}

// Remote campus row

class _RemoteCampusCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  const _RemoteCampusCard({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141720),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF5C842)
                : const Color(0xFFF5C842).withOpacity(0.15),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF1C2030),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.15)),
              ),
              child: const Center(child: Text('🌐', style: TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ALX Hub / Remote', style: TextStyle(
                    color: Color(0xFFF0EDE4), fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 3),
                  Text('Global Community Access', style: TextStyle(
                    color: Color(0xFF8A8D99), fontSize: 12)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFFF5C842), size: 22),
          ],
        ),
      ),
    );
  }
}

// Shared widgets

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1C2030),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.15)),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFF0EDE4), size: 16),
      ),
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String buttonLabel;
  final VoidCallback onTap;

  const _OnboardingFooter({
    required this.currentStep,
    required this.totalSteps,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (i) {
              final active = i == currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFF5C842) : const Color(0xFF1C2030),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5C842),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(buttonLabel, style: const TextStyle(
                    color: Color(0xFF0D0F14), fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Color(0xFF0D0F14), size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}