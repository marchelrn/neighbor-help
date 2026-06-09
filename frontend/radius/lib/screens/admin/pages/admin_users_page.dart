import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';
import 'package:radius/services/admin_service.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  String _filterStatus = 'Semua';
  int? _selectedUserIndex;

  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getUsers();
      setState(() {
        _users = data.map((u) {
          final role = u['role'] ?? 'user';
          return {
            'id': u['id'] ?? 0,
            'username': u['username'] ?? '',
            'name': u['full_name'] ?? u['username'] ?? 'Unknown',
            'email': '-', // Email not returned by API
            'area': u['address'] ?? '-',
            'joined': '-', // Not returned
            'status': role == 'admin'
                ? 'Aktif'
                : 'Aktif', // Mapping role to status for now
            'role': role,
            'helps': 0, // Not returned
          };
        }).toList();
        _selectedUserIndex = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat pengguna: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      await AdminService.deleteUser(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengguna berhasil dihapus')),
      );
      _fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus pengguna: $e')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filterStatus == 'Semua') return _users;
    return _users.where((u) => u['status'] == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      children: [
        // ── Table area ──
        Expanded(
          flex: _selectedUserIndex != null ? 3 : 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminPageHeader(
                  title: 'Kelola Pengguna',
                  subtitle: '${_users.length} pengguna terdaftar',
                  actions: [
                    AdminButton(
                      label: 'Refresh',
                      icon: Icons.refresh_rounded,
                      variant: AdminButtonVariant.outline,
                      onTap: _fetchUsers,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Filter + Search ──
                Row(
                  children: [
                    AdminFilterChips(
                      options: const [
                        'Semua',
                        'Aktif',
                        'Suspended',
                        'Nonaktif',
                      ],
                      initial: _filterStatus,
                      onSelected: (v) => setState(() {
                        _filterStatus = v;
                        _selectedUserIndex = null;
                      }),
                    ),
                    const Spacer(),
                    const AdminSearchBar(hint: 'Cari pengguna...'),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Table ──
                _buildTable(),
              ],
            ),
          ),
        ),

        // ── Detail Panel ──
        if (_selectedUserIndex != null)
          Container(
            width: 320,
            decoration: const BoxDecoration(
              color: AdminColors.surface,
              border: Border(left: BorderSide(color: AdminColors.border)),
            ),
            child: _buildUserDetail(_filtered[_selectedUserIndex!]),
          ),
      ],
    );
  }

  Widget _buildTable() {
    final rows = _filtered;
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdminColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AdminColors.surfaceAlt,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(bottom: BorderSide(color: AdminColors.border)),
            ),
            child: Row(
              children: [
                _th('Pengguna', flex: 3),
                _th('Area', flex: 2),
                _th('Bergabung', flex: 2),
                _th('Bantuan', flex: 1),
                _th('Status', flex: 2),
                _th('Aksi', flex: 2),
              ],
            ),
          ),
          // Rows
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("Tidak ada pengguna")),
            ),
          ...List.generate(rows.length, (i) => _buildRow(rows[i], i)),
        ],
      ),
    );
  }

  Widget _th(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: AdminColors.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> user, int index) {
    final isSelected = _selectedUserIndex == index;

    return GestureDetector(
      onTap: () =>
          setState(() => _selectedUserIndex = isSelected ? null : index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primarySoft : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: AdminColors.borderLight),
          ),
        ),
        child: Row(
          children: [
            // Name + email
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AdminColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user['name'].toString().isNotEmpty
                            ? user['name'][0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AdminColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '@${user['username']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AdminColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                user['area'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AdminColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                user['joined'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AdminColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${user['helps']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: AdminStatusBadge(
                  label: user['role'] == 'admin' ? 'Admin' : 'User',
                  type: user['role'] == 'admin'
                      ? AdminBadgeType.info
                      : AdminBadgeType.neutral,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdminButton(
                    label: 'Hapus',
                    small: true,
                    variant: AdminButtonVariant.danger,
                    icon: Icons.delete_outline_rounded,
                    onTap: () => _deleteUser(user['id']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetail(Map<String, dynamic> user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detail Pengguna',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AdminColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => setState(() => _selectedUserIndex = null),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AdminColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Avatar
          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AdminColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user['name'].toString().isNotEmpty
                          ? user['name'][0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AdminColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user['username']}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AdminColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                AdminStatusBadge(
                  label: user['role'] == 'admin' ? 'Admin' : 'User',
                  type: user['role'] == 'admin'
                      ? AdminBadgeType.info
                      : AdminBadgeType.neutral,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: AdminColors.border),
          const SizedBox(height: 16),

          // Stats
          Row(
            children: [
              _detailStat('${user['helps']}', 'Bantuan'),
              _detailStat('0', 'Laporan'),
            ],
          ),
          const SizedBox(height: 20),

          // Info
          _infoRow(Icons.location_on_rounded, 'Alamat', user['area']),
          _infoRow(Icons.calendar_today_rounded, 'Bergabung', user['joined']),
          _infoRow(Icons.email_rounded, 'Email', user['email']),
          const SizedBox(height: 20),

          // Actions
          AdminButton(
            label: user['role'] == 'admin'
                ? 'Jadikan User Biasa'
                : 'Jadikan Admin',
            icon: user['role'] == 'admin'
                ? Icons.person_rounded
                : Icons.admin_panel_settings_rounded,
            variant: AdminButtonVariant.outline,
            onTap: () async {
              try {
                final newRole = user['role'] == 'admin' ? 'user' : 'admin';
                await AdminService.updateUser(user['username'], {
                  'role': newRole,
                });
                _fetchUsers();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Peran berhasil diubah menjadi $newRole'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                }
              }
            },
          ),
          const SizedBox(height: 10),
          AdminButton(
            label: 'Hapus Akun',
            icon: Icons.delete_forever_rounded,
            variant: AdminButtonVariant.danger,
            onTap: () => _deleteUser(user['id']),
          ),
        ],
      ),
    );
  }

  Widget _detailStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AdminColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AdminColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AdminColors.textLight),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12.5,
              color: AdminColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AdminColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
