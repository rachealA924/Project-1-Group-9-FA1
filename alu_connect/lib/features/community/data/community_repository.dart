import 'package:flutter/material.dart';

import '../models/community.dart';

/// Simple in-memory store of communities + sample data.
///
/// Swap this out for an API/Firestore-backed implementation later — the
/// screens only depend on the public methods below.
class CommunityRepository extends ChangeNotifier {
  CommunityRepository._() {
    _communities.addAll(_seed());
  }

  static final CommunityRepository instance = CommunityRepository._();

  final List<Community> _communities = [];

  List<Community> get all => List.unmodifiable(_communities);
  List<Community> get joined =>
      _communities.where((c) => c.isJoined).toList(growable: false);

  /// Category filters shown as chips on the hub.
  final List<String> categories = const [
    'All Hubs',
    'Technology',
    'Arts & Culture',
    'Business',
    'Sports',
  ];

  /// Peers available to add as initial members in the create flow.
  final List<Peer> suggestedPeers = const [
    Peer(name: 'Amara Nwosu', detail: 'B22 Computer Science'),
    Peer(name: 'Kofi Mensah', detail: 'Global Challenges'),
    Peer(name: 'Sarah Tadesse', detail: 'Business Management'),
    Peer(name: 'Liam Okeke', detail: 'B23 Software Engineering'),
    Peer(name: 'Zara Bello', detail: 'Entrepreneurial Leadership'),
  ];

  List<Community> byCategory(String category) {
    if (category == 'All Hubs') return all;
    return _communities
        .where((c) => c.category.toLowerCase() == category.toLowerCase())
        .toList(growable: false);
  }

  void toggleJoined(Community community) {
    community.isJoined = !community.isJoined;
    notifyListeners();
  }

  /// Adds a freshly created community to the top of the list and returns it.
  Community create({
    required String name,
    required String category,
    required String about,
    required bool isPrivate,
    List<String> tags = const [],
  }) {
    final community = Community(
      id: 'c${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      tagline: about.isEmpty ? 'A new ALU community' : about,
      about: about,
      category: category,
      memberCount: 1,
      accentColor: const Color(0xFFFFC629),
      icon: Icons.rocket_launch_outlined,
      tags: tags,
      isJoined: true,
      isPrivate: isPrivate,
    );
    _communities.insert(0, community);
    notifyListeners();
    return community;
  }

