import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final List<Map<String, String>> _chats = const [
    {'name': 'ALU Tech Innovators', 'message': 'We need to finalize the prototype by Friday.', 'time': '09:42 AM', 'avatar': 'AT'},
    {'name': 'Dr. Elena Rostova', 'message': 'Your thesis draft looks solid. Let\'s discuss the methodology.', 'time': 'Yesterday', 'avatar': 'ER'},
    {'name': 'ENG 204 Study Group', 'message': 'Thanks for sharing the notes!', 'time': 'Mon', 'avatar': 'EG'},
    {'name': 'Marcus Chen', 'message': 'Are we still on for the library session tomorrow?', 'time': 'Sun', 'avatar': 'MC'},
    {'name': 'ALU Hackathon Team', 'message': 'Don\'t forget the submission deadline is Friday!', 'time': 'Sat', 'avatar': 'AH'},
    {'name': 'Startup Club', 'message': 'Next meeting is on Wednesday at 5PM.', 'time': 'Fri', 'avatar': 'SC'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Messages', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Active now
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Active Now', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Sarah', 'Prof. Lee', 'CS101', 'Marcus', 'Elena'].map((name) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.surfaceVariant,
                                  child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: AppColors.online,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.background, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(name, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border),
          // Chat list
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.surfaceVariant,
                    child: Text(chat['avatar']!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  title: Text(chat['name']!, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  subtitle: Text(chat['message']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(chat['time']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.edit, color: AppColors.onPrimary),
      ),
    );
  }
}