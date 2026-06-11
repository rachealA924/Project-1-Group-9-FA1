import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/home/notifications_screen.dart';
import 'package:alu_connect/features/home/user_session.dart';
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
  // FIX 1: removed _navIndex — MainNavigation handles nav, not this screen

  final List<String> _filters = ['All Events', 'Workshops', 'Social', 'Academic'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // FIX 2: replaced AluAppBar with one that has working notification bell
      appBar: _DiscoverAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Discover Events', style: TextStyle(
                color: AppColors.textPrimary, fontSize: 26,
                fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            const Text("Find what's happening around campus.",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border)),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search events, workshops, social...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: AppColors.textMuted, size: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14)),
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: active ? AppColors.primary : AppColors.border)),
                        child: Text(_filters[i], style: TextStyle(
                          color: active
                              ? AppColors.onPrimary : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: active
                              ? FontWeight.w700 : FontWeight.w500))),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Featured'),
            const SizedBox(height: 12),
            // FIX 3: Featured card now has a real image
            _FeaturedEventCard(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EventDetailsScreen())),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Upcoming this week', action: 'See all'),
            const SizedBox(height: 12),
            _UpcomingEventTile(
              category: 'SOCIAL',
              title: 'Campus Mix & Mingle',
              date: 'Oct 26, 18:00',
              location: 'Main Hall',
              imageUrl: 'https://images.unsplash.com/photo-1529543544282-ea669407fca3?w=200&q=80',
            ),
            const SizedBox(height: 10),
            _UpcomingEventTile(
              category: 'ACADEMIC',
              title: 'Midterm Prep Seminar',
              date: 'Oct 28, 10:00',
              location: 'Library, Study Room B',
              imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=200&q=80',
            ),
            const SizedBox(height: 10),
            _UpcomingEventTile(
              category: 'WORKSHOP',
              title: 'Product Design Sprint',
              date: 'Oct 30, 09:00',
              location: 'Innovation Hub',
              imageUrl: 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=200&q=80',
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Have an idea for an event?', style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Share it with the ALU community.',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 14),
                  AccentButton(
                    label: 'Create Event',
                    fullWidth: true,
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const CreateEventStep1Screen())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      // FIX 4: NO bottomNavigationBar here — MainNavigation provides it
    );
  }
}

// ── Working notification app bar ─────────────────────────────────────────────
class _DiscoverAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleSpacing: 16,
      title: Row(children: [
        Container(width: 30, height: 30,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.school_rounded,
              color: AppColors.onPrimary, size: 16)),
        const SizedBox(width: 8),
        const Text('ALU Connect+',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ]),
      actions: [
        ListenableBuilder(
          listenable: UserSession(),
          builder: (context, _) => GestureDetector(
            onTap: () {
              UserSession().markNotificationsRead();
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const NotificationsScreen()));
            },
            child: Stack(children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.notifications_none,
                    size: 24, color: AppColors.textPrimary)),
              if (UserSession().unreadNotifications > 0)
                Positioned(top: 8, right: 8,
                  child: Container(width: 8, height: 8,
                    decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle))),
            ]),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// FIX 5: Featured card now has a real background image
class _FeaturedEventCard extends StatelessWidget {
  final VoidCallback onTap;
  const _FeaturedEventCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          child: Stack(fit: StackFit.expand, children: [
            Image.network(
              'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.surface)),
            Container(decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('WORKSHOP', style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 10, fontWeight: FontWeight.w800))),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Column(children: [
                        Text('OCT', style: TextStyle(color: Colors.white70,
                            fontSize: 9, fontWeight: FontWeight.w700)),
                        Text('24', style: TextStyle(color: Colors.white,
                            fontSize: 16, fontWeight: FontWeight.w800,
                            height: 1)),
                      ])),
                  ]),
                  const Spacer(),
                  const Text('The Future of AI in\nTech Ecosystems',
                      style: TextStyle(color: Colors.white, fontSize: 18,
                          fontWeight: FontWeight.w700, height: 1.3)),
                  const SizedBox(height: 8),
                  Row(children: const [
                    Icon(Icons.access_time_rounded,
                        color: Colors.white70, size: 14),
                    SizedBox(width: 4),
                    Text('14:00 - 16:30',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(width: 12),
                    Icon(Icons.location_on_rounded,
                        color: Colors.white70, size: 14),
                    SizedBox(width: 4),
                    Text('Innovation Hub, Room 302',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// FIX 6: Upcoming tiles now have images
class _UpcomingEventTile extends StatelessWidget {
  final String category, title, date, location, imageUrl;
  const _UpcomingEventTile({
    required this.category, required this.title,
    required this.date, required this.location, required this.imageUrl});

  Color get _catColor {
    switch (category) {
      case 'SOCIAL':   return const Color(0xFF4A9EFF);
      case 'ACADEMIC': return const Color(0xFF9B6DFF);
      case 'WORKSHOP': return AppColors.primary;
      default:         return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border)),
      child: Row(children: [
        // Thumbnail image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(imageUrl,
              width: 56, height: 56, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 56, height: 56, color: AppColors.surfaceVariant,
                  child: const Icon(Icons.event_rounded,
                      color: AppColors.textMuted, size: 24)))),
        const SizedBox(width: 12),
        Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: _catColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4)),
            child: Text(category, style: TextStyle(
                color: _catColor, fontSize: 9, fontWeight: FontWeight.w800,
                letterSpacing: 0.6))),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.calendar_today_rounded,
                size: 11, color: AppColors.textMuted),
            const SizedBox(width: 3),
            Text(date,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(width: 8),
            const Icon(Icons.location_on_rounded,
                size: 11, color: AppColors.textMuted),
            const SizedBox(width: 3),
            Flexible(child: Text(location, overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11))),
          ]),
        ])),
        const Icon(Icons.chevron_right_rounded,
            color: AppColors.textMuted, size: 20),
      ]),
    );
  }
}