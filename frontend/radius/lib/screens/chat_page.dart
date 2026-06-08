import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../services/auth_service.dart';
import '../utils/storage.dart';

// =========================
// 🔹 MESSAGE MODEL
// =========================
class ChatMessage {
  final String text;
  final DateTime time;
  final bool isMe;
  final String senderName;

  ChatMessage({
    required this.text, 
    required this.time, 
    required this.isMe,
    this.senderName = "",
  });
}

class ChatPage extends StatefulWidget {
  final String receiverName;
  final bool isActive;
  final int? requestId;

  const ChatPage({
    super.key,
    required this.receiverName,
    this.isActive = true,
    this.requestId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  WebSocketChannel? _channel;
  int? currentUserId;
  String? currentUsername;
  List<ChatMessage> messages = [];
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  @override
  void didUpdateWidget(ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestId != widget.requestId ||
        oldWidget.isActive != widget.isActive) {
      _disconnectWebSocket();
      _connectWebSocket();
    }
  }

  @override
  void dispose() {
    _disconnectWebSocket();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connectWebSocket() async {
    if (widget.requestId == null) return;

    setState(() {
      isConnecting = true;
      messages.clear();
    });

    final token = await StorageService.getToken();
    if (token == null) return;

    try {
      final user = await AuthService.getCurrentUser(token);
      currentUsername = user["username"];
      currentUserId = user["id"];
    } catch (e) {
      debugPrint("Failed to load user: $e");
    }

    final wsUrl =
        AuthService.baseUrl.replaceFirst("http", "ws") +
        "/ws/help/${widget.requestId}/chat?token=$token";

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);

          if (data["type"] == "history") {
            final msgs = data["messages"] as List?;
            if (msgs != null) {
              setState(() {
                messages = msgs
                    .map(
                      (m) => ChatMessage(
                        text: m["content"] ?? "",
                        time: DateTime.parse(
                            m["created_at"] ?? DateTime.now().toIso8601String()),
                        isMe: m["sender_id"] == currentUserId,
                        senderName: m["sender_username"] ?? "Unknown",
                      ),
                    )
                    .toList();
              });
            }
            scrollToBottom();
          } else {
            // New message
            setState(() {
              messages.add(
                ChatMessage(
                  text: data["message"] ?? "",
                  time: DateTime.parse(
                      data["sent_at"] ?? DateTime.now().toIso8601String()),
                  isMe: data["sender_id"] == currentUserId,
                  senderName: data["sender_username"] ?? "Unknown",
                ),
              );
            });
            scrollToBottom();
          }
        },
        onError: (e) {
          debugPrint("WebSocket Error: $e");
        },
        onDone: () {
          debugPrint("WebSocket Closed");
        },
      );

      if (mounted) {
        setState(() {
          isConnecting = false;
        });
      }
    } catch (e) {
      debugPrint("WebSocket connection failed: $e");
      if (mounted) {
        setState(() {
          isConnecting = false;
        });
      }
    }
  }

  void _disconnectWebSocket() {
    _channel?.sink.close();
    _channel = null;
  }

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
    if (_controller.text.trim().isEmpty || _channel == null || !widget.isActive)
      return;

    final messageText = _controller.text.trim();
    _channel!.sink.add(jsonEncode({"message": messageText}));

    // The backend will broadcast the message back, so we don't necessarily need to add it manually immediately,
    // but the backend does broadcast it to all clients in the room including the sender.

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
  Widget build(BuildContext context) {
    if (widget.requestId == null) {
      return Container(
        color: const Color(0xFFF9FAFB),
        child: const Center(
          child: Text("Pilih obrolan untuk mulai mengirim pesan"),
        ),
      );
    }

    return Column(
      children: [
        // =========================
        // 🔹 HEADER CHAT
        // =========================
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: Colors.white,
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                child: Icon(Icons.person, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.receiverName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!widget.isActive)
                      const Text(
                        "Selesai",
                        style: TextStyle(fontSize: 12, color: Colors.redAccent),
                      ),
                  ],
                ),
              ),
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
                  child: isConnecting
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
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
                                    senderName: msg.senderName,
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
                        enabled: widget.isActive,
                        decoration: InputDecoration(
                          hintText: widget.isActive
                              ? "Ketik pesan..."
                              : "Sesi chat telah dimatikan.",
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
                      onPressed: widget.isActive ? sendMessage : null,
                      icon: Icon(
                        Icons.send,
                        color: widget.isActive
                            ? const Color(0xFF16A34A)
                            : Colors.grey,
                      ),
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
  final String senderName;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
    this.senderName = "",
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
          if (!isMe && senderName.isNotEmpty) ...[
            Text(
              senderName,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 2),
          ],
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
