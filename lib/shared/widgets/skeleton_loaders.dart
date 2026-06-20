import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/l10n.dart';
import 'skeleton_elements.dart';
import 'app_card_widget.dart';
import 'section_header_widget.dart';

class _SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final BoxBorder? border;
  final double? height;
  final double? width;
  final bool elevated;

  const _SkeletonCard({
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = AppRadius.xl,
    this.color,
    this.border,
    this.height,
    this.width,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = SkeletonContainer(child: child);
    if (elevated) {
      return AppCardWidget.elevated(
        boxShadow: null,
        radius: radius,
        padding: padding,
        color: color,
        border: border,
        height: height,
        width: width,
        child: content,
      );
    }

    return AppCardWidget(
      radius: radius,
      padding: padding,
      color: color,
      border: border,
      height: height,
      width: width,
      child: content,
    );
  }
}

class _SkeletonPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BoxBorder? border;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const _SkeletonPanel({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = AppRadius.lg,
    this.border,
    this.height,
    this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: SkeletonContainer(child: child),
    );
  }
}

class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 4, height: 50, borderRadius: 2),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 180, height: 16),
                    SizedBox(height: 6),
                    SkeletonLine(width: 120, height: 12),
                  ],
                ),
              ),
              SizedBox(width: 8),
              SkeletonBox(width: 60, height: 24, borderRadius: 8),
            ],
          ),
          SizedBox(height: 12),
          Row(
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
    );
  }
}

class PlantListCardSkeleton extends StatelessWidget {
  const PlantListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonBox(width: 48, height: 48, borderRadius: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 150, height: 16),
                    SizedBox(height: 6),
                    SkeletonLine(width: 100, height: 12),
                  ],
                ),
              ),
              SizedBox(width: 8),
              SkeletonBox(width: 60, height: 26, borderRadius: 8),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: const Row(
                    children: [
                      SkeletonCircle(size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 30, height: 10),
                            SizedBox(height: 4),
                            SkeletonLine(width: 50, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: const Row(
                    children: [
                      SkeletonCircle(size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 30, height: 10),
                            SizedBox(height: 4),
                            SkeletonLine(width: 70, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListTileCardSkeleton extends StatelessWidget {
  const ListTileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SkeletonCircle(size: 40),
          SizedBox(width: 16),
          Expanded(
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
          SizedBox(width: 16),
          SkeletonBox(width: 50, height: 24, borderRadius: 8),
        ],
      ),
    );
  }
}

Widget buildListSkeleton({
  int count = 5,
  String type = 'listTile',
  EdgeInsetsGeometry padding = const EdgeInsets.all(16),
}) {
  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: padding,
    itemCount: count,
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (_, __) {
      if (type == 'task') return const TaskCardSkeleton();
      if (type == 'plant') return const PlantListCardSkeleton();
      if (type == 'recommendation') return const RecommendationCardSkeleton();
      if (type == 'phase') return const PhaseCardSkeleton();
      if (type == 'site') return const SiteCardSkeleton();
      if (type == 'admin') return const AdminListItemSkeleton();
      return const ListTileCardSkeleton();
    },
  );
}

class GridCardSkeleton extends StatelessWidget {
  const GridCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: double.infinity, height: 120, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: double.infinity, height: 16),
                SizedBox(height: 6),
                SkeletonLine(width: 100, height: 12),
                SizedBox(height: 12),
                Row(
                  children: [
                    SkeletonBox(width: 50, height: 18, borderRadius: 9),
                    Spacer(),
                    SkeletonLine(width: 40, height: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    return _SkeletonCard(
      elevated: true,
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
    return GridView.builder(
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
    );
  }
}

class _SensorStatusCardSkeleton extends StatelessWidget {
  const _SensorStatusCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return _SkeletonPanel(
      height: 201,
      radius: AppRadius.lg,
      child: const Column(
        children: [
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
  final double? height;

  const CompactStatsCardSkeleton({super.key, this.itemCount = 3, this.height});

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      height: height ?? 74,
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          itemCount,
          (_) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SkeletonBox(
                width: 32,
                height: 32,
                borderRadius: AppRadius.xs,
              ),
              const SizedBox(width: 6),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonLine(width: 20, height: 14),
                  SizedBox(height: 4),
                  SkeletonLine(width: 32, height: 10),
                ],
              ),
            ],
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
    return _SkeletonCard(
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
    );
  }
}

class LatestNotesCardSkeleton extends StatelessWidget {
  final int rowCount;

  const LatestNotesCardSkeleton({super.key, this.rowCount = 3});

  @override
  Widget build(BuildContext context) {
    return _SkeletonPanel(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      radius: AppRadius.lg,
      child: Column(
        children: List.generate(
          rowCount,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index == rowCount - 1 ? 0 : 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(width: 40, height: 40, borderRadius: 8),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: index.isEven ? 156 : 126, height: 14),
                      const SizedBox(height: 6),
                      const SkeletonLine(width: double.infinity, height: 11),
                      const SizedBox(height: 5),
                      SkeletonLine(width: index.isEven ? 210 : 172, height: 11),
                      const SizedBox(height: 7),
                      const SkeletonLine(width: 92, height: 10),
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

class SiteNotesSectionSkeleton extends StatelessWidget {
  const SiteNotesSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        Align(
          alignment: Alignment.centerLeft,
          child: SkeletonContainer(
            child: SkeletonBox(width: 132, height: 40, borderRadius: 20),
          ),
        ),
        SizedBox(height: 12),
        LatestNotesCardSkeleton(rowCount: 4),
      ],
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
    return Column(
      children: List.generate(
        rowCount,
        (index) => _SkeletonPanel(
          margin: EdgeInsets.only(bottom: index == rowCount - 1 ? 0 : 8),
          padding: const EdgeInsets.all(14),
          radius: AppRadius.sm,
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
    );
  }
}

class KeyValueRowsCardSkeleton extends StatelessWidget {
  final int rowCount;

  const KeyValueRowsCardSkeleton({super.key, this.rowCount = 5});

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      elevated: true,
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
    );
  }
}

class DailyRecapListSkeleton extends StatelessWidget {
  final int rowCount;

  const DailyRecapListSkeleton({super.key, this.rowCount = 2});

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      elevated: true,
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
    return const _SkeletonPanel(
      width: double.infinity,
      radius: AppRadius.xl,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SkeletonBox(width: 172, height: 96, borderRadius: 48),
          SizedBox(height: 8),
          SkeletonLine(width: 84, height: 44),
          SizedBox(height: 6),
          SkeletonLine(width: 96, height: 12),
          SizedBox(height: 18),
          SkeletonBox(width: 132, height: 34, borderRadius: 17),
        ],
      ),
    );
  }
}

class EnvironmentalHealthCardSkeleton extends StatelessWidget {
  const EnvironmentalHealthCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      elevated: true,
      radius: AppRadius.lg,
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    );
  }
}

