import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // =========================
              // 🔥 PROFILE HEADER
              // =========================
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?img=3",
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Budi Santoso",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      SizedBox(width: 4),
                      Text("4.8 • Top Helper"),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // =========================
              // 🔥 ANIMATED STATS
              // =========================
              Row(
                children: const [
                  Expanded(
                    child: AnimatedProfileStat(value: 23, label: "Bantuan"),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AnimatedProfileStat(value: 12, label: "Request"),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AnimatedProfileStat(
                      value: 4.8,
                      label: "Rating",
                      isDecimal: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // =========================
              // 🔥 LEVEL CARD
              // =========================
              const _ReputationCard(),

              const SizedBox(height: 24),

              // =========================
              // 🔥 INSIGHT CARD
              // =========================
              const _ProfileInsight(),

              const SizedBox(height: 24),

              // =========================
              // 🔥 MENU
              // =========================
              _MenuItem(Icons.edit, "Edit Profil"),
              _MenuItem(Icons.history, "Riwayat Bantuan"),
              _MenuItem(Icons.settings, "Pengaturan"),
              _MenuItem(Icons.logout, "Keluar", isLogout: true),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🔥 ANIMATED PROFILE STAT
//
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
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.12),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  color: AppColors.primary.withOpacity(0.15),
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

class _ReputationCard extends StatelessWidget {
  const _ReputationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        // 🔥 premium gradient
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: AppColors.primary.withOpacity(0.25),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 TITLE
          Row(
            children: const [
              Icon(Icons.verified, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Reputasi Kamu",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 🔥 MAIN STATUS
          const Text(
            "Top Helper 🔥",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Kamu berada di top 20% pengguna paling aktif di area kamu",
            style: TextStyle(color: Colors.white70, height: 1.3),
          ),

          const SizedBox(height: 16),

          // 🔥 METRICS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _ReputationMetric(label: "Respons", value: "Cepat"),
              _ReputationMetric(label: "Rating", value: "4.8"),
              _ReputationMetric(label: "Kepercayaan", value: "Tinggi"),
            ],
          ),
        ],
      ),
    );
  }
}

//
// 🔥 SMALL METRIC
//
class _ReputationMetric extends StatelessWidget {
  final String label;
  final String value;

  const _ReputationMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

//
// 🔥 PROFILE INSIGHT
//
class _ProfileInsight extends StatelessWidget {
  const _ProfileInsight();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        // 🔥 softer glass effect
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.primary.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        border: Border.all(color: AppColors.primary.withOpacity(0.15)),

        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 TITLE
          Row(
            children: const [
              Icon(Icons.insights, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                "Performa Kamu",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 🔥 MINI STATS (MORE SPACED)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _MiniInsight(
                icon: Icons.volunteer_activism,
                value: "3",
                label: "Minggu ini",
              ),
              _MiniInsight(
                icon: Icons.schedule,
                value: "2 jam",
                label: "Aktif",
              ),
              _MiniInsight(
                icon: Icons.trending_up,
                value: "+0.2",
                label: "Rating",
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔥 CLEAN CENTERED BADGE (FIXED)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Top 20% pengguna",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// 🔥 MINI INSIGHT ITEM
//
class _MiniInsight extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniInsight({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

//
// 🔥 MENU ITEM
//
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;

  const _MenuItem(this.icon, this.title, {this.isLogout = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: Colors.white,
        leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {},
      ),
    );
  }
}
