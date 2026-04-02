import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        child: Column(
          children: [
            // ─── Stats Bar ─────────────────────────────────
            devicesAsync.when(
              data: (devices) => _StatsBar(devices: devices),
              loading: () => _shimmerBar(context),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // ─── Map View ──────────────────────────────────
            devicesAsync.when(
              loading: () => SizedBox(
                height: context.rh(0.45),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (e, _) => _ErrorCard(
                message: e.toString(),
                onRetry: () => ref.invalidate(devicesProvider),
              ),
              data: (devices) {
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

            // ─── Device List ───────────────────────────────
            Padding(
              padding: EdgeInsets.all(context.rw(0.051)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Device & Sensor',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.rh(0.015)),
                  devicesAsync.when(
                    loading: () => _shimmerList(context),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (devices) => devices.isEmpty
                        ? _EmptyCard(message: 'Belum ada device')
                        : _DeviceList(devices: devices),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBar(BuildContext context) {
    return Container(height: 72, color: AppColors.surfaceVariant);
  }

  Widget _shimmerList(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

// ─── Stats Bar ────────────────────────────────────────────
class _StatsBar extends StatelessWidget {
  final List<DeviceModel> devices;
  const _StatsBar({required this.devices});

  @override
  Widget build(BuildContext context) {
    final totalSensors = devices.fold<int>(
      0,
      (sum, d) => sum + d.sensors.length,
    );
    final activeDevices = devices.where((d) => d.isActive).length;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.02),
      ),
      color: AppColors.surface,
      child: Row(
        children: [
          _StatItem(
            icon: Icons.devices_rounded,
            label: 'Total Device',
            value: '${devices.length}',
            color: AppColors.primary,
          ),
          _divider(),
          _StatItem(
            icon: Icons.sensors_rounded,
            label: 'Total Sensor',
            value: '$totalSensors',
            color: AppColors.info,
          ),
          _divider(),
          _StatItem(
            icon: Icons.check_circle_outline_rounded,
            label: 'Aktif',
            value: '$activeDevices',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 40,
    color: AppColors.divider,
    margin: const EdgeInsets.symmetric(horizontal: 16),
  );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(10),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Map View (OpenStreetMap via WebView) ─────────────────
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
    return SizedBox(
      height: context.rh(0.45),
      child: WebViewWidget(controller: _controller),
    );
  }
}

// ─── Device List ──────────────────────────────────────────
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // Device header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(context.rw(0.041)),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: d.isActive
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.router_rounded,
                      size: 20,
                      color: d.isActive
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                  ),
                  SizedBox(width: context.rw(0.03)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.devName ?? d.devId,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          d.devLocation ?? 'Lokasi tidak diketahui',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: d.isActive
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.textTertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      d.isActive ? 'Aktif' : 'Offline',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(11),
                        fontWeight: FontWeight.w500,
                        color: d.isActive
                            ? AppColors.success
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                  SizedBox(width: context.rw(0.02)),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),

          // Sensors (expanded)
          if (_expanded && d.sensors.isNotEmpty)
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Column(
                children: d.sensors.map((s) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rw(0.051),
                      vertical: context.rh(0.01),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sensors_rounded,
                          size: 16,
                          color: AppColors.info,
                        ),
                        SizedBox(width: context.rw(0.025)),
                        Expanded(
                          child: Text(
                            s.sensName ?? s.sensId,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(12),
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          s.sensAddress ?? '',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(11),
                            color: AppColors.textTertiary,
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

class _EmptyCard extends StatelessWidget {
  final String message;
  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.061)),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(13),
            color: AppColors.textSecondary,
          ),
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
      margin: EdgeInsets.all(context.rw(0.051)),
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
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
    );
  }
}
