import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import '../utils/storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? currentUser;
  bool isLoading = true;
  int totalRequests = 0;
  int totalResolved = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final token = await StorageService.getToken();
      if (token != null) {
        final results = await Future.wait([
          AuthService.getCurrentUser(token),
          AuthService.getMyHelpRequests(token),
        ]);
        final user = results[0] as Map<String, dynamic>;
        final helpRequests = results[1] as List<Map<String, dynamic>>;
        final resolved = helpRequests
            .where((r) => r['status'] == 'resolved')
            .length;
        setState(() {
          currentUser = user;
          totalRequests = helpRequests.length;
          totalResolved = resolved;
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil data user: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = currentUser?["full_name"] ?? "Loading...";

    return SafeArea(
      child: Container(
        color: AppColors.background,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // profile header
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Text(
                              fullName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedProfileStat(
                            value: totalResolved.toDouble(),
                            label: "Bantuan",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedProfileStat(
                            value: totalRequests.toDouble(),
                            label: "Request",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const SizedBox(height: 24),

                    const SizedBox(height: 24),

                    _MenuItem(Icons.edit, "Edit Profil", onTap: _showEditProfileDialog),
                    // _MenuItem(Icons.history, "Riwayat Bantuan"),
                    // _MenuItem(Icons.settings, "Pengaturan"),
                    // _MenuItem(Icons.logout, "Keluar", isLogout: true),
                  ],
                ),
              ),
      ),
    );
  }
  void _showEditProfileDialog() {
    if (currentUser == null) return;

    final fullNameController = TextEditingController(text: currentUser!['full_name']);
    final addressController = TextEditingController(text: currentUser!['address']);

    showDialog(
      context: context,
      builder: (context) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Edit Profil'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat / Area',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setDialogState(() => isSaving = true);
                          try {
                            final token = await StorageService.getToken();
                            if (token != null) {
                              await AuthService.updateUser(
                                token,
                                currentUser!['username'],
                                {
                                  'full_name': fullNameController.text,
                                  'address': addressController.text,
                                },
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Profil berhasil diperbarui')),
                                );
                                _loadUser(); // Reload data
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal memperbarui profil: $e')),
                              );
                            }
                          } finally {
                            setDialogState(() => isSaving = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class AnimatedProfileStat extends StatefulWidget {
  final double value;
  final String label;
  final bool isDecimal;

  const AnimatedProfileStat({
    super.key,
    required this.value,
    required this.label,
    this.isDecimal = false,
  });

  @override
  State<AnimatedProfileStat> createState() => _AnimatedProfileStatState();
}

class _AnimatedProfileStatState extends State<AnimatedProfileStat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final displayValue = widget.isDecimal
              ? _animation.value.toStringAsFixed(1)
              : _animation.value.toInt().toString();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem(this.icon, this.title, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: Colors.white,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}
