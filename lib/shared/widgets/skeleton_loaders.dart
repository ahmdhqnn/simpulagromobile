import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'skeleton_elements.dart';
import 'app_card_widget.dart';

class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(width: 4, height: 50, borderRadius: 2),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 180, height: 16),
                      SizedBox(height: 6),
                      SkeletonLine(width: 120, height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const SkeletonBox(width: 60, height: 24, borderRadius: 8),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                SkeletonBox(width: 70, height: 20, borderRadius: 10),
                SizedBox(width: 12),
                SkeletonBox(width: 70, height: 20, borderRadius: 10),
                SizedBox(width: 12),
                SkeletonBox(width: 80, height: 20, borderRadius: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlantListCardSkeleton extends StatelessWidget {
  const PlantListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SkeletonBox(width: 48, height: 48, borderRadius: 12),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 150, height: 16),
                  SizedBox(height: 6),
                  SkeletonLine(width: 100, height: 12),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const SkeletonBox(width: 60, height: 26, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

class ListTileCardSkeleton extends StatelessWidget {
  const ListTileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SkeletonCircle(size: 40),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 140, height: 15),
                  SizedBox(height: 6),
                  SkeletonLine(width: 90, height: 12),
                  SizedBox(height: 4),
                  SkeletonLine(width: 60, height: 11),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const SkeletonBox(width: 50, height: 24, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

Widget buildListSkeleton({int count = 5, String type = 'listTile'}) {
  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(vertical: 16),
    itemCount: count,
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (_, __) {
      if (type == 'task') return const TaskCardSkeleton();
      if (type == 'plant') return const PlantListCardSkeleton();
      return const ListTileCardSkeleton();
    },
  );
}

class GridCardSkeleton extends StatelessWidget {
  const GridCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(
              width: double.infinity,
              height: 120,
              borderRadius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(width: double.infinity, height: 16),
                  const SizedBox(height: 6),
                  const SkeletonLine(width: 100, height: 12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SkeletonBox(width: 50, height: 18, borderRadius: 9),
                      const Spacer(),
                      const SkeletonLine(width: 40, height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildGridSkeleton({int count = 6}) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    ),
    itemCount: count,
    itemBuilder: (_, __) => const GridCardSkeleton(),
  );
}

class CardHeaderSkeleton extends StatelessWidget {
  final bool hasDescription;
  final bool hasTrailing;
  final double iconBoxSize;
  final double titleWidth;
  final double descriptionWidth;

  const CardHeaderSkeleton({
    super.key,
    this.hasDescription = true,
    this.hasTrailing = false,
    this.iconBoxSize = 50,
    this.titleWidth = 168,
    this.descriptionWidth = 128,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SkeletonBox(
          width: iconBoxSize,
          height: iconBoxSize,
          borderRadius: AppRadius.xs,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: titleWidth, height: 22, borderRadius: 6),
              if (hasDescription) ...[
                const SizedBox(height: 5),
                SkeletonLine(
                  width: descriptionWidth,
                  height: 12,
                  borderRadius: 6,
                ),
              ],
            ],
          ),
        ),
        if (hasTrailing) ...[
          const SizedBox(width: 12),
          const SkeletonBox(width: 32, height: 32, borderRadius: 16),
        ],
      ],
    );
  }
}

class ChartCardSkeleton extends StatelessWidget {
  final double chartHeight;
  final bool hasSelector;
  final bool hasStats;
  final bool hasLegend;
  final int selectorCount;
  final bool hasDescription;
  final double radius;
  final EdgeInsetsGeometry padding;

