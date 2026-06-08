import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/request_card.dart';
import '../utils/storage.dart';
import '../screens/chat_page.dart';

const String baseUrl = AuthService.baseUrl;

class HelpFeedPage extends StatefulWidget {
  const HelpFeedPage({super.key});

  @override
  State<HelpFeedPage> createState() => _HelpFeedPageState();
}

class _HelpFeedPageState extends State<HelpFeedPage> {
  List<dynamic> helpRequestsList = [];
  bool isLoading = true;
  String selectedFilter = "Semua";

  @override
  void initState() {
    super.initState();
    loadHelpRequests();
  }

  Future<void> loadHelpRequests() async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      final helpRes = await http.get(
        Uri.parse("$baseUrl/help/nearby"),
        headers: {"Authorization": "Bearer $token"},
      );

      List<dynamic> fetchedHelpRequests = [];
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

        final currentUser = await AuthService.getCurrentUser(token);
        final currentUsername = currentUser["username"];
        fetchedHelpRequests = fetchedHelpRequests.where((req) {
          return req["username"] != currentUsername;
        }).toList();
      }

      if (!mounted) return;

      setState(() {
        helpRequestsList = fetchedHelpRequests;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengambil data: $e")));

      setState(() {
        isLoading = false;
      });
    }
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
    List<dynamic> filteredRequests = helpRequestsList;
    if (selectedFilter == "Aktif") {
      filteredRequests = filteredRequests.where((req) => req["status"] == "pending").toList();
    } else if (selectedFilter == "Selesai") {
      filteredRequests = filteredRequests.where((req) => req["status"] == "solved").toList();
    } else if (selectedFilter == "Urgent") {
      filteredRequests = filteredRequests.where((req) => req["category"] == "urgent").toList();
    }

    return SafeArea(
      child: Container(
        color: const Color(0xFFF3F4F6),
        child: RefreshIndicator(
          onRefresh: loadHelpRequests,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      children: [
                        _FilterChip("Semua", selectedFilter == "Semua", onTap: () => setState(() => selectedFilter = "Semua")),
                        _FilterChip("Aktif", selectedFilter == "Aktif", onTap: () => setState(() => selectedFilter = "Aktif")),
                        _FilterChip("Selesai", selectedFilter == "Selesai", onTap: () => setState(() => selectedFilter = "Selesai")),
                        _FilterChip("Urgent", selectedFilter == "Urgent", onTap: () => setState(() => selectedFilter = "Urgent")),
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
                        "${helpRequestsList.length} tersedia",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // =========================
                  // 🔹 FEED LIST
                  // =========================
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (filteredRequests.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Tidak ada request bantuan yang sesuai.",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else ...[
                    // 🔹 ACTIVE REQUESTS
                    if (filteredRequests.where((req) => req["status"] == "pending").isNotEmpty) ...[
                      Column(
                        children: filteredRequests
                            .where((req) => req["status"] == "pending")
                            .map((req) {
                              return RequestCard(
                                name: req["username"] ?? "Unknown",
                                title: req["title"] ?? "Tanpa Judul",
                                description:
                                    req["description"] ??
                                    "Tidak ada deskripsi.",
                                urgent: req["category"] == "urgent",
                                time: getTimeAgo(req["created_at"]),
                                tags: [req["category"] ?? "umum"],
                                isActive: true,
                                onChat: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Scaffold(
                                        appBar: AppBar(
                                          title: Text(
                                            "Chat dengan ${req["username"] ?? 'Pembuat Request'}",
                                          ),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          elevation: 1,
                                        ),
                                        body: ChatPage(
                                          receiverName:
                                              req["title"] ?? "Group Chat",
                                          isActive: true,
                                          requestId: req["id"],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            })
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // 🔹 COMPLETED REQUESTS
                    if (filteredRequests.where((req) => req["status"] == "solved").isNotEmpty) ...[
                      const Row(
                        children: [
                          Text(
                            "Request Selesai",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: filteredRequests
                            .where((req) => req["status"] == "solved")
                            .map((req) {
                              return RequestCard(
                                name: req["username"] ?? "Unknown",
                                title: req["title"] ?? "Tanpa Judul",
                                description:
                                    req["description"] ??
                                    "Tidak ada deskripsi.",
                                urgent: req["category"] == "urgent",
                                time: getTimeAgo(req["created_at"]),
                                tags: [req["category"] ?? "umum"],
                                isActive: false,
                                onChat: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Scaffold(
                                        appBar: AppBar(
                                          title: Text(
                                            "Chat dengan ${req["username"] ?? 'Pembuat Request'}",
                                          ),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          elevation: 1,
                                        ),
                                        body: ChatPage(
                                          receiverName:
                                              req["title"] ?? "Group Chat",
                                          isActive: false,
                                          requestId: req["id"],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            })
                            .toList(),
                      ),
                    ],
                  ],

                  const SizedBox(height: 20),
                ],
              ),
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
  final VoidCallback onTap;

  const _FilterChip(this.label, this.selected, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
    ),
    );
  }
}
