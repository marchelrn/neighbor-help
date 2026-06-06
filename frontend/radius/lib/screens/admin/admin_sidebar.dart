import 'package:flutter/material.dart';
import 'admin_colors.dart';

class AdminSidebar extends StatelessWidget {
  final String activeMenu;
  final ValueChanged<String> onMenuSelected;
  final VoidCallback onLogout;

  const AdminSidebar({
    super.key,
    required this.activeMenu,
    required this.onMenuSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: AdminColors.sidebarBg,
      child: Column(
        children: [
          // ── Logo ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AdminColors.primary,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NeighborHelp',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AdminColors.sidebarText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Divider ──
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.06),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const SizedBox(height: 10),

          // ── Menu ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _sectionLabel('MAIN'),
                _menuItem(Icons.dashboard_rounded, 'Dashboard', 'Dashboard'),
                _menuItem(Icons.bar_chart_rounded, 'Monitoring', 'Monitoring'),
                _menuItem(Icons.assessment_rounded, 'Laporan', 'Laporan'),

                const SizedBox(height: 10),
                _sectionLabel('KELOLA'),
                _menuItem(Icons.people_alt_rounded, 'Pengguna', 'Pengguna'),
                _menuItem(
                  Icons.handshake_rounded,
                  'Permintaan Bantuan',
                  'Permintaan',
                ),
                _menuItem(Icons.flag_rounded, 'Moderasi', 'Moderasi'),

                const SizedBox(height: 10),
                _sectionLabel('SISTEM'),
                _menuItem(Icons.settings_rounded, 'Pengaturan', 'Pengaturan'),
              ],
            ),
          ),

          // ── Admin User ──
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
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
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'admin@radius.id',
                        style: TextStyle(
                          color: AdminColors.sidebarText,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    debugPrint("SIDEBAR LOGOUT PRESSED");
                    onLogout();
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.logout_rounded,
                      size: 16,
                      color: AdminColors.sidebarText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: AdminColors.sidebarText,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, String key) {
    final isActive = activeMenu == key;
    return GestureDetector(
      onTap: () => onMenuSelected(key),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? AdminColors.sidebarActive : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: isActive ? Colors.white : AdminColors.sidebarText,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? Colors.white : AdminColors.sidebarText,
                ),
              ),
            ),
            if (isActive)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AdminColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
