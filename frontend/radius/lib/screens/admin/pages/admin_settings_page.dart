import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';
import 'package:radius/screens/admin/admin_widgets.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  double _radius = 500;
  bool _notifEnabled = true;
  bool _notifEmail = true;
  bool _notifDesktop = true;
  bool _notifUrgent = true;
  bool _maintenanceMode = false;
  bool _autoModerate = false;
  bool _repSystem = true;
  String _theme = 'Terang';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminPageHeader(
            title: 'Pengaturan Aplikasi',
            subtitle: 'Konfigurasi sistem dan preferensi aplikasi',
          ),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  children: [
                    // App Settings
                    AdminSectionCard(
                      title: 'Pengaturan Umum',
                      child: Column(
                        children: [
                          _settingRow(
                            'Nama Aplikasi',
                            child: _textField('NeighborHelp'),
                          ),
                          _divider(),
                          _settingRow(
                            'Versi Aplikasi',
                            child: _readOnly('v1.2.0'),
                          ),
                          _divider(),
                          _settingRow(
                            'Mode Tampilan',
                            child: _dropdown(_theme, [
                              'Terang',
                              'Gelap',
                              'Sistem',
                            ], (v) => setState(() => _theme = v)),
                          ),
                          _divider(),
                          _settingRow(
                            'Mode Pemeliharaan',
                            subtitle: 'Nonaktifkan akses pengguna sementara',
                            child: _toggle(
                              _maintenanceMode,
                              (v) => setState(() => _maintenanceMode = v),
                            ),
                          ),
                          _divider(),
                          _settingRow(
                            'Moderasi Otomatis',
                            subtitle:
                                'Filter konten dengan AI sebelum dipublikasi',
                            child: _toggle(
                              _autoModerate,
                              (v) => setState(() => _autoModerate = v),
                            ),
                          ),
                          _divider(),
                          _settingRow(
                            'Sistem Reputasi',
                            subtitle: 'Aktifkan poin dan badge untuk helper',
                            child: _toggle(
                              _repSystem,
                              (v) => setState(() => _repSystem = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Danger zone
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AdminColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AdminColors.error.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                                color: AdminColors.error,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Zona Bahaya',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.error,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tindakan berikut tidak dapat dibatalkan.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _dangerAction(
                            'Reset Semua Data Reputasi',
                            'Menghapus semua log bantuan dan poin reputasi',
                          ),
                          const SizedBox(height: 10),
                          _dangerAction(
                            'Hapus Semua Request Lama',
                            'Hapus request yang sudah selesai lebih dari 30 hari',
                          ),
                          const SizedBox(height: 10),
                          _dangerAction(
                            'Reset Pengaturan ke Default',
                            'Kembalikan semua pengaturan ke nilai awal',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Right column
              Expanded(
                child: Column(
                  children: [
                    // Radius Settings
                    AdminSectionCard(
                      title: 'Pengaturan Radius Bantuan',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Radius default',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AdminColors.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AdminColors.primarySoft,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${_radius.round()} m',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AdminColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AdminColors.primary,
                              inactiveTrackColor: AdminColors.borderLight,
                              thumbColor: AdminColors.primary,
                              overlayColor: AdminColors.primarySoft,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                              trackHeight: 5,
                            ),
                            child: Slider(
                              value: _radius,
                              min: 100,
                              max: 2000,
                              divisions: 19,
                              onChanged: (v) => setState(() => _radius = v),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '100m',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AdminColors.textLight,
                                ),
                              ),
                              const Text(
                                '2000m',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AdminColors.textLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AdminColors.infoSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  size: 15,
                                  color: AdminColors.info,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Radius ini berlaku untuk semua notifikasi dan feed. Pengguna dapat mengatur radius pribadi mereka hingga batas ini.',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AdminColors.info,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AdminButton(label: 'Simpan Pengaturan Radius'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notification Settings
                    AdminSectionCard(
                      title: 'Pengaturan Notifikasi',
                      child: Column(
                        children: [
                          _settingRow(
                            'Aktifkan Notifikasi',
                            subtitle: 'Izinkan sistem mengirim notifikasi',
                            child: _toggle(
                              _notifEnabled,
                              (v) => setState(() => _notifEnabled = v),
                            ),
                          ),
                          _divider(),
                          _settingRow(
                            'Notifikasi Email',
                            subtitle: 'Kirim ringkasan harian ke email admin',
                            child: _toggle(
                              _notifEmail,
                              (v) => setState(() => _notifEmail = v),
                            ),
                          ),
                          _divider(),
                          _settingRow(
                            'Notifikasi Desktop',
                            subtitle: 'Push notification ke system tray',
                            child: _toggle(
                              _notifDesktop,
                              (v) => setState(() => _notifDesktop = v),
                            ),
                          ),
                          _divider(),
                          _settingRow(
                            'Prioritaskan Darurat',
                            subtitle:
                                'Notifikasi langsung untuk request urgent',
                            child: _toggle(
                              _notifUrgent,
                              (v) => setState(() => _notifUrgent = v),
                            ),
                          ),
                          _divider(),
                          _settingRow(
                            'Email Admin',
                            child: _textField('admin@radius.id'),
                          ),
                          const SizedBox(height: 16),
                          AdminButton(label: 'Simpan Pengaturan Notifikasi'),
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

  Widget _settingRow(String label, {String? subtitle, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _toggle(bool val, ValueChanged<bool> onChanged) {
    return Switch(
      value: val,
      onChanged: onChanged,
      activeColor: AdminColors.primary,
      activeTrackColor: AdminColors.primaryLight,
    );
  }

  Widget _textField(String initial) {
    return SizedBox(
      width: 200,
      height: 36,
      child: TextFormField(
        initialValue: initial,
        style: const TextStyle(fontSize: 13, color: AdminColors.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: AdminColors.surfaceAlt,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AdminColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AdminColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AdminColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _readOnly(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AdminColors.borderLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          color: AdminColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dropdown(
    String current,
    List<String> options,
    ValueChanged<String> onChange,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: AdminColors.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdminColors.border),
      ),
      child: DropdownButton<String>(
        value: current,
        underline: const SizedBox(),
        style: const TextStyle(fontSize: 13, color: AdminColors.textPrimary),
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (v) {
          if (v != null) onChange(v);
        },
      ),
    );
  }

  Widget _divider() => Container(height: 1, color: AdminColors.borderLight);

  Widget _dangerAction(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: Border.all(color: AdminColors.error.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.error,
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
          AdminButton(
            label: 'Eksekusi',
            variant: AdminButtonVariant.danger,
            small: true,
          ),
        ],
      ),
    );
  }
}
