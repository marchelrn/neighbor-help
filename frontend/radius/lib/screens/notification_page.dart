import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _notifCard(
            name: "Siti Rahayu",
            action: "mengirim pesan baru",
            time: "10 menit lalu",
            type: "chat",
          ),
          _notifCard(
            name: "Christo Budiman",
            action: "membantu request kamu",
            time: "1 jam lalu",
            type: "success",
          ),
          _notifCard(
            name: "Sistem",
            action: "Request kamu telah selesai",
            time: "3 jam lalu",
            type: "system",
          ),
        ],
      ),
    );
  }
}

// =========================
// 🔹 NOTIFICATION CARD
// =========================
class _notifCard extends StatelessWidget {
  final String name;
  final String action;
  final String time;
  final String type;

  const _notifCard({
    required this.name,
    required this.action,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 AVATAR (same as your helper/chat style)
          const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 18)),

          const SizedBox(width: 10),

          // 🔹 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13.5, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "$name ",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: action),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 RIGHT SIDE ACTION / ICON
          _buildTrailing(),
        ],
      ),
    );
  }

  Widget _buildTrailing() {
    switch (type) {
      case "request":
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF16A34A)),
          ),
          child: const Text(
            "Lihat",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF16A34A),
              fontWeight: FontWeight.w600,
            ),
          ),
        );

      case "chat":
        return const Icon(Icons.chat_bubble_outline, size: 18);

      case "success":
        return const Icon(Icons.check_circle, color: Colors.green, size: 18);

      case "system":
        return const Icon(Icons.info_outline, size: 18);

      default:
        return const SizedBox();
    }
  }
}
