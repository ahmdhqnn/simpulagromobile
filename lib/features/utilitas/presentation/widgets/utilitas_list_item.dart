import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';

/// List item card untuk semua modul Utilitas
/// Design mengikuti phase_list_screen.dart & agro_indicator_screen.dart
class UtilitasListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final bool isActive;
  final VoidCallback onTap;
  final List<Widget>? badges;

  const UtilitasListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.isActive = true,
    required this.onTap,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor =
        iconColor ?? (isActive ? const Color(0xFF1B5E20) : Colors.grey);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: effectiveIconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: effectiveIconColor, size: 22),
                  ),
                  SizedBox(width: context.rw(0.03)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D1D1D),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w300,
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.5),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                    size: 20,
                  ),
                ],
              ),
              if (badges != null && badges!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 6, children: badges!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge widget untuk list items
class UtilitasBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const UtilitasBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(11),
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
