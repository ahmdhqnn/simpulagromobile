import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/monitoring_models.dart';

/// Export button widget for exporting sensor data
class ExportButtonWidget extends StatelessWidget {
  final List<SensorReadModel> data;
  final String fileName;
  final VoidCallback? onExportComplete;

  const ExportButtonWidget({
    super.key,
    required this.data,
    this.fileName = 'sensor_data',
    this.onExportComplete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExportFormat>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.download_outlined,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      onSelected: (format) => _handleExport(context, format),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ExportFormat.csv,
          child: Row(
            children: [
              const Icon(Icons.table_chart_outlined, size: 20),
              const SizedBox(width: 12),
              Text(
                'Export ke CSV',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ExportFormat.json,
          child: Row(
            children: [
              const Icon(Icons.code_outlined, size: 20),
              const SizedBox(width: 12),
              Text(
                'Export ke JSON',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ExportFormat.share,
          child: Row(
            children: [
              const Icon(Icons.share_outlined, size: 20),
              const SizedBox(width: 12),
              Text(
                'Share Data',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleExport(BuildContext context, ExportFormat format) async {
    if (data.isEmpty) {
      _showMessage(context, 'Tidak ada data untuk di-export');
      return;
    }

    try {
      switch (format) {
        case ExportFormat.csv:
          await _exportToCsv(context);
          break;
        case ExportFormat.json:
          await _exportToJson(context);
          break;
        case ExportFormat.share:
          await _shareData(context);
          break;
      }

      onExportComplete?.call();
    } catch (e) {
      if (!context.mounted) return;
      _showMessage(context, 'Gagal export data: $e');
    }
  }

  Future<void> _exportToCsv(BuildContext context) async {
    final csv = _generateCsv();

    // In a real app, you would use packages like:
    // - path_provider to get directory
    // - share_plus to share file
    // For now, we'll show a dialog with the data

    if (!context.mounted) return;
    _showExportDialog(
      context,
      'CSV Export',
      csv,
      'Data berhasil di-export ke format CSV',
    );
  }

  Future<void> _exportToJson(BuildContext context) async {
    final json = _generateJson();

    _showExportDialog(
      context,
      'JSON Export',
      json,
      'Data berhasil di-export ke format JSON',
    );
  }

  Future<void> _shareData(BuildContext context) async {
    final summary = _generateSummary();

    _showExportDialog(
      context,
      'Share Data',
      summary,
      'Data siap untuk di-share',
    );
  }

  String _generateCsv() {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Timestamp,Sensor ID,Value,Unit');

    // Data rows
    for (final read in data) {
      final timestamp = read.readDate != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(read.readDate!)
          : '';
      final sensorId = read.dsId ?? '';
      final value = read.numericValue.toString();
      final unit = SensorMeta.unit(sensorId);

      buffer.writeln('$timestamp,$sensorId,$value,$unit');
    }

    return buffer.toString();
  }

  String _generateJson() {
    final jsonData = data.map((read) {
      return {
        'timestamp': read.readDate?.toIso8601String(),
        'sensor_id': read.dsId,
        'value': read.numericValue,
        'unit': SensorMeta.unit(read.dsId ?? ''),
        'label': SensorMeta.label(read.dsId ?? ''),
      };
    }).toList();

    return const JsonEncoder.withIndent('  ').convert({
      'export_date': DateTime.now().toIso8601String(),
      'total_records': data.length,
      'data': jsonData,
    });
  }

  String _generateSummary() {
    final buffer = StringBuffer();

    buffer.writeln('📊 Sensor Data Summary');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('');
    buffer.writeln(
      'Export Date: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}',
    );
    buffer.writeln('Total Records: ${data.length}');
    buffer.writeln('');

    // Group by sensor
    final grouped = <String, List<SensorReadModel>>{};
    for (final read in data) {
      final id = read.dsId ?? 'unknown';
      grouped.putIfAbsent(id, () => []).add(read);
    }

    buffer.writeln('Sensors:');
    for (final entry in grouped.entries) {
      final label = SensorMeta.label(entry.key);
      final count = entry.value.length;
      final values = entry.value.map((r) => r.numericValue).toList();
      final avg = values.isEmpty
          ? 0
          : values.reduce((a, b) => a + b) / values.length;
      final min = values.isEmpty ? 0 : values.reduce((a, b) => a < b ? a : b);
      final max = values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
      final unit = SensorMeta.unit(entry.key);

      buffer.writeln('  • $label:');
      buffer.writeln('    - Records: $count');
      buffer.writeln('    - Average: ${avg.toStringAsFixed(2)}$unit');
      buffer.writeln('    - Min: ${min.toStringAsFixed(2)}$unit');
      buffer.writeln('    - Max: ${max.toStringAsFixed(2)}$unit');
      buffer.writeln('');
    }

    return buffer.toString();
  }

  void _showExportDialog(
    BuildContext context,
    String title,
    String content,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  content,
                  style: TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: context.sp(11),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tip: Anda bisa copy text di atas',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(11),
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}

enum ExportFormat { csv, json, share }
