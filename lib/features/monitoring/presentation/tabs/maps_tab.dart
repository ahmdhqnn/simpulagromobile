import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../data/models/monitoring_models.dart';
import '../providers/monitoring_provider.dart';

class MapsTab extends ConsumerStatefulWidget {
  const MapsTab({super.key});

  @override
  ConsumerState<MapsTab> createState() => _MapsTabState();
}

class _MapsTabState extends ConsumerState<MapsTab> {
  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(devicesProvider);
    final selectedSite = ref.watch(selectedSiteProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(devicesProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(0.051),
          vertical: context.rh(0.015),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            devicesAsync.when(
              data: (devices) => _StatsBar(devices: devices),
              loading: () => _shimmerCard(context, 70),
              error: (_, __) => const SizedBox.shrink(),
            ),

            SizedBox(height: context.rh(0.024)),

            _SectionTitle('Maps'),
            SizedBox(height: context.rh(0.014)),

            devicesAsync.when(
              loading: () => _shimmerCard(context, 195),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(devicesProvider),
              ),
              data: (devices) {
                if (devices.isEmpty) {
                  return _EmptyStateCard(
                    height: 195,
                    message: 'Belum ada lokasi device untuk ditampilkan',
                    iconPath: 'assets/icons/maps-dot-filled-icon.svg',
                  );
                }
                final lat =
                    selectedSite?.siteLat ??
                    (devices.isNotEmpty ? devices.first.devLat : null) ??
                    -6.9731;
                final lon =
                    selectedSite?.siteLon ??
                    (devices.isNotEmpty ? devices.first.devLon : null) ??
                    107.6338;
                return _MapView(
                  centerLat: lat,
                  centerLon: lon,
                  devices: devices,
                );
              },
            ),

            SizedBox(height: context.rh(0.024)),

            _SectionTitle('Daftar Device & Sensor'),
            SizedBox(height: context.rh(0.014)),

            devicesAsync.when(
              loading: () => _shimmerCard(context, 73),
              error: (_, __) => const SizedBox.shrink(),
              data: (devices) => devices.isEmpty
                  ? _EmptyStateCard(
                      height: 73,
                      message: 'Belum ada device tersedia',
                      iconPath: 'assets/icons/device-filled-icon.svg',
                    )
                  : _DeviceList(devices: devices),
            ),

            SizedBox(height: context.rh(0.02)),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(22),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1D1D1D),
        height: 1.0,
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final List<DeviceModel> devices;
  const _StatsBar({required this.devices});

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/device-filled-icon.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: context.rh(0.005)),
              Text(
                'Belum ada statistik device',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D),
                  height: 1.83,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final totalSensors = devices.fold<int>(
      0,
      (sum, d) => sum + d.sensors.length,
    );
    final activeDevices = devices.where((d) => d.isActive).length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
            icon: 'assets/icons/device-filled-icon.svg',
            label: 'Device',
            value: '${devices.length}',
            color: const Color(0xFFE8EFE9),
            spacing: 4,
          ),
          _StatItem(
            icon: 'assets/icons/sensor-icon.svg',
            label: 'Sensor',
            value: '$totalSensors',
            color: const Color(0xFFECF6FE),
            spacing: 2,
          ),
          _StatItem(
            icon: 'assets/icons/check-icon.svg',
            label: 'Aktif',
            value: '$activeDevices',
            color: const Color(0xFFEDF7EE),
            spacing: 3,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final double spacing;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.only(
            top: 11,
            left: 10,
            right: 10,
            bottom: 9,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(_getIconColor(), BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(width: 11),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1D),
                height: 1.0,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getIconColor() {
    if (icon.contains('device-filled-icon')) {
      return const Color(0xFF1B5E20);
    } else if (icon.contains('sensor-icon')) {
      return const Color(0xFF42A5F5);
    } else if (icon.contains('check-icon')) {
      return const Color(0xFF4CAF50);
    }
    return const Color(0xFF1D1D1D);
  }
}

class _MapView extends StatefulWidget {
  final double centerLat;
  final double centerLon;
  final List<DeviceModel> devices;

  const _MapView({
    required this.centerLat,
    required this.centerLon,
    required this.devices,
  });

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadHtmlString(_buildHtml());
  }

  String _buildHtml() {
    final markers = widget.devices
        .map((d) {
          if (d.devLat == null || d.devLon == null) return '';
          final label = d.devName ?? d.devId;
          final status = d.isActive ? '#4CAF50' : '#9E9E9E';
          return '''
        L.circleMarker([${d.devLat}, ${d.devLon}], {
          radius: 10,
          fillColor: '$status',
          color: '#fff',
          weight: 2,
          opacity: 1,
          fillOpacity: 0.9
        }).addTo(map).bindPopup('<b>$label</b><br>${d.devLocation ?? ''}<br>${d.sensors.length} sensor');
      ''';
        })
        .join('\n');

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    body { margin: 0; padding: 0; }
    #map { width: 100%; height: 100vh; }
  </style>
</head>
<body>
  <div id="map"></div>
  <script>
    var map = L.map('map').setView([${widget.centerLat}, ${widget.centerLon}], 15);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    $markers
  </script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  final List<DeviceModel> devices;
  const _DeviceList({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: devices.map((d) => _DeviceCard(device: d)).toList(),
    );
  }
}

class _DeviceCard extends StatefulWidget {
  final DeviceModel device;
  const _DeviceCard({required this.device});

  @override
  State<_DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<_DeviceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.device;
    return Container(
      margin: EdgeInsets.only(bottom: context.rh(0.012)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.031),
                vertical: context.rh(0.015),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EFE9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/device-filled-icon.svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1B5E20),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(width: context.rw(0.02)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.devName ?? d.devId,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(22),
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF1D1D1D),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: context.rh(0.002)),
                          Text(
                            d.devLocation ?? 'Lokasi tidak diketahui',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(11),
                              fontWeight: FontWeight.w400,
                              color: const Color(
                                0xFF1D1D1D,
                              ).withValues(alpha: 0.6),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: d.isActive
                              ? const Color(0xFFEDF7EE)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          d.isActive ? 'Aktif' : 'Offline',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w500,
                            color: d.isActive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF9E9E9E),
                            height: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(width: context.rw(0.02)),
                      SvgPicture.asset(
                        _expanded
                            ? 'assets/icons/chevron-down-icon.svg'
                            : 'assets/icons/chevron-right-icon.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_expanded && d.sensors.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.012),
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Column(
                children: d.sensors.map((s) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: context.rh(0.008)),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/sensor-icon.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF42A5F5),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: context.rw(0.025)),
                        Expanded(
                          child: Text(
                            s.sensName ?? s.sensId,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(12),
                              color: const Color(0xFF1D1D1D),
                            ),
                          ),
                        ),
                        Text(
                          s.sensAddress ?? '',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(11),
                            color: const Color(
                              0xFF1D1D1D,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final double height;
  final String message;
  final String? iconPath;

  const _EmptyStateCard({
    required this.height,
    required this.message,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath ?? 'assets/icons/device-filled-icon.svg',
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                const Color(0xFF1D1D1D).withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: context.rh(0.005)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1D1D1D),
                height: 1.83,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 28),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(12),
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
