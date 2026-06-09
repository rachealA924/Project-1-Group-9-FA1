import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _showUnread = false;

  final List<_NotifItem> _notifications = [
    _NotifItem(
      type: _NotifType.event,
      title: 'Upcoming Event',
      body: 'Reminder: Tech Leadership Summit starts tomorrow at 10:00 AM in the Main Auditorium.',
      time: '2h ago',
      isUnread: true,
    ),
    _NotifItem(
      type: _NotifType.person,
      title: 'Sarah Jenkins',
      body: 'Hey! Are we still meeting for the study group later? I\'ve got the notes ready.',
      time: 'Yesterday',
      isUnread: true,
      avatarInitials: 'SJ',
      avatarColor: Color(0xFF4A9EFF),
    ),
    _NotifItem(
      type: _NotifType.club,
      title: 'Design Club',
      body: 'Prof. Ndibwi just posted an announcement: "New resources for the UX/UI final project have been uploaded to the drive."',
      time: 'More',
      isUnread: false,
    ),
    _NotifItem(
      type: _NotifType.system,
      title: 'Registrar Office',
      body: 'Course registration for the upcoming semester opens in 3 days. Please review your degree audit.',
      time: 'Oct 24',
      isUnread: false,
    ),
  ];

  List<_NotifItem> get _filtered =>
      _showUnread ? _notifications.where((n) => n.isUnread).toList() : _notifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2030),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.15)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFFF0EDE4), size: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Notifications', style: TextStyle(
                    color: Color(0xFFF0EDE4), fontSize: 18,
                    fontWeight: FontWeight.w600, letterSpacing: -0.3,
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // All / Unread toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2030),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    _TabChip(label: 'All', active: !_showUnread, onTap: () => setState(() => _showUnread = false)),
                    _TabChip(label: 'Unread', active: _showUnread, onTap: () => setState(() => _showUnread = true)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notification list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _NotifCard(item: _filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab chip ────────────────────────────────────────────────────────────────

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF5C842) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(
            color: active ? const Color(0xFF0D0F14) : const Color(0xFF8A8D99),
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          )),
        ),
      ),
    );
  }
}

// ── Notification card ───────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  final _NotifItem item;
  const _NotifCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isUnread ? const Color(0xFF141E30) : const Color(0xFF141720),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isUnread
              ? const Color(0xFFF5C842).withOpacity(0.2)
              : const Color(0xFFF5C842).withOpacity(0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon / Avatar
          _NotifAvatar(item: item),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(item.title, style: TextStyle(
                        color: item.isUnread ? const Color(0xFFF5C842) : const Color(0xFFF0EDE4),
                        fontSize: 13, fontWeight: FontWeight.w600,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Text(item.time, style: const TextStyle(
                      color: Color(0xFF8A8D99), fontSize: 11)),
                    if (item.isUnread) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 7, height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5C842), shape: BoxShape.circle),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Text(item.body, style: const TextStyle(
                  color: Color(0xFF8A8D99), fontSize: 12, height: 1.5),
                  maxLines: 3, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifAvatar extends StatelessWidget {
  final _NotifItem item;
  const _NotifAvatar({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.avatarInitials != null) {
      return Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: item.avatarColor!.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: item.avatarColor!.withOpacity(0.4)),
        ),
        child: Center(child: Text(item.avatarInitials!, style: TextStyle(
          color: item.avatarColor, fontSize: 13, fontWeight: FontWeight.w700,
        ))),
      );
    }

    IconData icon;
    Color color;
    switch (item.type) {
      case _NotifType.event:
        icon = Icons.calendar_month_rounded;
        color = const Color(0xFFF5C842);
        break;
      case _NotifType.club:
        icon = Icons.groups_rounded;
        color = const Color(0xFF9B6DFF);
        break;
      case _NotifType.system:
        icon = Icons.school_rounded;
        color = const Color(0xFF4A9EFF);
        break;
      default:
        icon = Icons.notifications_rounded;
        color = const Color(0xFF8A8D99);
    }

    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

// ── Data model ──────────────────────────────────────────────────────────────

enum _NotifType { event, person, club, system }

class _NotifItem {
  final _NotifType type;
  final String title;
  final String body;
  final String time;
  final bool isUnread;
  final String? avatarInitials;
  final Color? avatarColor;

  const _NotifItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
    this.avatarInitials,
    this.avatarColor,
  });
}