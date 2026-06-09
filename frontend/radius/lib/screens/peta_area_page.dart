import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import '../utils/storage.dart';
import '../screens/chat_page.dart';
import '../screens/request_detail_page.dart';

const String baseUrl = AuthService.baseUrl;

class PetaAreaPage extends StatefulWidget {
  const PetaAreaPage({super.key});

  @override
  State<PetaAreaPage> createState() => _PetaAreaPageState();
}

class _PetaAreaPageState extends State<PetaAreaPage> {
  String selectedFilter = "Semua";

  LatLng center = const LatLng(1.4748, 124.8421); // Default Manado
  final MapController _mapController = MapController();

  List<dynamic> helpRequestsList = [];
  bool isLoading = true;
  Map<String, dynamic>? selectedRequest;

  @override
  void initState() {
    super.initState();
    loadMapData();
  }

  Future<void> loadMapData() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception("Token not found");
      }

      // Fetch user data to center map
      try {
        final currentUser = await AuthService.getCurrentUser(token);
        if (currentUser["coordinate_lat"] != null &&
            currentUser["coordinate_long"] != null) {
          center = LatLng(
            (currentUser["coordinate_lat"] as num).toDouble(),
            (currentUser["coordinate_long"] as num).toDouble(),
          );
          _mapController.move(center, 15);
        }
      } catch (e) {
        debugPrint("Could not fetch user location: $e");
      }

      // Fetch nearby requests
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

        // As per the plan, filter out requests by the current user
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

  void _onChat(Map<String, dynamic> req) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text("Chat dengan ${req["username"] ?? 'Pembuat Request'}"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: ChatPage(
            receiverName: req["title"] ?? "Group Chat",
            isActive: req["status"] != "solved",
            requestId: req["id"],
          ),
        ),
      ),
    );
  }

  void _openDetail(Map<String, dynamic> req) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RequestDetailPage(
          name: req["username"] ?? "User",
          title: req["title"] ?? "Tanpa Judul",
          distance: req["distance_m"] != null
              ? "${req["distance_m"].toStringAsFixed(0)}m"
              : "-",
          description: req["description"] ?? "-",
          urgent: req["category"] == "urgent",
          time: getTimeAgo(req["created_at"]),
          onChat: () => _onChat(req),
          onAmbil: () => _onChat(req),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic
    List<dynamic> filteredRequests = helpRequestsList;
    if (selectedFilter == "Aktif") {
      filteredRequests = filteredRequests
          .where((r) => r["status"] == "pending")
          .toList();
    } else if (selectedFilter == "Selesai") {
      filteredRequests = filteredRequests
          .where((r) => r["status"] == "solved")
          .toList();
    } else if (selectedFilter == "Urgent") {
      filteredRequests = filteredRequests
          .where((r) => r["category"] == "urgent")
          .toList();
    }

    return Scaffold(
      body: Stack(
        children: [
          // =========================
          // 🔥 REAL MAP (FIXED)
          // =========================
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: center, initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.neighborhelp.app',
                maxZoom: 19,
              ),

              MarkerLayer(
                markers: [
                  // Draw User's center marker
                  Marker(
                    point: center,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  // Draw Request markers
                  ...filteredRequests
                      .where(
                        (req) =>
                            req["latitude"] != null && req["longitude"] != null,
                      )
                      .map((req) {
                        final lat = (req["latitude"] as num).toDouble();
                        final lng = (req["longitude"] as num).toDouble();
                        final isUrgent = req["category"] == "urgent";
                        final isSolved = req["status"] == "solved";
                        final isSelected =
                            selectedRequest != null &&
                            selectedRequest!["id"] == req["id"];

                        return Marker(
                          point: LatLng(lat, lng),
                          width: 140,
                          height: 80,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRequest = req;
                              });
                            },
                            child: _markerWidget(
                              req["title"] ?? "Butuh Bantuan",
                              isUrgent,
                              isSelected,
                              isSolved,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),

          // =========================
          // 🔹 HEADER
          // =========================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // 🔹 FILTER CHIPS
          // =========================
          Positioned(
            top: 90,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _filterChip("Semua"),
                  _filterChip("Aktif"),
                  _filterChip("Selesai"),
                  _filterChip("Urgent"),
                ],
              ),
            ),
          ),

          // =========================
          // 🔹 LOADING INDICATOR
          // =========================
          if (isLoading)
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // =========================
          // 🔹 FLOAT BUTTON
          // =========================
          Positioned(
            right: 16,
            bottom: selectedRequest != null
                ? 140
                : 100, // Adjust based on card presence
            child: FloatingActionButton(
              onPressed: () {
                _mapController.move(center, 15);
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // =========================
          // 🔹 BOTTOM CARD
          // =========================
          if (selectedRequest != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selectedRequest!["category"] == "urgent"
                        ? Colors.red.shade200
                        : AppColors.primarySoft,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person, size: 20),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRequest!["title"] ?? "Tanpa Judul",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${selectedRequest!["distance_m"] != null ? selectedRequest!["distance_m"].toStringAsFixed(0) : '-'}m • ${selectedRequest!["username"] ?? 'Unknown'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        _openDetail(selectedRequest!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedRequest!["category"] == "urgent"
                            ? Colors.red
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Lihat"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // =========================
  // 🔹 FILTER CHIP
  // =========================
  Widget _filterChip(String label) {
    final bool selected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = label);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // =========================
  // 🔥 MARKER UI
  // =========================
  Widget _markerWidget(
    String text,
    bool urgent,
    bool isSelected,
    bool isSolved,
  ) {
    Color markerColor = isSolved
        ? Colors.grey.shade600
        : (urgent ? Colors.red : AppColors.primary);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          constraints: const BoxConstraints(maxWidth: 120),
          decoration: BoxDecoration(
            color: markerColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        Icon(Icons.arrow_drop_down, color: markerColor, size: 32),
      ],
    );
  }
}
