import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../admin/presentation/providers/permission_guard_provider.dart';
import '../../domain/entities/recommendation.dart';
import '../../../phase/presentation/providers/phase_provider.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/plant_input_tab.dart';
import '../widgets/recommendation_lab_tab.dart';

/// Shell rekomendasi: Live, Plant Input, History, By Phase, Lab (admin).
class RecommendationTabsScreen extends ConsumerStatefulWidget {
  const RecommendationTabsScreen({super.key});

  @override
  ConsumerState<RecommendationTabsScreen> createState() =>
      _RecommendationTabsScreenState();
}

class _RecommendationTabsScreenState
    extends ConsumerState<RecommendationTabsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    final tabCount = isAdmin ? 5 : 4;
    if (_tabController == null || _tabController!.length != tabCount) {
      _tabController?.dispose();
      _tabController = TabController(length: tabCount, vsync: this);
    }

    final tabs = <Widget>[
      const Tab(text: 'Live'),
      const Tab(text: 'Input Tanaman'),
      const Tab(text: 'History'),
      const Tab(text: 'Per Fase'),
      if (isAdmin) const Tab(text: 'Lab'),
    ];

    final views = <Widget>[
      const _LiveTab(),
      const PlantInputTab(),
      const _HistoryTab(),
      const _ByPhaseTab(),
      if (isAdmin) const RecommendationLabTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.015),
              ),
              child: Row(
                children: [
                  CircularBackButtonWidget(
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Rekomendasi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              tabs: tabs,
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: views),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveTab extends ConsumerWidget {
  const _LiveTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(recommendationListProvider);
    return listAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (list) => _RecommendationSimpleList(recommendations: list),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(recommendationHistoryProvider);
    return historyAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (list) => _RecommendationSimpleList(recommendations: list),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _ByPhaseTab extends ConsumerWidget {
  const _ByPhaseTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phasesAsync = ref.watch(phasesForSelectedSiteProvider);
    final selectedPhase = ref.watch(selectedPhaseIdForRecProvider);
    final recAsync = ref.watch(recommendationByPhaseProvider);

    return Column(
      children: [
        phasesAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          data: (phases) => Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: selectedPhase,
              decoration: const InputDecoration(
                labelText: 'Pilih Fase',
                border: OutlineInputBorder(),
              ),
              items: phases
                  .map(
                    (p) =>
                        DropdownMenuItem(value: p.id, child: Text(p.phaseName)),
                  )
                  .toList(),
              onChanged: (v) {
                ref.read(selectedPhaseIdForRecProvider.notifier).state = v;
                ref.invalidate(recommendationByPhaseProvider);
              },
            ),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        Expanded(
          child: selectedPhase == null
              ? const Center(child: Text('Pilih fase terlebih dahulu'))
              : recAsync.when(
                  skipLoadingOnReload: true,
                  skipLoadingOnRefresh: true,
                  skipError: true,
                  data: (list) =>
                      _RecommendationSimpleList(recommendations: list),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                ),
        ),
      ],
    );
  }
}

class _RecommendationSimpleList extends StatelessWidget {
  final List<Recommendation> recommendations;

  const _RecommendationSimpleList({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recommendations.length,
      itemBuilder: (_, i) {
        final r = recommendations[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(title: Text(r.title), subtitle: Text(r.description)),
        );
      },
    );
  }
}
