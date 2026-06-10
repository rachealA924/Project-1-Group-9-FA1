import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/events/widgets/shared_widgets.dart';
import 'package:alu_connect/features/events/screens/event_details.dart';
import 'package:alu_connect/features/events/screens/create_event1.dart';

class EventDiscoveryScreen extends StatefulWidget {
  const EventDiscoveryScreen({super.key});

  @override
  State<EventDiscoveryScreen> createState() => _EventDiscoveryScreenState();
}

class _EventDiscoveryScreenState extends State<EventDiscoveryScreen> {
  int _selectedFilter = 0;
  int _navIndex = 1;

  final List<String> _filters = ['All Events', 'Workshops', 'Social', 'Academic'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AluAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Discover Events',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Find what's happening around campus.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search events, workshops, social...',
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final active = i == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          _filters[i],
                          style: TextStyle(
                            color: active ? AppColors.onPrimary : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Featured'),
            const SizedBox(height: 12),
            _FeaturedEventCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventDetailsScreen()),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Upcoming this week', action: 'See all'),
            const SizedBox(height: 12),
            _UpcomingEventTile(
              category: 'SOCIAL',
              categoryColor: AppColors.surfaceVariant,
              title: 'Campus Mix & Mingle',
              date: 'Oct 26, 18:00',
              location: 'Main 6 aad',
            ),
            const SizedBox(height: 10),
            _UpcomingEventTile(
              category: 'ACADEMIC',
              categoryColor: AppColors.surfaceVariant,
              title: 'Midterm Prep Seminar',
              date: 'Oct 28, 10:00',
              location: 'Library, Study Room B',
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Have an idea for an event?',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Share it with the ALU community.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  AccentButton(
                    label: 'Create Event',
                    fullWidth: true,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateEventStep1Screen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: AluBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _FeaturedEventCard extends StatelessWidget {
  final VoidCallback onTap;
  const _FeaturedEventCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  EventTag(label: 'WORKSHOP', color: AppColors.surfaceVariant, textColor: AppColors.primary),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Text('OCT', style: TextStyle(color: AppColors.onPrimary, fontSize: 9, fontWeight: FontWeight.w700)),
                        Text('24', style: TextStyle(color: AppColors.onPrimary, fontSize: 16, fontWeight: FontWeight.w800, height: 1)),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'The Future of AI in Tech\nEcosystems',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700, height: 1.3),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 14),
                  SizedBox(width: 4),
                  Text('14:00 - 16:30', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  SizedBox(width: 12),
                  Icon(Icons.location_on_rounded, color: AppColors.textSecondary, size: 14),
                  SizedBox(width: 4),
                  Text('Innovation Hub, Room 302', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingEventTile extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final String title;
  final String date;
  final String location;

  const _UpcomingEventTile({
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: categoryColor, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.event_rounded, color: AppColors.textSecondary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Flexible(child: Text(location, style: const TextStyle(color: AppColors.textMuted, fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
