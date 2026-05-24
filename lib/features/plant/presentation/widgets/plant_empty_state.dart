import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';

class PlantEmptyState extends StatelessWidget {
  final VoidCallback onAddPlant;
  final String title;
  final String message;
  final String actionLabel;
  final bool actionEnabled;

  const PlantEmptyState({
    super.key,
    required this.onAddPlant,
    this.title = 'There is no planting yet',
    this.message =
        'Start adding your first experience to start monitoring plants on this site.',
    this.actionLabel = 'Add first planting',
    this.actionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularBackButtonWidget(
                    onPressed: () {},
                    svgIconPath: 'assets/icons/more-icon.svg',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Plants Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1D1D1D),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/plant-filled-icon.svg',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF1D1D1D),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF1D1D1D),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: actionEnabled ? onAddPlant : null,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: actionEnabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        actionLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          color: actionEnabled
                              ? const Color(0xFF1D1D1D)
                              : const Color(0xFF1D1D1D).withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