class NoActivePlantCardSkeleton extends StatelessWidget {
  const NoActivePlantCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      radius: AppRadius.lg,
      color: AppColors.softOrange,
      border: Border.all(color: AppColors.warning.withValues(alpha: 0.24)),
      padding: const EdgeInsets.all(14),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(
            titleWidth: 176,
            descriptionWidth: 228,
            iconBoxSize: 50,
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 46,
                  borderRadius: AppRadius.sm,
                ),
              ),
              SizedBox(width: 10),
              SkeletonBox(width: 46, height: 46, borderRadius: AppRadius.sm),
            ],
          ),
        ],
      ),
    );
  }
}

class CenteredInfoStateSkeleton extends StatelessWidget {
  final double iconSize;
  final double titleWidth;
  final double messageWidth;

  const CenteredInfoStateSkeleton({
    super.key,
    this.iconSize = 72,
    this.titleWidth = 150,
    this.messageWidth = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonCircle(size: iconSize),
              const SizedBox(height: 16),
              SkeletonLine(width: titleWidth, height: 18),
              const SizedBox(height: 8),
              SkeletonLine(width: messageWidth, height: 13),
              const SizedBox(height: 6),
              SkeletonLine(width: messageWidth * 0.72, height: 13),
            ],
          ),
        ),
      ),
    );
  }
}

class AgroRecommendationCardSkeleton extends StatelessWidget {
  const AgroRecommendationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AgroSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 192, descriptionWidth: 166),
          SizedBox(height: 20),
          _AgroRecommendationItemSkeleton(),
          SizedBox(height: 12),
          _AgroRecommendationItemSkeleton(compact: true),
        ],
      ),
    );
  }
}

class AgroPhaseCardSkeleton extends StatelessWidget {
  const AgroPhaseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AgroSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 184, descriptionWidth: 150),
          SizedBox(height: 20),
          _AgroSummaryPanelSkeleton(
            height: 88,
            trailingPillWidth: 64,
            lineWidths: [138, 220, 168],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLine(width: 130, height: 12),
              SkeletonLine(width: 72, height: 12),
            ],
          ),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 8, borderRadius: 4),
        ],
      ),
    );
  }
}

class AgroEnvironmentalHealthCardSkeleton extends StatelessWidget {
  const AgroEnvironmentalHealthCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AgroSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 210, descriptionWidth: 172),
          SizedBox(height: 24),
          SkeletonBox(
            width: double.infinity,
            height: 144,
            borderRadius: AppRadius.md,
          ),
          SizedBox(height: 16),
          _AgroSensorPanelSkeleton(),
          SizedBox(height: 24),
          SkeletonLine(width: 112, height: 14),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AgroCircleMetricSkeleton(),
              _AgroCircleMetricSkeleton(),
              _AgroCircleMetricSkeleton(),
            ],
          ),
          SizedBox(height: 16),
          SkeletonBox(
            width: double.infinity,
            height: 72,
            borderRadius: AppRadius.sm,
          ),
        ],
      ),
    );
  }
}

class AgroVdpCardSkeleton extends StatelessWidget {
  const AgroVdpCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AgroSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 60, descriptionWidth: 142),
          SizedBox(height: 20),
          _AgroSummaryPanelSkeleton(
            height: 84,
            trailingValueWidth: 76,
            lineWidths: [82, 74],
          ),
          SizedBox(height: 20),
          SkeletonLine(width: 76, height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 8, borderRadius: 4),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLine(width: 10, height: 10),
              SkeletonLine(width: 22, height: 10),
              SkeletonLine(width: 22, height: 10),
              SkeletonLine(width: 28, height: 10),
            ],
          ),
          SizedBox(height: 16),
          SkeletonBox(
            width: double.infinity,
            height: 72,
            borderRadius: AppRadius.xs,
          ),
          SizedBox(height: 16),
          SkeletonLine(width: 84, height: 14),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: SkeletonBox(width: double.infinity, height: 64)),
              SizedBox(width: 8),
              Expanded(child: SkeletonBox(width: double.infinity, height: 64)),
              SizedBox(width: 8),
              Expanded(child: SkeletonBox(width: double.infinity, height: 64)),
            ],
          ),
        ],
      ),
    );
  }
}

class AgroGddCardSkeleton extends StatelessWidget {
  const AgroGddCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AgroSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 62, descriptionWidth: 178),
          SizedBox(height: 20),
          _AgroSummaryPanelSkeleton(
            height: 86,
            trailingValueWidth: 92,
            lineWidths: [82, 66],
          ),
          SizedBox(height: 20),
          SkeletonLine(width: 176, height: 14),
          SizedBox(height: 12),
          _ChartAreaSkeleton(height: 160),
          SizedBox(height: 16),
          _AgroTableSkeleton(rowCount: 4),
        ],
      ),
    );
  }
}

class AgroEtcCardSkeleton extends StatelessWidget {
  const AgroEtcCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AgroSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 62, descriptionWidth: 150),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _AgroMetricBoxSkeleton()),
              SizedBox(width: 12),
              Expanded(child: _AgroMetricBoxSkeleton()),
              SizedBox(width: 12),
              Expanded(child: _AgroMetricBoxSkeleton()),
            ],
          ),
          SizedBox(height: 20),
          SkeletonLine(width: 118, height: 14),
          SizedBox(height: 12),
          _ChartAreaSkeleton(height: 160),
          SizedBox(height: 16),
          SkeletonBox(
            width: double.infinity,
            height: 72,
            borderRadius: AppRadius.xs,
          ),
          SizedBox(height: 16),
          _AgroTableSkeleton(rowCount: 3),
        ],
      ),
    );
  }
}

