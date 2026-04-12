import 'package:flutter/material.dart';

// =========================
// 🔹 MESSAGE MODEL
// =========================
class ChatMessage {
  final String text;
  final DateTime time;
  final bool isMe;

  ChatMessage({required this.text, required this.time, required this.isMe});
}

class ChatPage extends StatefulWidget {
  final String receiverName;

  const ChatPage({super.key, required this.receiverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String selectedHelper = "Christo Budiman";

  final List<String> helpers = ["Siti Rahayu", "Christo Budiman"];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  List<ChatMessage> messages = [
    ChatMessage(
      text: "Saya bisa bantu Pak! Kapan waktunya?",
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: false,
    ),
    ChatMessage(
      text: "Minggu depan, Pak. Terima kasih banyak!",
      time: DateTime.now().subtract(const Duration(minutes: 3)),
      isMe: true,
    ),
  ];

  // =========================
  // 🔹 AUTO SCROLL
  // =========================
  void scrollToBottom() {
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

  // =========================
  // 🔹 SEND MESSAGE
  // =========================
  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text: _controller.text.trim(),
          time: DateTime.now(),
          isMe: true,
        ),
      );
    });

    _controller.clear();
    scrollToBottom();
  }

  // =========================
  // 🔹 DATE LABEL
  // =========================
  String getDateLabel(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Hari ini";
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Kemarin";
    }

    return "${date.day}/${date.month}/${date.year}";
  }

  // =========================
  // 🔹 TIME FORMAT
  // =========================
  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // =========================
        // 🔹 HELPERS
        // =========================
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Helpers",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              ...helpers.map((helper) {
                final isSelected = helper == selectedHelper;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedHelper = helper;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFDCFCE7)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1E6B45)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          child: Icon(Icons.person, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          helper,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        // SEPARATOR
        Container(height: 6, color: const Color(0xFFF3F4F6)),

        // =========================
        // 🔹 CHAT AREA
        // =========================
        Expanded(
          child: Column(
            children: [
              // MESSAGES
              Expanded(
                child: Container(
                  color: const Color(0xFFF9FAFB),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];

                      bool showDate = false;
                      if (index == 0) {
                        showDate = true;
                      } else {
                        final prev = messages[index - 1];
                        if (prev.time.day != msg.time.day ||
                            prev.time.month != msg.time.month ||
                            prev.time.year != msg.time.year) {
                          showDate = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showDate)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E7EB),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  getDateLabel(msg.time),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),

                          Align(
                            alignment: msg.isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ChatBubble(
                              text: msg.text,
                              time: formatTime(msg.time),
                              isMe: msg.isMe,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const Divider(height: 1),

              // INPUT
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Ketik pesan...",
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================
// 🔹 CHAT BUBBLE
// =========================
class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF16A34A) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(color: isMe ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: isMe ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
