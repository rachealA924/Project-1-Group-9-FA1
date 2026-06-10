import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _nameController = TextEditingController(text: 'Jane Doe');
  final _bioController = TextEditingController(text: 'BSE Computer Science');

  final List<String> _interests = ['Entrepreneurship', 'AI', 'Leadership'];
  final List<_Achievement> _achievements = [
    _Achievement(title: "Dean's List", subtitle: 'Fall 2023', icon: Icons.emoji_events_rounded, color: Color(0xFFF5C842)),
    _Achievement(title: 'Hackathon Winner', subtitle: 'CodeFest Q2', icon: Icons.code_rounded, color: Color(0xFF4A9EFF)),
    _Achievement(title: 'Guest Lecture', subtitle: 'In Progress', icon: Icons.mic_rounded, color: Color(0xFF9B6DFF)),
  ];
  final List<_EventAttended> _events = [
    _EventAttended(title: 'Future of AI Summit', location: 'Main Auditorium', date: 'Dec 12'),
    _EventAttended(title: 'Startup Pitch Night', location: 'Innovation Hub', date: 'Apr 30'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5C842),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.school_rounded, color: Color(0xFF0D0F14), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text('ALU Connect+', style: TextStyle(
                      color: Color(0xFFF0EDE4), fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    // Settings
                    GestureDetector(
                      onTap: () => _showSettingsSheet(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2030),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.15)),
                        ),
                        child: const Icon(Icons.settings_outlined,
                            color: Color(0xFFF0EDE4), size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Avatar + name
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A9EFF), Color(0xFF9B6DFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A9EFF).withOpacity(0.3),
                                blurRadius: 20, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: const Center(child: Text('JD', style: TextStyle(
                            color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700))),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 26, height: 26,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5C842), shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Color(0xFF0D0F14), size: 14),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Name
                    _isEditing
                        ? SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _nameController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFFF0EDE4),
                                  fontSize: 20, fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFFF5C842).withOpacity(0.5))),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFF5C842))),
                              ),
                            ),
                          )
                        : Text(_nameController.text, style: const TextStyle(
                            color: Color(0xFFF0EDE4), fontSize: 20,
                            fontWeight: FontWeight.w700)),

                    const SizedBox(height: 6),

                    // Bio
                    _isEditing
                        ? SizedBox(
                            width: 240,
                            child: TextField(
                              controller: _bioController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 13),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFFF5C842).withOpacity(0.3))),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.school_outlined,
                                  color: Color(0xFF8A8D99), size: 13),
                              const SizedBox(width: 4),
                              Text(_bioController.text, style: const TextStyle(
                                  color: Color(0xFF8A8D99), fontSize: 13)),
                              const Text(' • ', style: TextStyle(color: Color(0xFF8A8D99))),
                              const Icon(Icons.location_on_outlined,
                                  color: Color(0xFF8A8D99), size: 13),
                              const SizedBox(width: 2),
                              const Text('Mauritius', style: TextStyle(
                                  color: Color(0xFF8A8D99), fontSize: 13)),
                            ],
                          ),

                    const SizedBox(height: 16),

                    // Edit / Save button
                    GestureDetector(
                      onTap: () => setState(() => _isEditing = !_isEditing),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: _isEditing
                              ? const Color(0xFFF5C842)
                              : const Color(0xFF1C2030),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isEditing
                                ? const Color(0xFFF5C842)
                                : const Color(0xFFF5C842).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isEditing ? Icons.check_rounded : Icons.edit_rounded,
                              color: _isEditing
                                  ? const Color(0xFF0D0F14)
                                  : const Color(0xFFF5C842),
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isEditing ? 'Save Profile' : 'Edit Profile',
                              style: TextStyle(
                                color: _isEditing
                                    ? const Color(0xFF0D0F14)
                                    : const Color(0xFFF5C842),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Interests
              _SectionHeader(title: '🎯 Interests'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 8, runSpacing: 8,
                  children: [
                    ..._interests.map((t) => _InterestChip(
                          label: t,
                          onRemove: _isEditing
                              ? () => setState(() => _interests.remove(t))
                              : null,
                        )),
                    if (_isEditing)
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2030),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFF5C842).withOpacity(0.3),
                                style: BorderStyle.solid),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, color: Color(0xFFF5C842), size: 14),
                              SizedBox(width: 4),
                              Text('Add', style: TextStyle(
                                  color: Color(0xFFF5C842), fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Achievements
              _SectionHeader(title: '🏆 Achievements'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: _achievements.map((a) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _AchievementCard(achievement: a),
                    ),
                  )).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Events attended
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('📅 Events Attended', style: TextStyle(
                      color: Color(0xFFF0EDE4), fontSize: 14, fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All', style: TextStyle(
                          color: Color(0xFFF5C842), fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ..._events.map((e) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: _EventTile(event: e),
                  )),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141720),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4,
                decoration: BoxDecoration(color: const Color(0xFF3A3D4A),
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('Settings', style: TextStyle(color: Color(0xFFF0EDE4),
                fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            _SettingsTile(icon: Icons.notifications_outlined,
                label: 'Notifications', onTap: () {}),
            _SettingsTile(icon: Icons.privacy_tip_outlined,
                label: 'Privacy', onTap: () {}),
            _SettingsTile(icon: Icons.help_outline_rounded,
                label: 'Help & Support', onTap: () {}),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context,
                    fadeRoute(const LoginScreen()), (route) => false);
                },
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A1A1A),
                  foregroundColor: const Color(0xFFFF6B6B),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: const TextStyle(
          color: Color(0xFFF0EDE4), fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final VoidCallback? onRemove;
  const _InterestChip({required this.label, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 7, onRemove != null ? 6 : 12, 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF5C842).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(
              color: Color(0xFFF5C842), fontSize: 12, fontWeight: FontWeight.w500)),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close_rounded, color: Color(0xFFF5C842), size: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;
  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: achievement.color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: achievement.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(achievement.icon, color: achievement.color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(achievement.title, textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFF0EDE4),
                  fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(achievement.subtitle, textAlign: TextAlign.center,
              style: TextStyle(color: achievement.color.withOpacity(0.7), fontSize: 10)),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final _EventAttended event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF5C842).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(event.date.split(' ')[0], style: const TextStyle(
                    color: Color(0xFFF5C842), fontSize: 9, fontWeight: FontWeight.w600)),
                Text(event.date.split(' ')[1], style: const TextStyle(
                    color: Color(0xFFF5C842), fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(
                    color: Color(0xFFF0EDE4), fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      color: Color(0xFF8A8D99), size: 11),
                  const SizedBox(width: 3),
                  Text(event.location, style: const TextStyle(
                      color: Color(0xFF8A8D99), fontSize: 11)),
                ]),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A8D99), size: 20),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF8A8D99), size: 20),
      title: Text(label, style: const TextStyle(color: Color(0xFFF0EDE4), fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A8D99), size: 18),
      onTap: onTap,
    );
  }
}

// ── Data models ──────────────────────────────────────────────────────────────

class _Achievement {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _Achievement({required this.title, required this.subtitle,
      required this.icon, required this.color});
}

class _EventAttended {
  final String title;
  final String location;
  final String date;
  const _EventAttended({required this.title, required this.location, required this.date});
}