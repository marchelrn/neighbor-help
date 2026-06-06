import 'package:flutter/material.dart';
import 'admin_colors.dart';
import 'admin_sidebar.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/admin_users_page.dart';
import 'pages/admin_requests_page.dart';
import 'pages/admin_moderation_page.dart';
import 'pages/admin_monitoring_page.dart';
import 'pages/admin_reports_page.dart';
import 'pages/admin_settings_page.dart';
import '../../screens/login_page.dart';
import '../../utils/storage.dart';

class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  String activeMenu = 'Dashboard';

  // ─────────────────────────────────────────────
  // PAGE ROUTER
  // ─────────────────────────────────────────────
  Widget _buildContent() {
    switch (activeMenu) {
      case 'Dashboard':
        return const AdminDashboardPage();
      case 'Pengguna':
        return const AdminUsersPage();
      case 'Permintaan':
        return const AdminRequestsPage();
      case 'Moderasi':
        return const AdminModerationPage();
      case 'Monitoring':
        return const AdminMonitoringPage();
      case 'Laporan':
        return const AdminReportsPage();
      case 'Pengaturan':
        return const AdminSettingsPage();
      default:
        return const AdminDashboardPage();
    }
  }

  // ─────────────────────────────────────────────
  // TOPBAR TITLE
  // ─────────────────────────────────────────────
  String get _pageTitle {
    switch (activeMenu) {
      case 'Dashboard':
        return 'Dashboard';
      case 'Pengguna':
        return 'Kelola Pengguna';
      case 'Permintaan':
        return 'Kelola Permintaan Bantuan';
      case 'Moderasi':
        return 'Moderasi Konten';
      case 'Monitoring':
        return 'Monitoring Sistem';
      case 'Laporan':
        return 'Laporan & Statistik';
      case 'Pengaturan':
        return 'Pengaturan Aplikasi';
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

          // Notifications
          _topbarIcon(Icons.notifications_none_rounded, badge: 3),
          const SizedBox(width: 8),
          _topbarIcon(Icons.help_outline_rounded),
          const SizedBox(width: 12),

          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AdminColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topbarIcon(IconData icon, {int? badge}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AdminColors.surfaceAlt,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AdminColors.border),
          ),
          child: Icon(icon, size: 17, color: AdminColors.textSecondary),
        ),
        if (badge != null)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AdminColors.error,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
