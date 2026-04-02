import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../task/presentation/providers/task_provider.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/activity_timeline_widget.dart';
import '../widgets/task_overview_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final sitesAsync = ref.watch(sitesProvider);
    final selectedSite = ref.watch(selectedSiteProvider);
    final healthAsync = ref.watch(environmentalHealthProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: context.rh(0.17).clamp(120.0, 160.0),
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.rw(0.051),
                      context.rh(0.02),
                      context.rw(0.051),
                      0,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: context.rw(0.051).clamp(18.0, 24.0),
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Text(
                            (authState.user?.userName ?? 'U')[0].toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(14),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: context.rw(0.03)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Halo, ${authState.user?.userName ?? 'User'} 👋',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: context.sp(16),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                authState.isAdmin ? 'Admin' : 'User',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: context.sp(12),
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              ref.read(authProvider.notifier).logout(),
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(context.rw(0.051)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Site Selector
                  sitesAsync.when(
                    data: (sites) => _SiteSelector(
                      sites: sites,
                      selectedSiteId: selectedSite?.siteId,
                      onChanged: (id) {
                        final site = sites.firstWhere((s) => s.siteId == id);
                        ref.read(selectedSiteProvider.notifier).state = site;
                      },
                    ),
                    loading: () => const _ShimmerCard(height: 56),
                    error: (e, _) => _ErrorCard(
                      message: 'Gagal memuat site',
                      onRetry: () => ref.invalidate(sitesProvider),
                    ),
                  ),
                  SizedBox(height: context.rh(0.03)),

                  // Environmental Health
                  Text(
                    'Kesehatan Lingkungan',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.rh(0.015)),
                  healthAsync.when(
                    data: (health) {
                      if (health == null) {
                        return const _EmptyCard(
                          message: 'Pilih site terlebih dahulu',
                        );
                      }
                      return _HealthOverviewCard(health: health);
                    },
                    loading: () => const _ShimmerCard(height: 200),
                    error: (e, _) => _ErrorCard(
                      message: 'Gagal memuat data kesehatan',
                      onRetry: () =>
                          ref.invalidate(environmentalHealthProvider),
                    ),
                  ),

                  SizedBox(height: context.rh(0.03)),

                  // Sensor Grid
                  Text(
                    'Status Sensor',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.rh(0.015)),
                  healthAsync.when(
                    data: (health) {
                      if (health == null || health.sensors.isEmpty) {
                        return const _EmptyCard(
                          message: 'Belum ada data sensor',
                        );
                      }
                      return _SensorGrid(sensors: health.sensors);
                    },
                    loading: () => const _ShimmerCard(height: 200),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  SizedBox(height: context.rh(0.03)),

                  // Summary Cards
                  _buildSummaryCards(context, ref),

                  SizedBox(height: context.rh(0.03)),

                  // Task Overview
                  _buildTaskOverview(context, ref),

                  SizedBox(height: context.rh(0.03)),

                  // Quick Actions
                  const QuickActionsWidget(),

                  SizedBox(height: context.rh(0.03)),

                  // Recent Activities
                  ActivityTimelineWidget(
                    activities: ActivityItem.mockActivities(),
                  ),

                  SizedBox(height: context.rh(0.03)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, WidgetRef ref) {
    // Mock data - replace with real data from providers
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: context.rw(0.03),
      mainAxisSpacing: context.rw(0.03),
      children: [
        SummaryCardWidget(
          title: 'Total Device',
          value: '8',
          icon: Icons.devices_outlined,
          color: AppColors.primary,
          subtitle: '6 aktif',
          onTap: () {
            // Navigate to devices
          },
        ),
        SummaryCardWidget(
          title: 'Total Sensor',
          value: '24',
          icon: Icons.sensors_outlined,
          color: AppColors.info,
          subtitle: '22 aktif',
          onTap: () {
            // Navigate to sensors
          },
        ),
        SummaryCardWidget(
          title: 'Tanaman',
          value: '3',
          icon: Icons.grass_outlined,
          color: AppColors.success,
          subtitle: 'Aktif tumbuh',
          onTap: () {
            // Navigate to plants
          },
        ),
        SummaryCardWidget(
          title: 'Task Aktif',
          value: '12',
          icon: Icons.task_alt,
          color: AppColors.warning,
          subtitle: '3 terlambat',
          onTap: () => context.push('/tasks'),
        ),
      ],
    );
  }

  Widget _buildTaskOverview(BuildContext context, WidgetRef ref) {
    final taskStatsAsync = ref.watch(taskStatsProvider);

    return TaskOverviewWidget(
      totalTasks: taskStatsAsync.total,
      pendingTasks: taskStatsAsync.pending,
      inProgressTasks: taskStatsAsync.inProgress,
      completedTasks: taskStatsAsync.completed,
      overdueTasks: taskStatsAsync.overdue,
    );
  }
}

// ─── Site Selector ──────────────────────────────────────
class _SiteSelector extends StatelessWidget {
  final List sites;
  final String? selectedSiteId;
  final ValueChanged<String> onChanged;

  const _SiteSelector({
    required this.sites,
    required this.selectedSiteId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.041), vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSiteId,
          isExpanded: true,
          icon: const Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
          ),
          hint: Text(
            'Pilih Site',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(14),
              color: AppColors.textSecondary,
            ),
          ),
          items: sites.map<DropdownMenuItem<String>>((site) {
            return DropdownMenuItem<String>(
              value: site.siteId,
              child: Row(
                children: [
                  const Icon(
                    Icons.place,
                    size: 18,
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          site.siteName ?? site.siteId,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(14),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (site.siteAddress != null)
                          Text(
                            site.siteAddress!,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(11),
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ─── Health Overview Card ───────────────────────────────
class _HealthOverviewCard extends StatelessWidget {
  final dynamic health;

  const _HealthOverviewCard({required this.health});

  @override
  Widget build(BuildContext context) {
    final percent = (health.overallHealth / 100).clamp(0.0, 1.0);
    Color healthColor;
    String healthLabel;

    if (health.overallHealth >= 80) {
      healthColor = AppColors.success;
      healthLabel = 'Sangat Baik';
    } else if (health.overallHealth >= 60) {
      healthColor = AppColors.primaryLight;
      healthLabel = 'Baik';
    } else if (health.overallHealth >= 40) {
      healthColor = AppColors.warning;
      healthLabel = 'Cukup';
    } else {
      healthColor = AppColors.error;
      healthLabel = 'Perlu Perhatian';
    }

    // Circular indicator radius scales with screen width
    final circleRadius = (context.rw(0.14)).clamp(44.0, 64.0);

    return Container(
      padding: EdgeInsets.all(context.rw(0.061)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: healthColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: circleRadius,
            lineWidth: context.rw(0.025).clamp(7.0, 12.0),
            percent: percent,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${health.overallHealth.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w700,
                    color: healthColor,
                  ),
                ),
              ],
            ),
            progressColor: healthColor,
            backgroundColor: healthColor.withValues(alpha: 0.15),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1200,
          ),
          SizedBox(width: context.rw(0.061)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  healthLabel,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: context.rh(0.005)),
                Text(
                  '${health.totalSensors} sensor aktif',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.rh(0.01)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rw(0.025),
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: healthColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Kesehatan Lingkungan',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w500,
                      color: healthColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sensor Grid ────────────────────────────────────────
class _SensorGrid extends StatelessWidget {
  final List sensors;

  const _SensorGrid({required this.sensors});

  Color _getColorForSensor(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return AppColors.temperature;
      case 'env_hum':
        return AppColors.humidity;
      case 'soil_nitro':
        return AppColors.nitrogen;
      case 'soil_phos':
        return AppColors.phosphorus;
      case 'soil_pot':
        return AppColors.potassium;
      case 'soil_ph':
        return AppColors.ph;
      default:
        return AppColors.primaryLight;
    }
  }

  IconData _getIconForSensor(String dsId) {
    switch (dsId) {
      case 'env_temp':
        return Icons.thermostat_outlined;
      case 'env_hum':
        return Icons.water_drop_outlined;
      case 'soil_nitro':
        return Icons.grass_outlined;
      case 'soil_phos':
        return Icons.science_outlined;
      case 'soil_pot':
        return Icons.diamond_outlined;
      case 'soil_ph':
        return Icons.speed_outlined;
      default:
        return Icons.sensors_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // On wider screens (tablet), use 3 columns
    final crossAxisCount = context.sw >= 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: context.sw >= 600 ? 1.4 : 1.35,
        crossAxisSpacing: context.rw(0.03),
        mainAxisSpacing: context.rw(0.03),
      ),
      itemCount: sensors.length,
      itemBuilder: (context, i) {
        final sensor = sensors[i];
        final color = _getColorForSensor(sensor.dsId);
        final icon = _getIconForSensor(sensor.dsId);

        return Container(
          padding: EdgeInsets.all(context.rw(0.04)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.rw(0.02)),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: context.rw(0.051).clamp(16.0, 22.0),
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rw(0.02),
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: sensor.persentase >= 70
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${sensor.persentase.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(11),
                        fontWeight: FontWeight.w600,
                        color: sensor.persentase >= 70
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '${sensor.readUpdateValue}${sensor.unit}',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.rh(0.003)),
              Text(
                sensor.label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Utility Widgets ────────────────────────────────────
class _ShimmerCard extends StatelessWidget {
  final double height;
  const _ShimmerCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
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
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 32),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: AppColors.error,
              fontSize: context.sp(13),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Coba Lagi'),
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
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: context.rw(0.1).clamp(32.0, 48.0),
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: AppColors.textSecondary,
                fontSize: context.sp(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
