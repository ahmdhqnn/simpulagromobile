import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/locale_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/localized_labels.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../../domain/entities/recommendation.dart';
import '../providers/recommendation_hub_provider.dart';
import '../providers/recommendation_provider.dart';

class RecommendationHubScreen extends ConsumerStatefulWidget {
  const RecommendationHubScreen({
    super.key,
    this.initialScope = RecommendationScope.all,
  });

  final RecommendationScope initialScope;

  @override
  ConsumerState<RecommendationHubScreen> createState() =>
      _RecommendationHubScreenState();
}

class _RecommendationHubScreenState
    extends ConsumerState<RecommendationHubScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() {
        ref.read(recommendationSearchQueryProvider.notifier).state =
            _searchController.text;
        setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetRecommendationHubFilters(ref, scope: widget.initialScope);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await invalidateRecommendationHubDataSpaced(ref);
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredRecommendationCatalogProvider);
    final statsAsync = ref.watch(recommendationHubStatsProvider);
    final scope = ref.watch(recommendationScopeFilterProvider);
    final tab = ref.watch(recommendationHubTabProvider);
    final filter = ref.watch(recommendationHubFilterProvider);
    final horizontalPadding = context.rw(0.051);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refreshAll,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBar(context),
                          SizedBox(height: context.rh(0.024)),
                          Text(
                            context.l10n.recommendationHubTitle,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: context.sp(22),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.rh(0.016)),
                    _buildFilterChips(context, filter, horizontalPadding),
                    SizedBox(height: context.rh(0.016)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchField(context),
                          SizedBox(height: context.rh(0.012)),
                          if (tab == RecommendationHubTab.active) ...[
                            _buildStatsCard(context, statsAsync),
                            SizedBox(height: context.rh(0.012)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (tab == RecommendationHubTab.active)
                _buildListSliver(
                  context,
                  filteredAsync,
                  scope,
                  horizontalPadding,
                )
              else
                _buildHistoryListSliver(context, horizontalPadding),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    RecommendationHubFilter current,
    double horizontalInset,
  ) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalInset),
        itemCount: RecommendationHubFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final filterVal = RecommendationHubFilter.values[index];
          final selected = filterVal == current;
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ref.read(recommendationHubFilterProvider.notifier).state =
                  filterVal;
              if (filterVal == RecommendationHubFilter.history) {
                ref.read(recommendationHubTabProvider.notifier).state =
                    RecommendationHubTab.history;
              } else {
                ref.read(recommendationHubTabProvider.notifier).state =
                    RecommendationHubTab.active;
                final scope = switch (filterVal) {
                  RecommendationHubFilter.all => RecommendationScope.all,
                  RecommendationHubFilter.site => RecommendationScope.site,
                  RecommendationHubFilter.plant => RecommendationScope.plant,
                  RecommendationHubFilter.phase => RecommendationScope.phase,
                  _ => RecommendationScope.all,
                };
                ref.read(recommendationScopeFilterProvider.notifier).state =
                    scope;
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                _filterLabel(filterVal),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w400,
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textPrimary.withValues(alpha: 0.50),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _filterLabel(RecommendationHubFilter filter) {
    switch (filter) {
      case RecommendationHubFilter.all:
        return 'Semua';
      case RecommendationHubFilter.site:
        return 'Rekomendasi Aksi';
      case RecommendationHubFilter.plant:
        return 'Tanaman ML';
      case RecommendationHubFilter.phase:
        return 'Fase';
      case RecommendationHubFilter.history:
        return 'Riwayat';
    }
  }

  Widget _buildHistoryListSliver(
    BuildContext context,
    double horizontalPadding,
  ) {
    final siteId = ref.watch(selectedSiteIdProvider);
    if (siteId == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final historyAsync = ref.watch(recommendationHistoryProvider(siteId));
    final query = ref
        .watch(recommendationSearchQueryProvider)
        .trim()
        .toLowerCase();

    return historyAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (items) {
        final filteredItems = items.where((item) {
          if (query.isEmpty) return true;
          return [
            item.title,
            item.description,
            item.type.label,
            item.reason ?? '',
          ].join(' ').toLowerCase().contains(query);
        }).toList();

        if (filteredItems.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history_toggle_off_rounded,
                      size: 64,
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tidak ada riwayat rekomendasi',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = filteredItems[index];
              final catalogItem = RecommendationCatalogItem(
                recommendation: item,
                scopes: const {RecommendationScope.site},
              );
              return Padding(
                padding: EdgeInsets.only(bottom: context.rh(0.012)),
                child: _buildRecommendationCard(
                  context,
                  catalogItem,
                  isHistory: true,
                ),
              );
            }, childCount: filteredItems.length),
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: buildListSkeleton(
            count: 5,
            type: 'recommendation',
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      error: (error, _) =>
          SliverToBoxAdapter(child: _buildErrorState(context, error)),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.rh(0.015)),
      child: Row(
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          const Spacer(),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(29),
            ),
            child: IconButton(
              onPressed: _refreshAll,
              icon: SvgPicture.asset(
                'assets/icons/arrow-rotate-left.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/search-outline-icon.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.recommendationSearchHint,
                hintStyle: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: _searchController.clear,
              icon: const Icon(Icons.close_rounded, size: 17),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    AsyncValue<RecommendationHubStats> statsAsync,
  ) {
    return statsAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (stats) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statCell(
              context,
              context.l10n.commonTotal,
              stats.total,
              AppColors.primary,
            ),
            _statCell(
              context,
              RecommendationScope.site.localizedLabel(context.l10n),
              stats.site,
              AppColors.primary,
            ),
            _statCell(
              context,
              RecommendationScope.plant.localizedLabel(context.l10n),
              stats.plant,
              AppColors.success,
            ),
            _statCell(
              context,
              RecommendationScope.phase.localizedLabel(context.l10n),
              stats.phase,
              AppColors.info,
            ),
          ],
        ),
      ),
      loading: () => const InlineStatsCardSkeleton(itemCount: 4, height: 64),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _statCell(BuildContext context, String label, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(16),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(10),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSliver(
    BuildContext context,
    AsyncValue<List<RecommendationCatalogItem>> filteredAsync,
    RecommendationScope scope,
    double horizontalPadding,
  ) {
    return filteredAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (rows) {
        if (rows.isEmpty) {
          return SliverToBoxAdapter(child: _buildEmptyState(context, scope));
        }
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.only(bottom: context.rh(0.012)),
                child: _buildRecommendationCard(context, rows[index]),
              ),
              childCount: rows.length,
            ),
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: buildListSkeleton(
            count: 5,
            type: 'recommendation',
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      error: (error, _) =>
          SliverToBoxAdapter(child: _buildErrorState(context, error)),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    RecommendationCatalogItem catalogItem, {
    bool isHistory = false,
  }) {
    final recommendation = catalogItem.recommendation;
    final sourceScopes = catalogItem.scopes.toList()
      ..sort((left, right) => left.index.compareTo(right.index));
    final primaryScope = sourceScopes.isEmpty
        ? RecommendationScope.all
        : sourceScopes.first;
    final typeColor = _typeColor(recommendation.type);
    final priorityColor = _priorityColor(recommendation.priority);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () =>
            context.push('/recommendation/${recommendation.recommendationId}'),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: recommendation.hasError
                ? Border.all(color: AppColors.warning.withValues(alpha: 0.45))
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      recommendation.hasError
                          ? Icons.warning_amber_rounded
                          : _typeIcon(recommendation.type),
                      size: 19,
                      color: recommendation.hasError
                          ? AppColors.warning
                          : typeColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _sourceTitle(context, primaryScope),
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: context.sp(11),
                            color: typeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _pill(
                    context,
                    recommendation.priority.localizedLabel(context.l10n),
                    priorityColor,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _sourceIcon(primaryScope),
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _sourceDescription(
                        context,
                        primaryScope,
                        recommendation.createdAt,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(11),
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                recommendation.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              if (recommendation.createdAt != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context
                          .dateFormat('dd MMM yyyy')
                          .format(recommendation.createdAt!.toLocal()),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(10),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, RecommendationScope scope) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rw(0.12),
        context.rh(0.09),
        context.rw(0.12),
        0,
      ),
      child: Column(
        children: [
          Icon(
            scope == RecommendationScope.phase
                ? Icons.timeline_outlined
                : Icons.lightbulb_outline_rounded,
            size: context.rw(0.16).clamp(56.0, 72.0),
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          SizedBox(height: context.rh(0.016)),
          Text(
            context.l10n.recommendationEmptyDataTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(17),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.008)),
          Text(
            _emptyMessage(context, scope),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rw(0.12),
        context.rh(0.09),
        context.rw(0.12),
        0,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: context.rh(0.016)),
          Text(
            context.l10n.recommendationLoadFailed,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(17),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.008)),
          Text(
            toUiErrorMessage(error, context.l10n),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(13),
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _refreshAll,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(10),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _sourceTitle(BuildContext context, RecommendationScope scope) {
    return switch (scope) {
      RecommendationScope.site => 'Rekomendasi Aksi',
      RecommendationScope.plant => 'Rekomendasi Tanaman',
      RecommendationScope.phase => 'Rekomendasi Fase Aktif',
      RecommendationScope.all => 'Semua Rekomendasi',
    };
  }

  String _sourceDescription(
    BuildContext context,
    RecommendationScope scope,
    DateTime? createdAt,
  ) {
    final isToday = _isToday(createdAt);
    return switch (scope) {
      RecommendationScope.site =>
        isToday
            ? 'Saran tindakan langsung berdasarkan kondisi terkini lahan Anda hari ini.'
            : 'Saran tindakan langsung berdasarkan kondisi terkini lahan Anda pada tanggal tersebut.',
      RecommendationScope.plant =>
        'Rekomendasi jenis tanaman yang paling cocok berdasarkan riwayat kondisi tanah seminggu terakhir.',
      RecommendationScope.phase =>
        'Panduan perawatan tanaman yang disesuaikan dengan usia dan fase pertumbuhan saat ini.',
      RecommendationScope.all =>
        'Semua saran dan panduan pertanian aktif untuk lahan Anda.',
    };
  }

  bool _isToday(DateTime? dateTime) {
    if (dateTime == null) return true;
    final now = DateTime.now();
    final local = dateTime.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  String _emptyMessage(BuildContext context, RecommendationScope scope) {
    return switch (scope) {
      RecommendationScope.site => context.l10n.recommendationEmptyAction,
      RecommendationScope.plant => context.l10n.recommendationEmptyPlant,
      RecommendationScope.phase => context.l10n.recommendationEmptyPhase,
      RecommendationScope.all => context.l10n.recommendationEmptyAll,
    };
  }

  IconData _sourceIcon(RecommendationScope scope) => switch (scope) {
    RecommendationScope.site => Icons.task_alt_rounded,
    RecommendationScope.plant => Icons.psychology_alt_outlined,
    RecommendationScope.phase => Icons.storage_rounded,
    RecommendationScope.all => Icons.layers_outlined,
  };

  IconData _typeIcon(RecommendationType type) => switch (type) {
    RecommendationType.npk => Icons.grass_rounded,
    RecommendationType.ph => Icons.science_outlined,
    RecommendationType.watering => Icons.water_drop_outlined,
    RecommendationType.pestControl => Icons.bug_report_outlined,
    RecommendationType.harvesting => Icons.agriculture_outlined,
    RecommendationType.planting => Icons.eco_outlined,
    RecommendationType.general => Icons.lightbulb_outline_rounded,
  };

  Color _typeColor(RecommendationType type) => switch (type) {
    RecommendationType.npk => AppColors.success,
    RecommendationType.ph => AppColors.info,
    RecommendationType.watering => AppColors.recWatering,
    RecommendationType.pestControl => AppColors.error,
    RecommendationType.harvesting => AppColors.recHarvesting,
    RecommendationType.planting => AppColors.recPlanting,
    RecommendationType.general => AppColors.primary,
  };

  Color _priorityColor(RecommendationPriority priority) => switch (priority) {
    RecommendationPriority.low => AppColors.success,
    RecommendationPriority.medium => AppColors.warning,
    RecommendationPriority.high => AppColors.error,
    RecommendationPriority.critical => AppColors.errorDark,
  };
}
