import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/app_colors.dart';
import 'request_detail_page.dart';
import '../utils/storage.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Map<String, dynamic>? user;

  // nearby users
  List<dynamic> requests = [];

  bool isLoading = true;

  int activeRequests = 0;
  int completedHelp = 0;
  double rating = 4.8;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //
  // =====================================
  // REPLACE loadData() WITH THIS
  // =====================================
  //

  Future<void> loadData() async {
    try {
      // =====================================
      // TOKEN
      // =====================================

      final token = await StorageService.getToken();

      if (token == null) {
        throw Exception("Token not found");
      }
      // =====================================
      // CURRENT USER
      // =====================================

      final userRes = await http.get(
        Uri.parse("http://localhost:8080/api/user/me"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("USER STATUS: ${userRes.statusCode}");
      debugPrint("USER BODY: ${userRes.body}");

      if (userRes.statusCode != 200) {
        throw Exception("Failed to load current user");
      }

      final decodedUser = jsonDecode(userRes.body);

      final userData = decodedUser["data"] ?? decodedUser;

      // =====================================
      // NEARBY USERS
      // =====================================

      List<dynamic> nearbyData = [];

      final nearbyRes = await http.get(
        Uri.parse("http://localhost:8080/api/user/nearby"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("NEARBY STATUS: ${nearbyRes.statusCode}");
      debugPrint("NEARBY BODY: ${nearbyRes.body}");

      if (nearbyRes.statusCode == 200) {
        final decodedNearby = jsonDecode(nearbyRes.body);

        nearbyData = decodedNearby["data"] ?? decodedNearby;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mengambil data tetangga")),
          );
        }
      }

      setState(() {
        user = userData;

        requests = nearbyData;

        activeRequests = nearbyData.length;

        // temporary stats
        completedHelp = nearbyData.length * 2;

        rating = 4.8;

        isLoading = false;
      });
    } catch (e) {
      debugPrint("LOAD DATA ERROR:");
      debugPrint(e.toString());

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Selamat pagi";
    }

    if (hour < 17) {
      return "Selamat siang";
    }

    return "Selamat malam";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: AppColors.background,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7F9F8), Color(0xFFEAF4EE)],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================
              // HEADER
              // =====================================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.75),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      color: AppColors.primary.withOpacity(0.25),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${getGreeting()}, ${user?["full_name"] ?? "User"} 👋",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            user?["address"] ?? "Siap bantu tetangga hari ini?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =====================================
              // STATS
              // =====================================
              Row(
                children: [
                  Expanded(
                    child: AnimatedStatCard(
                      title: "Tetangga",
                      value: activeRequests.toDouble(),
                      icon: Icons.people_alt_rounded,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: AnimatedStatCard(
                      title: "Interaksi",
                      value: completedHelp.toDouble(),
                      icon: Icons.handshake_rounded,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: AnimatedStatCard(
                      title: "Rating",
                      value: rating,
                      icon: Icons.star_rounded,
                      isDecimal: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // =====================================
              // INSIGHT
              // =====================================
              const _InsightSection(),

              const SizedBox(height: 28),

              // =====================================
              // URGENT
              // =====================================
              const Text(
                "Tetangga Terdekat 🔥",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 14),

              if (requests.isNotEmpty) _UrgentCard(request: requests.first),

              const SizedBox(height: 28),

              // =====================================
              // REQUEST LIST
              // =====================================
              const Text(
                "Tetangga Sekitar",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 14),

              if (requests.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                        color: Colors.black.withOpacity(0.03),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_off_rounded,
                        size: 65,
                        color: Colors.grey.shade400,
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "Belum ada tetangga terdekat ditemukan",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

              Column(
                children: requests.map((req) {
                  return RequestCard(
                    name: req["full_name"] ?? "Unknown",
                    title: req["address"] ?? "Tidak ada alamat",
                    distance: "${(req["distance"] ?? 0).toStringAsFixed(1)} km",
                    urgent: (req["distance"] ?? 0) < 0.2,
                    time: "Tetangga sekitar",
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// =====================================
// ANIMATED STAT CARD
// =====================================
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
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white.withOpacity(0.8),
              border: Border.all(color: AppColors.primary.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                  color: Colors.black.withOpacity(0.04),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: AppColors.primary),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayValue,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
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
// =====================================
// INSIGHT SECTION
// =====================================
//

class _InsightSection extends StatelessWidget {
  const _InsightSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _InlineInsight("Aktif", "Komunitas"),
          _InlineInsight("+80%", "Respons"),
          _InlineInsight("Top Area", "Lingkungan"),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),

        const SizedBox(height: 5),

        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

//
// =====================================
// URGENT CARD
// =====================================
//

class _UrgentCard extends StatelessWidget {
  final dynamic request;

  const _UrgentCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade300],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.red.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 32),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request["full_name"] ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  request["address"] ?? "-",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.92)),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Text(
            "${(request["distance"] ?? 0).toStringAsFixed(1)} km",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
//
// =====================================
// REQUEST CARD
// =====================================
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

  @override
  Widget build(BuildContext context) {
    final Color accent = urgent ? Colors.red : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.8),
        border: Border.all(color: accent.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: accent.withOpacity(0.1),
            child: Icon(Icons.person, color: accent),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),

                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),

                const SizedBox(height: 6),

                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            children: [
              Text(
                distance,
                style: TextStyle(color: accent, fontWeight: FontWeight.bold),
              ),

              if (urgent)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "DEKAT",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
