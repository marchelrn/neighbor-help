import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  String _filterStatus = 'Semua';
  int? _selectedUserIndex;

  // ── Mock data ──
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Budi Santoso',
      'email': 'budi@example.com',
      'area': 'Malalayang, Manado',
      'joined': '12 Jan 2026',
      'status': 'Aktif',
      'helps': 23,
      'rating': 4.9,
    },
    {
      'name': 'Rina Hartati',
      'email': 'rina@example.com',
      'area': 'Tikala, Manado',
      'joined': '20 Jan 2026',
      'status': 'Aktif',
      'helps': 18,
      'rating': 4.8,
    },
    {
      'name': 'Christo Budiman',
      'email': 'christo@example.com',
      'area': 'Wenang, Manado',
      'joined': '3 Feb 2026',
      'status': 'Aktif',
      'helps': 15,
      'rating': 4.7,
    },
    {
      'name': 'Siti Rahayu',
      'email': 'siti@example.com',
      'area': 'Tuminting, Manado',
      'joined': '8 Feb 2026',
      'status': 'Suspended',
      'helps': 5,
      'rating': 3.2,
    },
    {
      'name': 'Andi Firmansyah',
      'email': 'andi@example.com',
      'area': 'Wanea, Manado',
      'joined': '15 Feb 2026',
      'status': 'Aktif',
      'helps': 11,
      'rating': 4.5,
    },
    {
      'name': 'Dewi Kusuma',
      'email': 'dewi@example.com',
      'area': 'Sario, Manado',
      'joined': '22 Feb 2026',
      'status': 'Aktif',
      'helps': 7,
      'rating': 4.3,
    },
    {
      'name': 'Faisal Hamid',
      'email': 'faisal@example.com',
      'area': 'Mapanget, Manado',
      'joined': '1 Mar 2026',
      'status': 'Nonaktif',
      'helps': 0,
      'rating': 0.0,
    },
    {
      'name': 'Grace Tampi',
      'email': 'grace@example.com',
      'area': 'Bunaken, Manado',
      'joined': '5 Mar 2026',
      'status': 'Aktif',
      'helps': 3,
      'rating': 4.1,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filterStatus == 'Semua') return _users;
    return _users.where((u) => u['status'] == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                      label: 'Ekspor Data',
                      icon: Icons.download_rounded,
                      variant: AdminButtonVariant.outline,
                    ),
                    const SizedBox(width: 10),
                    AdminButton(
                      label: 'Tambah Admin',
                      icon: Icons.person_add_rounded,
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
            color: Colors.black.withOpacity(0.04),
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
                _th('Rating', flex: 1),
                _th('Status', flex: 2),
                _th('Aksi', flex: 2),
              ],
            ),
          ),
          // Rows
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
    final isSuspended = user['status'] == 'Suspended';
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
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AdminColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user['name'][0],
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
                        ),
                        Text(
                          user['email'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AdminColors.textLight,
                          ),
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
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AdminColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                user['joined'],
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
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: user['rating'] > 0
                  ? Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFFBBF24),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${user['rating']}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      '—',
                      style: TextStyle(color: AdminColors.textLight),
                    ),
            ),
            Expanded(
              flex: 2,
              child: AdminStatusBadge(
                label: user['status'],
                type: user['status'] == 'Aktif'
                    ? AdminBadgeType.success
                    : user['status'] == 'Suspended'
                    ? AdminBadgeType.error
                    : AdminBadgeType.neutral,
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  AdminButton(
                    label: isSuspended ? 'Aktifkan' : 'Suspend',
                    small: true,
                    variant: isSuspended
                        ? AdminButtonVariant.ghost
                        : AdminButtonVariant.danger,
                    icon: isSuspended
                        ? Icons.check_rounded
                        : Icons.block_rounded,
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
      padding: const EdgeInsets.all(20),
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
                  fontWeight: FontWeight.w700,
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
                  decoration: BoxDecoration(
                    color: AdminColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user['name'][0],
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
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'],
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AdminColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                AdminStatusBadge(
                  label: user['status'],
                  type: user['status'] == 'Aktif'
                      ? AdminBadgeType.success
                      : AdminBadgeType.error,
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
              _detailStat('${user['rating']}', 'Rating'),
              _detailStat('3', 'Laporan'),
            ],
          ),
          const SizedBox(height: 20),

          // Info
          _infoRow(Icons.location_on_rounded, 'Area', user['area']),
          _infoRow(Icons.calendar_today_rounded, 'Bergabung', user['joined']),
          _infoRow(Icons.smartphone_rounded, 'Platform', 'Windows Desktop'),
          _infoRow(Icons.access_time_rounded, 'Login Terakhir', '2 jam lalu'),
          const SizedBox(height: 20),

          // Actions
          AdminButton(
            label: 'Kirim Peringatan',
            icon: Icons.warning_amber_rounded,
            variant: AdminButtonVariant.outline,
          ),
          const SizedBox(height: 10),
          AdminButton(
            label: user['status'] == 'Suspended'
                ? 'Aktifkan Akun'
                : 'Suspend Akun',
            icon: user['status'] == 'Suspended'
                ? Icons.check_circle_rounded
                : Icons.block_rounded,
            variant: user['status'] == 'Suspended'
                ? AdminButtonVariant.primary
                : AdminButtonVariant.danger,
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
