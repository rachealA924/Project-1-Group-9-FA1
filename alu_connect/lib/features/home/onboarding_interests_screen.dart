import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/onboarding_campus_screen.dart';

class OnboardingInterestsScreen extends StatefulWidget {
  const OnboardingInterestsScreen({super.key});

  @override
  State<OnboardingInterestsScreen> createState() => _OnboardingInterestsScreenState();
}

class _OnboardingInterestsScreenState extends State<OnboardingInterestsScreen> {
  final Set<String> _selected = {'Entrepreneurship', 'Technology', 'Creative Writing'};

  final List<Map<String, dynamic>> _groups = [
    {
      'icon': '💡',
      'label': 'Innovation & Core',
      'topics': ['Entrepreneurship', 'Technology', 'Leadership', 'Venture Capital'],
    },
    {
      'icon': '🌍',
      'label': 'Impact & Society',
      'topics': ['Social Impact', 'Climate Action', 'Governance', 'Public Health'],
    },
    {
      'icon': '🎨',
      'label': 'Creative & Culture',
      'topics': ['Design', 'Creative Writing', 'Media & Film', 'Music'],
    },
    {
      'icon': '⚡',
      'label': 'Lifestyle & Sports',
      'topics': ['Athletics', 'Wellness', 'Travel'],
    },
  ];

  void _toggle(String topic) {
    setState(() {
      _selected.contains(topic) ? _selected.remove(topic) : _selected.add(topic);
    });
  }

  void _next() => Navigator.push(
        context,
        slideRoute(OnboardingCampusScreen(interests: _selected.toList())),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackButton(onTap: () => Navigator.pop(context)),
                  TextButton(
                    onPressed: _next,
                    child: const Text('SKIP', style: TextStyle(
                      color: Color(0xFF8A8D99), fontSize: 13, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What interests you?', style: TextStyle(
                      color: Color(0xFFF0EDE4), fontSize: 26,
                      fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1.2,
                    )),
                    const SizedBox(height: 8),
                    const Text(
                      'Select topics to personalize your ALU Connect+ feed and community recommendations.',
                      style: TextStyle(color: Color(0xFF8A8D99), fontSize: 13, height: 1.55),
                    ),
                    const SizedBox(height: 28),
                    ..._groups.map((g) => _InterestGroup(
                          icon: g['icon'] as String,
                          label: g['label'] as String,
                          topics: g['topics'] as List<String>,
                          selected: _selected,
                          onToggle: _toggle,
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _OnboardingFooter(currentStep: 0, totalSteps: 2, buttonLabel: 'Continue', onTap: _next),
          ],
        ),
      ),
    );
  }
}

class _InterestGroup extends StatelessWidget {
  final String icon;
  final String label;
  final List<String> topics;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _InterestGroup({
    required this.icon, required this.label, required this.topics,
    required this.selected, required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(
              color: Color(0xFFF0EDE4), fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: topics.map((topic) {
              final sel = selected.contains(topic);
              return GestureDetector(
                onTap: () => onToggle(topic),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFF5C842).withOpacity(0.18) : const Color(0xFF1E2235),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sel
                          ? const Color(0xFFF5C842).withOpacity(0.6)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Text(topic, style: TextStyle(
                    color: sel ? const Color(0xFFF5C842) : const Color(0xFF8A8D99),
                    fontSize: 12, fontWeight: FontWeight.w500,
                  )),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

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
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFF0EDE4), size: 16),
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
    required this.currentStep, required this.totalSteps,
    required this.buttonLabel, required this.onTap,
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
                width: active ? 18 : 6, height: 6,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(buttonLabel, style: const TextStyle(
                    color: Color(0xFF0D0F14), fontSize: 14, fontWeight: FontWeight.w600,
                  )),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0D0F14), size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}