  const ChartCardSkeleton({
    super.key,
    this.chartHeight = 220,
    this.hasSelector = true,
    this.hasStats = true,
    this.hasLegend = true,
    this.selectorCount = 4,
    this.hasDescription = true,
    this.radius = AppRadius.lg,
    this.padding = AppSpacing.card,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget.elevated(
        boxShadow: null,
        radius: radius,
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeaderSkeleton(hasDescription: hasDescription),
            if (hasSelector) ...[
              const SizedBox(height: 12),
              _SelectorSkeleton(count: selectorCount),
            ],
            if (hasStats) ...[
              const SizedBox(height: 12),
              const _StatsBarSkeleton(),
            ],
            const SizedBox(height: 12),
            _ChartAreaSkeleton(height: chartHeight),
            if (hasLegend) ...[
              const SizedBox(height: 10),
              const _LegendSkeleton(),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectorSkeleton extends StatelessWidget {
  final int count;

  const _SelectorSkeleton({required this.count});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(
          count,
          (index) => Padding(
            padding: EdgeInsets.only(right: index == count - 1 ? 0 : 8),
            child: SkeletonBox(
              width: index.isEven ? 74 : 58,
              height: 30,
              borderRadius: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsBarSkeleton extends StatelessWidget {
  const _StatsBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: const [
          Expanded(child: _StatColumnSkeleton()),
          SkeletonBox(width: 1, height: 28, borderRadius: 0),
          Expanded(child: _StatColumnSkeleton()),
          SkeletonBox(width: 1, height: 28, borderRadius: 0),
          Expanded(child: _StatColumnSkeleton()),
        ],
      ),
    );
  }
}

class _StatColumnSkeleton extends StatelessWidget {
  const _StatColumnSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SkeletonLine(width: 48, height: 14),
        SizedBox(height: 4),
        SkeletonLine(width: 32, height: 10),
      ],
    );
  }
}

class _ChartAreaSkeleton extends StatelessWidget {
  final double height;

  const _ChartAreaSkeleton({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            width: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 28, height: 9),
                SkeletonLine(width: 24, height: 9),
                SkeletonLine(width: 28, height: 9),
                SkeletonLine(width: 18, height: 9),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.82,
                    child: Container(
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
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

class _LegendSkeleton extends StatelessWidget {
  const _LegendSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SkeletonCircle(size: 8),
        SizedBox(width: 6),
        SkeletonLine(width: 74, height: 10),
        SizedBox(width: 14),
        SkeletonCircle(size: 8),
        SizedBox(width: 6),
        SkeletonLine(width: 52, height: 10),
      ],
    );
  }
}

class SensorStatusGridSkeleton extends StatelessWidget {
  final int count;
  final int crossAxisCount;

  const SensorStatusGridSkeleton({
    super.key,
    this.count = 6,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.547,
        ),
        itemCount: count,
        itemBuilder: (_, __) => const _SensorStatusCardSkeleton(),
      ),
    );
  }
}

class _SensorStatusCardSkeleton extends StatelessWidget {
  const _SensorStatusCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 201,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: const [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 14, 8, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SkeletonBox(width: 24, height: 24, borderRadius: 6),
                  Column(
                    children: [
                      SkeletonLine(width: 52, height: 30),
                      SizedBox(height: 6),
                      SkeletonLine(width: 28, height: 11),
                    ],
                  ),
                  SkeletonLine(width: 72, height: 12),
                ],
              ),
            ),
          ),
          SkeletonBox(width: double.infinity, height: 34, borderRadius: 0),
        ],
      ),
    );
  }
}

class CompactStatsCardSkeleton extends StatelessWidget {
  final int itemCount;
  final double height;

