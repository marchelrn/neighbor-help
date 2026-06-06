import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';

class AdminRequestsPage extends StatefulWidget {
  const AdminRequestsPage({super.key});

  @override
  State<AdminRequestsPage> createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  String _filter = 'Semua';
  int? _selected;

  final List<Map<String, dynamic>> _requests = [
    {
      'title': 'Butuh bantuan angkat galon ke lantai 2',
      'user': 'Andi Firmansyah',
      'area': 'Malalayang',
      'category': 'Fisik',
      'status': 'Aktif',
      'distance': '120m',
      'time': '5 mnt lalu',
      'helpers': 1,
      'description':
          'Perlu 2-3 orang untuk membantu angkat galon air bersih ke lantai 2 rumah. Galon berjumlah 3 buah, tersedia minuman sebagai balas budi.',
      'duration': '±1 jam',
      'urgent': true,
    },
    {
      'title': 'Pinjam tangga untuk ganti lampu',
      'user': 'Siti Rahayu',
      'area': 'Tikala',
      'category': 'Peralatan',
      'status': 'Dalam Proses',
      'distance': '200m',
      'time': '12 mnt lalu',
      'helpers': 1,
      'description':
          'Membutuhkan pinjaman tangga lipat untuk mengganti lampu plafon yang mati. Estimasi penggunaan 30 menit.',
      'duration': '±30 mnt',
      'urgent': false,
    },
    {
      'title': 'Bantuan pindahan minggu depan',
      'user': 'Budi Santoso',
      'area': 'Wenang',
      'category': 'Fisik',
      'status': 'Selesai',
      'distance': '350m',
      'time': '1 jam lalu',
      'helpers': 3,
      'description':
          'Membutuhkan bantuan untuk memindahkan perabotan rumah ke lokasi baru yang berjarak 2 km.',
      'duration': '±4 jam',
      'urgent': false,
    },
    {
      'title': 'Pasang TV di dinding',
      'user': 'Grace Tampi',
      'area': 'Sario',
      'category': 'Teknis',
      'status': 'Aktif',
      'distance': '450m',
      'time': '2 jam lalu',
      'helpers': 0,
      'description':
          'Butuh bantuan untuk memasang bracket dan TV LED 43 inch di dinding ruang tamu.',
      'duration': '±2 jam',
      'urgent': false,
    },
    {
      'title': 'Ibu Lisa butuh bantuan sekarang!',
      'user': 'Lisa Pangemanan',
      'area': 'Tuminting',
      'category': 'Darurat',
      'status': 'Aktif',
      'distance': '50m',
      'time': '3 mnt lalu',
      'helpers': 2,
      'description':
          'Ibu Lisa mengalami kecelakaan ringan di rumah, butuh bantuan untuk diantarkan ke klinik terdekat.',
      'duration': 'Segera',
      'urgent': true,
    },
    {
      'title': 'Pinjam mesin jahit',
      'user': 'Dewi Kusuma',
      'area': 'Bunaken',
      'category': 'Peralatan',
      'status': 'Dibatalkan',
      'distance': '300m',
      'time': '1 hari lalu',
      'helpers': 0,
      'description':
          'Perlu pinjam mesin jahit untuk memperbaiki beberapa pakaian.',
      'duration': '±2 hari',
      'urgent': false,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'Semua') return _requests;
    return _requests.where((r) => r['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: _selected != null ? 3 : 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminPageHeader(
                  title: 'Kelola Permintaan Bantuan',
                  subtitle: '${_requests.length} total permintaan',
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    AdminFilterChips(
                      options: const [
                        'Semua',
                        'Aktif',
                        'Dalam Proses',
                        'Selesai',
                        'Dibatalkan',
                      ],
                      initial: _filter,
                      onSelected: (v) => setState(() {
                        _filter = v;
                        _selected = null;
                      }),
                    ),
                    const Spacer(),
                    const AdminSearchBar(hint: 'Cari permintaan...'),
                  ],
                ),
                const SizedBox(height: 16),

                _buildRequestList(),
              ],
            ),
          ),
        ),

        if (_selected != null)
          Container(
            width: 340,
            decoration: const BoxDecoration(
              color: AdminColors.surface,
              border: Border(left: BorderSide(color: AdminColors.border)),
            ),
            child: _buildDetail(_filtered[_selected!]),
          ),
      ],
    );
  }

  Widget _buildRequestList() {
    return Column(
      children: List.generate(_filtered.length, (i) {
        final r = _filtered[i];
        final isSelected = _selected == i;
        return GestureDetector(
          onTap: () => setState(() => _selected = isSelected ? null : i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AdminColors.primarySoft : AdminColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AdminColors.primaryLight
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
            child: Row(
              children: [
                // Category icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _categoryColor(r['category'])['soft'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _categoryIcon(r['category']),
                    size: 18,
                    color: _categoryColor(r['category'])['main'],
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (r['urgent'] == true) ...[
                            const AdminStatusBadge(
                              label: 'URGENT',
                              type: AdminBadgeType.error,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              r['title'],
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            r['user'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: AdminColors.textLight,
                          ),
                          Text(
                            r['area'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AdminColors.textLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '· ${r['time']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AdminColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AdminStatusBadge(
                      label: r['status'],
                      type: _statusType(r['status']),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${r['helpers']} helper',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AdminColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDetail(Map<String, dynamic> r) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detail Permintaan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => setState(() => _selected = null),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AdminColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (r['urgent'] == true) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AdminColors.errorSoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: AdminColors.error,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Permintaan Darurat',
                    style: TextStyle(
                      color: AdminColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          Text(
            r['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AdminColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          AdminStatusBadge(label: r['status'], type: _statusType(r['status'])),
          const SizedBox(height: 16),

          const Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AdminColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            r['description'],
            style: const TextStyle(
              fontSize: 13,
              color: AdminColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          Container(height: 1, color: AdminColors.border),
          const SizedBox(height: 14),

          _detailRow(Icons.person_rounded, 'Pembuat', r['user']),
          _detailRow(
            Icons.location_on_rounded,
            'Area',
            '${r['area']} (${r['distance']})',
          ),
          _detailRow(Icons.category_rounded, 'Kategori', r['category']),
          _detailRow(Icons.access_time_rounded, 'Durasi', r['duration']),
          _detailRow(
            Icons.people_rounded,
            'Jumlah Helper',
            '${r['helpers']} orang',
          ),
          _detailRow(Icons.schedule_rounded, 'Diposting', r['time']),
          const SizedBox(height: 20),

          const Text(
            'Update Status',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AdminColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Aktif', 'Dalam Proses', 'Selesai', 'Dibatalkan'].map((
              s,
            ) {
              return AdminButton(
                label: s,
                small: true,
                variant: r['status'] == s
                    ? AdminButtonVariant.primary
                    : AdminButtonVariant.outline,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          Container(height: 1, color: AdminColors.border),
          const SizedBox(height: 14),

          AdminButton(
            label: 'Hapus Permintaan',
            icon: Icons.delete_outline_rounded,
            variant: AdminButtonVariant.danger,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AdminColors.textLight),
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

  Map<String, dynamic> _categoryColor(String cat) {
    switch (cat) {
      case 'Darurat':
        return {'main': AdminColors.error, 'soft': AdminColors.errorSoft};
      case 'Fisik':
        return {'main': AdminColors.primary, 'soft': AdminColors.primarySoft};
      case 'Peralatan':
        return {'main': AdminColors.info, 'soft': AdminColors.infoSoft};
      default:
        return {'main': AdminColors.warning, 'soft': AdminColors.warningSoft};
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Darurat':
        return Icons.emergency_rounded;
      case 'Fisik':
        return Icons.fitness_center_rounded;
      case 'Peralatan':
        return Icons.build_rounded;
      default:
        return Icons.settings_rounded;
    }
  }

  AdminBadgeType _statusType(String s) {
    switch (s) {
      case 'Aktif':
        return AdminBadgeType.warning;
      case 'Dalam Proses':
        return AdminBadgeType.info;
      case 'Selesai':
        return AdminBadgeType.success;
      case 'Dibatalkan':
        return AdminBadgeType.error;
      default:
        return AdminBadgeType.neutral;
    }
  }
}
