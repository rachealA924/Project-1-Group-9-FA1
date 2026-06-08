import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/events/widgets/shared_widgets.dart';
import 'package:alu_connect/features/events/screens/create_event1.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AluAppBar(
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Row(
                      children: [
                        EventTag(label: 'Technology', color: AppColors.surfaceVariant, textColor: AppColors.primary),
                        const SizedBox(width: 8),
                        EventTag(label: 'In-Person', color: AppColors.surfaceVariant, textColor: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ALU Tech Summit\n2024',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 16),
                      SizedBox(width: 6),
                      Text('Oct 15 - 17', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      SizedBox(width: 16),
                      Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16),
                      SizedBox(width: 6),
                      Text('Main Auditorium', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 32,
                        child: Stack(
                          children: List.generate(3, (i) {
                            return Positioned(
                              left: i * 20.0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceVariant,
                                  border: Border.all(color: AppColors.background, width: 2),
                                ),
                                child: const Icon(Icons.person_rounded, color: AppColors.textMuted, size: 16),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('+42', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.star_border_rounded, size: 16),
                        label: const Text('Interested'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(onPressed: () {}, child: const Text('RSVP Now')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle(title: 'About the Event'),
                  const SizedBox(height: 10),
                  const Text(
                    'The annual ALU Tech Summit brings together the brightest minds in our student body, faculty, and industry leaders to explore the cutting edge of technology. This year\'s focus is on Artificial Intelligence, Sustainable Computing, and Future Digital Infrastructures.\n\nJoin us for three days of intensive workshops, keynote speeches from renowned alumni, and interactive hackathons designed to challenge your problem-solving skills.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      EventTag(label: 'AI/ML'),
                      EventTag(label: 'Networking'),
                      EventTag(label: 'Hackathon'),
                      EventTag(label: 'Keynotes'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle(title: 'When & Where'),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    title: 'Oct 15, 9:00 AM',
                    subtitle: 'to Oct 17, 5:00 PM',
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.location_on_rounded,
                    title: 'Main Auditorium',
                    subtitle: 'Innovation Hub, North Campus',
                    trailing: const Text(
                      'View Campus Map',
                      style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ORGANIZED BY',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceVariant,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: const Icon(Icons.person_rounded, color: AppColors.textSecondary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Prof. Elena Rostova', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                              Text('Head of Computer Science Dept.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          child: const Text('View Profile'),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AccentButton(
                    label: 'Create Event',
                    trailingIcon: Icons.add_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateEventStep1Screen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _InfoRow({required this.icon, required this.title, required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              if (trailing != null) ...[const SizedBox(height: 4), trailing!],
            ],
          ),
        ),
      ],
    );
  }
}
