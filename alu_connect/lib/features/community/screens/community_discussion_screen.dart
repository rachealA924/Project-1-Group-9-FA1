import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/home/notifications_screen.dart';
import 'package:alu_connect/features/home/user_session.dart';
import '../models/community.dart';
import '../widgets/community_widgets.dart';

class CommunityDiscussionScreen extends StatefulWidget {
  const CommunityDiscussionScreen({super.key, required this.community});
  final Community community;

  @override
  State<CommunityDiscussionScreen> createState() =>
      _CommunityDiscussionScreenState();
}

class _CommunityDiscussionScreenState
    extends State<CommunityDiscussionScreen> {
  // FIX: posts list is now mutable state so new posts appear
  late List<DiscussionPost> _posts;

  @override
  void initState() {
    super.initState();
    _posts = List.from(widget.community.posts);
  }

  void _addPost(String message, {String? imageUrl}) {
    setState(() {
      _posts.insert(0, DiscussionPost(
        author: UserSession().displayName,
        timeAgo: 'Just now',
        message: message,
        likes: 0,
        comments: 0,
        imageUrl: imageUrl,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _DiscussionAppBar(communityName: widget.community.name),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _CommunityHeaderCard(community: widget.community),
          const SizedBox(height: 14),
          // FIX: composer now actually posts
          _Composer(onPost: _addPost),
          const SizedBox(height: 16),
          if (_posts.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Text(
                'No posts yet. Be the first to start the conversation!',
                style: TextStyle(color: AppColors.textSecondary)))),
          for (var i = 0; i < _posts.length; i++) ...[
            _PostCard(post: _posts[i], variant: i % 3),
            const SizedBox(height: 14),
          ],
        ],
      ),
      // FIX: NO bottomNavigationBar — MainNavigation provides it
    );
  }
}

// ── App bar ──────────────────────────────────────────────────────────────────
class _DiscussionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String communityName;
  const _DiscussionAppBar({required this.communityName});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      onPressed: () => Navigator.pop(context)),
    title: Text(communityName,
        style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700, fontSize: 16)),
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

// ── Community header ─────────────────────────────────────────────────────────
class _CommunityHeaderCard extends StatelessWidget {
  final Community community;
  const _CommunityHeaderCard({required this.community});

  @override
  Widget build(BuildContext context) => SurfaceCard(
    padding: const EdgeInsets.all(14),
    child: Row(children: [
      CircleBadge(color: community.accentColor, icon: community.icon, size: 48),
      const SizedBox(width: 12),
      Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(community.name, style: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 3),
        Text('${community.memberCount} Members · '
            '${community.isPrivate ? 'Private' : 'Public'} Group',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12.5)),
      ])),
      if (community.isJoined)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20)),
          child: const Text('Joined', style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700, fontSize: 12))),
    ]),
  );
}

// ── FIX: Working composer with image attachment ───────────────────────────────
class _Composer extends StatefulWidget {
  final void Function(String message, {String? imageUrl}) onPost;
  const _Composer({required this.onPost});

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  final _controller = TextEditingController();
  XFile? _pickedImage;
  bool _isPosting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _pickedImage = file);
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty && _pickedImage == null) return;

    setState(() => _isPosting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    widget.onPost(text.isNotEmpty ? text : '📷 Shared a photo',
        imageUrl: _pickedImage?.path);

    _controller.clear();
    setState(() { _pickedImage = null; _isPosting = false; });
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Row(children: [
          CircleBadge(
              color: AppColors.primary,
              initials: UserSession().initials,
              size: 36),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 13),
              maxLines: null,
              decoration: InputDecoration(
                hintText: "What's on your mind, "
                    "${UserSession().displayName.split(' ').first}?",
                hintStyle: const TextStyle(
                    color: AppColors.textMuted, fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none)),
            )),
        ]),

        // Image preview
        if (_pickedImage != null) ...[
          const SizedBox(height: 10),
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(File(_pickedImage!.path),
                  height: 120, width: double.infinity, fit: BoxFit.cover)),
            Positioned(top: 6, right: 6,
              child: GestureDetector(
                onTap: () => setState(() => _pickedImage = null),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 14)))),
          ]),
        ],

        const SizedBox(height: 10),
        Row(children: [
          // Photo
          GestureDetector(
            onTap: _pickImage,
            child: _composerAction(Icons.image_outlined, 'Photo')),
          _composerAction(Icons.link, 'Link'),
          _composerAction(Icons.bar_chart, 'Poll'),
          const Spacer(),
          ElevatedButton(
            onPressed: _isPosting ? null : _post,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8)),
            child: _isPosting
                ? const SizedBox(width: 14, height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                            AppColors.onPrimary)))
                : const Text('Post')),
        ]),
      ]),
    );
  }

  Widget _composerAction(IconData icon, String label) => Padding(
    padding: const EdgeInsets.only(right: 18),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(
          color: AppColors.textSecondary, fontSize: 12)),
    ]));
}

// ── Post card (unchanged logic, added imageUrl support) ──────────────────────
class _PostCard extends StatelessWidget {
  final DiscussionPost post;
  final int variant;
  const _PostCard({required this.post, required this.variant});

  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AuthorHeader(
        name: post.author,
        subtitle: '${post.timeAgo}'
            '${post.role != null ? ' · ${post.role}' : ''}',
        verified: post.verified),
      const SizedBox(height: 12),
      Text(post.message,
          style: const TextStyle(height: 1.45, fontSize: 13.5)),
      // Show attached image if present
      if (post.imageUrl != null) ...[
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: post.imageUrl!.startsWith('http')
              ? Image.network(post.imageUrl!, height: 160,
                  width: double.infinity, fit: BoxFit.cover)
              : Image.file(File(post.imageUrl!), height: 160,
                  width: double.infinity, fit: BoxFit.cover)),
      ],
      if (variant == 1) ...[
        const SizedBox(height: 14),
        const _Poll(),
      ] else if (variant == 2) ...[
        const SizedBox(height: 14),
        const _LinkPreview(
          source: 'DEVGUIDES.IO',
          title: 'Visualizing React Hooks & State',
          subtitle: 'An interactive deep dive into modern React state management.'),
      ],
      const SizedBox(height: 14),
      EngagementRow(likes: post.likes, comments: post.comments),
    ]),
  );
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
    return Column(children: [
      for (final (label, pct) in options) ...[
        _PollBar(label: label, pct: pct),
        const SizedBox(height: 8),
      ],
      const Align(alignment: Alignment.centerLeft,
        child: Text('82 votes total',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11.5))),
    ]);
  }
}

class _PollBar extends StatelessWidget {
  final String label; final double pct;
  const _PollBar({required this.label, required this.pct});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Stack(children: [
      Container(height: 40, color: AppColors.surfaceVariant),
      FractionallySizedBox(widthFactor: pct,
        child: Container(height: 40,
            color: AppColors.primary.withOpacity(0.25))),
      Positioned.fill(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600)),
          Text('${(pct * 100).round()}%', style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: AppColors.primary)),
        ]))),
    ]));
}

class _LinkPreview extends StatelessWidget {
  final String source, title, subtitle;
  const _LinkPreview({required this.source, required this.title,
      required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(height: 80,
          decoration: const BoxDecoration(color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          alignment: Alignment.center,
          child: const Icon(Icons.article_outlined,
              size: 32, color: AppColors.textMuted)),
      Padding(padding: const EdgeInsets.all(12), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(source, style: const TextStyle(color: AppColors.textMuted,
            fontSize: 10.5, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 13.5)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary,
            fontSize: 12, height: 1.35)),
      ])),
    ]));
}