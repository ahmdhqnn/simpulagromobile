import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../../task/presentation/providers/task_provider.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/task_overview_widget.dart';
import '../widgets/smart_score_gauge.dart';
import '../widgets/sensor_status_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final sitesAsync = ref.watch(sitesProvider);
    final selectedSite = ref.watch(selectedSiteProvider);
    final healthAsync = ref.watch(environmentalHealthProvider);
    final deviceSummaryAsync = ref.watch(deviceSummaryProvider);
    final sensorSummaryAsync = ref.watch(sensorSummaryProvider);
    final plantSummaryAsync = ref.watch(plantSummaryProvider);
    final taskStats = ref.watch(taskStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(environmentalHealthProvider);
            ref.invalidate(deviceSummaryProvider);
            ref.invalidate(sensorSummaryProvider);
            ref.invalidate(plantSummaryProvider);
            ref.invalidate(latestSensorReadsProvider);
            ref.invalidate(sitesProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rw(0.051),
                    vertical: context.rh(0.015),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/user-outline-icon.svg',
                              width: 28,
                              height: 28,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1D1D1D),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Greeting column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${authState.user?.userName ?? 'User'}',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(16),
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1D1D1D),
                                height: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              authState.isAdmin ? 'Admin' : 'User',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(12),
                                fontWeight: FontWeight.w400,
                                color: const Color(
                                  0xFF1D1D1D,
                                ).withValues(alpha: 0.5),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/message-outline-icon.svg',
                            width: 28,
                            height: 28,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF1D1D1D),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sitesAsync.when(
                        data: (sites) {
                          // Auto-select site pertama jika belum ada yang dipilih
                          if (selectedSite == null && sites.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ref
                                  .read(selectedSiteProvider.notifier)
                                  .selectSite(sites.first);
                            });
                          }
                          return _SiteSelector(
                            sites: sites,
                            selectedSite: selectedSite,
                            onSiteSelected: (site) {
                              ref
                                  .read(selectedSiteProvider.notifier)
                                  .selectSite(site);
                            },
                          );
                        },
                        loading: () => _ShimmerCard(
                          height: context.rh(0.07).clamp(52.0, 72.0),
                        ),
                        error: (e, _) => _ErrorCard(
                          message: 'Gagal memuat site',
                          onRetry: () => ref.invalidate(sitesProvider),
                        ),
                      ),

                      SizedBox(height: context.rh(0.024)),

                      const _SectionTitle('Kesehatan Lingkungan'),
                      SizedBox(height: context.rh(0.014)),
                      healthAsync.when(
                        data: (health) {
                          if (health == null) {
                            return const _EmptyCard(
                              message: 'Pilih site terlebih dahulu',
                            );
                          }
                          return _HealthCard(health: health);
                        },
                        loading: () => _ShimmerCard(
                          height: context.rh(0.3).clamp(220.0, 280.0),
                        ),
                        error: (e, _) => _ErrorCard(
                          message: 'Gagal memuat data kesehatan',
                          onRetry: () =>
                              ref.invalidate(environmentalHealthProvider),
                        ),
                      ),

                      SizedBox(height: context.rh(0.024)),

                      const _SectionTitle('Status Sensor'),
                      SizedBox(height: context.rh(0.014)),
                      healthAsync.when(
                        data: (health) {
                          if (health == null || health.sensors.isEmpty) {
                            return const _SensorEmptyCard();
                          }
                          return SensorStatusGrid(sensors: health.sensors);
                        },
                        loading: () => _ShimmerCard(
                          height: context.rh(0.25).clamp(180.0, 240.0),
                        ),
                        error: (_, __) => const _SensorEmptyCard(),
                      ),

                      SizedBox(height: context.rh(0.024)),

                      const _SectionTitle('Ringkasan'),
                      SizedBox(height: context.rh(0.014)),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1.6,
                        crossAxisSpacing: context.rw(0.025),
                        mainAxisSpacing: context.rw(0.025),
                        children: [
                          SummaryCardWidget(
                            title: 'Device',
                            value: deviceSummaryAsync.when(
                              data: (d) => d?.total.toString() ?? '0',
                              loading: () => '...',
                              error: (_, __) => '-',
                            ),
                            svgIcon: 'assets/icons/device-outline-icon.svg',
                            iconBgColor: const Color(0xFFE8EFE9),
                            iconColor: AppColors.primary,
                            onTap: () {},
                          ),
                          SummaryCardWidget(
                            title: 'Sensor',
                            value: sensorSummaryAsync.when(
                              data: (s) => s?.total.toString() ?? '0',
                              loading: () => '...',
                              error: (_, __) => '-',
                            ),
                            svgIcon: 'assets/icons/sensor-icon.svg',
                            iconBgColor: const Color(0xFFECF6FE),
                            iconColor: AppColors.info,
                            onTap: () {},
                          ),
                          SummaryCardWidget(
                            title: 'Tanaman',
                            value: plantSummaryAsync.when(
                              data: (p) => p?.active.toString() ?? '0',
                              loading: () => '...',
                              error: (_, __) => '-',
                            ),
                            svgIcon: 'assets/icons/plant-outline-icon.svg',
                            iconBgColor: const Color(0xFFEDF7EE),
                            iconColor: AppColors.success,
                            onTap: () {},
                          ),
                          SummaryCardWidget(
                            title: 'Task',
                            value: taskStats.total.toString(),
                            svgIcon: 'assets/icons/check-task-outline-icon.svg',
                            iconBgColor: const Color(0xFFFFF6E9),
                            iconColor: AppColors.warning,
                            onTap: () => context.push('/tasks'),
                          ),
                        ],
                      ),

                      SizedBox(height: context.rh(0.024)),

                      const _SectionTitle('Ringkasan Task'),
                      SizedBox(height: context.rh(0.014)),
                      TaskOverviewWidget(
                        totalTasks: taskStats.total,
                        completedTasks: taskStats.completed,
                      ),

                      SizedBox(height: context.rh(0.024)),

                      const _SectionTitle('Aksi Cepat'),
                      SizedBox(height: context.rh(0.014)),
                      const QuickActionsWidget(),

                      SizedBox(height: context.rh(0.04)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

class _SiteSelector extends StatelessWidget {
  final List sites;
  final dynamic selectedSite;
  final ValueChanged<dynamic> onSiteSelected;

  const _SiteSelector({
    required this.sites,
    required this.selectedSite,
    required this.onSiteSelected,
  });

  void _showSiteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Pilih Site',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: MediaQuery.sizeOf(ctx).width / 390 * 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (sites.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Tidak ada site tersedia'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sites.length,
                  itemBuilder: (_, i) {
                    final site = sites[i];
                    final isSelected = selectedSite?.siteId == site.siteId;
                    return ListTile(
                      onTap: () {
                        onSiteSelected(site);
                        Navigator.pop(ctx);
                      },
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        site.siteName ?? site.siteId,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      subtitle: site.siteAddress != null
                          ? Text(
                              site.siteAddress!,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF9E9E9E),
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final siteName =
        selectedSite?.siteName ?? selectedSite?.siteId ?? 'Pilih Site';
    final siteAddress = selectedSite?.siteAddress as String?;

    return GestureDetector(
      onTap: () => _showSiteSheet(context),
      child: Container(
        width: double.infinity,
        height: context.rh(0.14).clamp(100.0, 120.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/maps-image.png',
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.92),
                        Colors.white.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 12,
                top: 12,
                right: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      siteName,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D),
                        height: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (siteAddress != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        siteAddress,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                          height: 1.83,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              Positioned(
                right: 12,
                bottom: 12,
                child: SvgPicture.asset(
                  'assets/icons/maps-dot-outline-icon.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1D1D1D),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final dynamic health;
  const _HealthCard({required this.health});

  @override
  Widget build(BuildContext context) {
    final score = (health.overallHealth as num).toDouble();
    final totalSensors = health.totalSensors as int? ?? 0;

    String statusLabel;
    Color statusColor;
    bool showWarning;
    if (score >= 80) {
      statusLabel = 'Sangat Baik';
      statusColor = const Color(0xFF88E096);
      showWarning = false;
    } else if (score >= 60) {
      statusLabel = 'Kondisi Baik';
      statusColor = const Color(0xFF88E096);
      showWarning = false;
    } else if (score >= 40) {
      statusLabel = 'Cukup';
      statusColor = const Color(0xFFFFD580);
      showWarning = true;
    } else {
      statusLabel = 'Perlu Perhatian';
      statusColor = const Color(0xFFFCBCBC);
      showWarning = true;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFFE1F3E2), Color(0xFFFDDEC5)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.rh(0.03),
          horizontal: context.rw(0.051),
        ),
        child: SmartScoreGauge(
          score: score,
          totalSensors: totalSensors,
          statusLabel: statusLabel,
          statusColor: statusColor,
          showWarning: showWarning,
        ),
      ),
    );
  }
}

class _SensorEmptyCard extends StatelessWidget {
  const _SensorEmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 195,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/sensor-icon.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              const Color(0xFF1D1D1D).withValues(alpha: 0.3),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada data sensor',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double height;
  const _ShimmerCard({required this.height});

  @override
  Widget build(BuildContext context) {
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
        borderRadius: BorderRadius.circular(20),
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
              color: AppColors.error,
              fontSize: context.sp(13),
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Coba Lagi',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: context.rw(0.1).clamp(32.0, 48.0),
              color: const Color(0xFF1D1D1D).withValues(alpha: 0.2),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                fontSize: context.sp(13),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
