import 'package:flutter/material.dart';
import 'admin_colors.dart';
import 'admin_sidebar.dart';
import 'pages/admin_users_page.dart';
import 'pages/admin_requests_page.dart';
import '../../screens/login_page.dart';
import '../../utils/storage.dart';

class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  String activeMenu = 'Pengguna';

  // ─────────────────────────────────────────────
  // PAGE ROUTER
  // ─────────────────────────────────────────────
  Widget _buildContent() {
    switch (activeMenu) {
      case 'Pengguna':
        return const AdminUsersPage();
      case 'Permintaan':
        return const AdminRequestsPage();
      default:
        return const AdminUsersPage();
    }
  }

  // ─────────────────────────────────────────────
  // TOPBAR TITLE
  // ─────────────────────────────────────────────
  String get _pageTitle {
    switch (activeMenu) {
      case 'Pengguna':
        return 'Kelola Pengguna';
      case 'Permintaan':
        return 'Kelola Permintaan Bantuan';
      default:
        return activeMenu;
    }
  }

  Future<void> _handleLogout() async {
    await StorageService.deleteToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: Row(
        children: [
          // ── Sidebar ──
          AdminSidebar(
            activeMenu: activeMenu,
            onMenuSelected: (menu) => setState(() => activeMenu = menu),
            onLogout: _handleLogout,
          ),

          // ── Main Area ──
          Expanded(
            child: Column(
              children: [
                // ── Topbar ──
                _buildTopbar(),

                // ── Content ──
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
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

  Widget _buildTopbar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          // Breadcrumb
          Text(
            'Admin',
            style: TextStyle(fontSize: 13, color: AdminColors.textLight),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AdminColors.textMuted,
            ),
          ),
          Text(
            _pageTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AdminColors.textPrimary,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
