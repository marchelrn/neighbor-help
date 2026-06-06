import 'package:flutter/material.dart';
import 'package:radius/screens/admin/admin_colors.dart';

// ─────────────────────────────────────────────
// STAT CARD
// ─────────────────────────────────────────────
class AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color softColor;
  final String? trend;
  final bool trendUp;

  const AdminStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.softColor,
    this.trend,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: softColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? AdminColors.successSoft
                        : AdminColors.errorSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trendUp
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 12,
                        color: trendUp
                            ? AdminColors.success
                            : AdminColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: trendUp
                              ? AdminColors.success
                              : AdminColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AdminColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AdminColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────
class AdminStatusBadge extends StatelessWidget {
  final String label;
  final AdminBadgeType type;

  const AdminStatusBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case AdminBadgeType.success:
        bg = AdminColors.successSoft;
        fg = AdminColors.success;
        break;
      case AdminBadgeType.warning:
        bg = AdminColors.warningSoft;
        fg = AdminColors.warning;
        break;
      case AdminBadgeType.error:
        bg = AdminColors.errorSoft;
        fg = AdminColors.error;
        break;
      case AdminBadgeType.info:
        bg = AdminColors.infoSoft;
        fg = AdminColors.info;
        break;
      case AdminBadgeType.neutral:
        bg = AdminColors.borderLight;
        fg = AdminColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

enum AdminBadgeType { success, warning, error, info, neutral }

// ─────────────────────────────────────────────
// SECTION CARD
// ─────────────────────────────────────────────
class AdminSectionCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets? padding;

  const AdminSectionCard({
    super.key,
    required this.title,
    this.trailing,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.textPrimary,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Padding(padding: padding ?? const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SEARCH BAR
// ─────────────────────────────────────────────
class AdminSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final double? width;

  const AdminSearchBar({
    super.key,
    required this.hint,
    this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 280,
      height: 40,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13.5, color: AdminColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 13.5,
            color: AdminColors.textLight,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 18,
            color: AdminColors.textLight,
          ),
          filled: true,
          fillColor: AdminColors.surfaceAlt,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AdminColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AdminColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AdminColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACTION BUTTON
// ─────────────────────────────────────────────
class AdminButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final AdminButtonVariant variant;
  final bool small;

  const AdminButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.variant = AdminButtonVariant.primary,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (variant) {
      case AdminButtonVariant.primary:
        bg = AdminColors.primary;
        fg = Colors.white;
        border = AdminColors.primary;
        break;
      case AdminButtonVariant.danger:
        bg = AdminColors.error;
        fg = Colors.white;
        border = AdminColors.error;
        break;
      case AdminButtonVariant.outline:
        bg = Colors.white;
        fg = AdminColors.textPrimary;
        border = AdminColors.border;
        break;
      case AdminButtonVariant.ghost:
        bg = AdminColors.primarySoft;
        fg = AdminColors.primary;
        border = AdminColors.primarySoft;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? 12 : 16,
          vertical: small ? 7 : 10,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: small ? 14 : 16, color: fg),
              SizedBox(width: small ? 5 : 7),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: small ? 12.5 : 13.5,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AdminButtonVariant { primary, danger, outline, ghost }

// ─────────────────────────────────────────────
// MINI BAR CHART
// ─────────────────────────────────────────────
class AdminMiniBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color barColor;
  final double height;

  const AdminMiniBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.barColor = AdminColors.primary,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height + 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final ratio = maxVal > 0 ? values[i] / maxVal : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height * ratio,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
                    style: const TextStyle(
                      fontSize: 10,
                      color: AdminColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACTIVITY ITEM
// ─────────────────────────────────────────────
class AdminActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String time;

  const AdminActivityItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
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
}

// ─────────────────────────────────────────────
// PAGE HEADER
// ─────────────────────────────────────────────
class AdminPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? actions;

  const AdminPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AdminColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AdminColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (actions != null) Row(children: actions!),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// FILTER CHIP ROW
// ─────────────────────────────────────────────
class AdminFilterChips extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String initial;

  const AdminFilterChips({
    super.key,
    required this.options,
    required this.onSelected,
    required this.initial,
  });

  @override
  State<AdminFilterChips> createState() => _AdminFilterChipsState();
}

class _AdminFilterChipsState extends State<AdminFilterChips> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.options.map((opt) {
        final isSelected = selected == opt;
        return GestureDetector(
          onTap: () {
            setState(() => selected = opt);
            widget.onSelected(opt);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected ? AdminColors.primary : AdminColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AdminColors.primary : AdminColors.border,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AdminColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
