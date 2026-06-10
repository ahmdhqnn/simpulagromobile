// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Alignment> _textAlignments = [
    Alignment.center,
    Alignment.centerLeft,
    Alignment.centerRight,
  ];

  final List<CrossAxisAlignment> _crossAlignments = [
    CrossAxisAlignment.center,
    CrossAxisAlignment.start,
    CrossAxisAlignment.end,
  ];

  final List<TextAlign> _textAligns = [
    TextAlign.center,
    TextAlign.left,
    TextAlign.right,
  ];

  void nextPage() {
    if (currentPage < _onboardingData(context).length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      ref.read(onboardingProvider.notifier).completeOnboarding();
      context.go('/login');
    }
  }

  void skip() {
    ref.read(onboardingProvider.notifier).completeOnboarding();
    context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingData = _onboardingData(context);

    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) => setState(() => currentPage = index),
        itemBuilder: (context, index) {
          final data = onboardingData[index];

          return Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(data["bg"]!, fit: BoxFit.cover),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: context.rh(0.022)),

                      _buildIndicators(context),

                      SizedBox(height: context.rh(0.022)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.authWelcome,
                            style: TextStyle(
                              color: const Color(0x7F1D1D1D),
                              fontSize: context.sp(12),
                              fontFamily: "Plus Jakarta Sans",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: skip,
                            child: Text(
                              context.l10n.authSkip,
                              style: TextStyle(
                                color: const Color(0xFF1D1D1D),
                                fontSize: context.sp(12),
                                fontFamily: "Plus Jakarta Sans",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Align(
                        alignment: _textAlignments[index],
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: context.rw(0.86),
                          ),
                          child: Column(
                            crossAxisAlignment: _crossAlignments[index],
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data["title"]!,
                                textAlign: _textAligns[index],
                                style: TextStyle(
                                  color: const Color(0xFF1D1D1D),
                                  fontSize: context.sp(32),
                                  fontFamily: "Plus Jakarta Sans",
                                  fontWeight: FontWeight.w700,
                                  height: 0.94,
                                ),
                              ),
                              SizedBox(height: context.rh(0.018)),
                              Text(
                                data["desc"]!,
                                textAlign: _textAligns[index],
                                style: TextStyle(
                                  color: const Color(0xFF1D1D1D),
                                  fontSize: context.sp(12),
                                  fontFamily: "Plus Jakarta Sans",
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: context.rh(0.04)),

                      // Next / Get Started button
                      GestureDetector(
                        onTap: nextPage,
                        child: Container(
                          height: context.rh(0.072).clamp(52.0, 68.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                index == onboardingData.length - 1
                                    ? context.l10n.authGetStarted
                                    : context.l10n.authNext,
                                style: TextStyle(
                                  color: const Color(0xFF1D1D1D),
                                  fontSize: context.sp(18),
                                  fontFamily: "Plus Jakarta Sans",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Positioned(
                                right: context.rw(0.04),
                                child: SvgPicture.asset(
                                  "assets/icons/chevron-right-icon.svg",
                                  width: context.rw(0.072).clamp(24.0, 32.0),
                                  height: context.rw(0.072).clamp(24.0, 32.0),
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF1D1D1D),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: context.rh(0.04)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIndicators(BuildContext context) {
    final onboardingData = _onboardingData(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = (onboardingData.length - 1) * 10.0;
        final indicatorWidth =
            (constraints.maxWidth - spacing) / onboardingData.length;

        return Row(
          children: List.generate(onboardingData.length, (i) {
            final active = i == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: indicatorWidth,
              height: 2,
              margin: EdgeInsets.only(
                right: i == onboardingData.length - 1 ? 0 : 10,
              ),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF1D1D1D,
                ).withValues(alpha: active ? 1 : 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }

  List<Map<String, String>> _onboardingData(BuildContext context) => [
    {
      'title': context.l10n.onboardingMonitorTitle,
      'desc': context.l10n.onboardingMonitorDesc,
      'bg': 'assets/images/onboarding1.svg',
    },
    {
      'title': context.l10n.onboardingDataTitle,
      'desc': context.l10n.onboardingDataDesc,
      'bg': 'assets/images/onboarding2.svg',
    },
    {
      'title': context.l10n.onboardingRiskTitle,
      'desc': context.l10n.onboardingRiskDesc,
      'bg': 'assets/images/onboarding3.svg',
    },
  ];
}
