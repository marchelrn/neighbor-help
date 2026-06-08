import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_colors.dart';
import '../utils/storage.dart';
import '../widgets/request_card.dart';
import '../widgets/create_request_dialog.dart';
import '../services/auth_service.dart';

class RequestListPage extends StatefulWidget {
  final Function(String, bool, int)? onChatSelected;

  const RequestListPage({super.key, this.onChatSelected});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _activeRequests = [];
  List<dynamic> _completedRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchMyRequests();
  }

  Future<void> _fetchMyRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        setState(() {
          _errorMessage = "Harap login terlebih dahulu.";
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("http://127.0.0.1:3000/my-help"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        final data = jsonDecode(response.body);
        final List<dynamic> requests = data["help_requests"] ?? [];

        setState(() {
          _activeRequests = requests
              .where((req) => req["status"] != "completed")
              .toList();
          _completedRequests = requests
              .where((req) => req["status"] == "completed")
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Gagal mengambil data: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Terjadi kesalahan koneksi.";
        _isLoading = false;
      });
    }
  }

  String getTimeAgo(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "Beberapa saat lalu";
    try {
      final date = DateTime.parse(isoString);
      final diff = DateTime.now().difference(date);

      if (diff.inDays > 0) {
        return "${diff.inDays} hari lalu";
      } else if (diff.inHours > 0) {
        return "${diff.inHours} jam lalu";
      } else if (diff.inMinutes > 0) {
        return "${diff.inMinutes} menit lalu";
      } else {
        return "Baru saja";
      }
    } catch (e) {
      return "Waktu tidak diketahui";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Request Saya",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_activeRequests.length} request aktif • ${_completedRequests.length} selesai",
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              // BUTTON
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => CreateRequestDialog(
                      onSuccess: () {
                        _fetchMyRequests();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySoft,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "+ Buat Baru",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔹 CONTENT
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryDark,
                    ),
                  )
                : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchMyRequests,
                    color: const Color(0xFF16A34A),
                    child: ListView(
                      children: [
                        if (_activeRequests.isEmpty &&
                            _completedRequests.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                "Belum ada request yang dibuat.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),

                        ..._activeRequests.map(
                          (req) => RequestCard(
                            isActive: true,
                            isMyRequest: true,
                            name: req["username"] ?? "User",
                            title: req["title"] ?? "Tanpa Judul",
                            description:
                                req["description"] ?? "Tidak ada deskripsi",
                            time: getTimeAgo(req["created_at"]),
                            urgent: req["category"] == "urgent",
                            onStatusToggle: () async {
                              try {
                                final token = await StorageService.getToken();
                                if (token != null) {
                                  await AuthService.updateHelpRequestStatus(
                                    token,
                                    req["id"],
                                    "completed",
                                  );
                                  _fetchMyRequests(); // Refresh
                                }
                              } catch (e) {
                                debugPrint("Failed to update status: $e");
                              }
                            },
                            onChat: () {
                              if (widget.onChatSelected != null) {
                                widget.onChatSelected!(req["username"] ?? "Sistem", true, req["id"]);
                              }
                            },
                          ),
                        ),

                        if (_activeRequests.isNotEmpty &&
                            _completedRequests.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),

                        ..._completedRequests.map(
                          (req) => RequestCard(
                            isActive: false,
                            isMyRequest: true,
                            name: req["username"] ?? "User",
                            title: req["title"] ?? "Tanpa Judul",
                            description:
                                req["description"] ?? "Tidak ada deskripsi",
                            time: getTimeAgo(req["created_at"]),
                            urgent: req["category"] == "urgent",
                            onStatusToggle: () async {
                              try {
                                final token = await StorageService.getToken();
                                if (token != null) {
                                  await AuthService.updateHelpRequestStatus(
                                    token,
                                    req["id"],
                                    "pending", // Change back to active
                                  );
                                  _fetchMyRequests(); // Refresh
                                }
                              } catch (e) {
                                debugPrint("Failed to update status: $e");
                              }
                            },
                            onChat: () {
                              if (widget.onChatSelected != null) {
                                widget.onChatSelected!(req["username"] ?? "Sistem", false, req["id"]);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
