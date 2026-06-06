import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          const AdminPageHeader(
            title: 'Dashboard',
            subtitle:
                'Selamat datang kembali, Admin. Berikut ringkasan aktivitas hari ini.',
          ),
          const SizedBox(height: 24),

          // ── Stat Cards Row ──
          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  label: 'Total Pengguna',
                  value: '1.284',
                  icon: Icons.people_alt_rounded,
                  color: AdminColors.primary,
                  softColor: AdminColors.primarySoft,
                  trend: '12%',
                  trendUp: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminStatCard(
                  label: 'Total Permintaan',
                  value: '3.892',
                  icon: Icons.handshake_rounded,
                  color: AdminColors.info,
                  softColor: AdminColors.infoSoft,
                  trend: '8%',
                  trendUp: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminStatCard(
                  label: 'Permintaan Aktif',
                  value: '47',
                  icon: Icons.pending_actions_rounded,
                  color: AdminColors.warning,
                  softColor: AdminColors.warningSoft,
                  trend: '3%',
                  trendUp: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminStatCard(
                  label: 'Permintaan Selesai',
                  value: '3.721',
                  icon: Icons.check_circle_outline_rounded,
                  color: AdminColors.success,
                  softColor: AdminColors.successSoft,
                  trend: '18%',
                  trendUp: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Chart + Activity Row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bar Chart
              Expanded(
                flex: 3,
                child: AdminSectionCard(
                  title: 'Aktivitas Permintaan (7 Hari)',
                  trailing: const AdminStatusBadge(
                    label: 'Minggu ini',
                    type: AdminBadgeType.info,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      AdminMiniBarChart(
                        values: const [28, 42, 35, 56, 43, 61, 47],
                        labels: const [
                          'Sen',
                          'Sel',
                          'Rab',
                          'Kam',
                          'Jum',
                          'Sab',
                          'Min',
                        ],
                        barColor: AdminColors.primary,
                        height: 140,
                      ),
                      const SizedBox(height: 16),
                      // Second chart (completed)
                      Row(
                        children: [
                          _legendDot(AdminColors.primary),
                          const SizedBox(width: 6),
                          const Text(
                            'Dibuat',
                            style: TextStyle(
                              fontSize: 12,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          _legendDot(AdminColors.accent),
                          const SizedBox(width: 6),
                          const Text(
                            'Diselesaikan',
                            style: TextStyle(
                              fontSize: 12,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Recent Activity
              Expanded(
                flex: 2,
                child: AdminSectionCard(
                  title: 'Aktivitas Terbaru',
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat semua',
                      style: TextStyle(
                        fontSize: 12,
                        color: AdminColors.primary,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Column(
                    children: [
                      _divider(),
                      const AdminActivityItem(
                        icon: Icons.person_add_rounded,
                        iconColor: AdminColors.primary,
                        iconBg: AdminColors.primarySoft,
                        title: 'Pengguna baru mendaftar',
                        subtitle: 'Rina Hartati — Malalayang',
                        time: '2 mnt lalu',
                      ),
                      _divider(),
                      const AdminActivityItem(
                        icon: Icons.flag_rounded,
                        iconColor: AdminColors.error,
                        iconBg: AdminColors.errorSoft,
                        title: 'Laporan baru diterima',
                        subtitle: 'Konten melanggar aturan',
                        time: '15 mnt lalu',
                      ),
                      _divider(),
                      const AdminActivityItem(
                        icon: Icons.check_rounded,
                        iconColor: AdminColors.success,
                        iconBg: AdminColors.successSoft,
                        title: 'Permintaan diselesaikan',
                        subtitle: 'Bantu angkat galon — Budi S.',
                        time: '32 mnt lalu',
                      ),
                      _divider(),
                      const AdminActivityItem(
                        icon: Icons.notifications_rounded,
                        iconColor: AdminColors.warning,
                        iconBg: AdminColors.warningSoft,
                        title: 'Notifikasi darurat terkirim',
                        subtitle: '23 pengguna dalam radius',
                        time: '1 jam lalu',
                      ),
                      _divider(),
                      const AdminActivityItem(
                        icon: Icons.block_rounded,
                        iconColor: AdminColors.error,
                        iconBg: AdminColors.errorSoft,
                        title: 'Akun disuspend',
                        subtitle: 'user.spam@example.com',
                        time: '3 jam lalu',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Bottom Row: Status Distribution + Top Users ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status distribution
              Expanded(
                child: AdminSectionCard(
                  title: 'Distribusi Status Permintaan',
                  child: Column(
                    children: [
                      _statusRow('Aktif', 47, 3892, AdminColors.warning),
                      const SizedBox(height: 12),
                      _statusRow('Dalam Proses', 124, 3892, AdminColors.info),
                      const SizedBox(height: 12),
                      _statusRow('Selesai', 3721, 3892, AdminColors.success),
                      const SizedBox(height: 12),
                      _statusRow('Dibatalkan', 0, 3892, AdminColors.error),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Top helpers
              Expanded(
                child: AdminSectionCard(
                  title: 'Top Helper Bulan Ini',
                  child: Column(
                    children: [
                      _topHelperRow(1, 'Budi Santoso', '23 bantuan', '4.9'),
                      _topHelperRow(2, 'Rina Hartati', '18 bantuan', '4.8'),
                      _topHelperRow(3, 'Christo Budiman', '15 bantuan', '4.7'),
                      _topHelperRow(4, 'Siti Rahayu', '12 bantuan', '4.6'),
                      _topHelperRow(5, 'Andi Firmansyah', '11 bantuan', '4.5'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Quick actions
              Expanded(
                child: AdminSectionCard(
                  title: 'Aksi Cepat',
                  child: Column(
                    children: [
                      _quickAction(
                        Icons.person_add_rounded,
                        'Tambah Admin Baru',
                        AdminColors.primarySoft,
                        AdminColors.primary,
                      ),
                      const SizedBox(height: 10),
                      _quickAction(
                        Icons.download_rounded,
                        'Ekspor Data Pengguna',
                        AdminColors.infoSoft,
                        AdminColors.info,
                      ),
                      const SizedBox(height: 10),
                      _quickAction(
                        Icons.flag_rounded,
                        'Tinjau Laporan Baru',
                        AdminColors.errorSoft,
                        AdminColors.error,
                      ),
                      const SizedBox(height: 10),
                      _quickAction(
                        Icons.settings_rounded,
                        'Atur Radius Default',
                        AdminColors.warningSoft,
                        AdminColors.warning,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 1, color: AdminColors.borderLight);

  Widget _legendDot(Color color) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _statusRow(String label, int count, int total, Color color) {
    final pct = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: AdminColors.textSecondary,
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AdminColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AdminColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _topHelperRow(int rank, String name, String helps, String rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: rank == 1
                  ? const Color(0xFFFBBF24)
                  : AdminColors.borderLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: rank == 1 ? Colors.white : AdminColors.textSecondary,
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
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
                Text(
                  helps,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AdminColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 13,
                color: Color(0xFFFBBF24),
              ),
              const SizedBox(width: 3),
              Text(
                rating,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: fg),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
