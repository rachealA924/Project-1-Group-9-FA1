import 'package:flutter/material.dart';

// ignore: library_private_types_in_public_api
class ChatScreen extends StatefulWidget {
  final dynamic conversation;
  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [
    _Message(text: 'Hey! Are we still meeting at the library for the study group at 4?',
        isMine: false, time: '1:42 PM', senderName: 'Sarah Jenkins'),
    _Message(text: 'Yes, absolutely. I\'ve already booked study C on the second floor.',
        isMine: true, time: '1:45 PM'),
    _Message(text: 'Econ_Syllabus_F24.pdf\n2.8 MB • PDF',
        isMine: false, time: '1:46 PM', isFile: true, senderName: 'Sarah Jenkins'),
    _Message(text: 'Got it, thanks! I\'ll review it before we meet.',
        isMine: true, time: '3:51 PM'),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(
        text: text,
        isMine: true,
        time: TimeOfDay.now().format(context),
      ));
      _messageController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F14),
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
              ),
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
                  const SizedBox(width: 12),
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A9EFF).withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF4A9EFF).withOpacity(0.5), width: 1.5),
                        ),
                        child: const Center(child: Text('SJ', style: TextStyle(
                          color: Color(0xFF4A9EFF), fontSize: 13, fontWeight: FontWeight.w700))),
                      ),
                      Positioned(
                        bottom: 1, right: 1,
                        child: Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0D0F14), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.conversation?.name ?? 'Sarah Jenkins',
                          style: const TextStyle(color: Color(0xFFF0EDE4),
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const Text('Active now', style: TextStyle(
                            color: Color(0xFF4CAF50), fontSize: 11)),
                      ],
                    ),
                  ),
                  // Action buttons
                  Row(
                    children: [
                      _IconBtn(icon: Icons.call_outlined, onTap: () {}),
                      const SizedBox(width: 8),
                      _IconBtn(icon: Icons.videocam_outlined, onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),

            // Date separator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.07))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Today', style: TextStyle(
                        color: const Color(0xFF8A8D99).withOpacity(0.7), fontSize: 11)),
                  ),
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.07))),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _MessageBubble(message: _messages[i]),
              ),
            ),

            // Input bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F14),
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
              ),
              child: Row(
                children: [
                  // Attachment button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2030),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.attach_file_rounded,
                          color: Color(0xFF8A8D99), size: 18),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2030),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: const TextStyle(color: Color(0xFFF0EDE4), fontSize: 13),
                              maxLines: null,
                              onSubmitted: (_) => _sendMessage(),
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Color(0xFF8A8D99), fontSize: 13),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.sentiment_satisfied_alt_outlined,
                                  color: Color(0xFF8A8D99), size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Send button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5C842),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Color(0xFF0D0F14), size: 18),
                    ),
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

class _MessageBubble extends StatelessWidget {
  final _Message message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isMine && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(message.senderName!, style: const TextStyle(
                  color: Color(0xFF8A8D99), fontSize: 11)),
            ),
          Row(
            mainAxisAlignment:
                message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!message.isMine) const SizedBox(width: 4),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.72),
                  padding: message.isFile
                      ? const EdgeInsets.all(12)
                      : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: message.isMine
                        ? const Color(0xFFF5C842)
                        : const Color(0xFF1C2030),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isMine ? 16 : 4),
                      bottomRight: Radius.circular(message.isMine ? 4 : 16),
                    ),
                  ),
                  child: message.isFile
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5C842).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.picture_as_pdf_rounded,
                                  color: Color(0xFFF5C842), size: 20),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: message.text.split('\n').map((line) =>
                                Text(line, style: TextStyle(
                                  color: message.isMine
                                      ? const Color(0xFF0D0F14)
                                      : const Color(0xFFF0EDE4),
                                  fontSize: line.contains('MB') ? 11 : 13,
                                  fontWeight: line.contains('MB')
                                      ? FontWeight.w400 : FontWeight.w500,
                                ))).toList(),
                            ),
                          ],
                        )
                      : Text(
                          message.text,
                          style: TextStyle(
                            color: message.isMine
                                ? const Color(0xFF0D0F14)
                                : const Color(0xFFF0EDE4),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                ),
              ),
              if (message.isMine) const SizedBox(width: 4),
            ],
          ),
          const SizedBox(height: 3),
          Padding(
            padding: EdgeInsets.only(
                left: message.isMine ? 0 : 4, right: message.isMine ? 4 : 0),
            child: Text(message.time, style: const TextStyle(
                color: Color(0xFF8A8D99), fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1C2030),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF5C842).withOpacity(0.12)),
        ),
        child: Icon(icon, color: const Color(0xFFF0EDE4), size: 18),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isMine;
  final String time;
  final String? senderName;
  final bool isFile;

  const _Message({
    required this.text,
    required this.isMine,
    required this.time,
    this.senderName,
    this.isFile = false,
  });
}