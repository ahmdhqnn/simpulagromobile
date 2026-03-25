import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgroIndicatorButton extends StatelessWidget {
  const AgroIndicatorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
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
          SvgPicture.asset('assets/icons/chevron-right-icon.svg', width: 16),
        ],
      ),
    );
  }
}
