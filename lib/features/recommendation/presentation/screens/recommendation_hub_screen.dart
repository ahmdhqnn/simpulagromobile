import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildScopeChips(context, scope),
            if (scope == RecommendationScope.phase)
              _buildPhaseSelector(context),
            _buildStatusChips(context, status),
            _buildSearchField(context),
            _buildStatsCard(context, statsAsync),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refreshAll,
                child: filteredAsync.when(
                  skipLoadingOnReload: true,
                  skipLoadingOnRefresh: true,
                  skipError: true,
                  data: (rows) {
                    if (rows.isEmpty) {
                      return _buildEmptyState(context, scope, status);
                    }
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        context.rw(0.051),
                        context.rh(0.006),
                        context.rw(0.051),
                        context.rh(0.02),
                      ),
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        final item = rows[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: context.rh(0.012)),
                          child: _buildRecommendationCard(context, item),
                        );
                      },
                    );
                  },
                  loading: () => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rw(0.051),
                    ),
                    child: buildListSkeleton(count: 6, type: 'plant'),
                  ),
                  error: (error, _) => _buildErrorState(context, error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        children: [
          CircularBackButtonWidget(onPressed: () => context.pop()),
          Expanded(
            child: Text(
              'Pusat Rekomendasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: context.sp(18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          CircularIconActionWidget(
            onPressed: _refreshAll,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildScopeChips(BuildContext context, RecommendationScope current) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
        children: RecommendationScope.values.map((scope) {
          final selected = scope == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ref.read(recommendationScopeFilterProvider.notifier).state =
                    scope;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.divider.withValues(alpha: 0.8),
                  ),
                ),
                child: Text(
                  scope.label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
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

        final ids = phases.map((phase) => phase.id).toSet();
        final dropdownValue = ids.contains(selectedPhase)
            ? selectedPhase
            : phases.first.id;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            context.rw(0.051),
            context.rh(0.008),
            context.rw(0.051),
            0,
          ),
          child: DropdownButtonFormField<String>(
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
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
            ),
            items: phases
                .map(
                  (phase) => DropdownMenuItem<String>(
                    value: phase.id,
                    child: Text(
                      phase.phaseName,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (phaseId) {
              if (phaseId == null) return;
              ref.read(selectedPhaseIdForRecProvider.notifier).state = phaseId;
              ref.invalidate(recommendationPhaseSelectionProvider);
              ref.invalidate(recommendationPhaseFeedProvider);
              ref.invalidate(recommendationCatalogProvider);
            },
          ),
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
        child: const LinearProgressIndicator(minHeight: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatusChips(
    BuildContext context,
    RecommendationStatusFilter current,
  ) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(
          context.rw(0.051),
          context.rh(0.006),
          context.rw(0.051),
          0,
        ),
        children: RecommendationStatusFilter.values.map((filter) {
          final selected = filter == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ref.read(recommendationStatusFilterProvider.notifier).state =
                    filter;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.info : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selected
                        ? AppColors.info
                        : AppColors.divider.withValues(alpha: 0.8),
                  ),
                ),
                child: Text(
                  filter.label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: context.sp(11),
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rw(0.051),
        context.rh(0.006),
        context.rw(0.051),
        0,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari judul, deskripsi, tanaman, atau site',
          hintStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.textSecondary,
            fontSize: context.sp(12),
          ),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
        ),
        style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    AsyncValue<RecommendationHubStats> statsAsync,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rw(0.051),
        context.rh(0.01),
        context.rw(0.051),
        context.rh(0.008),
      ),
      child: statsAsync.when(
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
              _statCell(context, 'High', stats.highPriority, AppColors.error),
            ],
          ),
        ),
        loading: () => const LoadingCardWidget(height: 66),
        error: (_, __) => const SizedBox.shrink(),
      ),
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

  Widget _buildRecommendationCard(
    BuildContext context,
    RecommendationCatalogItem item,
  ) {
    final sources = item.scopes.toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    final recommendation = item.recommendation;
    final priorityColor = _priorityColor(recommendation.priority);
    final statusColor = _statusColor(recommendation.status);
    final typeColor = _typeColor(recommendation.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () =>
            context.push('/recommendation/${recommendation.recommendationId}'),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.9)),
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
                      _typeIcon(recommendation.type),
                      size: 18,
                      color: typeColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      recommendation.title,
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
                  _pill(recommendation.priority.label, priorityColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                recommendation.description,
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
                  _pill(recommendation.status.label, statusColor),
                  const SizedBox(width: 8),
                  _pill(recommendation.type.label, typeColor),
                  const Spacer(),
                  if (recommendation.createdAt != null)
                    Text(
                      _dateText(recommendation.createdAt!),
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
    final message = scope == RecommendationScope.all
        ? 'Belum ada rekomendasi yang tersedia untuk site ini.'
        : 'Tidak ada data untuk filter ${scope.label} dengan status ${status.label}.';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: context.rh(0.14)),
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
            message,
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
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: context.rh(0.14)),
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
    );
  }

  Widget _pill(String label, Color color) {
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
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  IconData _typeIcon(RecommendationType type) {
    switch (type) {
      case RecommendationType.npk:
        return Icons.grass_rounded;
      case RecommendationType.ph:
        return Icons.science_outlined;
      case RecommendationType.watering:
        return Icons.water_drop_outlined;
      case RecommendationType.pestControl:
        return Icons.bug_report_outlined;
      case RecommendationType.harvesting:
        return Icons.agriculture_outlined;
      case RecommendationType.planting:
        return Icons.eco_outlined;
      case RecommendationType.general:
        return Icons.lightbulb_outline_rounded;
    }
  }

  Color _typeColor(RecommendationType type) {
    switch (type) {
      case RecommendationType.npk:
        return AppColors.success;
      case RecommendationType.ph:
        return AppColors.info;
      case RecommendationType.watering:
        return AppColors.recWatering;
      case RecommendationType.pestControl:
        return AppColors.error;
      case RecommendationType.harvesting:
        return AppColors.recHarvesting;
      case RecommendationType.planting:
        return AppColors.recPlanting;
      case RecommendationType.general:
        return AppColors.primary;
    }
  }

  Color _priorityColor(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.low:
        return AppColors.success;
      case RecommendationPriority.medium:
        return AppColors.warning;
      case RecommendationPriority.high:
        return AppColors.error;
      case RecommendationPriority.critical:
        return AppColors.errorDark;
    }
  }

  Color _statusColor(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.pending:
        return AppColors.warning;
      case RecommendationStatus.applied:
        return AppColors.success;
      case RecommendationStatus.dismissed:
        return AppColors.textSecondary;
      case RecommendationStatus.expired:
        return AppColors.muted;
    }
  }
}
