import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            const SizedBox(height: 12),
            _SearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OfficialNewsBanner(),
                    const SizedBox(height: 24),
                    _SectionHeader(title: 'Upcoming Events', onSeeAll: () {}),
                    const SizedBox(height: 12),
                    _UpcomingEvents(),
                    const SizedBox(height: 24),
                    const _SectionHeader(title: 'Available Opportunities'),
                    const SizedBox(height: 12),
                    _OpportunityCard(
                      tag: 'Internship',
                      tagColor: const Color(0xFF4A9EFF),
                      title: 'Product Design Intern',
                      subtitle: 'Google Africa • Remote',
                      icon: Icons.work_outline_rounded,
                    ),
                    const SizedBox(height: 10),
                    _OpportunityCard(
                      tag: 'Fellowship',
                      tagColor: const Color(0xFF9B6DFF),
                      title: 'Global Leadership Program',
                      subtitle: 'ALU Foundation • Kigali',
                      icon: Icons.emoji_events_outlined,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }
}

// ---- Top Bar ----
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Logo + title
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5C842),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.school_rounded, color: Color(0xFF0D0F14), size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'ALU Connect+',
            style: TextStyle(
              color: Color(0xFFF0EDE4),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          // Notification bell
          GestureDetector(
            onTap: () => Navigator.push(context, slideRoute(const NotificationsScreen())),
            child: Stack(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2030),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.12)),
                  ),
                  child: const Icon(Icons.notifications_none_rounded, color: Color(0xFFF0EDE4), size: 20),
                ),
                Positioned(
                  top: 8,
                  right: 9,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5C842),
                      shape: BoxShape.circle,
                    ),
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

// ---- Search Bar ----
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1C2030),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.1)),
        ),
        child: Row(
          children: const [
            SizedBox(width: 14),
            Icon(Icons.search_rounded, color: Color(0xFF8A8D99), size: 18),
            SizedBox(width: 10),
            Text(
              'Search events, clubs, or peers...',
              style: TextStyle(color: Color(0xFF8A8D99), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Official News Banner ----
class _OfficialNewsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1C2440), Color(0xFF0D1525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.15)),
      ),
      child: Stack(
        children: [
          // Background building icon
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.07,
              child: Icon(Icons.location_city_rounded, size: 120, color: const Color(0xFFF5C842)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C842).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.3)),
                  ),
                  child: const Text(
                    'OFFICIAL NEWS',
                    style: TextStyle(
                      color: Color(0xFFF5C842),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'New Student Hub Opening in Kigali',
                  style: TextStyle(
                    color: Color(0xFFF0EDE4),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Join us this Friday for the grand opening of the new innovation and community hub...',
                  style: TextStyle(color: Color(0xFF8A8D99), fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Section Header ----
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF0EDE4),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See all',
              style: TextStyle(color: Color(0xFFF5C842), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}

// ---- Upcoming Events Horizontal Scroll ----
class _UpcomingEvents extends StatelessWidget {
  final List<Map<String, dynamic>> _events = const [
    {
      'title': 'Entrepreneurship Summit',
      'location': 'Main Campus',
      'date': 'Oct 15',
      'color': Color(0xFF1C2440),
    },
    {
      'title': 'Tech Mixer',
      'location': 'Innovation Hub',
      'date': 'Oct 18',
      'color': Color(0xFF1A2030),
    },
    {
      'title': 'Design Sprint',
      'location': 'Studio B',
      'date': 'Oct 22',
      'color': Color(0xFF201A30),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final e = _events[i];
          return _EventCard(
            title: e['title'] as String,
            location: e['location'] as String,
            date: e['date'] as String,
            bgColor: e['color'] as Color,
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final Color bgColor;

  const _EventCard({
    required this.title,
    required this.location,
    required this.date,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.12)),
      ),
      child: Stack(
        children: [
          // BG icon
          Positioned(
            bottom: -8,
            right: -8,
            child: Opacity(
              opacity: 0.06,
              child: const Icon(Icons.calendar_month_rounded, size: 80, color: Color(0xFFF5C842)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C842).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFFF5C842),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFF0EDE4),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: Color(0xFF8A8D99), size: 11),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Opportunity Card ----
class _OpportunityCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String title;
  final String subtitle;
  final IconData icon;

  const _OpportunityCard({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: tagColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: tagColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFF0EDE4),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A8D99), size: 20),
        ],
      ),
    );
  }
}

// ---- Bottom Nav Bar ----
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.explore_outlined, 'label': 'Discover'},
    {'icon': Icons.people_outline_rounded, 'label': 'People'},
    {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Messages'},
    {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _items[i]['icon'] as IconData,
                    color: isActive ? const Color(0xFFF5C842) : const Color(0xFF8A8D99),
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _items[i]['label'] as String,
                    style: TextStyle(
                      color: isActive ? const Color(0xFFF5C842) : const Color(0xFF8A8D99),
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}