import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../utils/storage.dart';

import 'sidebar.dart';
import 'request_list_page.dart';
import 'chat_page.dart';
import 'beranda_page.dart';
import 'profile_page.dart';
import 'help_feed_page.dart';
import 'peta_area_page.dart';
import 'notification_page.dart';
import 'login_page.dart';
import 'admin/pages/admin_dashboard_page.dart';
import 'admin/admin_main_layout.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String selectedChat = "Budi Santoso";

  String activeMenu = "Beranda";

  Map<String, dynamic>? currentUser;

  bool isLoadingUser = true;

  // =====================================
  // INIT
  // =====================================

  @override
  void initState() {
    super.initState();

    loadCurrentUser();
  }

  // =====================================
  // LOAD USER
  // =====================================

  Future<void> loadCurrentUser() async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return;
      }

      final response = await http.get(
        Uri.parse("http://localhost:8080/api/user/me"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("MAIN LAYOUT USER:");
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final role = data["role"];

        if (role == "admin") {
          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminMainLayout()),
          );

          return;
        }
        setState(() {
          currentUser = data;
          isLoadingUser = false;
        });
      } else {
        setState(() {
          isLoadingUser = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoadingUser = false;
      });
    }
  }

  // =====================================
  // PAGE SWITCHER
  // =====================================

  Widget _buildContent() {
    switch (activeMenu) {
      case "Beranda":
        return const BerandaPage();

      case "Request Saya":
        return Row(
          children: [
            const Expanded(flex: 2, child: RequestListPage()),
            Expanded(flex: 3, child: ChatPage(receiverName: selectedChat)),
          ],
        );

      case "Peta Area":
        return const PetaAreaPage();

      case "Help Feed":
        return const HelpFeedPage();

      case "Notifikasi":
        return const NotificationPage();

      case "Profil":
        return const ProfilePage();

      default:
        return const BerandaPage();
    }
  }

  // =====================================
  // LOGOUT
  // =====================================

  Future<void> _handleLogout() async {
    await StorageService.deleteToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // =====================================
  // INITIALS
  // =====================================

  String getInitials() {
    if (currentUser == null) {
      return "?";
    }

    final fullName = currentUser?["full_name"] ?? "User";

    final parts = fullName.split(" ");

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return "${parts[0][0]}${parts[1][0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // =====================================
          // SIDEBAR
          // =====================================
          Sidebar(
            activeMenu: activeMenu,
            onMenuSelected: (menu) {
              setState(() {
                activeMenu = menu;
              });
            },
            onLogout: _handleLogout,
          ),

          // =====================================
          // MAIN CONTENT
          // =====================================
          Expanded(
            child: Column(
              children: [
                // =====================================
                // TOPBAR
                // =====================================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                        color: Colors.black.withOpacity(0.03),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // =====================================
                      // STATUS
                      // =====================================
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Online • Lokasi aktif",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // =====================================
                      // ADDRESS
                      // =====================================
                      Expanded(
                        child: Text(
                          currentUser?["address"] ?? "Memuat lokasi...",
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // =====================================
                      // ACTIVE USERS BADGE
                      // =====================================
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Tetangga aktif sekitar",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =====================================
                // CONTENT
                // =====================================
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
