import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.surfaceVariant,
                        child: const Text('GM', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 2),
                          ),
                          child: const Icon(Icons.edit, size: 14, color: AppColors.onPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Gloria M', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('ALU Student · Kigali Campus', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  const Text('Software Engineering · Year 2', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem('12', 'Applied'),
                      _divider(),
                      _statItem('5', 'Events'),
                      _divider(),
                      _statItem('3', 'Communities'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border),
            // Menu items
            _menuItem(Icons.work_outline, 'My Applications', context),
            _menuItem(Icons.event_outlined, 'My Events', context),
            _menuItem(Icons.group_outlined, 'My Communities', context),
            _menuItem(Icons.bookmark_outline, 'Saved Opportunities', context),
            _menuItem(Icons.notifications_outlined, 'Notifications', context),
            const Divider(color: AppColors.border),
            _menuItem(Icons.help_outline, 'Help & Support', context),
            _menuItem(Icons.logout, 'Logout', context, isRed: true),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 30, color: AppColors.border);
  }

  Widget _menuItem(IconData icon, String title, BuildContext context, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.red : AppColors.textSecondary),
      title: Text(title, style: TextStyle(color: isRed ? Colors.red : AppColors.textPrimary)),
      trailing: isRed ? null : const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
      onTap: () {},
    );
  }
}