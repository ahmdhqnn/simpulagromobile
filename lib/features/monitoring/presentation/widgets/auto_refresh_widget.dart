import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

/// Auto-refresh widget with timer and manual refresh
class AutoRefreshWidget extends ConsumerStatefulWidget {
  final VoidCallback onRefresh;
  final Duration refreshInterval;
  final bool autoRefreshEnabled;
  final Widget child;

  const AutoRefreshWidget({
    super.key,
    required this.onRefresh,
    required this.child,
    this.refreshInterval = const Duration(seconds: 30),
    this.autoRefreshEnabled = true,
  });

  @override
  ConsumerState<AutoRefreshWidget> createState() => _AutoRefreshWidgetState();
}

class _AutoRefreshWidgetState extends ConsumerState<AutoRefreshWidget> {
  Timer? _timer;
  DateTime? _lastRefresh;
  bool _isRefreshing = false;
  bool _autoRefreshEnabled = true;

  @override
  void initState() {
    super.initState();
    _autoRefreshEnabled = widget.autoRefreshEnabled;
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer?.cancel();
    if (_autoRefreshEnabled) {
      _timer = Timer.periodic(widget.refreshInterval, (_) {
        _refresh();
      });
    }
  }

  void _stopAutoRefresh() {
    _timer?.cancel();
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
      _lastRefresh = DateTime.now();
    });

    try {
      widget.onRefresh();
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  void _toggleAutoRefresh() {
    setState(() {
      _autoRefreshEnabled = !_autoRefreshEnabled;
    });

    if (_autoRefreshEnabled) {
      _startAutoRefresh();
    } else {
      _stopAutoRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRefreshBar(context),
        Expanded(child: widget.child),
      ],
    );
  }

  Widget _buildRefreshBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.041),
        vertical: context.rh(0.01),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          // Auto-refresh toggle
          InkWell(
            onTap: _toggleAutoRefresh,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _autoRefreshEnabled
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _autoRefreshEnabled
                        ? Icons.autorenew
                        : Icons.pause_circle_outline,
                    size: 16,
                    color: _autoRefreshEnabled
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _autoRefreshEnabled ? 'Auto' : 'Manual',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w500,
                      color: _autoRefreshEnabled
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Last refresh time
          if (_lastRefresh != null)
            Expanded(
              child: Text(
                'Last update: ${_formatLastRefresh()}',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(11),
                  color: AppColors.textTertiary,
                ),
              ),
            )
          else
            const Spacer(),

          // Manual refresh button
          InkWell(
            onTap: _isRefreshing ? null : _refresh,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isRefreshing
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.refresh,
                      size: 16,
                      color: AppColors.primary,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastRefresh() {
    if (_lastRefresh == null) return '';

    final now = DateTime.now();
    final diff = now.difference(_lastRefresh!);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }
}

/// Provider for auto-refresh settings
final autoRefreshEnabledProvider = StateProvider<bool>((ref) => true);

final refreshIntervalProvider = StateProvider<Duration>((ref) {
  return const Duration(seconds: 30);
});
