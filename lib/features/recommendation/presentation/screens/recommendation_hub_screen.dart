import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/ui_error_message.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
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
    _searchController = TextEditingController();
    _searchController.addListener(() {
      ref.read(recommendationSearchQueryProvider.notifier).state =
          _searchController.text;
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetRecommendationHubFilters(ref, scope: widget.initialScope);
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    invalidateRecommendationHubData(ref);
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredRecommendationCatalogProvider);
    final statsAsync = ref.watch(recommendationHubStatsProvider);
    final scope = ref.watch(recommendationScopeFilterProvider);
    final status = ref.watch(recommendationStatusFilterProvider);
    final hPad = context.rw(0.051);

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
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBar(context),
                          SizedBox(height: context.rh(0.024)),

                          Text(
                            'Pusat Rekomendasi',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: context.sp(22),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: context.rh(0.016)),
                        ],
                      ),
                    ),

                    _buildStatusChips(context, status, hPad),
                    SizedBox(height: context.rh(0.012)),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildScopeAndFilterRow(context, scope),
                          SizedBox(height: context.rh(0.012)),

                          if (scope == RecommendationScope.phase) ...[
                            _buildPhaseSelector(context),
                            SizedBox(height: context.rh(0.012)),
                          ],

                          _buildSearchField(context),
                          SizedBox(height: context.rh(0.012)),

                          _buildStatsCard(context, statsAsync),
                          SizedBox(height: context.rh(0.012)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _buildListSliver(context, filteredAsync, scope, status, hPad),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.rh(0.015)),
      child: Row(
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          const Spacer(),
          CircularIconActionWidget(
            onPressed: _refreshAll,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChips(
    BuildContext context,
    RecommendationStatusFilter current,
    double horizontalInset,
  ) {
    final quickFilters = [
      RecommendationStatusFilter.all,
      RecommendationStatusFilter.pending,
      RecommendationStatusFilter.applied,
      RecommendationStatusFilter.highPriority,
    ];

    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalInset),
        itemCount: quickFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, i) {
          final filter = quickFilters[i];
          final selected = filter == current;
          return GestureDetector(
            onTap: () {
              ref.read(recommendationStatusFilterProvider.notifier).state =
                  filter;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    filter.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w400,
                      height: 1.83,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textPrimary.withValues(alpha: 0.50),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScopeAndFilterRow(
    BuildContext context,
    RecommendationScope current,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _showScopeSheet(context, current),
          child: Container(
            width: 123,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  current.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w400,
                    height: 1.83,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () => _showStatusSheet(
            context,
            ref.read(recommendationStatusFilterProvider),
          ),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Container(
              width: 35,
              height: 35,
              padding: const EdgeInsets.all(5),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: SvgPicture.asset(
                'assets/icons/filter_icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseSelector(BuildContext context) {
    final phasesAsync = ref.watch(phasesForSelectedSiteProvider);
    final selectedPhase = ref.watch(selectedPhaseIdForRecProvider);

    return phasesAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (phases) {
        if (phases.isEmpty) return const SizedBox.shrink();
        final ids = phases.map((p) => p.id).toSet();
        final dropdownValue = ids.contains(selectedPhase)
            ? selectedPhase
            : phases.first.id;

        return DropdownButtonFormField<String>(
          value: dropdownValue,
          decoration: InputDecoration(
            labelText: 'Filter Phase',
            labelStyle: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: AppColors.textSecondary,
              fontSize: context.sp(12),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          items: phases
              .map(
                (p) => DropdownMenuItem<String>(
                  value: p.id,
                  child: Text(
                    p.phaseName,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: context.sp(12),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (id) {
            if (id == null) return;
            ref.read(selectedPhaseIdForRecProvider.notifier).state = id;
            ref.invalidate(recommendationPhaseSelectionProvider);
            ref.invalidate(recommendationPhaseFeedProvider);
            ref.invalidate(recommendationCatalogProvider);
          },
        );
      },
      loading: () => const LinearProgressIndicator(minHeight: 2),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/search-outline-icon.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(12),
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Cari judul, deskripsi, tanaman atau site',
                hintStyle: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w400,
                  height: 1.83,
                  color: AppColors.textPrimary.withValues(alpha: 0.50),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () => _searchController.clear(),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.black,
              ),
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
      skipError: true,
      data: (stats) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statCell(context, 'Total', stats.total, AppColors.primary),
            _statCell(context, 'Pending', stats.pending, AppColors.warning),
            _statCell(context, 'Applied', stats.applied, AppColors.success),
            _statCell(
              context,
              'Prioritas',
              stats.highPriority,
              AppColors.error,
            ),
          ],
        ),
      ),
      loading: () => const LoadingCardWidget(height: 64),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _statCell(BuildContext context, String label, int value, Color color) {
    return Column(
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
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(11),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildListSliver(
    BuildContext context,
    AsyncValue<List<RecommendationCatalogItem>> filteredAsync,
    RecommendationScope scope,
    RecommendationStatusFilter status,
    double hPad,
  ) {
    return filteredAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (rows) {
        if (rows.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptyState(context, scope, status),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: EdgeInsets.only(bottom: context.rh(0.012)),
                child: _buildRecommendationCard(ctx, rows[i]),
              ),
              childCount: rows.length,
            ),
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: buildListSkeleton(count: 6, type: 'plant'),
        ),
      ),
      error: (error, _) =>
          SliverToBoxAdapter(child: _buildErrorState(context, error)),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    RecommendationCatalogItem item,
  ) {
    final sources = item.scopes.toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    final rec = item.recommendation;
    final priorityColor = _priorityColor(rec.priority);
    final statusColor = _statusColor(rec.status);
    final typeColor = _typeColor(rec.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => context.push('/recommendation/${rec.recommendationId}'),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _typeIcon(rec.type),
                      size: 18,
                      color: typeColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rec.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _pill(context, rec.priority.label, priorityColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                rec.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: context.sp(12),
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: sources.map(_sourceChip).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _pill(context, rec.status.label, statusColor),
                  const SizedBox(width: 8),
                  _pill(context, rec.type.label, typeColor),
                  const Spacer(),
                  if (rec.createdAt != null)
                    Text(
                      _dateText(rec.createdAt!),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: context.sp(11),
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    RecommendationScope scope,
    RecommendationStatusFilter status,
  ) {
    final msg = scope == RecommendationScope.all
        ? 'Belum ada rekomendasi yang tersedia untuk site ini.'
        : 'Tidak ada data untuk filter ${scope.label} dengan status ${status.label}.';
    return Padding(
      padding: EdgeInsets.only(top: context.rh(0.10)),
      child: Column(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: context.rw(0.16).clamp(56.0, 72.0),
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          SizedBox(height: context.rh(0.016)),
          Text(
            'Data rekomendasi kosong',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(17),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.008)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(0.12)),
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Padding(
      padding: EdgeInsets.only(top: context.rh(0.10)),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: context.rw(0.16).clamp(56.0, 72.0),
            color: AppColors.error,
          ),
          SizedBox(height: context.rh(0.016)),
          Text(
            'Gagal memuat rekomendasi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: context.sp(17),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.rh(0.008)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(0.12)),
            child: Text(
              toUiErrorMessage(error),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showScopeSheet(BuildContext context, RecommendationScope current) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Filter Kategori',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...RecommendationScope.values.map((scope) {
              final sel = scope == current;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _radioCircle(sel),
                title: Text(
                  scope.label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  ref.read(recommendationScopeFilterProvider.notifier).state =
                      scope;
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showStatusSheet(
    BuildContext context,
    RecommendationStatusFilter current,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Filter Status',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...RecommendationStatusFilter.values.map((filter) {
              final sel = filter == current;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _radioCircle(sel),
                title: Text(
                  filter.label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  ref.read(recommendationStatusFilterProvider.notifier).state =
                      filter;
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _radioCircle(bool selected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.divider,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
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

  Widget _sourceChip(RecommendationScope scope) {
    final color = switch (scope) {
      RecommendationScope.site => AppColors.primary,
      RecommendationScope.plant => AppColors.success,
      RecommendationScope.phase => AppColors.info,
      RecommendationScope.all => AppColors.textSecondary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        scope.label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: context.sp(10),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _dateText(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

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

  Color _priorityColor(RecommendationPriority p) => switch (p) {
    RecommendationPriority.low => AppColors.success,
    RecommendationPriority.medium => AppColors.warning,
    RecommendationPriority.high => AppColors.error,
    RecommendationPriority.critical => AppColors.errorDark,
  };

  Color _statusColor(RecommendationStatus s) => switch (s) {
    RecommendationStatus.pending => AppColors.warning,
    RecommendationStatus.applied => AppColors.success,
    RecommendationStatus.dismissed => AppColors.textSecondary,
    RecommendationStatus.expired => AppColors.muted,
  };
}
