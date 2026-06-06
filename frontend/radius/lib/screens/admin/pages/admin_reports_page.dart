import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  String _period = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: 'Laporan & Statistik',
            subtitle: 'Ringkasan performa dan aktivitas sistem',
            actions: [
              AdminFilterChips(
                options: const ['Minggu Ini', 'Bulan Ini', 'Tahun Ini'],
                initial: _period,
                onSelected: (v) => setState(() => _period = v),
              ),
              const SizedBox(width: 12),
              AdminButton(
                label: 'Ekspor PDF',
                icon: Icons.picture_as_pdf_rounded,
                variant: AdminButtonVariant.outline,
              ),
              const SizedBox(width: 8),
              AdminButton(label: 'Ekspor CSV', icon: Icons.download_rounded),
            ],
          ),
          const SizedBox(height: 24),

          // ── Top Stats ──
          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  label: 'Pengguna Baru',
                  value: '128',
                  icon: Icons.person_add_rounded,
                  color: AdminColors.primary,
                  softColor: AdminColors.primarySoft,
                  trend: '12%',
                  trendUp: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminStatCard(
                  label: 'Request Dibuat',
                  value: '342',
                  icon: Icons.add_circle_outline_rounded,
                  color: AdminColors.info,
                  softColor: AdminColors.infoSoft,
                  trend: '8%',
                  trendUp: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminStatCard(
                  label: 'Request Selesai',
                  value: '298',
                  icon: Icons.check_circle_outline_rounded,
                  color: AdminColors.success,
                  softColor: AdminColors.successSoft,
                  trend: '15%',
                  trendUp: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminStatCard(
                  label: 'Tingkat Keberhasilan',
                  value: '87%',
                  icon: Icons.trending_up_rounded,
                  color: AdminColors.warning,
                  softColor: AdminColors.warningSoft,
                  trend: '3%',
                  trendUp: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart 1: Request per week
              Expanded(
                flex: 2,
                child: AdminSectionCard(
                  title: 'Tren Permintaan Bantuan',
                  trailing: const AdminStatusBadge(
                    label: 'Per minggu',
                    type: AdminBadgeType.info,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      AdminMiniBarChart(
                        values: const [45, 62, 58, 71, 84, 76, 92, 88],
                        labels: const [
                          'W1',
                          'W2',
                          'W3',
                          'W4',
                          'W5',
                          'W6',
                          'W7',
                          'W8',
                        ],
                        barColor: AdminColors.primary,
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Chart 2: New users
              Expanded(
                child: AdminSectionCard(
                  title: 'Pertumbuhan Pengguna',
                  trailing: const AdminStatusBadge(
                    label: '+12%',
                    type: AdminBadgeType.success,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      AdminMiniBarChart(
                        values: const [18, 22, 19, 28, 31, 24, 35, 29],
                        labels: const [
                          'W1',
                          'W2',
                          'W3',
                          'W4',
                          'W5',
                          'W6',
                          'W7',
                          'W8',
                        ],
                        barColor: AdminColors.accent,
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category breakdown
              Expanded(
                child: AdminSectionCard(
                  title: 'Request per Kategori',
                  child: Column(
                    children: [
                      _categoryRow(
                        Icons.fitness_center_rounded,
                        'Bantuan Fisik',
                        142,
                        342,
                        AdminColors.primary,
                      ),
                      const SizedBox(height: 12),
                      _categoryRow(
                        Icons.build_rounded,
                        'Peralatan',
                        98,
                        342,
                        AdminColors.info,
                      ),
                      const SizedBox(height: 12),
                      _categoryRow(
                        Icons.settings_rounded,
                        'Teknis',
                        67,
                        342,
                        AdminColors.warning,
                      ),
                      const SizedBox(height: 12),
                      _categoryRow(
                        Icons.emergency_rounded,
                        'Darurat',
                        23,
                        342,
                        AdminColors.error,
                      ),
                      const SizedBox(height: 12),
                      _categoryRow(
                        Icons.more_horiz_rounded,
                        'Lainnya',
                        12,
                        342,
                        AdminColors.textLight,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Area breakdown
              Expanded(
                child: AdminSectionCard(
                  title: 'Request per Area',
                  child: Column(
                    children: [
                      _areaRow('Malalayang', 87, AdminColors.primary),
                      _areaRow('Tikala', 72, AdminColors.info),
                      _areaRow('Wenang', 65, AdminColors.warning),
                      _areaRow('Tuminting', 48, AdminColors.success),
                      _areaRow('Sario', 36, AdminColors.error),
                      _areaRow('Mapanget', 21, AdminColors.textLight),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Completion rates
              Expanded(
                child: AdminSectionCard(
                  title: 'Ringkasan Aktivitas',
                  child: Column(
                    children: [
                      _summaryRow('Total Pengguna Aktif', '847'),
                      _summaryRow('Rata-rata Bantuan/Hari', '11.4'),
                      _summaryRow('Waktu Respon Rata-rata', '8 mnt'),
                      _summaryRow('Helper Terdaftar', '312'),
                      _summaryRow('Rating Rata-rata', '4.6 ⭐'),
                      _summaryRow('Laporan Ditangani', '24'),
                      _summaryRow('Akun Suspended', '7'),
                      _summaryRow('Notifikasi Terkirim', '2.847'),
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

  Widget _categoryRow(
    IconData icon,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final pct = count / total;
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AdminColors.textSecondary,
                ),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AdminColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${(pct * 100).round()}%)',
              style: const TextStyle(
                fontSize: 11,
                color: AdminColors.textLight,
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

  Widget _areaRow(String area, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              area,
              style: const TextStyle(
                fontSize: 12.5,
                color: AdminColors.textSecondary,
              ),
            ),
          ),
          Text(
            '$count req',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AdminColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
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
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AdminColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