class AgroInfoCardSkeleton extends StatelessWidget {
  const AgroInfoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AgroSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 36, height: 36, borderRadius: AppRadius.xs),
              SizedBox(width: 12),
              SkeletonLine(width: 170, height: 16),
            ],
          ),
          SizedBox(height: 16),
          _AgroInfoItemSkeleton(width: 174),
          SizedBox(height: 12),
          _AgroInfoItemSkeleton(width: 154),
          SizedBox(height: 12),
          _AgroInfoItemSkeleton(width: 166),
        ],
      ),
    );
  }
}

class _AgroSkeletonCard extends StatelessWidget {
  final Widget child;

  const _AgroSkeletonCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return AppCardWidget(
      radius: AppRadius.lg,
      padding: AppSpacing.card,
      child: SkeletonContainer(child: child),
    );
  }
}

class _AgroRecommendationItemSkeleton extends StatelessWidget {
  final bool compact;

  const _AgroRecommendationItemSkeleton({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonBox(width: 62, height: 22, borderRadius: 11),
              SizedBox(width: 8),
              SkeletonLine(width: 74, height: 12),
            ],
          ),
          const SizedBox(height: 12),
          SkeletonLine(width: compact ? 150 : 190, height: 16),
          const SizedBox(height: 8),
          const SkeletonLine(width: double.infinity, height: 12),
          const SizedBox(height: 6),
          SkeletonLine(width: compact ? 176 : 230, height: 12),
          if (!compact) ...[
            const SizedBox(height: 12),
            const SkeletonBox(
              width: double.infinity,
              height: 48,
              borderRadius: AppRadius.xs,
            ),
          ],
        ],
      ),
    );
  }
}

class _AgroSummaryPanelSkeleton extends StatelessWidget {
  final double height;
  final double trailingValueWidth;
  final double trailingPillWidth;
  final List<double> lineWidths;

  const _AgroSummaryPanelSkeleton({
    required this.height,
    this.trailingValueWidth = 78,
    this.trailingPillWidth = 0,
    required this.lineWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final width in lineWidths) ...[
                  SkeletonLine(
                    width: width,
                    height: width == lineWidths.first ? 14 : 12,
                  ),
                  if (width != lineWidths.last) const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (trailingPillWidth > 0)
                SkeletonBox(
                  width: trailingPillWidth,
                  height: 26,
                  borderRadius: 13,
                )
              else ...[
                SkeletonLine(width: trailingValueWidth, height: 30),
                const SizedBox(height: 5),
                const SkeletonLine(width: 42, height: 11),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AgroSensorPanelSkeleton extends StatelessWidget {
  const _AgroSensorPanelSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              SkeletonBox(width: 18, height: 18, borderRadius: 5),
              SizedBox(width: 8),
              Expanded(child: SkeletonLine(width: 144, height: 13)),
              SizedBox(width: 12),
              SkeletonLine(width: 56, height: 12),
            ],
          ),
          SizedBox(height: 12),
          _AgroCompactRowSkeleton(),
          SizedBox(height: 8),
          _AgroCompactRowSkeleton(),
        ],
      ),
    );
  }
}

class _AgroCompactRowSkeleton extends StatelessWidget {
  const _AgroCompactRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 112, height: 12),
              SizedBox(height: 4),
              SkeletonLine(width: 156, height: 10),
            ],
          ),
        ),
        SizedBox(width: 12),
        SkeletonBox(width: 42, height: 22, borderRadius: 11),
      ],
    );
  }
}

class _AgroCircleMetricSkeleton extends StatelessWidget {
  const _AgroCircleMetricSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonCircle(size: 72),
        SizedBox(height: 8),
        SkeletonLine(width: 32, height: 12),
      ],
    );
  }
}

class _AgroMetricBoxSkeleton extends StatelessWidget {
  const _AgroMetricBoxSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(
      width: double.infinity,
      height: 94,
      borderRadius: AppRadius.sm,
    );
  }
}

class _AgroTableSkeleton extends StatelessWidget {
  final int rowCount;

