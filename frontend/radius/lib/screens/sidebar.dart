import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../utils/storage.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onMenuSelected;

  final String activeMenu;

  final VoidCallback onLogout;

  final int unreadNotificationCount;

  const Sidebar({
    super.key,
    required this.onMenuSelected,
    required this.activeMenu,
    required this.onLogout,
    this.unreadNotificationCount = 0,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isCollapsed = false;

  Map<String, dynamic>? currentUser;

  // =====================================
  // INIT
  // =====================================

  @override
  void initState() {
    super.initState();

    loadCurrentUser();
  }

  // =====================================
  // LOAD CURRENT USER
  // =====================================

  Future<void> loadCurrentUser() async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return;
      }

      final data = await AuthService.getCurrentUser(token);

      setState(() {
        currentUser = data;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // =====================================
  // USER INITIALS
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: isCollapsed ? 82 : 270,
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 8 : 16,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(4, 0),
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================
              // HEADER
              // =====================================
              Row(
                mainAxisAlignment: isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "NeighborHelp",
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          SizedBox(height: 2),

                          Text(
                            "Saling Bantu Tetangga",
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 24),

              // =====================================
              // PROFILE
              // =====================================
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.all(isCollapsed ? 8 : 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Text(
                        getInitials(),
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (!isCollapsed) ...[
                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser?["full_name"] ?? "Loading...",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              "@${currentUser?["username"] ?? "..."}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // =====================================
              // CREATE REQUEST BUTTON
              // =====================================
              if (!isCollapsed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.onMenuSelected("buat_request");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("Buat Request"),
                  ),
                ),

              const SizedBox(height: 20),

              Divider(color: Colors.white.withValues(alpha: 0.16)),

              const SizedBox(height: 8),

              // =====================================
              // MENU
              // =====================================
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _menuItem(Icons.home_outlined, "Beranda"),

                      _menuItem(Icons.map_outlined, "Peta Area"),

                      _menuItem(Icons.dynamic_feed_outlined, "Help Feed"),

                      _menuItem(Icons.assignment_outlined, "Request Saya"),

                      _menuItem(
                        Icons.notifications_outlined,
                        "Notifikasi",
                        badge: widget.unreadNotificationCount > 0 
                            ? widget.unreadNotificationCount.toString() 
                            : null,
                      ),

                      _menuItem(Icons.person_outline, "Profil"),
                    ],
                  ),
                ),
              ),

              // =====================================
              // LOGOUT
              // =====================================
              GestureDetector(
                onTap: widget.onLogout,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(top: 6),
                  padding: EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: isCollapsed ? 0 : 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 20,
                      ),

                      if (!isCollapsed) ...[
                        const SizedBox(width: 8),

                        const Flexible(
                          child: Text(
                            "Keluar",
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
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

        // =====================================
        // COLLAPSE BUTTON
        // =====================================
        Positioned(
          top: 110,
          right: -14,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.primary, width: 2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ],
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

  // =====================================
  // MENU ITEM
  // =====================================

  Widget _menuItem(IconData icon, String title, {String? badge}) {
    final bool active = widget.activeMenu == title;

    return GestureDetector(
      onTap: () {
        widget.onMenuSelected(title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(
          vertical: 13,
          horizontal: active ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: active
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: active
              ? Border.all(color: Colors.white.withValues(alpha: 0.12))
              : null,
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
                  Icon(icon, color: Colors.white, size: 21),

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
