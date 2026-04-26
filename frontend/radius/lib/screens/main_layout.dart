import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'request_list_page.dart';
import 'chat_page.dart';
import 'beranda_page.dart';
import 'profile_page.dart';
import 'help_feed_page.dart';
import 'peta_area_page.dart';
import 'notification_page.dart';
import '../theme/app_colors.dart';

// 🔥 TEMP LOGIN PAGE (replace later)
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Login Page")));
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String selectedChat = "Budi Santoso";
  String activeMenu = "Beranda";

  // =========================
  // 🔥 PAGE SWITCHER
  // =========================
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

  // =========================
  // 🔥 LOGOUT HANDLER
  // =========================
  void _handleLogout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          Sidebar(
            activeMenu: activeMenu,
            onMenuSelected: (menu) {
              setState(() {
                activeMenu = menu;
              });
            },
            onLogout: _handleLogout, // 🔥 NEW
          ),

          Expanded(
            child: Column(
              children: [
                // 🔹 TOP BAR
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Online • Lokasi aktif",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          "- Tanjung Batu, Manado",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "23 tetangga aktif dalam 500m",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 CONTENT
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
