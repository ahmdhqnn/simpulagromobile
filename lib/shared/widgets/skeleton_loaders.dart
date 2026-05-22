import 'package:flutter/material.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