  const CompactStatsCardSkeleton({
    super.key,
    this.itemCount = 3,
    this.height = 74,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        height: height,
        radius: AppRadius.lg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            itemCount,
            (_) => const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonBox(width: 28, height: 28, borderRadius: 8),
                  SizedBox(height: 4),
                  SkeletonLine(width: 48, height: 11),
                  SizedBox(height: 2),
                  SkeletonLine(width: 28, height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleRowsCardSkeleton extends StatelessWidget {
  final int rowCount;
  final double rowHeight;
  final double iconSize;
  final bool showTrailing;
  final EdgeInsetsGeometry padding;

  const SimpleRowsCardSkeleton({
    super.key,
    this.rowCount = 4,
    this.rowHeight = 54,
    this.iconSize = 40,
    this.showTrailing = true,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        radius: AppRadius.lg,
        padding: padding,
        child: Column(
          children: List.generate(
            rowCount,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == rowCount - 1 ? 0 : 12),
              child: SizedBox(
                height: rowHeight,
                child: Row(
                  children: [
                    SkeletonBox(
                      width: iconSize,
                      height: iconSize,
                      borderRadius: AppRadius.xs,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SkeletonLine(width: 128, height: 13),
                          SizedBox(height: 5),
                          SkeletonLine(width: 88, height: 10),
                        ],
                      ),
                    ),
                    if (showTrailing) ...[
                      const SizedBox(width: 10),
                      const SkeletonLine(width: 54, height: 14),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CompactTextRowsSkeleton extends StatelessWidget {
  final int rowCount;
  final bool hasSubtitle;

  const CompactTextRowsSkeleton({
    super.key,
    this.rowCount = 3,
    this.hasSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Column(
        children: List.generate(
          rowCount,
          (index) => Container(
            margin: EdgeInsets.only(bottom: index == rowCount - 1 ? 0 : 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [SkeletonLine(width: 126, height: 12)],
                  ),
                ),
                const SizedBox(width: 12),
                const SkeletonLine(width: 64, height: 11),
                if (hasSubtitle) ...[
                  const SizedBox(width: 8),
                  const SkeletonLine(width: 48, height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KeyValueRowsCardSkeleton extends StatelessWidget {
  final int rowCount;

  const KeyValueRowsCardSkeleton({super.key, this.rowCount = 5});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget.elevated(
        boxShadow: null,
        radius: AppRadius.lg,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: List.generate(
            rowCount,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == rowCount - 1 ? 0 : 14),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonLine(width: 82, height: 11),
                  SkeletonLine(width: 64, height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DailyRecapListSkeleton extends StatelessWidget {
  final int rowCount;

  const DailyRecapListSkeleton({super.key, this.rowCount = 2});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget.elevated(
        boxShadow: null,
        radius: AppRadius.lg,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: List.generate(
            rowCount,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == rowCount - 1 ? 0 : 18),
              child: const _DailyRecapRowSkeleton(),
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyRecapRowSkeleton extends StatelessWidget {
  const _DailyRecapRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 38, height: 38, borderRadius: AppRadius.sm),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 138, height: 13),
                  SizedBox(height: 5),
                  SkeletonLine(width: 116, height: 10),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: SkeletonBox(width: double.infinity, height: 47)),
            SizedBox(width: 8),
            Expanded(child: SkeletonBox(width: double.infinity, height: 47)),
            SizedBox(width: 8),
            Expanded(child: SkeletonBox(width: double.infinity, height: 47)),
          ],
        ),
      ],
    );
  }
}

class HealthCardSkeleton extends StatelessWidget {
  const HealthCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SkeletonBox(width: 172, height: 96, borderRadius: 48),
            SizedBox(height: 8),
            SkeletonLine(width: 84, height: 44),
            SizedBox(height: 6),
            SkeletonLine(width: 96, height: 12),
            SizedBox(height: 18),
            SkeletonBox(width: 132, height: 34, borderRadius: 17),
          ],
        ),
      ),
    );
  }
}

class EnvironmentalHealthCardSkeleton extends StatelessWidget {
  const EnvironmentalHealthCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget.elevated(
        boxShadow: null,
        radius: AppRadius.lg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CardHeaderSkeleton(titleWidth: 190, descriptionWidth: 142),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  SkeletonLine(width: 96, height: 44),
                  SizedBox(height: 10),
                  SkeletonLine(width: 88, height: 12),
                ],
              ),
            ),
            SizedBox(height: 14),
            SkeletonBox(width: double.infinity, height: 6, borderRadius: 4),
            SizedBox(height: 14),
            SkeletonBox(
              width: double.infinity,
              height: 58,
              borderRadius: AppRadius.sm,
            ),
          ],
        ),
      ),
    );
  }
}

class MapCardSkeleton extends StatelessWidget {
  final double height;

  const MapCardSkeleton({super.key, this.height = 195});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Stack(
          children: const [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                    SkeletonBox(
                      width: double.infinity,
                      height: 1,
                      borderRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
            Align(alignment: Alignment.center, child: SkeletonCircle(size: 34)),
            Positioned(left: 66, top: 58, child: SkeletonCircle(size: 22)),
            Positioned(right: 58, bottom: 48, child: SkeletonCircle(size: 24)),
          ],
        ),
      ),
    );
  }
}

