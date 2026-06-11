import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/login_screen.dart';
import 'package:alu_connect/features/home/notifications_screen.dart';
import 'package:alu_connect/features/home/user_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _session = UserSession();
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _session.displayName);
    _bioController  = TextEditingController(text: _session.campusLabel);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    _session.updateProfile(name: _nameController.text.trim());
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Profile updated!',
          style: TextStyle(color: Color(0xFF0D0F14))),
      backgroundColor: const Color(0xFFF5C842),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _pickImage() {
    // TODO: integrate image_picker package
    // final picker = ImagePicker();
    // final file = await picker.pickImage(source: ImageSource.gallery);
    // if (file != null) _session.updateProfile(avatarPath: file.path);
    showModalBottomSheet(context: context,
      backgroundColor: const Color(0xFF141720),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4,
              decoration: BoxDecoration(color: const Color(0xFF3A3D4A),
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Change Photo', style: TextStyle(color: Color(0xFFF0EDE4),
              fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          _SettingsTile(icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () { Navigator.pop(context); /* TODO: gallery picker */ }),
          _SettingsTile(icon: Icons.camera_alt_outlined,
              label: 'Take a Photo',
              onTap: () { Navigator.pop(context); /* TODO: camera picker */ }),
          if (_session.avatarPath != null)
            _SettingsTile(icon: Icons.delete_outline_rounded,
                label: 'Remove Photo', isDestructive: true,
                onTap: () { _session.updateProfile(avatarPath: null); Navigator.pop(context); }),
          const SizedBox(height: 8),
        ]),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                Container(width: 34, height: 34,
                  decoration: BoxDecoration(color: const Color(0xFFF5C842),
                      borderRadius: BorderRadius.circular(9)),
                  child: const Icon(Icons.school_rounded, color: Color(0xFF0D0F14), size: 18)),
                const SizedBox(width: 10),
                const Text('ALU Connect+', style: TextStyle(
                    color: Color(0xFFF0EDE4), fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                // Notifications bell with badge
                ListenableBuilder(listenable: _session, builder: (_, __) =>
                  GestureDetector(
                    onTap: () {
                      _session.markNotificationsRead();
                      Navigator.push(context, slideRoute(const NotificationsScreen()));
                    },
                    child: Stack(children: [
                      Container(width: 36, height: 36,
                        decoration: BoxDecoration(color: const Color(0xFF1C2030),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.15))),
                        child: const Icon(Icons.notifications_none_rounded,
                            color: Color(0xFFF0EDE4), size: 20)),
                      if (_session.unreadNotifications > 0)
                        Positioned(top: 6, right: 6,
                          child: Container(width: 8, height: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xFFF5C842), shape: BoxShape.circle))),
                    ]),
                  )),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showSettingsSheet(context),
                  child: Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: const Color(0xFF1C2030),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.15))),
                    child: const Icon(Icons.settings_outlined,
                        color: Color(0xFFF0EDE4), size: 18))),
              ]),
            ),

            const SizedBox(height: 24),

            // Avatar + info
            ListenableBuilder(listenable: _session, builder: (_, __) =>
              Center(child: Column(children: [
                // Avatar with camera overlay
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(children: [
                    Container(width: 90, height: 90,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        gradient: const LinearGradient(
                            colors: [Color(0xFF4A9EFF), Color(0xFF9B6DFF)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                        boxShadow: [BoxShadow(color: const Color(0xFF4A9EFF).withOpacity(0.3),
                            blurRadius: 20, offset: const Offset(0, 6))]),
                      child: _session.googlePhotoUrl != null
                          ? ClipOval(child: Image.network(_session.googlePhotoUrl!,
                              fit: BoxFit.cover, width: 90, height: 90))
                          : _session.avatarPath != null
                              ? ClipOval(child: Image.asset(_session.avatarPath!,
                                  fit: BoxFit.cover, width: 90, height: 90))
                              : Center(child: Text(_session.initials, style: const TextStyle(
                                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)))),
                    Positioned(bottom: 0, right: 0,
                      child: Container(width: 26, height: 26,
                        decoration: const BoxDecoration(
                            color: Color(0xFFF5C842), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Color(0xFF0D0F14), size: 14))),
                  ]),
                ),
                const SizedBox(height: 14),

                // Name — editable
                _isEditing
                    ? SizedBox(width: 220, child: TextField(
                        controller: _nameController, textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFF0EDE4),
                            fontSize: 20, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(border: UnderlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xFFF5C842).withOpacity(0.5))),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFF5C842))))))
                    : Text(_session.displayName, style: const TextStyle(
                        color: Color(0xFFF0EDE4), fontSize: 20, fontWeight: FontWeight.w700)),

                const SizedBox(height: 6),

                // Role + campus
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.school_outlined, color: Color(0xFF8A8D99), size: 13),
                  const SizedBox(width: 4),
                  Text(_session.role.isNotEmpty
                      ? '${_session.role[0].toUpperCase()}${_session.role.substring(1)}'
                      : 'Student',
                      style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 13)),
                  const Text(' • ', style: TextStyle(color: Color(0xFF8A8D99))),
                  const Icon(Icons.location_on_outlined, color: Color(0xFF8A8D99), size: 13),
                  const SizedBox(width: 2),
                  Text(_session.campusLabel.split('·').first.trim(),
                      style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 13)),
                ]),

                if (_session.signedInWithGoogle) ...[
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(width: 14, height: 14, child: CustomPaint(painter: _GoogleMiniPainter())),
                    const SizedBox(width: 5),
                    const Text('Signed in with Google',
                        style: TextStyle(color: Color(0xFF8A8D99), fontSize: 11)),
                  ]),
                ],

                const SizedBox(height: 16),

                // Edit / Save button
                GestureDetector(
                  onTap: _isEditing ? _saveProfile : () => setState(() => _isEditing = true),
                  child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isEditing ? const Color(0xFFF5C842) : const Color(0xFF1C2030),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _isEditing
                          ? const Color(0xFFF5C842) : const Color(0xFFF5C842).withOpacity(0.3))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_isEditing ? Icons.check_rounded : Icons.edit_rounded,
                          color: _isEditing ? const Color(0xFF0D0F14) : const Color(0xFFF5C842), size: 15),
                      const SizedBox(width: 6),
                      Text(_isEditing ? 'Save Profile' : 'Edit Profile',
                          style: TextStyle(
                              color: _isEditing ? const Color(0xFF0D0F14) : const Color(0xFFF5C842),
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ])),
                ),
              ])),
            ),

            const SizedBox(height: 28),

            // Interests
            _SectionLabel(title: '🎯 Interests'),
            const SizedBox(height: 12),
            ListenableBuilder(listenable: _session, builder: (_, __) =>
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _session.interests.isEmpty
                    ? const Text('No interests added yet.',
                        style: TextStyle(color: Color(0xFF8A8D99), fontSize: 13))
                    : Wrap(spacing: 8, runSpacing: 8,
                        children: _session.interests.map((t) =>
                          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5C842).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.4))),
                            child: Text(t, style: const TextStyle(
                                color: Color(0xFFF5C842), fontSize: 12, fontWeight: FontWeight.w500)))).toList()))),

            const SizedBox(height: 24),

            // Achievements
            _SectionLabel(title: '🏆 Achievements'),
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _AchievementCard(title: "Dean's List", subtitle: 'Fall 2023',
                    icon: Icons.emoji_events_rounded, color: const Color(0xFFF5C842)),
                const SizedBox(width: 8),
                _AchievementCard(title: 'Hackathon Winner', subtitle: 'CodeFest Q2',
                    icon: Icons.code_rounded, color: const Color(0xFF4A9EFF)),
                const SizedBox(width: 8),
                _AchievementCard(title: 'Guest Lecture', subtitle: 'In Progress',
                    icon: Icons.mic_rounded, color: const Color(0xFF9B6DFF)),
              ])),

            const SizedBox(height: 24),

            // Events attended
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('📅 Events Attended', style: TextStyle(
                    color: Color(0xFFF0EDE4), fontSize: 14, fontWeight: FontWeight.w600)),
                TextButton(onPressed: () {},
                    child: const Text('View All', style: TextStyle(
                        color: Color(0xFFF5C842), fontSize: 12))),
              ])),
            const SizedBox(height: 8),
            _EventTile(title: 'Future of AI Summit', location: 'Main Auditorium', date: 'Dec\n12'),
            _EventTile(title: 'Startup Pitch Night', location: 'Innovation Hub', date: 'Apr\n30'),
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(context: context,
      backgroundColor: const Color(0xFF141720),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4,
              decoration: BoxDecoration(color: const Color(0xFF3A3D4A),
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Settings', style: TextStyle(color: Color(0xFFF0EDE4),
              fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _SettingsTile(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
          _SettingsTile(icon: Icons.privacy_tip_outlined, label: 'Privacy', onTap: () {}),
          _SettingsTile(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () {}),
          const SizedBox(height: 8),
          SizedBox(width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _session.signOut();
                Navigator.pushAndRemoveUntil(context,
                    fadeRoute(const LoginScreen()), (r) => false);
              },
              icon: const Icon(Icons.logout_rounded, size: 16),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A1A1A),
                foregroundColor: const Color(0xFFFF6B6B),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0))),
          const SizedBox(height: 8),
        ])));
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(title, style: const TextStyle(color: Color(0xFFF0EDE4),
        fontSize: 14, fontWeight: FontWeight.w600)));
}

