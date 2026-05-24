import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../agro/presentation/screens/agro_indicator_screen.dart';

class AgroIndicatorButton extends StatelessWidget {
  const AgroIndicatorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AgroIndicatorScreen())),
      child: Container(
        width: 130,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Agro Indicator',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.8,
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/icons/arrow-up-right-long-outline-icon.svg',
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