  const _AgroTableSkeleton({required this.rowCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonLine(width: 126, height: 14),
        const SizedBox(height: 12),
        const SkeletonBox(
          width: double.infinity,
          height: 40,
          borderRadius: AppRadius.xs,
        ),
        for (var index = 0; index < rowCount; index++) ...[
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(flex: 2, child: SkeletonLine(width: 90, height: 12)),
              Expanded(
                child: Center(child: SkeletonLine(width: 44, height: 12)),
              ),
              Expanded(
                child: Center(child: SkeletonLine(width: 44, height: 12)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SkeletonLine(width: 38, height: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _AgroInfoItemSkeleton extends StatelessWidget {
  final double width;

  const _AgroInfoItemSkeleton({required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(width: width, height: 14),
        const SizedBox(height: 6),
        const SkeletonLine(width: double.infinity, height: 12),
        const SizedBox(height: 5),
        const SkeletonLine(width: 260, height: 12),
      ],
    );
  }
}

class MapCardSkeleton extends StatelessWidget {
  final double height;

  const MapCardSkeleton({super.key, this.height = 195});

  @override
  Widget build(BuildContext context) {
    return _SkeletonPanel(
      height: height,
      radius: AppRadius.lg,
      child: const Stack(
        children: [
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
    );
  }
}

class SiteSelectorSkeleton extends StatelessWidget {
  const SiteSelectorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      height: 64,
      radius: AppRadius.lg,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
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
    );
  }
}

class SplitMetricCardsSkeleton extends StatelessWidget {
  final int count;
  final double height;

  const SplitMetricCardsSkeleton({super.key, this.count = 2, this.height = 74});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == count - 1 ? 0 : 11),
            child: _SkeletonCard(
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
    );
  }
}

class RecommendationOverviewCardSkeleton extends StatelessWidget {
  const RecommendationOverviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonPanel(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      radius: AppRadius.lg,
      child: Column(
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      itemBuilder: (_, index) => const _SkeletonPanel(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(12),
        radius: 14,
        child: Column(
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
    );
  }
}

class DropdownFieldSkeleton extends StatelessWidget {
  final double height;
  final double radius;
  final EdgeInsetsGeometry padding;

  const DropdownFieldSkeleton({
    super.key,
    this.height = 56,
    this.radius = AppRadius.sm,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: _SkeletonPanel(
        height: height,
        radius: radius,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Row(
          children: [
            Expanded(child: SkeletonLine(width: 160, height: 14)),
            SkeletonBox(width: 24, height: 24, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

class FormCardSkeleton extends StatelessWidget {
  final int fieldCount;
  final bool hasLargeField;
  final bool showHeader;
  final bool showSubmitButton;
  final bool useCircularActions;

  const FormCardSkeleton({
    super.key,
    this.fieldCount = 4,
    this.hasLargeField = true,
    this.showHeader = true,
    this.showSubmitButton = true,
    this.useCircularActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            const CardHeaderSkeleton(titleWidth: 154, descriptionWidth: 118),
            const SizedBox(height: 20),
          ],
          for (var i = 0; i < fieldCount; i++) ...[
            _FormFieldBlockSkeleton(
              labelWidth: i.isEven ? 112 : 86,
              height: hasLargeField && i == 1 ? 108 : 48,
              borderRadius: hasLargeField && i == 1
                  ? AppRadius.xl
                  : AppRadius.pill,
            ),
            if (i != fieldCount - 1) const SizedBox(height: 12),
          ],
          if (showSubmitButton) ...[
            const SizedBox(height: 18),
            if (useCircularActions)
              const _CircularFormActionsSkeleton()
            else
              const SkeletonBox(
                width: double.infinity,
                height: 48,
                borderRadius: AppRadius.pill,
              ),
          ],
        ],
      ),
    );
  }
}

class PlantFormCardSkeleton extends StatelessWidget {
  final bool showConflictBanner;

  const PlantFormCardSkeleton({super.key, this.showConflictBanner = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showConflictBanner) ...[
          const _SkeletonPanel(
            radius: AppRadius.md,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SkeletonCircle(size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 176, height: 12),
                      SizedBox(height: 6),
                      SkeletonLine(width: 128, height: 11),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        const _SkeletonCard(
          radius: AppRadius.xl,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FormFieldBlockSkeleton(labelWidth: 104),
              SizedBox(height: 20),
              _FormFieldBlockSkeleton(labelWidth: 136, trailingIcon: true),
              SizedBox(height: 20),
              _FormFieldBlockSkeleton(labelWidth: 92, trailingIcon: true),
              SizedBox(height: 20),
              _FormFieldBlockSkeleton(labelWidth: 112, trailingIcon: true),
              SizedBox(height: 28),
              _CircularFormActionsSkeleton(),
            ],
          ),
        ),
      ],
    );
  }
}

class TaskFormCardSkeleton extends StatelessWidget {
  final bool isEditMode;

  const TaskFormCardSkeleton({super.key, this.isEditMode = false});

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isEditMode) ...[
            const _FormFieldBlockSkeleton(labelWidth: 54, trailingIcon: true),
            const SizedBox(height: 20),
          ],
          const _FormFieldBlockSkeleton(labelWidth: 96),
          const SizedBox(height: 20),
          const _FormFieldBlockSkeleton(
            labelWidth: 86,
            height: 108,
            borderRadius: AppRadius.xl,
          ),
          const SizedBox(height: 20),
          const _ChoiceGroupSkeleton(labelWidth: 80, pillWidths: [92, 84, 78]),
          const SizedBox(height: 20),
          const _ChoiceGroupSkeleton(labelWidth: 70, pillWidths: [74, 92, 78]),
          if (isEditMode) ...[
            const SizedBox(height: 20),
            const _ChoiceGroupSkeleton(
              labelWidth: 64,
              pillWidths: [76, 88, 78, 70],
            ),
          ],
          const SizedBox(height: 28),
          const _CircularFormActionsSkeleton(),
        ],
      ),
    );
  }
}

class AdminFormScreenSkeleton extends StatelessWidget {
  final double titleWidth;
  final List<int> sectionFieldCounts;
  final bool showSubmitButton;

  const AdminFormScreenSkeleton({
    super.key,
    this.titleWidth = 180,
    this.sectionFieldCounts = const [4],
    this.showSubmitButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        const SizedBox(height: 8),
        SkeletonContainer(child: SkeletonLine(width: titleWidth, height: 22)),
        const SizedBox(height: 14),
        for (var i = 0; i < sectionFieldCounts.length; i++) ...[
          _AdminFormSectionSkeleton(
            fieldCount: sectionFieldCounts[i],
            titleWidth: i.isEven ? 154 : 126,
          ),
          const SizedBox(height: 16),
        ],
        if (showSubmitButton) ...[
          const SkeletonContainer(
            child: SkeletonBox(
              width: double.infinity,
              height: 60,
              borderRadius: AppRadius.pill,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _AdminFormSectionSkeleton extends StatelessWidget {
  final int fieldCount;
  final double titleWidth;

  const _AdminFormSectionSkeleton({
    required this.fieldCount,
    required this.titleWidth,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      radius: 20,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: titleWidth, height: 16),
          const SizedBox(height: 14),
          for (var i = 0; i < fieldCount; i++) ...[
            SkeletonBox(
              width: double.infinity,
              height: i == 2 && fieldCount > 4 ? 72 : 54,
              borderRadius: 12,
            ),
            if (i != fieldCount - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FormFieldBlockSkeleton extends StatelessWidget {
  final double labelWidth;
  final double height;
  final double borderRadius;
  final bool trailingIcon;

  const _FormFieldBlockSkeleton({
    required this.labelWidth,
    this.height = 48,
    this.borderRadius = AppRadius.pill,
    this.trailingIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(width: labelWidth, height: 13),
        const SizedBox(height: 10),
        SkeletonBox(
          width: double.infinity,
          height: height,
          borderRadius: borderRadius,
        ),
        if (trailingIcon) ...[
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: SkeletonLine(width: 126, height: 11),
          ),
        ],
      ],
    );
  }
}

class _ChoiceGroupSkeleton extends StatelessWidget {
  final double labelWidth;
  final List<double> pillWidths;

  const _ChoiceGroupSkeleton({
    required this.labelWidth,
    required this.pillWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(width: labelWidth, height: 13),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final width in pillWidths)
              SkeletonBox(width: width, height: 32, borderRadius: 16),
          ],
        ),
      ],
    );
  }
}

class _CircularFormActionsSkeleton extends StatelessWidget {
  const _CircularFormActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [SkeletonCircle(size: 52), SkeletonCircle(size: 52)],
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

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: cardWidth / cardHeight,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          children: List.generate(4, (_) => const _SummaryCardSkeleton()),
        );
      },
    );
  }
}

class _SummaryCardSkeleton extends StatelessWidget {
  const _SummaryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonPanel(
      height: 90,
      padding: EdgeInsets.all(12),
      radius: AppRadius.lg,
      child: Row(
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
    return Container(
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
          child: SkeletonContainer(
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
                _SkeletonCard(
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
                if (hasDescription) ...[
                  const SizedBox(height: 16),
                  const _SkeletonCard(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 100, height: 16),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 8),
                        SkeletonLine(width: double.infinity, height: 14),
                        SizedBox(height: 8),
                        SkeletonLine(width: double.infinity, height: 14),
                        SizedBox(height: 8),
                        SkeletonLine(width: 200, height: 14),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const SkeletonContainer(
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

class PlantOverviewSkeleton extends StatelessWidget {
  const PlantOverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const SizedBox(height: 58),
            const SizedBox(height: 18),
            Text(
              context.l10n.plantOverviewTitle,
              style: AppTextStyles.sectionTitle(context),
            ),
            const SizedBox(height: 16),
            SkeletonContainer(
              child: SizedBox(
                width: double.infinity,
                height: 270,
                child: Center(
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(115),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const SkeletonContainer(
              child: Row(
                children: [
                  SkeletonBox(
                    width: 136,
                    height: 44,
                    borderRadius: AppRadius.pill,
                  ),
                  Spacer(),
                  SkeletonBox(
                    width: 136,
                    height: 44,
                    borderRadius: AppRadius.pill,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SkeletonCard(
              radius: AppRadius.lg,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 178, height: 22),
                            SizedBox(height: 7),
                            SkeletonLine(width: 118, height: 12),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      SkeletonBox(
                        width: 82,
                        height: 26,
                        borderRadius: AppRadius.xs,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (var i = 0; i < 6; i++) ...[
                    const _TwoColumnInfoRowSkeleton(),
                    if (i != 5) const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            const RecommendationOverviewListSkeleton(count: 2),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class PhaseStatsCardSkeleton extends StatelessWidget {
  const PhaseStatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(
            titleWidth: 206,
            descriptionWidth: 146,
            iconBoxSize: 50,
          ),
          SizedBox(height: 20),
          SkeletonBox(width: double.infinity, height: 8, borderRadius: 4),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatColumnSkeleton(),
              _StatColumnSkeleton(),
              _StatColumnSkeleton(),
            ],
          ),
        ],
      ),
    );
  }
}

class GddSummaryCardSkeleton extends StatelessWidget {
  const GddSummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(
            titleWidth: 142,
            descriptionWidth: 96,
            iconBoxSize: 50,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_WideStatColumnSkeleton(), _WideStatColumnSkeleton()],
          ),
        ],
      ),
    );
  }
}

class GddTrackingSkeleton extends StatelessWidget {
  const GddTrackingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          SkeletonContainer(child: SkeletonLine(width: 170, height: 22)),
          SizedBox(height: 14),
          GddSummaryCardSkeleton(),
          SizedBox(height: 24),
          _GddChartCardSkeleton(),
          SizedBox(height: 24),
          _GddTableCardSkeleton(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class PhaseDetailContentSkeleton extends StatelessWidget {
  const PhaseDetailContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          _PhaseHeaderCardSkeleton(),
          SizedBox(height: 24),
          _PhaseProgressCardSkeleton(),
          SizedBox(height: 24),
          _PhaseTimelineCardSkeleton(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class RecommendationDetailContentSkeleton extends StatelessWidget {
  const RecommendationDetailContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          _RecommendationTitleCardSkeleton(),
          SizedBox(height: 16),
          _RecommendationInfoCardSkeleton(),
          SizedBox(height: 16),
          _RecommendationKeyValueCardSkeleton(titleWidth: 84, rowCount: 3),
          SizedBox(height: 16),
          _RecommendationActionStepsSkeleton(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class ProfilePermissionsCardSkeleton extends StatelessWidget {
  const ProfilePermissionsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      height: 82,
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          SkeletonBox(width: 50, height: 50, borderRadius: 10),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 176, height: 22),
                SizedBox(height: 6),
                SkeletonLine(width: 112, height: 12),
              ],
            ),
          ),
          SkeletonBox(width: 24, height: 24, borderRadius: 12),
        ],
      ),
    );
  }
}

class PermissionGroupsSkeleton extends StatelessWidget {
  final int groupCount;
  final int rowsPerGroup;

  const PermissionGroupsSkeleton({
    super.key,
    this.groupCount = 3,
    this.rowsPerGroup = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        groupCount,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == groupCount - 1 ? 0 : 12),
          child: _PermissionGroupCardSkeleton(rowCount: rowsPerGroup),
        ),
      ),
    );
  }
}

class InlineStatsCardSkeleton extends StatelessWidget {
  final int itemCount;
  final double height;

  const InlineStatsCardSkeleton({
    super.key,
    this.itemCount = 4,
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      height: height,
      radius: AppRadius.sm,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          itemCount,
          (_) => const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(width: 28, height: 16),
                SizedBox(height: 5),
                SkeletonLine(width: 52, height: 11),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TwoColumnInfoRowSkeleton extends StatelessWidget {
  const _TwoColumnInfoRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 132, child: SkeletonLine(width: 104, height: 12)),
        SizedBox(width: 12),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SkeletonLine(width: 116, height: 12),
          ),
        ),
      ],
    );
  }
}

class _WideStatColumnSkeleton extends StatelessWidget {
  const _WideStatColumnSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonLine(width: 88, height: 24),
        SizedBox(height: 6),
        SkeletonLine(width: 102, height: 12),
      ],
    );
  }
}

