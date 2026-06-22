import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_elements.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? action;
  final bool showBack;
  final VoidCallback? onRefresh;
  final bool showTitle;
  final Widget? headerContent;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.showBack = true,
    this.onRefresh,
    this.showTitle = true,
    this.headerContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  if (showTitle)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.rw(0.051),
                        0,
                        context.rw(0.051),
                        AppSpacing.sm,
                      ),
                      child: AdminSectionTitle(title),
                    ),
                  if (headerContent != null) headerContent!,
                ],
              ),
            ),
          ],
          body: body,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: back button atau spacer
          if (showBack)
            CircularBackButtonWidget(onPressed: () => context.pop())
          else
            const SizedBox(width: 58),

          // Kanan: action button (add/more) atau spacer
          if (action != null)
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 58),
              child: Align(alignment: Alignment.centerRight, child: action!),
            )
          else if (onRefresh != null)
            CircularBackButtonWidget(
              onPressed: onRefresh!,
              svgIconPath: 'assets/icons/arrow-rotate-left.svg',
            )
          else
            const SizedBox(width: 58),
        ],
      ),
    );
  }
}

class AdminFormScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool isLoading;
  final String? loadingMessage;
  final bool showTitle;

  const AdminFormScaffold({
    super.key,
    required this.title,
    required this.body,
    this.isLoading = false,
    this.loadingMessage,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  if (showTitle)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.rw(0.051),
                        0,
                        context.rw(0.051),
                        AppSpacing.sm,
                      ),
                      child: AdminSectionTitle(title),
                    ),
                ],
              ),
            ),
          ],
          body: Stack(
            children: [
              body,
              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                          if (loadingMessage != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              loadingMessage!,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: context.sp(14),
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF1D1D1D),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: back button
          CircularBackButtonWidget(onPressed: () => context.pop()),
          // Kanan: spacer (simetris seperti agro/phase)
          const SizedBox(width: 58),
        ],
      ),
    );
  }
}

class AdminAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const AdminAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CircularBackButtonWidget(
      onPressed: onTap,
      svgIconPath: 'assets/icons/plus-outline-icon.svg',
    );
  }
}

class AdminLoadingState extends StatelessWidget {
  const AdminLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.01),
      ),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: context.rh(0.014)),
      itemBuilder: (_, __) => const AdminListItemSkeleton(),
    );
  }
}

class AdminErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const AdminErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(context.rw(0.061)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: context.rw(0.164).clamp(48.0, 72.0),
                      color: AppColors.error,
                    ),
                    SizedBox(height: context.rh(0.02)),
                    Text(
                      AppLocalizations.of(context)!.commonLoadFailed,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1D1D),
                      ),
                    ),
                    SizedBox(height: context.rh(0.01)),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: context.rh(0.03)),
                    GestureDetector(
                      onTap: onRetry,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.retry,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AdminDetailScreenSkeleton extends StatelessWidget {
  const AdminDetailScreenSkeleton({
    super.key,
    this.sectionRowCounts = const [5, 3],
  });

  final List<int> sectionRowCounts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.01),
      ),
      children: [
        const _AdminDetailHeaderSkeleton(),
        const SizedBox(height: AppSpacing.sm),
        for (int index = 0; index < sectionRowCounts.length; index++) ...[
          _AdminDetailSectionSkeleton(rowCount: sectionRowCounts[index]),
          SizedBox(
            height: index == sectionRowCounts.length - 1
                ? AppSpacing.xl
                : AppSpacing.sm,
          ),
        ],
      ],
    );
  }
}

class _AdminDetailHeaderSkeleton extends StatelessWidget {
  const _AdminDetailHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AdminSectionCard(
      child: SkeletonContainer(
        child: Row(
          children: [
            SkeletonBox(width: 56, height: 56, borderRadius: 16),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 160, height: 18),
                  SizedBox(height: 6),
                  SkeletonLine(width: 96, height: 12),
                  SizedBox(height: 10),
                  SkeletonBox(width: 74, height: 24, borderRadius: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminDetailSectionSkeleton extends StatelessWidget {
  const _AdminDetailSectionSkeleton({required this.rowCount});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: SkeletonContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonLine(width: 132, height: 16),
            const SizedBox(height: 10),
            for (int index = 0; index < rowCount; index++)
              AdminDetailRowSkeleton(showDivider: index != rowCount - 1),
          ],
        ),
      ),
    );
  }
}

class AdminDetailRowsSkeleton extends StatelessWidget {
  const AdminDetailRowsSkeleton({super.key, required this.rowCount});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < rowCount; index++)
          AdminDetailRowSkeleton(showDivider: index != rowCount - 1),
      ],
    );
  }
}

class AdminDetailRowSkeleton extends StatelessWidget {
  const AdminDetailRowSkeleton({super.key, this.showDivider = true});

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 36, height: 36, borderRadius: 10),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 92, height: 12),
                      SizedBox(height: 6),
                      SkeletonLine(width: 148, height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showDivider) const Divider(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

class AdminPermissionLoadingState extends StatelessWidget {
  const AdminPermissionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(0.051),
        vertical: context.rh(0.01),
      ),
      children: const [
        CompactStatsCardSkeleton(itemCount: 2),
        SizedBox(height: AppSpacing.sm),
        KeyValueRowsCardSkeleton(rowCount: 4),
        SizedBox(height: AppSpacing.sm),
        KeyValueRowsCardSkeleton(rowCount: 4),
        SizedBox(height: 24),
      ],
    );
  }
}

class AdminEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const AdminEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(context.rw(0.061)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: context.rw(0.164).clamp(48.0, 72.0),
                      color: const Color(0xFF1D1D1D).withValues(alpha: 0.2),
                    ),
                    SizedBox(height: context.rh(0.02)),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1D1D),
                      ),
                    ),
                    SizedBox(height: context.rh(0.01)),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF1D1D1D).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AdminSectionTitle extends StatelessWidget {
  final String title;

  const AdminSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: context.sp(22),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1D1D1D),
        height: 1.0,
      ),
    );
  }
}

class AdminSectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final EdgeInsets? padding;

  const AdminSectionCard({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardWidget.elevated(
      width: double.infinity,
      padding: padding ?? AppSpacing.card,
      radius: AppRadius.lg,
      boxShadow: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: context.sp(16),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D1D),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class AdminSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const AdminSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.22,
                  ),
                ),
        ),
      ),
    );
  }
}
