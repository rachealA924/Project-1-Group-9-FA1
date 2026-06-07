import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/community_repository.dart';
import '../models/community.dart';
import '../widgets/community_widgets.dart';
import 'community_discussion_screen.dart';

/// Read-only community profile: about, tags, upcoming events, announcements.
class CommunityDetailsScreen extends StatefulWidget {
  const CommunityDetailsScreen({super.key, required this.community});

  final Community community;

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  final CommunityRepository _repo = CommunityRepository.instance;

  Community get c => widget.community;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALU Connect+',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        actions: const [Icon(Icons.more_vert), SizedBox(width: 12)],
      ),
      body: AnimatedBuilder(
        animation: _repo,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              if (c.isOfficial)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Official Group',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              Text(
                c.name,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.people_outline,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Text(
                    '${c.memberCount} Members',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _AboutCard(community: c),
              if (c.events.isNotEmpty) ...[
                const SizedBox(height: 22),
                const SectionHeader(title: 'Upcoming Events'),
                const SizedBox(height: 12),
                for (final e in c.events) ...[
                  _EventTile(event: e),
                  const SizedBox(height: 10),
                ],
              ],
              if (c.announcements.isNotEmpty) ...[
                const SizedBox(height: 12),
                const SectionHeader(title: 'Announcements'),
                const SizedBox(height: 12),
                for (final a in c.announcements) ...[
                  _AnnouncementCard(announcement: a),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        child: PrimaryButton(
          label: c.isJoined ? 'Enter Hub' : 'Join Community',
          icon: c.isJoined ? Icons.arrow_forward : null,
          onPressed: () {
            if (c.isJoined) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CommunityDiscussionScreen(community: c),
              ));
            } else {
              _repo.toggleJoined(c);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Joined ${c.name}')),
              );
            }
          },
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text('About',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            community.about,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 13.5,
            ),
          ),
          if (community.tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in community.tags) PillChip(label: t),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(event.month,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    )),
                Text(event.day,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    )),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 3),
                Text(
                  '${event.location} · ${event.time}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final a = announcement;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthorHeader(name: a.author, subtitle: '${a.role} · ${a.timeAgo}'),
          const SizedBox(height: 12),
          if (a.title != null) ...[
            Text(a.title!,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 6),
          ],
          Text(
            a.body,
            style: const TextStyle(
                color: AppColors.textSecondary, height: 1.45, fontSize: 13),
          ),
          if (a.attachmentName != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined,
                      color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.attachmentName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                        if (a.attachmentSize != null)
                          Text(a.attachmentSize!,
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 11.5)),
                      ],
                    ),
                  ),
                  const Icon(Icons.download_outlined,
                      size: 20, color: AppColors.textSecondary),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          EngagementRow(likes: a.likes, comments: a.comments),
        ],
      ),
    );
  }
}
