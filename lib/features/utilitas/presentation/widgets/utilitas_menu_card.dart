import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/responsive.dart';

class UtilitasMenuItem {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final Color? color;

  const UtilitasMenuItem({
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.color,
  });
}

class UtilitasMenuCard extends StatelessWidget {
  final UtilitasMenuItem item;

  const UtilitasMenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cardColor = item.color ?? const Color(0xFF1B5E20);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(context.rw(0.04)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: context.rw(0.15).clamp(56.0, 72.0),
                height: context.rw(0.15).clamp(56.0, 72.0),
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    item.iconPath,
                    width: context.rw(0.08).clamp(32.0, 40.0),
                    height: context.rw(0.08).clamp(32.0, 40.0),
                    colorFilter: ColorFilter.mode(cardColor, BlendMode.srcIn),
                  ),
                ),
              ),
              SizedBox(height: context.rh(0.012)),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