class _GddChartCardSkeleton extends StatelessWidget {
  const _GddChartCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 176, descriptionWidth: 160),
          SizedBox(height: 20),
          _ChartAreaSkeleton(height: 250),
        ],
      ),
    );
  }
}

class _GddTableCardSkeleton extends StatelessWidget {
  const _GddTableCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 188, descriptionWidth: 172),
          SizedBox(height: 20),
          _AgroTableSkeleton(rowCount: 4),
        ],
      ),
    );
  }
}

class _PhaseHeaderCardSkeleton extends StatelessWidget {
  const _PhaseHeaderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 164, descriptionWidth: 116),
          SizedBox(height: 12),
          SkeletonLine(width: double.infinity, height: 13),
          SizedBox(height: 6),
          SkeletonLine(width: 230, height: 13),
        ],
      ),
    );
  }
}

class _PhaseProgressCardSkeleton extends StatelessWidget {
  const _PhaseProgressCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 142, descriptionWidth: 166),
          SizedBox(height: 20),
          SkeletonBox(width: double.infinity, height: 12, borderRadius: 6),
          SizedBox(height: 12),
          SkeletonLine(width: 118, height: 24),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _IconMetricSkeleton()),
              Expanded(child: _IconMetricSkeleton()),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _IconMetricSkeleton()),
              Expanded(child: _IconMetricSkeleton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseTimelineCardSkeleton extends StatelessWidget {
  const _PhaseTimelineCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeaderSkeleton(titleWidth: 118, descriptionWidth: 138),
          SizedBox(height: 20),
          _TimelineRowSkeleton(),
          SizedBox(height: 16),
          _TimelineRowSkeleton(),
        ],
      ),
    );
  }
}

