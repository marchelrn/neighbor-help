import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../utils/storage.dart';

const String baseUrl = AuthService.baseUrl;

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  List<dynamic> helpRequestsList = [];
  Map<String, dynamic>? user;
  List<dynamic> nearbyUsers = [];

  bool isLoading = true;
  int activeRequests = 0;
  int completedHelp = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      final userRes = await http.get(
        Uri.parse("$baseUrl/user/me"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (userRes.statusCode != 200) {
        throw Exception("Failed to load current user");
      }

      final decodedUser = jsonDecode(userRes.body);
      final currentUser = decodedUser is Map && decodedUser["data"] is Map
          ? Map<String, dynamic>.from(decodedUser["data"])
          : Map<String, dynamic>.from(decodedUser);

      List<dynamic> nearbyData = [];

      final nearbyRes = await http.get(
        Uri.parse("$baseUrl/nearby"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (nearbyRes.statusCode == 200) {
        final decodedNearby = jsonDecode(nearbyRes.body);

        if (decodedNearby is List) {
          nearbyData = decodedNearby;
        } else if (decodedNearby is Map) {
          if (decodedNearby.containsKey("data") &&
              decodedNearby["data"] is List) {
            nearbyData = decodedNearby["data"];
          } else if (decodedNearby.containsKey("users") &&
              decodedNearby["users"] is List) {
            nearbyData = decodedNearby["users"];
          } else if (decodedNearby.containsKey("user") &&
              decodedNearby["user"] is List) {
            nearbyData = decodedNearby["user"];
          } else if (decodedNearby.containsKey("users") &&
              decodedNearby["users"] is Map &&
              decodedNearby["users"]["data"] is List) {
            nearbyData = decodedNearby["users"]["data"];
          } else {
            nearbyData = [];
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mengambil data tetangga")),
          );
        }
      }

      List<dynamic> fetchedHelpRequests = [];

      final helpRes = await http.get(
        Uri.parse("$baseUrl/help/nearby"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (helpRes.statusCode >= 200 && helpRes.statusCode < 300) {
        final decodedHelp = jsonDecode(helpRes.body);

        if (decodedHelp is List) {
          fetchedHelpRequests = decodedHelp;
        } else if (decodedHelp is Map &&
            decodedHelp.containsKey("help_requests")) {
          fetchedHelpRequests = decodedHelp["help_requests"] is List
              ? decodedHelp["help_requests"]
              : [];
        }

        final currentUsername = currentUser["username"];
        fetchedHelpRequests = fetchedHelpRequests.where((req) {
          return req["username"] != currentUsername;
        }).toList();
      }

      if (!mounted) return;

      setState(() {
        helpRequestsList = fetchedHelpRequests;
        user = currentUser;
        nearbyUsers = nearbyData;
        activeRequests = fetchedHelpRequests.length;
        completedHelp = nearbyData.length * 2;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));

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

  String getTimeAgo(String? isoString) {
    if (isoString == null) return "Baru saja";
    try {
      final dateTime = DateTime.parse(isoString);
      final diff = DateTime.now().difference(dateTime);
      if (diff.inDays > 0) return "${diff.inDays} hari lalu";
      if (diff.inHours > 0) return "${diff.inHours} jam lalu";
      if (diff.inMinutes > 0) return "${diff.inMinutes} menit lalu";
      return "Baru saja";
    } catch (e) {
      return "Baru saja";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: AppColors.background,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final urgentRequests = helpRequestsList
        .where((r) => r["category"] == "urgent")
        .toList();
    final bool hasUrgent = urgentRequests.isNotEmpty;

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
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.75),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      color: AppColors.primary.withValues(alpha: 0.25),
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
                          color: Colors.white.withValues(alpha: 0.5),
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
                            "${getGreeting()}, ${user?["full_name"] ?? user?["username"] ?? "User"} 👋",
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
                              color: Colors.white.withValues(alpha: 0.92),
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

              Row(
                children: [
                  Expanded(
                    child: AnimatedStatCard(
                      title: "Request",
                      value: activeRequests.toDouble(),
                      icon: Icons.assignment_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedStatCard(
                      title: "Tetangga",
                      value: nearbyUsers.length.toDouble(),
                      icon: Icons.people_alt_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              const SizedBox(height: 28),

              if (hasUrgent) ...[
                const Text(
                  "Bantuan Mendesak",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                ...urgentRequests.map(
                  (req) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _UrgentCard(request: req),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              const Text(
                "Request Terbaru",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 14),

              if (helpRequestsList.isEmpty ||
                  helpRequestsList.length == urgentRequests.length)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                        color: Colors.black.withValues(alpha: 0.03),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 65,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Belum ada request bantuan",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

              Column(
                children: helpRequestsList
                    .where((req) => req["category"] != "urgent")
                    .map((req) {
                      return RequestCard(
                        name: req["username"] ?? "Unknown",
                        title: req["title"] ?? "Tanpa Judul",
                        distance: "-",
                        urgent: false,
                        time: getTimeAgo(req["created_at"]),
                      );
                    })
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
              color: Colors.white.withValues(alpha: 0.8),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: 0.04),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
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

class _UrgentCard extends StatelessWidget {
  final dynamic request;

  const _UrgentCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request["username"] ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request["title"] ?? "-",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.92)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Urgent",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = urgent ? AppColors.primarySoft : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.8),
        border: Border.all(color: accent.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: accent.withValues(alpha: 0.1),
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
              if (distance != "-")
                Text(
                  distance,
                  style: TextStyle(color: accent, fontWeight: FontWeight.bold),
                ),
              if (urgent)
                Container(
                  margin: EdgeInsets.only(top: distance != "-" ? 6 : 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "URGENT",
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
