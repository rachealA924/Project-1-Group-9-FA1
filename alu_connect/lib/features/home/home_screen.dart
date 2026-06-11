import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/notifications_screen.dart';
import 'package:alu_connect/features/home/user_session.dart';
import 'package:alu_connect/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _session = UserSession();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        _TopBar(session: _session),
        const SizedBox(height: 12),
        const _SearchBar(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _WelcomeBanner(session: _session),
              const SizedBox(height: 20),
              const _OfficialNewsBanner(),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Upcoming Events',
                onSeeAll: () => MainNavigation.jumpTo(context, 1),
              ),
              const SizedBox(height: 12),
              const _UpcomingEvents(),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Available Opportunities',
                onSeeAll: () => MainNavigation.jumpTo(context, 3),
              ),
              const SizedBox(height: 12),
              _OpportunityCard(
                tag: 'Internship',
                tagColor: const Color(0xFF4A9EFF),
                title: 'Product Design Intern',
                subtitle: 'Google Africa • Remote',
                imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&q=80',
                onTap: () => MainNavigation.jumpTo(context, 3),
              ),
              const SizedBox(height: 10),
              _OpportunityCard(
                tag: 'Fellowship',
                tagColor: const Color(0xFF9B6DFF),
                title: 'Global Leadership Program',
                subtitle: 'ALU Foundation • Kigali',
                imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&q=80',
                onTap: () => MainNavigation.jumpTo(context, 3),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── Top bar — FIX: only notification bell, no messages icon ─────────────────
class _TopBar extends StatelessWidget {
  final UserSession session;
  const _TopBar({required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
              color: const Color(0xFFF5C842),
              borderRadius: BorderRadius.circular(9)),
          child: const Icon(Icons.school_rounded, color: Color(0xFF0D0F14), size: 18)),
        const SizedBox(width: 10),
        const Text('ALU Connect+', style: TextStyle(
            color: Color(0xFFF0EDE4), fontSize: 16, fontWeight: FontWeight.w700)),
        const Spacer(),
        // Only the notification bell — messages accessible from bottom nav
        ListenableBuilder(
          listenable: session,
          builder: (_, __) => GestureDetector(
            onTap: () {
              session.markNotificationsRead();
              Navigator.push(context, slideRoute(const NotificationsScreen()));
            },
            child: Stack(children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                    color: const Color(0xFF1C2030),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFF5C842).withOpacity(0.12))),
                child: const Icon(Icons.notifications_none_rounded,
                    color: Color(0xFFF0EDE4), size: 20)),
              if (session.unreadNotifications > 0)
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFFF5C842), shape: BoxShape.circle))),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── Welcome banner — FIX: shows name only, campus shown separately ───────────
class _WelcomeBanner extends StatelessWidget {
  final UserSession session;
  const _WelcomeBanner({required this.session});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: session,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Welcome back 👋',
              style: TextStyle(color: const Color(0xFF8A8D99), fontSize: 13)),
            const SizedBox(height: 2),
            Text(
              session.displayName,
              style: const TextStyle(
                  color: Color(0xFFF0EDE4),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on_rounded,
                  color: Color(0xFFF5C842), size: 12),
              const SizedBox(width: 3),
              Text(session.campusLabel,
                  style: const TextStyle(
                      color: Color(0xFFF5C842), fontSize: 11)),
            ]),
          ]),
          // Avatar
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF4A9EFF), Color(0xFF9B6DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFF5C842).withOpacity(0.3), width: 2)),
            child: session.googlePhotoUrl != null
                ? ClipOval(child: Image.network(session.googlePhotoUrl!,
                    fit: BoxFit.cover, width: 52, height: 52))
                : Center(child: Text(session.initials,
                    style: const TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.w700)))),
        ],
      ),
    );
  }
}

// ── Search bar ───────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 44,
      decoration: BoxDecoration(
          color: const Color(0xFF1C2030),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.1))),
      child: const Row(children: [
        SizedBox(width: 14),
        Icon(Icons.search_rounded, color: Color(0xFF8A8D99), size: 18),
        SizedBox(width: 10),
        Text('Search events, clubs, or peers...',
            style: TextStyle(color: Color(0xFF8A8D99), fontSize: 13)),
      ])));
}