class _IconMetricSkeleton extends StatelessWidget {
  const _IconMetricSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonCircle(size: 24),
        SizedBox(height: 5),
        SkeletonLine(width: 72, height: 12),
        SizedBox(height: 4),
        SkeletonLine(width: 48, height: 16),
      ],
    );
  }
}

class _TimelineRowSkeleton extends StatelessWidget {
  const _TimelineRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SkeletonCircle(size: 12),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 46, height: 12),
              SizedBox(height: 4),
              SkeletonLine(width: 82, height: 14),
              SizedBox(height: 4),
              SkeletonLine(width: 118, height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendationTitleCardSkeleton extends StatelessWidget {
  const _RecommendationTitleCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      width: double.infinity,
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonCircle(size: 48),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 94, height: 12),
                    SizedBox(height: 6),
                    SkeletonLine(width: 184, height: 18),
                    SizedBox(height: 5),
                    SkeletonLine(width: 134, height: 18),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SkeletonBox(width: 72, height: 26, borderRadius: AppRadius.xs),
              SizedBox(width: 8),
              SkeletonBox(width: 82, height: 26, borderRadius: AppRadius.xs),
            ],
          ),
          SizedBox(height: 16),
          SkeletonLine(width: double.infinity, height: 14),
          SizedBox(height: 7),
          SkeletonLine(width: double.infinity, height: 14),
          SizedBox(height: 7),
          SkeletonLine(width: 230, height: 14),
        ],
      ),
    );
  }
}

class _RecommendationInfoCardSkeleton extends StatelessWidget {
  const _RecommendationInfoCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      width: double.infinity,
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: 86, height: 16),
          SizedBox(height: 12),
          _IconTextRowSkeleton(),
          _IconTextRowSkeleton(),
          _IconTextRowSkeleton(),
          _IconTextRowSkeleton(),
        ],
      ),
    );
  }
}

class _RecommendationKeyValueCardSkeleton extends StatelessWidget {
  final double titleWidth;
  final int rowCount;

  const _RecommendationKeyValueCardSkeleton({
    required this.titleWidth,
    required this.rowCount,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      width: double.infinity,
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: titleWidth, height: 16),
          const SizedBox(height: 12),
          for (var i = 0; i < rowCount; i++) ...[
            const _TwoColumnInfoRowSkeleton(),
            if (i != rowCount - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _RecommendationActionStepsSkeleton extends StatelessWidget {
  const _RecommendationActionStepsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      width: double.infinity,
      radius: AppRadius.lg,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: 128, height: 16),
          SizedBox(height: 12),
          _StepRowSkeleton(width: double.infinity),
          _StepRowSkeleton(width: 220),
          _StepRowSkeleton(width: 250),
        ],
      ),
    );
  }
}

class _IconTextRowSkeleton extends StatelessWidget {
  const _IconTextRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonCircle(size: 18),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 82, height: 11),
                SizedBox(height: 4),
                SkeletonLine(width: 168, height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRowSkeleton extends StatelessWidget {
  final double width;

  const _StepRowSkeleton({required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonCircle(size: 24),
          const SizedBox(width: 12),
          Expanded(child: SkeletonLine(width: width, height: 13)),
        ],
      ),
    );
  }
}

class _PermissionGroupCardSkeleton extends StatelessWidget {
  final int rowCount;

  const _PermissionGroupCardSkeleton({required this.rowCount});

