import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../models/community.dart';
import '../widgets/community_widgets.dart';

/// The inside-the-community feed: composer + posts (incl. a poll + link card).
class CommunityDiscussionScreen extends StatelessWidget {
  const CommunityDiscussionScreen({super.key, required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    final posts = community.posts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALU Connect+',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 12)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _CommunityHeaderCard(community: community),
          const SizedBox(height: 14),
          const _Composer(),
          const SizedBox(height: 16),
          if (posts.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No posts yet. Be the first to start the conversation!',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          for (var i = 0; i < posts.length; i++) ...[
            _PostCard(post: posts[i], variant: i),
            const SizedBox(height: 14),
          ],
        ],
      ),
      bottomNavigationBar: const AluBottomNav(currentIndex: 2),
    );
  }
}

class _CommunityHeaderCard extends StatelessWidget {
  const _CommunityHeaderCard({required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleBadge(color: community.accentColor, icon: community.icon, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(community.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 3),
                Text(
                  '${community.memberCount} Members · '
                  '${community.isPrivate ? 'Private' : 'Public'} Group',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12.5),
                ),
              ],
            ),
          ),
          if (community.isJoined)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Joined',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  )),
            ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              const CircleBadge(
                  color: AppColors.primary, initials: 'A', size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "What's on your mind, Alex?",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _composerAction(Icons.image_outlined, 'Photo'),
              _composerAction(Icons.link, 'Link'),
              _composerAction(Icons.bar_chart, 'Poll'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _composerAction(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.variant});

  final DiscussionPost post;

  /// 0 = plain, 1 = poll, 2 = link preview (mirrors the Figma feed).
  final int variant;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthorHeader(
            name: post.author,
            subtitle: '${post.timeAgo}'
                '${post.role != null ? ' · ${post.role}' : ''}',
            verified: post.verified,
          ),
          const SizedBox(height: 12),
          Text(
            post.message,
            style: const TextStyle(height: 1.45, fontSize: 13.5),
          ),
          if (variant == 1) ...[
            const SizedBox(height: 14),
            const _Poll(),
          ] else if (variant == 2) ...[
            const SizedBox(height: 14),
            const _LinkPreview(
              source: 'DEVGUIDES.IO',
              title: 'Visualizing React Hooks & State',
              subtitle:
                  'An interactive deep dive into modern React state management '
                  'using animated diagrams.',
            ),
          ],
          const SizedBox(height: 14),
          EngagementRow(likes: post.likes, comments: post.comments),
        ],
      ),
    );
  }
}

class _Poll extends StatelessWidget {
  const _Poll();

  @override
  Widget build(BuildContext context) {
    const options = [
      ('Thursday, 6 PM - 8 PM', 0.60),
      ('Friday, 4 PM - 6 PM', 0.30),
      ('Saturday Morning (Virtual)', 0.15),
    ];
    return Column(
      children: [
        for (final (label, pct) in options) ...[
          _PollBar(label: label, pct: pct),
          const SizedBox(height: 8),
        ],
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('82 votes total',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
        ),
      ],
    );
  }
}

class _PollBar extends StatelessWidget {
  const _PollBar({required this.label, required this.pct});

  final String label;
  final double pct;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(height: 40, color: AppColors.surfaceVariant),
          FractionallySizedBox(
            widthFactor: pct,
            child: Container(
              height: 40,
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('${(pct * 100).round()}%',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkPreview extends StatelessWidget {
  const _LinkPreview({
    required this.source,
    required this.title,
    required this.subtitle,
  });

  final String source;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.article_outlined,
                size: 40, color: AppColors.textMuted),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(source,
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10.5,
                        letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