// ── Official news banner ─────────────────────────────────────────────────────
class _OfficialNewsBanner extends StatelessWidget {
  const _OfficialNewsBanner();
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Stack(children: [
      // Background image
      Image.network(
        'https://images.unsplash.com/photo-1562774053-701939374585?w=800&q=80',
        height: 140, width: double.infinity, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
            height: 140, color: const Color(0xFF1C2440))),
      // Dark overlay
      Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.75), Colors.black.withOpacity(0.3)],
            begin: Alignment.bottomCenter, end: Alignment.topCenter))),
      // Content
      Positioned(left: 16, right: 16, bottom: 14,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: const Color(0xFFF5C842),
                borderRadius: BorderRadius.circular(5)),
            child: const Text('OFFICIAL NEWS', style: TextStyle(
                color: Color(0xFF0D0F14), fontSize: 9,
                fontWeight: FontWeight.w800, letterSpacing: 0.8))),
          const SizedBox(height: 6),
          const Text('New Student Hub Opening in Kigali',
              style: TextStyle(color: Colors.white, fontSize: 15,
                  fontWeight: FontWeight.w700, height: 1.2)),
          const SizedBox(height: 3),
          const Text('Join us this Friday for the grand opening...',
              style: TextStyle(color: Colors.white70, fontSize: 11)),
        ])),
    ]),
  );
}

// ── Section header ───────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});
  @override
  Widget build(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(
            color: Color(0xFFF0EDE4),
            fontSize: 15, fontWeight: FontWeight.w600)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('See all', style: TextStyle(
                color: Color(0xFFF5C842),
                fontSize: 12, fontWeight: FontWeight.w500))),
      ]);
}

// ── Events horizontal scroll — with real images ──────────────────────────────
class _UpcomingEvents extends StatelessWidget {
  const _UpcomingEvents();

  static const _events = [
    {
      'title': 'Entrepreneurship Summit',
      'location': 'Main Campus',
      'date': 'Oct 15',
      'imageUrl': 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400&q=80',
    },
    {
      'title': 'Tech Mixer',
      'location': 'Innovation Hub',
      'date': 'Oct 18',
      'imageUrl': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400&q=80',
    },
    {
      'title': 'Design Sprint',
      'location': 'Studio B',
      'date': 'Oct 22',
      'imageUrl': 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=400&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 170,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _events.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, i) => _EventCard(
        title:    _events[i]['title']!,
        location: _events[i]['location']!,
        date:     _events[i]['date']!,
        imageUrl: _events[i]['imageUrl']!,
      )));
}

class _EventCard extends StatelessWidget {
  final String title, location, date, imageUrl;
  const _EventCard({required this.title, required this.location,
      required this.date, required this.imageUrl});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: SizedBox(
      width: 160,
      child: Stack(fit: StackFit.expand, children: [
        // Background image
        Image.network(imageUrl, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF1C2440))),
        // Gradient overlay
        Container(decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.75), Colors.transparent],
            begin: Alignment.bottomCenter, end: Alignment.topCenter))),
        // Content
        Positioned(left: 12, right: 12, bottom: 12,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5C842),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(date, style: const TextStyle(
                  color: Color(0xFF0D0F14),
                  fontSize: 9, fontWeight: FontWeight.w800))),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(color: Colors.white,
                fontSize: 12, fontWeight: FontWeight.w700, height: 1.2)),
            const SizedBox(height: 3),
            Row(children: [
              const Icon(Icons.location_on_rounded,
                  color: Colors.white70, size: 10),
              const SizedBox(width: 2),
              Expanded(child: Text(location, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10))),
            ]),
          ])),
      ]),
    ));
}

// ── Opportunity card — with image ─────────────────────────────────────────────
class _OpportunityCard extends StatelessWidget {
  final String tag, title, subtitle, imageUrl;
  final Color tagColor;
  final VoidCallback onTap;
  const _OpportunityCard({required this.tag, required this.tagColor,
      required this.title, required this.subtitle,
      required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          color: const Color(0xFF141720),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.1))),
      child: Row(children: [
        // Image on the left
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(13)),
          child: Image.network(
            imageUrl,
            width: 80, height: 80, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 80, height: 80,
              color: const Color(0xFF1C2030),
              child: Icon(Icons.work_outline_rounded,
                  color: tagColor.withOpacity(0.4), size: 28)))),
        const SizedBox(width: 12),
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(tag, style: TextStyle(
                  color: tagColor, fontSize: 10,
                  fontWeight: FontWeight.w600, letterSpacing: 0.3))),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(
                color: Color(0xFFF0EDE4),
                fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(
                color: Color(0xFF8A8D99), fontSize: 11)),
          ]))),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(Icons.chevron_right_rounded,
              color: Color(0xFF8A8D99), size: 20)),
      ]),
    ));
}