class _AchievementCard extends StatelessWidget {
  final String title, subtitle; final IconData icon; final Color color;
  const _AchievementCard({required this.title, required this.subtitle,
      required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2))),
    child: Column(children: [
      Container(width: 40, height: 40,
        decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20)),
      const SizedBox(height: 8),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(
          color: Color(0xFFF0EDE4), fontSize: 11, fontWeight: FontWeight.w600)),
      const SizedBox(height: 2),
      Text(subtitle, textAlign: TextAlign.center,
          style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
    ])));
}

class _EventTile extends StatelessWidget {
  final String title, location, date;
  const _EventTile({required this.title, required this.location, required this.date});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
    child: Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.08))),
      child: Row(children: [
        Container(width: 42, height: 42,
          decoration: BoxDecoration(color: const Color(0xFFF5C842).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(date, textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFF5C842),
                  fontSize: 11, fontWeight: FontWeight.w700)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Color(0xFFF0EDE4),
              fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),
          Row(children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF8A8D99), size: 11),
            const SizedBox(width: 3),
            Text(location, style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 11)),
          ]),
        ])),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A8D99), size: 20),
      ])));
}

class _SettingsTile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  final bool isDestructive;
  const _SettingsTile({required this.icon, required this.label,
      required this.onTap, this.isDestructive = false});
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: isDestructive ? const Color(0xFFFF6B6B) : const Color(0xFF8A8D99), size: 20),
    title: Text(label, style: TextStyle(
        color: isDestructive ? const Color(0xFFFF6B6B) : const Color(0xFFF0EDE4), fontSize: 14)),
    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A8D99), size: 18),
    onTap: onTap);
}

class _GoogleMiniPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width/2; final cy = size.height/2; final r = size.width/2;
    final paints = [Paint()..color = const Color(0xFF4285F4), Paint()..color = const Color(0xFF34A853),
      Paint()..color = const Color(0xFFFBBC05), Paint()..color = const Color(0xFFEA4335)];
    canvas.drawArc(Rect.fromCircle(center: Offset(cx,cy), radius: r), -1.57, 3.14, false,
        paints[0]..style=PaintingStyle.stroke..strokeWidth=size.width*0.28);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx,cy), radius: r), 1.57, 1.57, false,
        paints[1]..style=PaintingStyle.stroke..strokeWidth=size.width*0.28);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx,cy), radius: r), 3.14, 0.79, false,
        paints[2]..style=PaintingStyle.stroke..strokeWidth=size.width*0.28);
    canvas.drawRect(Rect.fromLTWH(cx, cy-size.height*0.12, r*0.85, size.height*0.24),
        paints[0]..style=PaintingStyle.fill);
  }
  @override bool shouldRepaint(_) => false;
}