import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/request_card.dart';

class HelpFeedPage extends StatelessWidget {
  const HelpFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFF3F4F6),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // 🔹 HEADER PANEL
                // =========================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bantuan di Sekitarmu",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Temukan dan bantu tetangga di area kamu",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 14),

                      // 🔹 SEARCH BAR
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Cari bantuan...",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // =========================
                // 🔹 FILTER CHIPS
                // =========================
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _FilterChip("Semua", true),
                      _FilterChip("Urgent", false),
                      _FilterChip("Terdekat", false),
                      _FilterChip("Baru", false),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // =========================
                // 🔹 SECTION LABEL
                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Request Aktif",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      "4 tersedia",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // =========================
                // 🔹 FEED LIST (UNCHANGED CONTENT)
                // =========================
                Column(
                  children: const [
                    RequestCard(
                      name: "Ibu Lina",
                      title: "Butuh bantuan angkat lemari besar",
                      description: "Butuh 2 orang bantu angkat ke lantai 2.",
                      distance: "50m",
                      time: "Baru saja",
                      urgent: true,
                      tags: ["Berat", "2 Orang"],
                    ),
                    RequestCard(
                      name: "Andi",
                      title: "Pasang TV di dinding",
                      description: "Sudah ada bracket.",
                      distance: "120m",
                      time: "5 menit lalu",
                      tags: ["Peralatan"],
                    ),
                    RequestCard(
                      name: "Siti",
                      title: "Pinjam tangga",
                      description: "30 menit saja.",
                      distance: "300m",
                      time: "10 menit lalu",
                      tags: ["Pinjam"],
                    ),
                    RequestCard(
                      name: "Rudi",
                      title: "Bersihin halaman rumah",
                      description: "Banyak daun kering, butuh bantuan cepat.",
                      distance: "500m",
                      time: "25 menit lalu",
                      tags: ["Ringan"],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// 🔹 FILTER CHIP WIDGET
// =========================
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip(this.label, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.primary : const Color(0xFFE5E7EB),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
