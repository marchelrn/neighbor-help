import 'package:flutter/material.dart';

class RequestDetailCard extends StatelessWidget {
  const RequestDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // 🔹 HEADER (STATUS + TIME)
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.access_time, size: 14, color: Color(0xFF16A34A)),
                    SizedBox(width: 6),
                    Text(
                      "Aktif",
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "1 hari lalu",
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================
          // 🔹 TITLE
          // =========================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: Text(
                  "Butuh bantuan pindahan minggu depan",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.35,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text("📦", style: TextStyle(fontSize: 18)),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // 🔹 DESCRIPTION
          // =========================
          const Text(
            "Saya akan pindah kontrakan minggu depan. Butuh 2-3 orang yang bisa bantu angkat barang sekitar 3 jam.",
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          // =========================
          // 🔹 META INFO (BADGES STYLE)
          // =========================
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _infoChip(Icons.people_outline, "1 Helper"),
              _infoChip(Icons.chat_bubble_outline, "1 Pesan"),
              _infoChip(Icons.schedule, "±3 Jam"),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(),

          const SizedBox(height: 14),

          // =========================
          // 🔹 ACTION BUTTONS (CLEANER)
          // =========================
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B7280),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "✓ Tandai Selesai",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Tutup Request",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // 🔹 INFO CHIP (REUSABLE)
  // =========================
  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF6B7280)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF374151)),
          ),
        ],
      ),
    );
  }
}
