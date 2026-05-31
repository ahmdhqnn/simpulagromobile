import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/info_state_widget.dart';
import '../../../recommendation/presentation/providers/recommendation_provider.dart';

/// Ringkasan rekomendasi live dari GET /sites/{siteId}/recommendations
class DashboardRecommendationCard extends ConsumerWidget {
  const DashboardRecommendationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recAsync = ref.watch(recommendationListProvider);

    return recAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      skipError: true,
      data: (list) {
        if (list.isEmpty) {
          return const InfoStateWidget.icon(
            icon: Icons.lightbulb_outline,
            message: 'Belum ada rekomendasi untuk site ini',
            height: 72,
          );
        }
        final top = list.first;
        return InkWell(
          onTap: () => context.push('/recommendations'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.rw(0.04)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  top.title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  top.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(12),
                    color: Colors.grey[700],
                  ),
                ),
                if (list.length > 1) ...[
                  const SizedBox(height: 6),
                  Text(
                    '+${list.length - 1} rekomendasi lainnya',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: context.sp(11),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingCardWidget(height: 88),
      error: (e, _) => InfoStateWidget.icon(
        icon: Icons.error_outline,
        message: e.toString(),
        height: 72,
      ),
    );
  }
}
