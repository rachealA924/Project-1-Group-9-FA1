import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/home/notifications_screen.dart';
import 'package:alu_connect/features/home/user_session.dart';
import '../data/community_repository.dart';
import '../models/community.dart';
import '../widgets/community_widgets.dart';
import 'community_details_screen.dart';
import 'community_discussion_screen.dart';
import 'create_community_screen.dart';

class CommunitiesHubScreen extends StatefulWidget {
  const CommunitiesHubScreen({super.key});

  @override
  State<CommunitiesHubScreen> createState() => _CommunitiesHubScreenState();
}

class _CommunitiesHubScreenState extends State<CommunitiesHubScreen> {
  final CommunityRepository _repo = CommunityRepository.instance;
  String _category = 'All Hubs';
  String _query = '';

  List<Community> get _visible {
    final base = _repo.byCategory(_category);
    if (_query.isEmpty) return base;
    final q = _query.toLowerCase();
    return base.where((c) =>
        c.name.toLowerCase().contains(q) ||
        c.tags.any((t) => t.toLowerCase().contains(q)))
        .toList(growable: false);
  }

  void _open(Community c) => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CommunityDetailsScreen(community: c)));

  void _openHub(Community c) => Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => CommunityDiscussionScreen(community: c)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FIX 1: working notification app bar, no duplicate nav
      appBar: _CommunitiesAppBar(),
      body: AnimatedBuilder(
        animation: _repo,
        builder: (context, _) {
          final visible = _visible;
          final featured = visible.isNotEmpty ? visible.first : null;
          final rest = visible.skip(featured == null ? 0 : 1).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const Text('Communities', style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Discover organizations and connect with peers.',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 16),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Search clubs, societies, tags...',
                  prefixIcon: Icon(Icons.search,
                      color: AppColors.textMuted)),
              ),
              const SizedBox(height: 14),
              _CategoryFilters(
                categories: _repo.categories,
                selected: _category,
                onSelect: (c) => setState(() => _category = c)),
              const SizedBox(height: 22),
              _MyCommunitiesStrip(
                joined: _repo.joined,
                onTap: _openHub,
                onSeeAll: () {}),
              const SizedBox(height: 22),
              if (featured != null) ...[
                _FeaturedCard(
                  community: featured,
                  onJoin: () => _repo.toggleJoined(featured),
                  onOpen: () => _open(featured)),
                const SizedBox(height: 16),
              ],
              for (final c in rest) ...[
                CommunityListCard(
                  community: c,
                  onJoinToggle: () => _repo.toggleJoined(c),
                  onOpen: () => _open(c)),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Create Community',
                icon: Icons.add,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const CreateCommunityScreen()))),
              const SizedBox(height: 12),
              Center(child: Text(
                'View all ${_repo.all.length} communities',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13))),
            ],
          );
        },
      ),
      // FIX 2: NO bottomNavigationBar — MainNavigation provides it
    );
  }
}

// ── Working notification app bar ─────────────────────────────────────────────
class _CommunitiesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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

// keep all the other private widgets exactly as they were
class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({required this.categories,
      required this.selected, required this.onSelect});
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, i) {
        final c = categories[i];
        return PillChip(
            label: c, selected: c == selected, onTap: () => onSelect(c));
      }));
}

class _MyCommunitiesStrip extends StatelessWidget {
  const _MyCommunitiesStrip(
      {required this.joined, required this.onTap, required this.onSeeAll});
  final List<Community> joined;
  final ValueChanged<Community> onTap;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (joined.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'My Communities', actionLabel: 'See All',
          onAction: onSeeAll),
      const SizedBox(height: 12),
      SizedBox(height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: joined.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, i) {
            final c = joined[i];
            return GestureDetector(onTap: () => onTap(c),
              child: SizedBox(width: 64, child: Column(children: [
                CircleBadge(color: c.accentColor, icon: c.icon, size: 56),
                const SizedBox(height: 6),
                Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11.5)),
              ])));
          })),
    ]);
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.community,
      required this.onJoin, required this.onOpen});
  final Community community;
  final VoidCallback onJoin, onOpen;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onOpen,
    borderRadius: BorderRadius.circular(kCardRadius),
    child: Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCardRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [
            community.accentColor.withOpacity(0.85), AppColors.surface]),
        border: Border.all(color: AppColors.border)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20)),
          child: const Text('Featured',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
        const Spacer(),
        Text(community.name,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(community.tagline,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.people_outline, size: 15, color: Colors.white70),
          const SizedBox(width: 4),
          Text('${community.memberCount} Members',
              style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
          const Spacer(),
          ElevatedButton(
            onPressed: onJoin,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10)),
            child: Text(community.isJoined ? 'Joined' : 'Join Hub')),
        ]),
      ]),
    ));
}