import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

/// Alert widget for displaying sensor threshold alerts
class AlertWidget extends StatelessWidget {
  final List<SensorAlert> alerts;
  final VoidCallback? onViewAll;

  const AlertWidget({super.key, required this.alerts, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.rw(0.041)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.rw(0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alerts',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${alerts.length} active alert${alerts.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alerts.length > 5 ? 5 : alerts.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _AlertItem(alert: alert);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: AppColors.success.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Semua sensor dalam kondisi normal',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(13),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final SensorAlert alert;

  const _AlertItem({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: _getSeverityColor(alert.severity),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.rw(0.03)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.sensorName,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(
                          alert.severity,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        alert.severity.name.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(9),
                          fontWeight: FontWeight.w600,
                          color: _getSeverityColor(alert.severity),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM HH:mm').format(alert.timestamp),
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(10),
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return AppColors.error;
      case AlertSeverity.warning:
        return AppColors.warning;
      case AlertSeverity.info:
        return AppColors.info;
    }
  }
}

/// Sensor alert model
class SensorAlert {
  final String id;
  final String sensorId;
  final String sensorName;
  final String message;
  final AlertSeverity severity;
  final DateTime timestamp;
  final double? currentValue;
  final double? threshold;

  const SensorAlert({
    required this.id,
    required this.sensorId,
    required this.sensorName,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.currentValue,
    this.threshold,
  });

  // Mock data generator for testing
  static List<SensorAlert> mockAlerts() {
    return [
      SensorAlert(
        id: '1',
        sensorId: 'env_temp',
        sensorName: 'Temperature',
        message: 'Suhu terlalu tinggi (35°C), melebihi batas maksimal 32°C',
        severity: AlertSeverity.critical,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        currentValue: 35,
        threshold: 32,
      ),
      SensorAlert(
        id: '2',
        sensorId: 'soil_ph',
        sensorName: 'pH Tanah',
        message: 'pH tanah mendekati batas minimum (5.2)',
        severity: AlertSeverity.warning,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        currentValue: 5.2,
        threshold: 5.0,
      ),
      SensorAlert(
        id: '3',
        sensorId: 'env_hum',
        sensorName: 'Humidity',
        message: 'Kelembaban udara optimal (75%)',
        severity: AlertSeverity.info,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        currentValue: 75,
        threshold: 70,
      ),
    ];
  }
}

enum AlertSeverity { critical, warning, info }
