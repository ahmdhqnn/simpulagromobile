import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/recommendation.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/recommendation_action_buttons_widget.dart';
import '../widgets/recommendation_action_items_card_widget.dart';
import '../widgets/recommendation_detail_header_widget.dart';
import '../widgets/recommendation_error_state_widget.dart';
import '../widgets/recommendation_info_card_widget.dart';
import '../widgets/recommendation_parameters_card_widget.dart';
import '../widgets/recommendation_reason_card_widget.dart';
import '../widgets/recommendation_title_card_widget.dart';

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
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
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
                        if (recommendation.isActionable) ...[
                          SizedBox(height: context.rh(0.02)),
                          RecommendationActionButtonsWidget(
                            onDismiss: () =>
                                _dismiss(context, ref, recommendation),
                            onApply: () => _apply(context, ref, recommendation),
                          ),
                        ],
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

  Future<void> _apply(
    BuildContext context,
    WidgetRef ref,
    Recommendation recommendation,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Terapkan Rekomendasi',
      message: 'Apakah Anda yakin ingin menerapkan rekomendasi ini?',
      confirmLabel: 'Terapkan',
      confirmColor: AppColors.primary,
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final repository = ref.read(recommendationRepositoryProvider);
      await repository.applyRecommendation(recommendation.recommendationId);

      if (!context.mounted) return;
      ref.invalidate(recommendationListProvider);
      ref.invalidate(recommendationDetailProvider(recommendationId));
      _showSnack(
        context,
        'Rekomendasi berhasil diterapkan',
        backgroundColor: AppColors.success,
      );
    } catch (e) {
      if (!context.mounted) return;
      _showSnack(
        context,
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: AppColors.error,
      );
    }
  }

  Future<void> _dismiss(
    BuildContext context,
    WidgetRef ref,
    Recommendation recommendation,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Abaikan Rekomendasi',
      message: 'Apakah Anda yakin ingin mengabaikan rekomendasi ini?',
      confirmLabel: 'Abaikan',
      confirmColor: AppColors.error,
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final repository = ref.read(recommendationRepositoryProvider);
      await repository.dismissRecommendation(recommendation.recommendationId);

      if (!context.mounted) return;
      ref.invalidate(recommendationListProvider);
      _showSnack(context, 'Rekomendasi diabaikan');
      context.pop();
    } catch (e) {
      if (!context.mounted) return;
      _showSnack(
        context,
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: AppColors.error,
      );
    }
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          title,
          style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: Text(
              confirmLabel,
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
