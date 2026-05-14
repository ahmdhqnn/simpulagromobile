import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/monitoring_models.dart';

class MapsWebviewWidget extends StatefulWidget {
  final double centerLat;
  final double centerLon;
  final List<DeviceModel> devices;

  const MapsWebviewWidget({
    super.key,
    required this.centerLat,
    required this.centerLon,
    required this.devices,
  });

  @override
  State<MapsWebviewWidget> createState() => _MapsWebviewWidgetState();
}

class _MapsWebviewWidgetState extends State<MapsWebviewWidget> {
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
