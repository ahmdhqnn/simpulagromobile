import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: context.rh(0.14).clamp(100.0, 140.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tugas Saya',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: context.rh(0.005)),
                        filteredAsync.when(
                          data: (tasks) => Text(
                            '${tasks.length} tugas',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: context.sp(13),
                              color: Colors.white70,
                            ),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── Search Bar ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.rw(0.051),
                context.rh(0.02),
                context.rw(0.051),
                0,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    ref.read(taskSearchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Cari tugas...',
                  hintStyle: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: AppColors.textTertiary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(taskSearchQueryProvider.notifier).state =
                                '';
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // ─── Content ───────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.all(context.rw(0.051)),
            sliver: filteredAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: _TaskErrorState(
                  error: error.toString(),
                  onRetry: () => ref.invalidate(tasksProvider),
                ),
              ),
              data: (tasks) {
                if (tasks.isEmpty) {
                  return SliverFillRemaining(
                    child: _TaskEmptyState(
                      isSearching: _searchController.text.isNotEmpty,
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Padding(
                      padding: EdgeInsets.only(bottom: context.rh(0.015)),
                      child: _TaskCard(task: tasks[i]),
                    ),
                    childCount: tasks.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Task Card ──────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final createdAt = task.taskCreated != null
        ? DateFormat('dd MMM yyyy').format(task.taskCreated!)
        : null;

    return Container(
      padding: EdgeInsets.all(context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          SizedBox(width: context.rw(0.035)),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskName ?? 'Tanpa Nama',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (task.taskDesc != null && task.taskDesc!.isNotEmpty) ...[
                  SizedBox(height: context.rh(0.005)),
                  Text(
                    task.taskDesc!,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(13),
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (createdAt != null) ...[
                  SizedBox(height: context.rh(0.01)),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        createdAt,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(11),
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ────────────────────────────────────────
class _TaskEmptyState extends StatelessWidget {
  final bool isSearching;

  const _TaskEmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_rounded
                  : Icons.assignment_outlined,
              size: context.rw(0.2).clamp(64.0, 96.0),
              color: AppColors.textTertiary,
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              isSearching ? 'Tugas tidak ditemukan' : 'Belum ada tugas',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              isSearching
                  ? 'Coba kata kunci lain'
                  : 'Tugas yang ditugaskan akan muncul di sini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error State ────────────────────────────────────────
class _TaskErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _TaskErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rw(0.1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: context.rw(0.18).clamp(56.0, 80.0),
              color: AppColors.error,
            ),
            SizedBox(height: context.rh(0.02)),
            Text(
              'Gagal memuat tugas',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.rh(0.01)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(13),
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.rh(0.03)),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
