import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/storage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final token = await StorageService.getToken();
      if (token != null) {
        final data = await AuthService.getNotifications(token);
        
        // Panggil endpoint untuk menandai sudah dibaca
        try {
          await AuthService.markNotificationsAsRead(token);
        } catch (e) {
          debugPrint('Gagal menandai notifikasi dibaca: $e');
        }

        setState(() {
          notifications = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Token tidak ditemukan. Silakan login ulang.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Gagal memuat notifikasi: $e';
        isLoading = false;
      });
    }
  }

  String _formatTime(String? isoString) {
    if (isoString == null) return '';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      return '${diff.inDays} hari lalu';
    } catch (_) {
      return '';
    }
  }

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
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  )
                : notifications.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.notifications_none,
                                    size: 64, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  "Belum ada notifikasi",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          return _notifCard(
                            name: notif['username'] ?? 'Sistem',
                            action: notif['title'] ?? '',
                            time: _formatTime(notif['created_at']),
                            isRead: notif['is_read'] ?? false,
                          );
                        },
                      ),
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
  final bool isRead;

  const _notifCard({
    required this.name,
    required this.action,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRead
              ? const Color(0xFFE5E7EB)
              : const Color(0xFF93C5FD),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 AVATAR
          CircleAvatar(
            radius: 18,
            backgroundColor:
                isRead ? Colors.grey.shade200 : const Color(0xFFDBEAFE),
            child: Icon(
              Icons.notifications,
              size: 18,
              color: isRead ? Colors.grey : const Color(0xFF3B82F6),
            ),
          ),

          const SizedBox(width: 10),

          // 🔹 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style:
                        const TextStyle(fontSize: 13.5, color: Colors.black),
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

          // 🔹 UNREAD INDICATOR
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
