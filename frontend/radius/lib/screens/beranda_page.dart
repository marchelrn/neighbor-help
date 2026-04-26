import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'request_detail_page.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Selamat pagi";
    if (hour < 17) return "Selamat siang";
    return "Selamat malam";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 HEADER
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getGreeting()}, Budi 👋",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Siap bantu tetangga hari ini?",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔥 STATS
            Row(
              children: const [
                Expanded(
                  child: AnimatedStatCard(
                    title: "Request Aktif",
                    value: 5,
                    icon: Icons.assignment,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: AnimatedStatCard(
                    title: "Bantuan Selesai",
                    value: 23,
                    icon: Icons.check,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: AnimatedStatCard(
                    title: "Rating",
                    value: 4.8,
                    icon: Icons.star,
                    isDecimal: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const _InsightSection(),

            const SizedBox(height: 24),

            // 🔥 URGENT
            const Text(
              "Butuh Bantuan Mendesak 🔥",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _UrgentCard(),

            const SizedBox(height: 24),

            // 🔥 REQUEST LIST
            const Text(
              "Request Terdekat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Column(
              children: const [
                RequestCard(
                  name: "Andi",
                  title: "Butuh bantuan angkat galon ke lantai 2",
                  distance: "120m",
                  urgent: true,
                  time: "2 menit lalu",
                ),
                RequestCard(
                  name: "Siti",
                  title: "Pinjam tangga sebentar untuk betulin atap",
                  distance: "300m",
                  time: "10 menit lalu",
                ),
                RequestCard(
                  name: "Rudi",
                  title: "Butuh orang bantu pasang lampu ruang tamu",
                  distance: "500m",
                  time: "25 menit lalu",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//
// 🔥 ANIMATED STAT CARD
//
class AnimatedStatCard extends StatefulWidget {
  final String title;
  final double value;
  final IconData icon;
  final bool isDecimal;

  const AnimatedStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isDecimal = false,
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final displayValue = widget.isDecimal
              ? _animation.value.toStringAsFixed(1)
              : _animation.value.toInt().toString();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.12),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  color: AppColors.primary.withOpacity(0.15),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: AppColors.primary),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayValue,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

//
// 🔥 INSIGHT
//
class _InsightSection extends StatelessWidget {
  const _InsightSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _InlineInsight("1", "Minggu ini"),
          _InlineInsight("+80%", "Performa"),
          _InlineInsight("Top 20%", "Ranking"),
        ],
      ),
    );
  }
}

class _InlineInsight extends StatelessWidget {
  final String value;
  final String label;

  const _InlineInsight(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

//
// 🔥 URGENT CARD (INTERACTIVE)
//
class _UrgentCard extends StatelessWidget {
  const _UrgentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Ibu Lina butuh bantuan sekarang (50m)",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RequestDetailPage(
                    name: "Ibu Lina",
                    title: "Butuh bantuan sekarang",
                    distance: "50m",
                    urgent: true,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Bantu"),
          ),
        ],
      ),
    );
  }
}

//
// 🔥 REQUEST CARD (FULLY INTERACTIVE)
//
class RequestCard extends StatelessWidget {
  final String name;
  final String title;
  final String distance;
  final bool urgent;
  final String time;

  const RequestCard({
    super.key,
    required this.name,
    required this.title,
    required this.distance,
    this.urgent = false,
    this.time = "Baru saja",
  });

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RequestDetailPage(
          name: name,
          title: title,
          distance: distance,
          urgent: urgent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = urgent ? Colors.red : AppColors.primary;

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, accent.withOpacity(0.05)],
          ),
          border: Border.all(color: accent.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.04),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  distance,
                  style: TextStyle(color: accent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (urgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "URGENT",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _openDetail(context),
                  child: Text(
                    "Lihat Detail →",
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
