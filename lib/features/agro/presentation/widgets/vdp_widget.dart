import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/agro_entity.dart';
import '../../../../l10n/app_localizations.dart';

class VdpWidget extends StatelessWidget {
  final VdpEntity? vdpData;

  const VdpWidget({super.key, this.vdpData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (vdpData == null || !vdpData!.hasDisplayData) {
      return _buildEmptyState(context, l10n);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Color(0xFF42A5F5),
                  size: 20,
                ),
              ),
              SizedBox(width: context.rw(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VPD',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.agroVdpDeficitTitle,
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
            ],
          ),
          if (vdpData!.vdp != null) ...[
            const SizedBox(height: 20),
            _buildLatestVdp(context, l10n),
            const SizedBox(height: 20),
            _buildVdpIndicator(context, vdpData!.vdp, l10n),
            const SizedBox(height: 16),
            _buildVdpInfo(context, vdpData!.vdp, l10n),
            const SizedBox(height: 16),
            _buildVdpDetails(context, l10n),
          ] else ...[
            const SizedBox(height: 16),
            _buildVdpDetails(context, l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildLatestVdp(BuildContext context, AppLocalizations l10n) {
    final vdp = vdpData!.vdp!;
    final color = _getVdpColor(vdp);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            AppColors.primary.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.agroVdpValueLabel,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vdpData!.status ?? _getVdpStatusLabel(vdp, l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                vdp.toStringAsFixed(2),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(32),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'kPa',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVdpIndicator(
    BuildContext context,
    double? vdp,
    AppLocalizations l10n,
  ) {
    if (vdp == null) return const SizedBox.shrink();

    final percentage = (vdp / 2.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.agroVdpRangeLabel,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(12),
            color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.info,
                        AppColors.success,
                        AppColors.warning,
                        AppColors.error,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * percentage * 0.85,
                  top: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _getVdpColor(vdp), width: 3),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildScaleLabel(context, '0'),
            _buildScaleLabel(context, '0.4'),
            _buildScaleLabel(context, '1.2'),
            _buildScaleLabel(context, '2.0+'),
          ],
        ),
      ],
    );
  }

  Widget _buildScaleLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(10),
        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildVdpInfo(
    BuildContext context,
    double? vdp,
    AppLocalizations l10n,
  ) {
    if (vdp == null) return const SizedBox.shrink();

    final title = vdpData!.status ?? _getVdpStatusLabel(vdp, l10n);
    final description = vdpData!.description ?? _getVdpDescription(vdp, l10n);
    IconData icon = Icons.info_outline;
    Color color = AppColors.info;

    if (vdp < 0.4) {
      icon = Icons.info_outline;
      color = AppColors.info;
    } else if (vdp <= 1.2) {
      icon = Icons.check_circle_outline;
      color = AppColors.success;
    } else if (vdp <= 1.6) {
      icon = Icons.warning_amber_outlined;
      color = AppColors.warning;
    } else {
      icon = Icons.error_outline;
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVdpDetails(BuildContext context, AppLocalizations l10n) {
    final details = <_VdpDetailData>[
      _VdpDetailData(
        label: 'V (VPD)',
        value: _formatNumberUnit(vdpData!.vdp, 2, 'kPa', l10n),
      ),
      _VdpDetailData(
        label: 'D (Es)',
        value: _formatNumberUnit(vdpData!.es, 2, 'kPa', l10n),
      ),
      _VdpDetailData(
        label: 'P (Ea)',
        value: _formatNumberUnit(vdpData!.ea, 2, 'kPa', l10n),
      ),
      if (vdpData!.temperature != null)
        _VdpDetailData(
          label: 'Temp',
          value: _formatNumberUnit(vdpData!.temperature, 1, 'C', l10n),
        ),
      if (vdpData!.humidity != null)
        _VdpDetailData(
          label: 'RH',
          value: _formatNumberUnit(vdpData!.humidity, 1, '%', l10n),
        ),
    ];

    if (details.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.agroVdpDetailTitle,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: context.sp(13),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D1D1D),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = details.length <= 3
                ? (constraints.maxWidth - ((details.length - 1) * 8)) /
                      details.length
                : (constraints.maxWidth - 8) / 2;

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final detail in details)
                  SizedBox(
                    width: itemWidth,
                    child: _buildDetailItem(
                      context,
                      detail.label,
                      detail.value,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(10),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1D1D1D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 48,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.agroVdpUnavailable,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(14),
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getVdpColor(double? vdp) {
    if (vdp == null) return const Color(0xFF1D1D1D).withValues(alpha: 0.6);
    if (vdp < 0.4) return AppColors.error;
    if (vdp <= 1.2) return AppColors.success;
    if (vdp <= 1.6) return AppColors.warning;
    return AppColors.error;
  }

  String _formatNumberUnit(
    double? value,
    int fractionDigits,
    String unit,
    AppLocalizations l10n,
  ) {
    if (value == null) return l10n.commonNotAvailableYet;
    final number = value.toStringAsFixed(fractionDigits);
    if (unit == '%') return '$number%';
    return '$number $unit';
  }

  String _getVdpStatusLabel(double vdp, AppLocalizations l10n) {
    if (vdp < 0.4) return l10n.agroVdpStatusLow;
    if (vdp <= 1.2) return l10n.agroVdpStatusOptimal;
    if (vdp <= 1.6) return l10n.agroVdpStatusWarning;
    return l10n.agroVdpStatusHigh;
  }

  String _getVdpDescription(double vdp, AppLocalizations l10n) {
    if (vdp < 0.4) {
      return l10n.agroVdpDescLow;
    }
    if (vdp <= 1.2) {
      return l10n.agroVdpDescOptimal;
    }
    if (vdp <= 1.6) {
      return l10n.agroVdpDescWarning;
    }
    return l10n.agroVdpDescHigh;
  }
}

class _VdpDetailData {
  final String label;
  final String value;

  const _VdpDetailData({required this.label, required this.value});
}
