import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/recommendation_hub_provider.dart';
import '../widgets/recommendation_action_items_card_widget.dart';
import '../widgets/recommendation_detail_header_widget.dart';
import '../widgets/recommendation_error_state_widget.dart';
import '../widgets/recommendation_info_card_widget.dart';
import '../widgets/recommendation_parameters_card_widget.dart';
import '../widgets/recommendation_reason_card_widget.dart';
import '../widgets/recommendation_title_card_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';

class RecommendationDetailScreen extends ConsumerWidget {
  final String recommendationId;

  const RecommendationDetailScreen({super.key, required this.recommendationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      recommendationHubDetailItemProvider(recommendationId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: detailAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => Column(
            children: [
              RecommendationDetailHeaderWidget(
                onBack: () => context.pop(),
                onRefresh: () => ref.invalidate(
                  recommendationHubDetailItemProvider(recommendationId),
                ),
              ),
              const Expanded(child: RecommendationDetailContentSkeleton()),
            ],
          ),
          error: (error, stack) => Column(
            children: [
              RecommendationDetailHeaderWidget(
                onBack: () => context.pop(),
                onRefresh: () => ref.invalidate(
                  recommendationHubDetailItemProvider(recommendationId),
                ),
              ),
              Expanded(
                child: RecommendationErrorStateWidget(
                  errorMessage: error.toString(),
                  onRetry: () => ref.invalidate(
                    recommendationHubDetailItemProvider(recommendationId),
                  ),
                ),
              ),
            ],
          ),
          data: (catalogItem) {
            final recommendation = catalogItem.recommendation;
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                invalidateRecommendationHubData(ref);
                ref.invalidate(
                  recommendationHubDetailItemProvider(recommendationId),
                );
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecommendationDetailHeaderWidget(
                      onBack: () => context.pop(),
                      onRefresh: () => ref.invalidate(
                        recommendationHubDetailItemProvider(recommendationId),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rw(0.051),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RecommendationTitleCardWidget(
                            recommendation: recommendation,
                          ),
                          SizedBox(height: context.rh(0.012)),
                          RecommendationInfoCardWidget(
                            recommendation: recommendation,
                            sourceScopes: catalogItem.scopes,
                          ),
                          if (recommendation.parameters != null &&
                              recommendation.parameters!.isNotEmpty) ...[
                            SizedBox(height: context.rh(0.012)),
                            RecommendationParametersCardWidget(
                              parameters: recommendation.parameters!,
                            ),
                          ],
                          if (recommendation.actionItems != null &&
                              recommendation.actionItems!.isNotEmpty) ...[
                            SizedBox(height: context.rh(0.012)),
                            RecommendationActionItemsCardWidget(
                              actionItems: recommendation.actionItems!,
                            ),
                          ],
                          if (recommendation.reason != null) ...[
                            SizedBox(height: context.rh(0.012)),
                            RecommendationReasonCardWidget(
                              reason: recommendation.reason!,
                            ),
                          ],
                          SizedBox(height: context.rh(0.024)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
