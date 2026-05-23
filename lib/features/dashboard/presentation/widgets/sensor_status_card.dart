import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_entity.dart';

class _StatusInfo {
  final String label;
  final List<Color> gradientColors;
  const _StatusInfo({required this.label, required this.gradientColors});
}

_StatusInfo _statusInfoFor(double persentase) {
  if (persentase >= 80) {
    return const _StatusInfo(
      label: 'Optimal',
      gradientColors: [Color(0xFF72E85A), Color(0xFF4DC934), Color(0xFF2FA010)],
    );
  } else if (persentase >= 60) {
    return const _StatusInfo(
      label: 'Cukup',
      gradientColors: [Color(0xFF72E85A), Color(0xFF4DC934), Color(0xFF2FA010)],
    );
  } else if (persentase >= 40) {
    return const _StatusInfo(
      label: 'Kurang',
      gradientColors: [Color(0xFFFFCC55), Color(0xFFFFAA22), Color(0xFFE07800)],
    );
  } else {
    return const _StatusInfo(
      label: 'Kritis',
      gradientColors: [Color(0xFFFF7A7A), Color(0xFFFF4444), Color(0xFFCC1111)],
    );
  }
}

class SensorStatusCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double persentase;

  const SensorStatusCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.persentase,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    final status = _statusInfoFor(persentase);

    final valueFontSize = (sw / 390 * 30).clamp(22.0, 36.0);
    final unitFontSize = (sw / 390 * 11).clamp(9.0, 14.0);
    final labelFontSize = (sw / 390 * 12).clamp(10.0, 14.0);
    final badgeFontSize = (sw / 390 * 11).clamp(9.0, 13.0);

    return Container(
      height: 201,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/cardsensor-image.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.sensors, size: 22),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: valueFontSize,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        unit,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: unitFontSize,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: labelFontSize,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 34,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: status.gradientColors,
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              status.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: badgeFontSize,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.0,
                shadows: const [
                  Shadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
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

class SensorStatusGrid extends StatefulWidget {
  final List<SensorHealthEntity> sensors;

  final int defaultCount;

  const SensorStatusGrid({
    super.key,
    required this.sensors,
    this.defaultCount = 6,
  });

  @override
  State<SensorStatusGrid> createState() => _SensorStatusGridState();
}

class _SensorStatusGridState extends State<SensorStatusGrid> {
  bool _expanded = false;

  String _labelFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return 'Suhu Udara';
      case 'env_hum':
        return 'Kel. Udara';
      case 'soil_nitro':
        return 'Nitrogen';
      case 'soil_phos':
        return 'Fosfor';
      case 'soil_pot':
        return 'Kalium';
      case 'soil_ph':
        return 'pH Tanah';
      case 'soil_temp':
        return 'Suhu Tanah';
      case 'soil_hum':
        return 'Kel. Tanah';
      default:
        return dsId;
    }
  }

  String _unitFor(String dsId) {
    switch (dsId) {
      case 'env_temp':
      case 'soil_temp':
        return '°C';
      case 'env_hum':
      case 'soil_hum':
        return '%';
      case 'soil_nitro':
      case 'soil_phos':
      case 'soil_pot':
        return 'ppm';
      case 'soil_ph':
        return 'pH';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.sensors.length;
    final showCount = _expanded ? total : total.clamp(0, widget.defaultCount);
    final hasMore = total > widget.defaultCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,

            childAspectRatio: 0.547,
          ),
          itemCount: showCount,
          itemBuilder: (context, i) {
            final sensor = widget.sensors[i];
            return SensorStatusCard(
              label: _labelFor(sensor.dsId),
              value: sensor.readUpdateValue,
              unit: _unitFor(sensor.dsId),
              persentase: sensor.persentase,
            );
          },
        ),

        if (hasMore) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _expanded
                        ? 'Sembunyikan'
                        : 'Lihat ${total - widget.defaultCount} sensor lainnya',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