  List<Community> _seed() => [
        Community(
          id: 'tech-innovation',
          name: 'Tech Innovation Hub',
          tagline: 'Building the future of software',
          about:
              'A space for builders, designers and tinkerers shipping real '
              'products. Weekly hack nights, demo days and mentorship from '
              'senior engineers.',
          category: 'Technology',
          memberCount: 420,
          accentColor: const Color(0xFF3B82F6),
          icon: Icons.memory_outlined,
          tags: const ['Software', 'AI', 'Hackathons'],
          isOfficial: true,
        ),
        Community(
          id: 'debate-society',
          name: 'Debate Society',
          tagline: 'Sharpen your argument',
          about:
              'Fostering critical thinking and public speaking through '
              'structured academic discourse and competitive debate.',
          category: 'Arts & Culture',
          memberCount: 150,
          accentColor: const Color(0xFFEF4444),
          icon: Icons.mic_outlined,
          tags: const ['Public Speaking', 'Critical Thinking'],
        ),
        Community(
          id: 'global-business',
          name: 'Global Business Leaders',
          tagline: 'From idea to venture',
          about:
              'Connecting aspiring entrepreneurs with industry veterans. '
              'Weekly pitch sessions and fireside chats with founders.',
          category: 'Business',
          memberCount: 280,
          accentColor: const Color(0xFF8B5CF6),
          icon: Icons.trending_up_outlined,
          tags: const ['Startups', 'Pitching', 'Networking'],
        ),
        Community(
          id: 'sustainable-future',
          name: 'Sustainable Future Org',
          tagline: 'Greener campus, greener planet',
          about:
              'Driving campus sustainability initiatives, organizing '
              'clean-ups, and researching green technology.',
          category: 'Arts & Culture',
          memberCount: 199,
          accentColor: const Color(0xFF22C55E),
          icon: Icons.eco_outlined,
          tags: const ['Sustainability', 'Volunteering'],
        ),
        Community(
          id: 'women-in-leadership',
          name: 'Women in Leadership',
          tagline: 'Empowering the next generation',
          about:
              'A dedicated space for aspiring female leaders at ALU to '
              'connect, share resources, and foster professional growth. We '
              'host weekly workshops, mentorship sessions, and networking '
              'events designed to empower the next generation of women leaders '
              'in Africa and beyond.',
          category: 'Business',
          memberCount: 1249,
          accentColor: const Color(0xFFEC4899),
          icon: Icons.workspace_premium_outlined,
          isOfficial: true,
          tags: const ['Leadership', 'Mentorship', 'Social', 'Networking'],
          events: const [
            CommunityEvent(
              month: 'DEC',
              day: '12',
              title: 'Guest Speaker: CEO Panel',
              location: 'Auditorium A',
              time: '5:00 PM',
            ),
            CommunityEvent(
              month: 'DEC',
              day: '18',
              title: 'Resume Workshop',
              location: 'Virtual',
              time: '6:30 PM',
            ),
          ],
          announcements: const [
            Announcement(
              author: 'Sarah Jenkins',
              role: 'Community Admin',
              timeAgo: '2h ago',
              title: 'Application Open: Fall Mentorship Program',
              body:
                  'We are thrilled to announce that applications for the Fall '
                  'Mentorship Program are now open! Pair up with industry '
                  'leaders and alumni for a 10-week guided journey focusing on '
                  'personal branding and negotiation skills. Don\'t miss out, '
                  'spots are limited.',
              likes: 40,
              comments: 12,
              attachmentName: 'Mentorship_Application_2024.pdf',
              attachmentSize: '2.4 MB',
            ),
            Announcement(
              author: 'Dr. Amina Diallo',
              role: 'Faculty Advisor',
              timeAgo: '1d ago',
              body:
                  'A huge thank you to everyone who attended yesterday\'s '
                  'negotiation workshop. The energy was incredible. For those '
                  'who asked, I\'ve attached the presentation slides below. '
                  'Remember your worth, and don\'t be afraid to ask for it!',
              likes: 88,
              comments: 34,
            ),
          ],
        ),
        Community(
          id: 'cs-cohort-24',
          name: 'Computer Science Cohort 24',
          tagline: 'Private Group',
          about: 'Coordination space for the CS Cohort of 2024.',
          category: 'Technology',
          memberCount: 128,
          accentColor: const Color(0xFF6366F1),
          icon: Icons.computer_outlined,
          isJoined: true,
          isPrivate: true,
          posts: const [
            DiscussionPost(
              author: 'Sarah Jenkins',
              role: 'Data Structures',
              timeAgo: '3 hours ago',
              message:
                  'Just finished the first draft of my mid-term project! '
                  'Highly recommend checking out the new library quiet zone '
                  'for deep work. Who else is grinding this weekend?',
              likes: 24,
              comments: 8,
            ),
            DiscussionPost(
              author: 'David Chen',
              role: 'Cohort Rep',
              timeAgo: '5 hours ago',
              message:
                  'Hey team! We need to schedule our final exam review '
                  'session. Which day works best for the majority?',
              likes: 5,
              comments: 12,
              verified: true,
            ),
            DiscussionPost(
              author: 'Maya Johnson',
              role: 'Resources',
              timeAgo: 'Yesterday',
              message:
                  'Found this incredible interactive guide on React state '
                  'management. It breaks down complex hooks into really simple '
                  'visual metaphors. Must read before the upcoming assignment!',
              likes: 68,
              comments: 4,
            ),
          ],
        ),
        Community(
          id: 'alu-chorus',
          name: 'ALU Chorus',
          tagline: 'Find your voice',
          about: 'The official student choir. All voices welcome.',
          category: 'Arts & Culture',
          memberCount: 64,
          accentColor: const Color(0xFFF59E0B),
          icon: Icons.music_note_outlined,
          isJoined: true,
        ),
        Community(
          id: 'tech-hub',
          name: 'Tech Hub',
          tagline: 'Private Group',
          about: 'General tech discussion and workshops.',
          category: 'Technology',
          memberCount: 128,
          accentColor: const Color(0xFF06B6D4),
          icon: Icons.hub_outlined,
          isJoined: true,
          isPrivate: true,
        ),
      ];
}
