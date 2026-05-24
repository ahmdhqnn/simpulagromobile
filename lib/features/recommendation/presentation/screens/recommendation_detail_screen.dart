import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/recommendation_provider.dart';
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
    final recommendationAsync = ref.watch(
      recommendationDetailProvider(recommendationId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: recommendationAsync.when(
          loading: () => Column(
            children: [
              RecommendationDetailHeaderWidget(
                onBack: () => context.pop(),
                onRefresh: () => ref.invalidate(
                  recommendationDetailProvider(recommendationId),
                ),
              ),
              const Expanded(
                child: DetailScreenSkeleton(infoRowCount: 4, hasDescription: true, headerHeight: 120),
              ),
            ],
          ),
          error: (error, stack) => Column(
            children: [
              RecommendationDetailHeaderWidget(
                onBack: () => context.pop(),
                onRefresh: () => ref.invalidate(
                  recommendationDetailProvider(recommendationId),
                ),
              ),
              Expanded(
                child: RecommendationErrorStateWidget(
                  errorMessage: error.toString(),
                  onRetry: () => ref.invalidate(
                    recommendationDetailProvider(recommendationId),
                  ),
                ),
              ),
            ],
          ),
          data: (recommendation) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(recommendationDetailProvider(recommendationId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              children: [
                RecommendationDetailHeaderWidget(
                  onBack: () => context.pop(),
                  onRefresh: () => ref.invalidate(
                    recommendationDetailProvider(recommendationId),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rw(0.051),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.rh(0.01)),
                        RecommendationTitleCardWidget(
                          recommendation: recommendation,
                        ),
                        SizedBox(height: context.rh(0.02)),
                        RecommendationInfoCardWidget(
                          recommendation: recommendation,
                        ),
                        if (recommendation.parameters != null &&
                            recommendation.parameters!.isNotEmpty) ...[
                          SizedBox(height: context.rh(0.02)),
                          RecommendationParametersCardWidget(
                            parameters: recommendation.parameters!,
                          ),
                        ],
                        if (recommendation.actionItems != null &&
                            recommendation.actionItems!.isNotEmpty) ...[
                          SizedBox(height: context.rh(0.02)),
                          RecommendationActionItemsCardWidget(
                            actionItems: recommendation.actionItems!,
                          ),
                        ],
                        if (recommendation.reason != null) ...[
                          SizedBox(height: context.rh(0.02)),
                          RecommendationReasonCardWidget(
                            reason: recommendation.reason!,
                          ),
                        ],
                        const SizedBox.shrink(),
                        SizedBox(height: context.rh(0.02)),
                      ],
                    ),
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
