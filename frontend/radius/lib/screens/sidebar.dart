import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onMenuSelected;
  final String activeMenu;
  final VoidCallback onLogout; // 🔥 ADD THIS

  const Sidebar({
    super.key,
    required this.onMenuSelected,
    required this.activeMenu,
    required this.onLogout, // 🔥 ADD THIS
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isCollapsed ? 80 : 260,
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 8 : 16,
            vertical: 20,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    width: isCollapsed ? 44 : 50,
                    height: isCollapsed ? 44 : 50,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.handshake,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "NeighborHelp",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Saling Bantu Tetangga",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20),

              // PROFILE (🔥 FIXED AVATAR)
              Container(
                padding: EdgeInsets.all(isCollapsed ? 6 : 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      child: Icon(Icons.person, size: 18),
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Budi Santoso",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "⭐ 4.8 • 23 helps",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BUTTON
              if (!isCollapsed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onMenuSelected("buat_request");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("+ Buat Request"),
                  ),
                ),

              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 10),

              // 🔥 MENU
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _menuItem(Icons.home_outlined, "Beranda"),
                      _menuItem(Icons.map_outlined, "Peta Area"),
                      _menuItem(Icons.assignment_outlined, "Help Feed"),
                      _menuItem(Icons.assignment_outlined, "Request Saya"),
                      _menuItem(
                        Icons.notifications_outlined,
                        "Notifikasi",
                        badge: "2",
                      ),
                      _menuItem(Icons.person_outline, "Profil"),
                    ],
                  ),
                ),
              ),

              // 🔥 LOGOUT (FIXED)
              GestureDetector(
                onTap: widget.onLogout,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: isCollapsed ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.logout, color: Colors.white, size: 20),
                      if (!isCollapsed) ...[
                        const SizedBox(width: 12),
                        const Text(
                          "Keluar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // COLLAPSE BUTTON
        Positioned(
          top: 110,
          right: -14,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.primary, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, {String? badge}) {
    final bool active = widget.activeMenu == title;

    return GestureDetector(
      onTap: () {
        widget.onMenuSelected(title);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: active ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  if (badge != null)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
