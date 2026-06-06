import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';

class AdminModerationPage extends StatefulWidget {
  const AdminModerationPage({super.key});

  @override
  State<AdminModerationPage> createState() => _AdminModerationPageState();
}

class _AdminModerationPageState extends State<AdminModerationPage> {
  String _tab = 'Laporan Pengguna';

  final List<Map<String, dynamic>> _userReports = [
    {
      'reporter': 'Budi Santoso',
      'reported': 'faisal.spam@example.com',
      'reason': 'Spam / Penipuan',
      'detail':
          'Pengguna ini mengirim pesan berulang menawarkan jasa fiktif dan meminta pembayaran di muka.',
      'time': '2 jam lalu',
      'status': 'Menunggu',
    },
    {
      'reporter': 'Rina Hartati',
      'reported': 'user.kasar@example.com',
      'reason': 'Perilaku Tidak Pantas',
      'detail':
          'Pengguna menggunakan bahasa kasar dan mengancam saat percakapan chat.',
      'time': '5 jam lalu',
      'status': 'Menunggu',
    },
    {
      'reporter': 'Grace Tampi',
      'reported': 'multi.akun@example.com',
      'reason': 'Multi Akun',
      'detail':
          'Diduga menggunakan lebih dari satu akun untuk mendapatkan lebih banyak request.',
      'time': '1 hari lalu',
      'status': 'Diproses',
    },
    {
      'reporter': 'Admin',
      'reported': 'scammer.user@example.com',
      'reason': 'Penipuan Terverifikasi',
      'detail':
          'Berdasarkan investigasi, akun ini terbukti melakukan penipuan kepada 3 pengguna.',
      'time': '2 hari lalu',
      'status': 'Ditolak',
    },
  ];

  final List<Map<String, dynamic>> _requestReports = [
    {
      'reporter': 'Andi Firmansyah',
      'requestTitle': 'Pinjam uang 500rb tanpa jaminan',
      'reason': 'Konten Tidak Sesuai',
      'detail':
          'Permintaan pinjam uang tidak relevan dengan tujuan aplikasi. Tidak sesuai kategori yang tersedia.',
      'time': '1 jam lalu',
      'status': 'Menunggu',
    },
    {
      'reporter': 'Siti Rahayu',
      'requestTitle': 'Bantu promosi jualan online',
      'reason': 'Spam / Iklan',
      'detail':
          'Request ini berisi promosi bisnis, bukan permintaan bantuan warga.',
      'time': '4 jam lalu',
      'status': 'Diterima',
    },
    {
      'reporter': 'Dewi Kusuma',
      'requestTitle': 'Konten bermasalah lainnya',
      'reason': 'Konten Berbahaya',
      'detail':
          'Permintaan berisi informasi yang berpotensi berbahaya bagi pengguna lain.',
      'time': '8 jam lalu',
      'status': 'Diproses',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: AdminPageHeader(
                  title: 'Moderasi Konten',
                  subtitle: 'Tinjau dan tangani laporan dari pengguna',
                ),
              ),
              // Summary badges
              Row(
                children: [
                  _summaryBadge(
                    '3 Menunggu',
                    AdminColors.error,
                    AdminColors.errorSoft,
                  ),
                  const SizedBox(width: 8),
                  _summaryBadge(
                    '2 Diproses',
                    AdminColors.warning,
                    AdminColors.warningSoft,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Tabs ──
          Row(
            children: ['Laporan Pengguna', 'Laporan Permintaan'].map((tab) {
              final isActive = _tab == tab;
              return GestureDetector(
                onTap: () => setState(() => _tab = tab),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AdminColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isActive
                        ? null
                        : Border.all(color: AdminColors.border),
                  ),
                  child: Row(
                    children: [
                      Text(
                        tab,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : AdminColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withOpacity(0.2)
                              : AdminColors.borderLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tab == 'Laporan Pengguna'
                              ? '${_userReports.length}'
                              : '${_requestReports.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? Colors.white
                                : AdminColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // ── Report List ──
          _tab == 'Laporan Pengguna'
              ? _buildUserReports()
              : _buildRequestReports(),
        ],
      ),
    );
  }

  Widget _buildUserReports() {
    return Column(
      children: _userReports
          .map(
            (r) => _reportCard(
              icon: Icons.person_rounded,
              title: 'Dilaporkan: ${r['reported']}',
              subtitle: 'Pelapor: ${r['reporter']}',
              reason: r['reason'],
              detail: r['detail'],
              time: r['time'],
              status: r['status'],
            ),
          )
          .toList(),
    );
  }

  Widget _buildRequestReports() {
    return Column(
      children: _requestReports
          .map(
            (r) => _reportCard(
              icon: Icons.article_rounded,
              title: '"${r['requestTitle']}"',
              subtitle: 'Pelapor: ${r['reporter']}',
              reason: r['reason'],
              detail: r['detail'],
              time: r['time'],
              status: r['status'],
            ),
          )
          .toList(),
    );
  }

  Widget _reportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String reason,
    required String detail,
    required String time,
    required String status,
  }) {
    final isPending = status == 'Menunggu';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPending
              ? AdminColors.error.withOpacity(0.3)
              : AdminColors.border,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AdminColors.errorSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 17, color: AdminColors.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AdminColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AdminStatusBadge(label: reason, type: AdminBadgeType.error),
              const SizedBox(width: 12),
              AdminStatusBadge(
                label: status,
                type: status == 'Menunggu'
                    ? AdminBadgeType.warning
                    : status == 'Diterima'
                    ? AdminBadgeType.success
                    : status == 'Diproses'
                    ? AdminBadgeType.info
                    : AdminBadgeType.neutral,
              ),
              const SizedBox(width: 12),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: AdminColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              detail,
              style: const TextStyle(
                fontSize: 12.5,
                color: AdminColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          if (isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                AdminButton(
                  label: 'Terima Laporan',
                  icon: Icons.check_rounded,
                  variant: AdminButtonVariant.primary,
                  small: true,
                ),
                const SizedBox(width: 10),
                AdminButton(
                  label: 'Tolak Laporan',
                  icon: Icons.close_rounded,
                  variant: AdminButtonVariant.danger,
                  small: true,
                ),
                const SizedBox(width: 10),
                AdminButton(
                  label: 'Tandai Diproses',
                  icon: Icons.pending_rounded,
                  variant: AdminButtonVariant.outline,
                  small: true,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryBadge(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
