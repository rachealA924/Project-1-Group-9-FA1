import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'package:alu_connect/features/home/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  final List<_Conversation> _conversations = [
    _Conversation(
      id: '1',
      name: 'ALU Tech Innovators',
      lastMessage: 'David: We need to finalize the prototype by Friday',
      time: '10:42 AM',
      unread: 2,
      isGroup: true,
      avatarColor: Color(0xFF4A9EFF),
      initials: 'AT',
    ),
    _Conversation(
      id: '2',
      name: 'Dr. Elena Rostova',
      lastMessage: 'Your thesis draft looks good! Let\'s discuss the methodology section during office hours.',
      time: 'Yesterday',
      unread: 0,
      isGroup: false,
      avatarColor: Color(0xFF9B6DFF),
      initials: 'ER',
    ),
    _Conversation(
      id: '3',
      name: 'ENG 204 Study Group',
      lastMessage: 'Thanks for sharing the notes!',
      time: 'Mon',
      unread: 0,
      isGroup: true,
      avatarColor: Color(0xFF4CAF50),
      initials: 'EG',
    ),
    _Conversation(
      id: '4',
      name: 'Marcus Chen',
      lastMessage: 'Are we still on for the library session tomorrow?',
      time: 'Sun',
      unread: 0,
      isGroup: false,
      avatarColor: Color(0xFFF5C842),
      initials: 'MC',
    ),
  ];

  final List<_ActiveUser> _activeNow = [
    _ActiveUser(name: 'Sarah', avatarColor: Color(0xFF4A9EFF), initials: 'SJ'),
    _ActiveUser(name: 'Marcus', avatarColor: Color(0xFFF5C842), initials: 'MC'),
    _ActiveUser(name: 'Amara', avatarColor: Color(0xFF9B6DFF), initials: 'AM'),
    _ActiveUser(name: 'David', avatarColor: Color(0xFF4CAF50), initials: 'DK'),
    _ActiveUser(name: 'Lina', avatarColor: Color(0xFFFF6B6B), initials: 'LN'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Conversation> get _filtered => _query.isEmpty
      ? _conversations
      : _conversations
          .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();

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
                  // New message button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2030),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.edit_outlined, color: Color(0xFFF5C842), size: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(color: Color(0xFFF0EDE4), fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: const TextStyle(color: Color(0xFF8A8D99), fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8A8D99), size: 18),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                          onTap: () => setState(() {
                            _query = '';
                            _searchController.clear();
                          }),
                          child: const Icon(Icons.close_rounded, color: Color(0xFF8A8D99), size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1C2030),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Active Now
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: const Text('Active Now', style: TextStyle(
                color: Color(0xFFF0EDE4), fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _activeNow.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) {
                  final u = _activeNow[i];
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 46, height: 46,
                            decoration: BoxDecoration(
                              color: u.avatarColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: u.avatarColor.withOpacity(0.5), width: 1.5),
                            ),
                            child: Center(child: Text(u.initials, style: TextStyle(
                              color: u.avatarColor, fontSize: 13, fontWeight: FontWeight.w700))),
                          ),
                          Positioned(
                            bottom: 1, right: 1,
                            child: Container(
                              width: 11, height: 11,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF0D0F14), width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(u.name, style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 10)),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Conversations list
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('No conversations found',
                      style: TextStyle(color: Color(0xFF8A8D99), fontSize: 13)))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        color: Colors.white.withOpacity(0.05), height: 1),
                      itemBuilder: (_, i) {
                        final c = _filtered[i];
                        return _ConversationTile(
                          conversation: c,
                          onTap: () => Navigator.push(context,
                            slideRoute(ChatScreen(conversation: c))),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Floating compose button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFF5C842),
        child: const Icon(Icons.edit_rounded, color: Color(0xFF0D0F14)),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final _Conversation conversation;
  final VoidCallback onTap;
  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: conversation.avatarColor.withOpacity(0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: conversation.avatarColor.withOpacity(0.35), width: 1.5),
                  ),
                  child: Center(
                    child: conversation.isGroup
                        ? Icon(Icons.group_rounded,
                            color: conversation.avatarColor, size: 22)
                        : Text(conversation.initials, style: TextStyle(
                            color: conversation.avatarColor,
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(conversation.name, style: TextStyle(
                          color: conversation.unread > 0
                              ? const Color(0xFFF0EDE4)
                              : const Color(0xFFBDBFC8),
                          fontSize: 14,
                          fontWeight: conversation.unread > 0
                              ? FontWeight.w600 : FontWeight.w400,
                        )),
                      ),
                      Text(conversation.time, style: TextStyle(
                        color: conversation.unread > 0
                            ? const Color(0xFFF5C842)
                            : const Color(0xFF8A8D99),
                        fontSize: 11,
                      )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(conversation.lastMessage,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: conversation.unread > 0
                                ? const Color(0xFFBDBFC8)
                                : const Color(0xFF8A8D99),
                            fontSize: 12,
                          )),
                      ),
                      if (conversation.unread > 0)
                        Container(
                          width: 20, height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5C842), shape: BoxShape.circle),
                          child: Center(
                            child: Text('${conversation.unread}', style: const TextStyle(
                              color: Color(0xFF0D0F14), fontSize: 10,
                              fontWeight: FontWeight.w700)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data models ──────────────────────────────────────────────────────────────

class _Conversation {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isGroup;
  final Color avatarColor;
  final String initials;

  const _Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.isGroup,
    required this.avatarColor,
    required this.initials,
  });
}

class _ActiveUser {
  final String name;
  final Color avatarColor;
  final String initials;
  const _ActiveUser({required this.name, required this.avatarColor, required this.initials});
}