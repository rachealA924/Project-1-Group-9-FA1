import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/events/widgets/shared_widgets.dart';
import 'package:alu_connect/features/events/screens/event_created.dart';

class CreateEventStep2Screen extends StatefulWidget {
  const CreateEventStep2Screen({super.key});

  @override
  State<CreateEventStep2Screen> createState() => _CreateEventStep2ScreenState();
}

class _CreateEventStep2ScreenState extends State<CreateEventStep2Screen> {
  int _selectedVisibility = 0;
  bool _registrationEnabled = false;

  final List<_VisibilityOption> _visibilityOptions = [
    _VisibilityOption(icon: Icons.public_rounded, title: 'Public', subtitle: 'Visible to all students and staff members in the ALU ecosystem.'),
    _VisibilityOption(icon: Icons.lock_outline_rounded, title: 'Private', subtitle: 'Invite only. The event will not appear in global search results.'),
    _VisibilityOption(icon: Icons.shield_outlined, title: 'Restricted', subtitle: 'Limited to specific Departments or Academic Programs.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AluAppBar(
        showBack: true,
        title: 'Create Event',
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepIndicator(currentStep: 2, totalSteps: 2, stepLabel: '90% Complete', progress: 0.9),
                  const SizedBox(height: 8),
                  const Text('Media & Visibility', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                  const SizedBox(height: 20),
                  const Text('Event Media', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                          child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.textMuted, size: 28),
                        ),
                        const SizedBox(height: 12),
                        const Text('Click to upload cover image', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        const Text('Recommended size: 1200 x 675px (16:9 ratio)', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Visibility Settings', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...List.generate(_visibilityOptions.length, (i) {
                    final opt = _visibilityOptions[i];
                    final isSelected = i == _selectedVisibility;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedVisibility = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceVariant,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(opt.icon, size: 18, color: isSelected ? AppColors.primary : AppColors.textMuted),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(opt.title, style: TextStyle(color: isSelected ? AppColors.textPrimary : AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 2),
                                    Text(opt.subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.4)),
                                  ],
                                ),
                              ),
                              Radio<int>(
                                value: i,
                                groupValue: _selectedVisibility,
                                onChanged: (v) => setState(() => _selectedVisibility = v!),
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _registrationEnabled ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _registrationEnabled ? AppColors.primary : AppColors.border, width: _registrationEnabled ? 1.5 : 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _registrationEnabled ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.how_to_reg_rounded, size: 18, color: _registrationEnabled ? AppColors.primary : AppColors.textMuted),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('Enable Registration', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700))),
                            Switch(
                              value: _registrationEnabled,
                              onChanged: (v) => setState(() => _registrationEnabled = v),
                              activeColor: AppColors.primary,
                              inactiveThumbColor: AppColors.textMuted,
                              inactiveTrackColor: AppColors.border,
                            ),
                          ],
                        ),
                        if (_registrationEnabled) ...[
                          const SizedBox(height: 14),
                          const TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: 'e.g. 50', suffixText: 'Students', suffixStyle: TextStyle(color: AppColors.textMuted)),
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          const Text('Leave blank for unlimited capacity', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: const BoxDecoration(color: AppColors.background, border: Border(top: BorderSide(color: AppColors.border))),
            child: AccentButton(
              label: 'Publish Event',
              trailingIcon: Icons.rocket_launch_rounded,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventCreatedScreen())),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilityOption {
  final IconData icon;
  final String title;
  final String subtitle;
  _VisibilityOption({required this.icon, required this.title, required this.subtitle});
}
