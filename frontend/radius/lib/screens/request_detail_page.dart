import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RequestDetailPage extends StatelessWidget {
  final String name;
  final String title;
  final String distance;
  final bool urgent;

  const RequestDetailPage({
    super.key,
    required this.name,
    required this.title,
    required this.distance,
    this.urgent = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = urgent ? Colors.red : AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("Detail Request"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =========================
            // 🔹 USER INFO
            // =========================
            _accentCard(
              accent: accent,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distance,
                              style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // 🔹 STATUS BAR
            // =========================
            _accentCard(
              accent: accent,
              child: Row(
                children: [
                  _statusChip(urgent ? "URGENT" : "AKTIF", accent),
                  const SizedBox(width: 10),
                  const Text(
                    "Dibuat 1 hari lalu",
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const Spacer(),
                  const Icon(Icons.flag_outlined, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // 🔹 MAIN DETAIL
            // =========================
            _accentCard(
              accent: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "JUDUL REQUEST",
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "DESKRIPSI",
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Saya membutuhkan bantuan untuk menyelesaikan pekerjaan ini. Estimasi waktu sekitar beberapa jam dan membutuhkan tenaga tambahan.",
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 13.5,
                      color: Color(0xFF374151),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _infoBox("Durasi", "±3 jam")),
                      const SizedBox(width: 10),
                      Expanded(child: _infoBox("Helper", "1 orang")),
                      const SizedBox(width: 10),
                      Expanded(child: _infoBox("Status", "Menunggu")),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // 🔹 ACTION PANEL
            // =========================
            _accentCard(
              accent: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AKSI",
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat),
                          label: const Text("Chat"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check),
                          label: const Text("Ambil"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                          ),
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

  // =========================
  // 🔹 ACCENT CARD
  // =========================
  Widget _accentCard({required Widget child, required Color accent}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        // ✅ FIX HERE
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(padding: const EdgeInsets.all(16), child: child),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // 🔹 STATUS CHIP
  // =========================
  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  // =========================
  // 🔹 INFO BOX
  // =========================
  Widget _infoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 0.8,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
