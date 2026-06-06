import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';

class AdminMonitoringPage extends StatelessWidget {
  const AdminMonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminPageHeader(
            title: 'Monitoring Sistem',
            subtitle: 'Pantau aktivitas dan performa sistem secara real-time',
          ),
          const SizedBox(height: 24),

          // ── Server Health Row ──
          Row(
            children: [
              Expanded(
                child: _healthCard(
                  'Server Status',
                  'Online',
                  Icons.cloud_done_rounded,
                  AdminColors.success,
                  AdminColors.successSoft,
                  '99.9% uptime',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _healthCard(
                  'Pengguna Online',
                  '47',
                  Icons.people_alt_rounded,
                  AdminColors.primary,
                  AdminColors.primarySoft,
                  'dalam 30 menit terakhir',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _healthCard(
                  'Request Aktif',
                  '12',
                  Icons.pending_actions_rounded,
                  AdminColors.warning,
                  AdminColors.warningSoft,
                  'sedang berjalan',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _healthCard(
                  'Notifikasi Terkirim',
                  '284',
                  Icons.notifications_active_rounded,
                  AdminColors.info,
                  AdminColors.infoSoft,
                  'hari ini',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity timeline
              Expanded(
                flex: 2,
                child: AdminSectionCard(
                  title: 'Aktivitas Real-time',
                  trailing: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AdminColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    children: [
                      _timelineItem(
                        'Pengguna Baru',
                        'rina.manado@gmail.com mendaftar',
                        '2 mnt lalu',
                        AdminColors.primary,
                        Icons.person_add_rounded,
                      ),
                      _timelineItem(
                        'Request Darurat',
                        'Ibu Lisa — Tuminting, 50m',
                        '5 mnt lalu',
                        AdminColors.error,
                        Icons.emergency_rounded,
                      ),
                      _timelineItem(
                        'Push Notifikasi',
                        '23 pengguna diberitahu',
                        '5 mnt lalu',
                        AdminColors.info,
                        Icons.notifications_rounded,
                      ),
                      _timelineItem(
                        'Request Selesai',
                        'Bantu angkat galon — Budi S.',
                        '18 mnt lalu',
                        AdminColors.success,
                        Icons.check_circle_rounded,
                      ),
                      _timelineItem(
                        'Poin Reputasi',
                        'Budi S. +5 poin helper',
                        '18 mnt lalu',
                        AdminColors.warning,
                        Icons.star_rounded,
                      ),
                      _timelineItem(
                        'Request Dibuat',
                        'Pasang TV di dinding — Grace',
                        '34 mnt lalu',
                        AdminColors.primary,
                        Icons.add_circle_rounded,
                      ),
                      _timelineItem(
                        'Login',
                        '12 pengguna login hari ini',
                        '1 jam lalu',
                        AdminColors.info,
                        Icons.login_rounded,
                      ),
                      _timelineItem(
                        'Laporan Baru',
                        'Konten pelanggaran dilaporkan',
                        '2 jam lalu',
                        AdminColors.error,
                        Icons.flag_rounded,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Right column
              Expanded(
                child: Column(
                  children: [
                    // Ongoing helps
                    AdminSectionCard(
                      title: 'Bantuan Sedang Berlangsung',
                      child: Column(
                        children: [
                          _ongoingHelp(
                            'Andi + Grace',
                            'Pasang TV di dinding',
                            '34 mnt',
                          ),
                          const SizedBox(height: 10),
                          _ongoingHelp(
                            'Budi + Rina',
                            'Pinjam tangga',
                            '12 mnt',
                          ),
                          const SizedBox(height: 10),
                          _ongoingHelp(
                            'Christo + Dewi',
                            'Angkat galon',
                            '8 mnt',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // System health bars
                    AdminSectionCard(
                      title: 'Performa Sistem',
                      child: Column(
                        children: [
                          _perfBar('CPU Usage', 0.23, AdminColors.primary),
                          const SizedBox(height: 12),
                          _perfBar('Memory', 0.41, AdminColors.info),
                          const SizedBox(height: 12),
                          _perfBar('Database', 0.18, AdminColors.success),
                          const SizedBox(height: 12),
                          _perfBar(
                            'Notification Queue',
                            0.07,
                            AdminColors.warning,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Active area map summary
                    AdminSectionCard(
                      title: 'Area Paling Aktif',
                      child: Column(
                        children: [
                          _areaBar('Malalayang', 0.82, '23 req'),
                          const SizedBox(height: 8),
                          _areaBar('Tikala', 0.65, '18 req'),
                          const SizedBox(height: 8),
                          _areaBar('Wenang', 0.54, '15 req'),
                          const SizedBox(height: 8),
                          _areaBar('Tuminting', 0.38, '11 req'),
                          const SizedBox(height: 8),
                          _areaBar('Sario', 0.27, '7 req'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _healthCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color softColor,
    String sub,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AdminColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
                Text(
                  sub,
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
    );
  }

  Widget _timelineItem(
    String title,
    String subtitle,
    String time,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 1,
            height: 40,
            color: AdminColors.borderLight,
            margin: const EdgeInsets.only(right: 12),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AdminColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: AdminColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _ongoingHelp(String users, String task, String duration) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.primarySoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.handshake_rounded,
            size: 16,
            color: AdminColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
                Text(
                  users,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AdminColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AdminColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              duration,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AdminColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _perfBar(String label, double val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AdminColors.textSecondary,
              ),
            ),
            Text(
              '${(val * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
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
            value: val,
            backgroundColor: AdminColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _areaBar(String area, double ratio, String count) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            area,
            style: const TextStyle(
              fontSize: 12,
              color: AdminColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AdminColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AdminColors.primary,
              ),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          count,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AdminColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
