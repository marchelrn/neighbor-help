import 'package:flutter/material.dart';
import '../screens/request_detail_page.dart';

class RequestCard extends StatelessWidget {
  // 🔥 DEFAULT ACTIVE (FIXED)
  final bool isActive;

  // 🔥 OPTIONAL DATA
  final String? name;
  final String? title;
  final String? description;
  final String? distance;
  final String? time;
  final bool urgent;
  final List<String> tags;

  const RequestCard({
    super.key,
    this.isActive = true, // ✅ ONLY THIS (REMOVE required)
    this.name,
    this.title,
    this.description,
    this.distance,
    this.time,
    this.urgent = false,
    this.tags = const [],
  });

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RequestDetailPage(
          name: name ?? "User",
          title: title ?? "Request",
          distance: distance ?? "-",
          urgent: urgent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = urgent ? Colors.red : const Color(0xFF22C55E);

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? accent.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? accent : const Color(0xFFE5E7EB),
            width: isActive ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 TOP ROW
            Row(
              children: [
                if (name != null)
                  const CircleAvatar(
                    radius: 18,
                    child: Icon(Icons.person, size: 18),
                  ),
                if (name != null) const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (name != null)
                        Text(
                          name!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                      Text(
                        isActive
                            ? "Aktif • ${time ?? "1 hari lalu"}"
                            : "Selesai • ${time ?? "3 hari lalu"}",
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? accent : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),

                if (distance != null)
                  Text(
                    distance!,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔥 TITLE
            Text(
              title ??
                  (isActive
                      ? "Butuh bantuan pindahan minggu depan"
                      : "Pinjam tangga untuk ganti lampu"),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.5,
              ),
            ),

            const SizedBox(height: 8),

            // 🔥 DESCRIPTION
            Text(
              description ??
                  (isActive
                      ? "Butuh 2-3 orang bantu angkat barang selama 3 jam."
                      : "Butuh tangga lipat untuk ganti lampu."),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // 🔥 TAGS
            if (tags.isNotEmpty)
              Wrap(
                spacing: 6,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(fontSize: 10, color: accent),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 14),

            // 🔥 ACTIONS
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 16),
                const SizedBox(width: 4),
                Text(
                  isActive ? "1 pesan" : "0 pesan",
                  style: const TextStyle(fontSize: 13),
                ),

                const Spacer(),

                if (name != null) ...[
                  TextButton(
                    onPressed: () => _openDetail(context),
                    child: const Text("Detail"),
                  ),
                  ElevatedButton(
                    onPressed: () => _openDetail(context),
                    style: ElevatedButton.styleFrom(backgroundColor: accent),
                    child: const Text("Bantu"),
                  ),
                ] else ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Tandai Selesai"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: accent),
                      child: const Text("Lihat Chat"),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