  @override
  Widget build(BuildContext context) {
    return _SkeletonPanel(
      width: double.infinity,
      radius: AppRadius.sm,
      border: Border.all(color: AppColors.divider),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SkeletonBox(width: 24, height: 24, borderRadius: 4),
                SizedBox(width: 8),
                SkeletonBox(width: 82, height: 24, borderRadius: 6),
                Spacer(),
                SkeletonLine(width: 28, height: 12),
              ],
            ),
          ),
          const SkeletonBox(width: double.infinity, height: 1, borderRadius: 0),
          for (var i = 0; i < rowCount; i++)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SkeletonBox(width: 24, height: 24, borderRadius: 4),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 156, height: 14),
                        SizedBox(height: 4),
                        SkeletonLine(width: 112, height: 12),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  SkeletonBox(width: 58, height: 22, borderRadius: 4),
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
    return _SkeletonPanel(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonCircle(size: 36),
              SizedBox(width: 10),
              Column(
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SkeletonLine(width: 60, height: 16),
              SkeletonLine(width: 60, height: 16),
              SkeletonLine(width: 60, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardCardSkeleton extends StatelessWidget {
  const DashboardCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonCircle(size: 40),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 100, height: 16),
                  SizedBox(height: 4),
                  SkeletonLine(width: 60, height: 12),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          SkeletonBox(width: double.infinity, height: 80, borderRadius: 12),
        ],
      ),
    );
  }
}

class MonitoringSensorSkeleton extends StatelessWidget {
  const MonitoringSensorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          SkeletonCircle(size: 32),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 80, height: 14),
              SizedBox(height: 4),
              SkeletonLine(width: 50, height: 10),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonLine(width: 40, height: 18),
              SizedBox(height: 4),
              SkeletonLine(width: 20, height: 10),
            ],
          ),
        ],
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
                _SkeletonCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < 3; i++) const InfoRowSkeleton(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < 3; i++) ...[
                  const _SkeletonCard(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SkeletonCircle(size: 24),
                        SizedBox(width: 16),
                        SkeletonLine(width: 150, height: 16),
                        Spacer(),
                        SkeletonBox(width: 24, height: 24, borderRadius: 4),
                      ],
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

class RecommendationCardSkeleton extends StatelessWidget {
  const RecommendationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonPanel(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      radius: AppRadius.md,
      child: Column(
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
          SizedBox(height: 10),
          Row(
            children: [
              SkeletonBox(width: 50, height: 20, borderRadius: 10),
              SizedBox(width: 6),
              SkeletonBox(width: 64, height: 20, borderRadius: 10),
            ],
          ),
          SizedBox(height: 10),
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
    );
  }
}

class PhaseCardSkeleton extends StatelessWidget {
  const PhaseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonPanel(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonBox(width: 50, height: 50, borderRadius: 10),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 160, height: 22),
                    SizedBox(height: 4),
                    SkeletonLine(width: 60, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonLine(width: double.infinity, height: 14),
          const SizedBox(height: 6),
          const SkeletonLine(width: 200, height: 14),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonCircle(size: 16),
                          SizedBox(width: 6),
                          SkeletonLine(width: 30, height: 10),
                        ],
                      ),
                      SizedBox(height: 6),
                      SkeletonLine(width: 48, height: 13),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonCircle(size: 16),
                          SizedBox(width: 6),
                          SkeletonLine(width: 40, height: 10),
                        ],
                      ),
                      SizedBox(height: 6),
                      SkeletonLine(width: 52, height: 13),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonBox(width: double.infinity, height: 8, borderRadius: 4),
          const SizedBox(height: 8),
          const SkeletonLine(width: 70, height: 12),
        ],
      ),
    );
  }
}

class SiteCardSkeleton extends StatelessWidget {
  const SiteCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 40, height: 40, borderRadius: 8),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 130, height: 16),
                    SizedBox(height: 6),
                    SkeletonLine(width: 180, height: 12),
                  ],
                ),
              ),
              SizedBox(width: 12),
              SkeletonBox(width: 20, height: 20, borderRadius: 4),
            ],
          ),
          SizedBox(height: 12),
          SkeletonBox(width: 110, height: 26, borderRadius: 6),
        ],
      ),
    );
  }
}

class SiteDetailRowSkeleton extends StatelessWidget {
  const SiteDetailRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 20, height: 20, borderRadius: 4),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 80, height: 11),
                SizedBox(height: 4),
                SkeletonLine(width: 140, height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SiteDetailOverviewSkeleton extends StatelessWidget {
  const SiteDetailOverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          _SkeletonPanel(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            radius: 20,
            child: Row(
              children: [
                SkeletonBox(width: 56, height: 56, borderRadius: 16),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 156, height: 18),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SkeletonBox(width: 76, height: 26, borderRadius: 12),
                          SizedBox(width: 8),
                          SkeletonBox(width: 96, height: 26, borderRadius: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          _SkeletonPanel(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 80, height: 16),
                SizedBox(height: 12),
                SiteDetailRowSkeleton(),
                SiteDetailRowSkeleton(),
                SiteDetailRowSkeleton(),
              ],
            ),
          ),
          SizedBox(height: 14),
          _SkeletonPanel(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 120, height: 16),
                SizedBox(height: 12),
                SiteDetailRowSkeleton(),
                SiteDetailRowSkeleton(),
                SiteDetailRowSkeleton(),
              ],
            ),
          ),
          SizedBox(height: 14),
          _SkeletonPanel(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 140, height: 16),
                SizedBox(height: 12),
                SiteDetailRowSkeleton(),
                SiteDetailRowSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SiteDetailScreenSkeleton extends StatelessWidget {
  const SiteDetailScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonContainer(child: SkeletonLine(width: 142, height: 22)),
          SizedBox(height: 14),
          SkeletonContainer(
            child: SkeletonBox(
              width: double.infinity,
              height: 44,
              borderRadius: 16,
            ),
          ),
          SizedBox(height: 12),
          Expanded(child: SiteDetailOverviewSkeleton()),
        ],
      ),
    );
  }
}