class SiteSelectorSkeleton extends StatelessWidget {
  const SiteSelectorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        height: 64,
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: const Row(
          children: [
            SkeletonBox(width: 40, height: 40, borderRadius: AppRadius.xs),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 132, height: 14),
                  SizedBox(height: 5),
                  SkeletonLine(width: 92, height: 10),
                ],
              ),
            ),
            SkeletonCircle(size: 24),
          ],
        ),
      ),
    );
  }
}

class SplitMetricCardsSkeleton extends StatelessWidget {
  final int count;
  final double height;

  const SplitMetricCardsSkeleton({super.key, this.count = 2, this.height = 74});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Row(
        children: List.generate(
          count,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == count - 1 ? 0 : 11),
              child: AppCardWidget(
                height: height,
                radius: AppRadius.lg,
                child: const Row(
                  children: [
                    SkeletonBox(width: 40, height: 40, borderRadius: 8),
                    SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(width: 34, height: 22),
                          SizedBox(height: 4),
                          SkeletonLine(width: 78, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecommendationOverviewCardSkeleton extends StatelessWidget {
  const RecommendationOverviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeaderSkeleton(titleWidth: 176, descriptionWidth: 154),
            SizedBox(height: 20),
            Row(
              children: [
                SkeletonBox(width: 74, height: 27, borderRadius: AppRadius.xs),
                SizedBox(width: 8),
                SkeletonBox(width: 82, height: 27, borderRadius: AppRadius.xs),
              ],
            ),
            SizedBox(height: 16),
            SkeletonBox(
              width: double.infinity,
              height: 94,
              borderRadius: AppRadius.sm,
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendationOverviewListSkeleton extends StatelessWidget {
  final int count;

  const RecommendationOverviewListSkeleton({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == count - 1 ? 0 : 12),
          child: const RecommendationOverviewCardSkeleton(),
        ),
      ),
    );
  }
}

class RecommendationListSkeleton extends StatelessWidget {
  final int count;

  const RecommendationListSkeleton({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: count,
        itemBuilder: (_, index) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonBox(width: 34, height: 34, borderRadius: 10),
                  SizedBox(width: 10),
                  Expanded(child: SkeletonLine(width: 160, height: 14)),
                  SizedBox(width: 8),
                  SkeletonBox(width: 58, height: 22, borderRadius: 8),
                ],
              ),
              SizedBox(height: 8),
              SkeletonLine(width: double.infinity, height: 12),
              SizedBox(height: 5),
              SkeletonLine(width: 220, height: 12),
              SizedBox(height: 8),
              Row(
                children: [
                  SkeletonBox(width: 60, height: 22, borderRadius: 8),
                  SizedBox(width: 8),
                  SkeletonBox(width: 72, height: 22, borderRadius: 8),
                  Spacer(),
                  SkeletonLine(width: 64, height: 11),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownFieldSkeleton extends StatelessWidget {
  const DropdownFieldSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Row(
            children: [
              Expanded(child: SkeletonLine(width: 160, height: 14)),
              SkeletonBox(width: 24, height: 24, borderRadius: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class FormCardSkeleton extends StatelessWidget {
  final int fieldCount;
  final bool hasLargeField;

  const FormCardSkeleton({
    super.key,
    this.fieldCount = 4,
    this.hasLargeField = true,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        radius: AppRadius.xl,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CardHeaderSkeleton(titleWidth: 154, descriptionWidth: 118),
            const SizedBox(height: 20),
            for (var i = 0; i < fieldCount; i++) ...[
              SkeletonBox(
                width: double.infinity,
                height: hasLargeField && i == 1 ? 112 : 56,
                borderRadius: AppRadius.sm,
              ),
              if (i != fieldCount - 1) const SizedBox(height: 12),
            ],
            const SizedBox(height: 18),
            const SkeletonBox(
              width: double.infinity,
              height: 48,
              borderRadius: AppRadius.pill,
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryGridSkeleton extends StatelessWidget {
  const SummaryGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;
        const cardHeight = 90.0;

        return SkeletonContainer(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: cardWidth / cardHeight,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            children: List.generate(4, (_) => const _SummaryCardSkeleton()),
          ),
        );
      },
    );
  }
}

class _SummaryCardSkeleton extends StatelessWidget {
  const _SummaryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 50, height: 50, borderRadius: AppRadius.sm),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonLine(width: 34, height: 22),
              SizedBox(height: 20),
              SkeletonBox(width: 22, height: 22, borderRadius: 11),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailHeaderSkeleton extends StatelessWidget {
  final double height;
  final bool hasAvatar;

  const DetailHeaderSkeleton({
    super.key,
    this.height = 180,
    this.hasAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasAvatar) ...[
                  const SkeletonCircle(size: 64),
                  const SizedBox(height: 16),
                ],
                const SkeletonLine(width: 150, height: 20),
                const SizedBox(height: 8),
                const SkeletonBox(width: 80, height: 24, borderRadius: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRowSkeleton extends StatelessWidget {
  const InfoRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SkeletonLine(width: 100, height: 14),
          const SizedBox(width: 16),
          const Expanded(
            child: SkeletonLine(width: double.infinity, height: 14),
          ),
        ],
      ),
    );
  }
}

class DetailScreenSkeleton extends StatelessWidget {
  final int infoRowCount;
  final bool hasDescription;
  final double headerHeight;
  final bool hasAvatar;

  const DetailScreenSkeleton({
    super.key,
    this.infoRowCount = 5,
    this.hasDescription = true,
    this.headerHeight = 180,
    this.hasAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DetailHeaderSkeleton(height: headerHeight, hasAvatar: hasAvatar),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SkeletonContainer(
                  child: AppCardWidget(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SkeletonLine(width: 120, height: 16),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        for (int i = 0; i < infoRowCount; i++)
                          const InfoRowSkeleton(),
                      ],
                    ),
                  ),
                ),
                if (hasDescription) ...[
                  const SizedBox(height: 16),
                  SkeletonContainer(
                    child: AppCardWidget(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonLine(width: 100, height: 16),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          const SkeletonLine(
                            width: double.infinity,
                            height: 14,
                          ),
                          const SizedBox(height: 8),
                          const SkeletonLine(
                            width: double.infinity,
                            height: 14,
                          ),
                          const SizedBox(height: 8),
                          const SkeletonLine(width: 200, height: 14),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SkeletonContainer(
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 48,
                    borderRadius: 24,
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

class PostCardSkeleton extends StatelessWidget {
  final bool hasImage;

  const PostCardSkeleton({super.key, this.hasImage = false});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonCircle(size: 36),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 120, height: 14),
                    SizedBox(height: 4),
                    SkeletonLine(width: 80, height: 10),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonLine(width: double.infinity, height: 16),
            const SizedBox(height: 4),
            const SkeletonLine(width: 200, height: 16),
            const SizedBox(height: 12),
            const SkeletonLine(width: double.infinity, height: 12),
            const SizedBox(height: 4),
            const SkeletonLine(width: double.infinity, height: 12),
            const SizedBox(height: 4),
            const SkeletonLine(width: 150, height: 12),
            if (hasImage) ...[
              const SizedBox(height: 12),
              const SkeletonBox(
                width: double.infinity,
                height: 180,
                borderRadius: 12,
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SkeletonLine(width: 60, height: 16),
                const SkeletonLine(width: 60, height: 16),
                const SkeletonLine(width: 60, height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCardSkeleton extends StatelessWidget {
  const DashboardCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonCircle(size: 40),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 100, height: 16),
                    SizedBox(height: 4),
                    SkeletonLine(width: 60, height: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonBox(
              width: double.infinity,
              height: 80,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class MonitoringSensorSkeleton extends StatelessWidget {
  const MonitoringSensorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: AppCardWidget(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const SkeletonCircle(size: 32),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 80, height: 14),
                SizedBox(height: 4),
                SkeletonLine(width: 50, height: 10),
              ],
            ),
            const Spacer(),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SkeletonLine(width: 40, height: 18),
                SizedBox(height: 4),
                SkeletonLine(width: 20, height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DetailHeaderSkeleton(height: 220),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SkeletonContainer(
                  child: AppCardWidget(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 3; i++) const InfoRowSkeleton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < 3; i++) ...[
                  SkeletonContainer(
                    child: AppCardWidget(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const SkeletonCircle(size: 24),
                          const SizedBox(width: 16),
                          const SkeletonLine(width: 150, height: 16),
                          const Spacer(),
                          const SkeletonBox(
                            width: 24,
                            height: 24,
                            borderRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
