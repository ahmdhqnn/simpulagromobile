import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/l10n.dart';

class SmartScoreGauge extends StatelessWidget {
  const SmartScoreGauge({
    super.key,
    required this.score,
    this.totalSensors = 0,
    this.statusLabel = 'Perlu Perhatian',
    this.statusColor = AppColors.healthStatusCritical,
    this.statusIcon = Icons.warning_amber_rounded,
    this.statusIconSize = 14,
  });

  final double score;
  final int totalSensors;
  final String statusLabel;
  final Color statusColor;
  final IconData statusIcon;
  final double statusIconSize;

  @override
  Widget build(BuildContext context) {
    final percentage = score.clamp(0, 100) / 100;
    final sw = MediaQuery.sizeOf(context).width;

    final gaugeW = (sw * 0.44).clamp(140.0, 180.0);
    final gaugeH = gaugeW * (95.5 / 171);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: gaugeW,
          height: gaugeH + 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: CustomPaint(
                  size: Size(gaugeW, gaugeH),
                  painter: _GaugePainter(percentage: percentage),
                ),
              ),

              Positioned(
                top: gaugeH * 0.38,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: score.toStringAsFixed(0),
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: sw / 390 * 44,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              height: 1.0,
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.top,
                            child: Transform.translate(
                              offset: const Offset(2, -12),
                              child: Text(
                                '%',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: sw / 390 * 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: gaugeW,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          context.l10n.dashboardActiveSensorsCount(
                            totalSensors,
                          ),
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: sw / 390 * 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.15),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusLabel,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: sw / 390 * 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                statusIcon,
                size: statusIconSize,
                color: statusColor,
                shadows: [
                  Shadow(
                    color: statusColor.withValues(alpha: 0.6),
                    blurRadius: 6,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.percentage});

  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const double trackWidth = 11;
    const double progressWidth = 11;
    const double auraMultiplier = 2.2;

    final backgroundRadius = radius - (trackWidth / 2);
    final backgroundRect = Rect.fromCircle(
      center: center,
      radius: backgroundRadius,
    );
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF7AD3FF), Color(0x1AE6C9FF), Color(0x00FFFFFF)],
        stops: [0.0, 0.65, 1.0],
      ).createShader(backgroundRect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, backgroundRadius, backgroundPaint);

    final auraPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x337AD3FF), Color(0x1AE6C9FF), Color(0x00FFFFFF)],
        stops: [0.0, 0.6, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth * auraMultiplier
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, pi, false, auraPaint);

    final trackPaint = Paint()
      ..color = const Color(0xFFE6C9FF).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, pi, false, trackPaint);

    final glowPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF7AD3FF), Color(0xFFE6C9FF)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = progressWidth * 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, pi * percentage, false, glowPaint);

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF7AD3FF), Color(0xFFE6C9FF)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = progressWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, pi * percentage, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}
