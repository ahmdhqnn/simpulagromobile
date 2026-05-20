import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/user_comment.dart';
import '../providers/forum_provider.dart';

class MyCommentsScreen extends ConsumerWidget {
  const MyCommentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myCommentsAsync = ref.watch(myCommentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Komentar Saya',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: myCommentsAsync.when(
        data: (comments) {
          if (comments.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_bubble_outline,
              title: 'Belum ada komentar',
              message: 'Komentar Anda pada postingan akan muncul di sini',
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(myCommentsProvider);
            },
            child: ListView.builder(
              padding: EdgeInsets.all(context.rw(0.051)),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return _CommentCard(
                  comment: comment,
                  onTap: () {
                    context.push('/forum/post/${comment.forumId}');
                  },
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(message: 'Memuat komentar...'),
        error: (error, _) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.textPrimary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              error.toString().replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(myCommentsProvider),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final UserComment comment;
  final VoidCallback? onTap;

  const _CommentCard({required this.comment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post title reference
            Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 14,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    comment.postTitle.isEmpty
                        ? 'Tanpa Judul'
                        : comment.postTitle,
                    style: AppTextStyles.label(
                      context,
                      size: 12,
                      weight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Comment content
            Text(
              comment.commentContent,
              style: AppTextStyles.label(
                context,
                size: 13,
                weight: FontWeight.w400,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Time ago
            Text(
              comment.timeAgo,
              style: AppTextStyles.hint(context, size: 10),
            ),
          ],
        ),
      ),
    );
  }
}