class AdminUserDetailSkeleton extends StatelessWidget {
  const AdminUserDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonContainer(child: SkeletonLine(width: 92, height: 22)),
          SizedBox(height: 14),
          _SkeletonPanel(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            radius: 20,
            child: Column(
              children: [
                Row(
                  children: [
                    SkeletonCircle(size: 56),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(width: 160, height: 18),
                          SizedBox(height: 6),
                          SkeletonLine(width: 76, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _AdminUserDetailRowSkeleton(),
                _AdminUserDetailRowSkeleton(),
                _AdminUserDetailRowSkeleton(),
                _AdminUserDetailRowSkeleton(),
                _AdminUserDetailRowSkeleton(),
                _AdminUserDetailRowSkeleton(showDivider: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminListScreenSkeleton extends StatelessWidget {
  final double titleWidth;
  final int itemCount;

  const AdminListScreenSkeleton({
    super.key,
    this.titleWidth = 120,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: itemCount + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SkeletonContainer(
              child: SkeletonLine(width: titleWidth, height: 22),
            ),
          );
        }
        return const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: AdminListItemSkeleton(),
        );
      },
    );
  }
}

class SiteManagementListSkeleton extends StatelessWidget {
  const SiteManagementListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 7,
      itemBuilder: (_, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonContainer(
              child: SkeletonLine(width: 72, height: 22),
            ),
          );
        }
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SiteCardSkeleton(),
        );
      },
    );
  }
}

class _AdminUserDetailRowSkeleton extends StatelessWidget {
  final bool showDivider;

  const _AdminUserDetailRowSkeleton({this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: const [
              SkeletonBox(width: 20, height: 20, borderRadius: 5),
              SizedBox(width: 12),
              Expanded(child: SkeletonLine(width: 92, height: 12)),
              SizedBox(width: 12),
              SkeletonLine(width: 118, height: 13),
            ],
          ),
        ),
        if (showDivider)
          const SkeletonBox(width: double.infinity, height: 1, borderRadius: 0),
      ],
    );
  }
}

class ProfileScreenSkeleton extends StatelessWidget {
  const ProfileScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const SkeletonContainer(child: SkeletonCircle(size: 100)),
          const SizedBox(height: 16),
          const SkeletonContainer(
            child: SkeletonBox(width: 80, height: 22, borderRadius: 10),
          ),
          const SizedBox(height: 8),
          const SkeletonContainer(child: SkeletonLine(width: 160, height: 22)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeaderWidget(title: l10n.profileAccountInfoTitle),
                const SizedBox(height: 14),
                const _SkeletonCard(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileInfoRowSkeleton(labelWidth: 44, valueWidth: 210),
                      SizedBox(height: 3),
                      _ProfileInfoRowSkeleton(labelWidth: 56, valueWidth: 128),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeaderWidget(title: l10n.forumTitle),
                const SizedBox(height: 14),
                const _SkeletonCard(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SkeletonBox(width: 50, height: 50, borderRadius: 10),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 150, height: 16),
                            SizedBox(height: 4),
                            SkeletonLine(width: 180, height: 12),
                          ],
                        ),
                      ),
                      SkeletonBox(width: 24, height: 24, borderRadius: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeaderWidget(title: l10n.profilePermissionsSection),
                const SizedBox(height: 14),
                const _SkeletonCard(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SkeletonBox(width: 50, height: 50, borderRadius: 10),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 140, height: 16),
                            SizedBox(height: 4),
                            SkeletonLine(width: 100, height: 12),
                          ],
                        ),
                      ),
                      SkeletonBox(width: 24, height: 24, borderRadius: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonContainer(
              child: SkeletonBox(
                width: double.infinity,
                height: 60,
                borderRadius: 30,
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ProfileInfoRowSkeleton extends StatelessWidget {
  final double labelWidth;
  final double valueWidth;

  const _ProfileInfoRowSkeleton({
    required this.labelWidth,
    required this.valueWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SkeletonBox(width: 20, height: 20, borderRadius: 5),
            const SizedBox(width: 3),
            SkeletonLine(width: labelWidth, height: 14),
          ],
        ),
        const SizedBox(height: 3),
        SkeletonLine(width: valueWidth, height: 12),
      ],
    );
  }
}

class AdminListItemSkeleton extends StatelessWidget {
  const AdminListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonPanel(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 50, height: 50, borderRadius: 10),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 140, height: 16),
                    SizedBox(height: 5),
                    SkeletonLine(width: 90, height: 12),
                  ],
                ),
              ),
              SkeletonBox(width: 20, height: 20, borderRadius: 4),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              SkeletonBox(width: 80, height: 22, borderRadius: 8),
              SizedBox(width: 8),
              SkeletonBox(width: 60, height: 22, borderRadius: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class PlantHeaderCardSkeleton extends StatelessWidget {
  const PlantHeaderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      height: 78,
      radius: AppRadius.lg,
      padding: EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 50, height: 50, borderRadius: AppRadius.sm),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(width: 150, height: 18),
                SizedBox(height: 6),
                SkeletonLine(width: 100, height: 12),
              ],
            ),
          ),
          SizedBox(width: 10),
          SkeletonBox(width: 60, height: 24, borderRadius: AppRadius.xs),
        ],
      ),
    );
  }
}

class PlantGrowthCardSkeleton extends StatelessWidget {
  const PlantGrowthCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      height: 130,
      radius: AppRadius.lg,
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 38, height: 38, borderRadius: AppRadius.sm),
              SizedBox(width: 10),
              SkeletonLine(width: 120, height: 16),
            ],
          ),
          SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 18, height: 18, borderRadius: 4),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(width: 30, height: 10),
                          SizedBox(height: 4),
                          SkeletonLine(width: 40, height: 16),
                          SizedBox(height: 4),
                          SkeletonLine(width: 60, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 18, height: 18, borderRadius: 4),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(width: 30, height: 10),
                          SizedBox(height: 4),
                          SkeletonLine(width: 80, height: 16),
                          SizedBox(height: 4),
                          SkeletonLine(width: 50, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlantInfoCardSkeleton extends StatelessWidget {
  const PlantInfoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      height: 320,
      radius: AppRadius.lg,
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 38, height: 38, borderRadius: AppRadius.sm),
              SizedBox(width: 10),
              SkeletonLine(width: 120, height: 16),
            ],
          ),
          SizedBox(height: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PlantInfoItemSkeleton(),
                _PlantInfoItemSkeleton(),
                _PlantInfoItemSkeleton(),
                _PlantInfoItemSkeleton(),
                _PlantInfoItemSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlantInfoItemSkeleton extends StatelessWidget {
  const _PlantInfoItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: 20, height: 20, borderRadius: 4),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 80, height: 10),
              SizedBox(height: 4),
              SkeletonLine(width: 140, height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
