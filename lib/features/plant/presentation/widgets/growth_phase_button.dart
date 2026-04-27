import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../phase/presentation/screens/phase_list_screen.dart';

class GrowthPhaseButton extends StatelessWidget {
  final String plantId;
  final String plantName;

  const GrowthPhaseButton({
    super.key,
    required this.plantId,
    required this.plantName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              PhaseListScreen(plantId: plantId, plantName: plantName),
        ),
      ),
      child: Container(
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
              'Growth Phase',
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
