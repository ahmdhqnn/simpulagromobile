// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Pantau Lahan\nLebih Akurat",
      "desc":
          "Pantau kondisi tanaman dan kesehatan tanah secara real-time langsung dari smartphone Anda, di mana saja dan kapan saja.",
      "bg": "assets/images/onboarding1.svg",
    },
    {
      "title": "Keputusan Berbasis\nData",
      "desc":
          "Dapatkan wawasan akurat mengenai kelembapan, suhu, dan nutrisi tanah untuk menentukan langkah perawatan yang paling tepat.",
      "bg": "assets/images/onboarding2.svg",
    },
    {
      "title": "Minimalkan Risiko\nGagal Panen",
      "desc":
          "Terima notifikasi dini jika terjadi anomali pada lahan sehingga Anda bisa bertindak lebih cepat sebelum masalah berkembang.",
      "bg": "assets/images/onboarding3.svg",
    },
  ];

  final List<Map<String, dynamic>> textLayout = [
    {
      "top": 365.0,
      "align": CrossAxisAlignment.center,
      "textAlign": TextAlign.center,
    },
    {
      "top": 543.0,
      "align": CrossAxisAlignment.start,
      "textAlign": TextAlign.left,
    },
    {
      "top": 187.0,
      "align": CrossAxisAlignment.end,
      "textAlign": TextAlign.right,
    },
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  void skip() {
    context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          final layout = textLayout[index];

          return Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  data["bg"]!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: layout["top"],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: index == 0
                        ? Alignment.center
                        : index == 1
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: SizedBox(
                      width: 335,
                      child: Column(
                        crossAxisAlignment: layout["align"],
                        children: [
                          Text(
                            data["title"]!,
                            textAlign: layout["textAlign"],
                            style: const TextStyle(
                              color: Color(0xFF1D1D1D),
                              fontSize: 32,
                              fontFamily: "Plus Jakarta Sans",
                              fontWeight: FontWeight.w700,
                              height: 0.94,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            data["desc"]!,
                            textAlign: layout["textAlign"],
                            style: const TextStyle(
                              color: Color(0xFF1D1D1D),
                              fontSize: 12,
                              fontFamily: "Plus Jakarta Sans",
                              fontWeight: FontWeight.w400,
                              height: 1.17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          double totalSpacing =
                              (onboardingData.length - 1) * 10;

                          double indicatorWidth =
                              (constraints.maxWidth - totalSpacing) /
                              onboardingData.length;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onboardingData.length,
                              (i) => _indicator(i, indicatorWidth),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Welcome to SimpulAgro",
                            style: TextStyle(
                              color: Color(0x7F1D1D1D),
                              fontSize: 12,
                              fontFamily: "Plus Jakarta Sans",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: skip,
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                color: Color(0xFF1D1D1D),
                                fontSize: 12,
                                fontFamily: "Plus Jakarta Sans",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: nextPage,
                        child: Container(
                          height: 60,
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
                                    ? "Get Started"
                                    : "Next",
                                style: const TextStyle(
                                  color: Color(0xFF1D1D1D),
                                  fontSize: 18,
                                  fontFamily: "Plus Jakarta Sans",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Positioned(
                                right: 16,
                                child: SvgPicture.asset(
                                  "assets/icons/chevron-right-icon.svg",
                                  width: 28,
                                  height: 28,
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

                      const SizedBox(height: 30),
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

  Widget _indicator(int index, double width) {
    bool active = index == currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      height: 2,
      margin: EdgeInsets.only(
        right: index == onboardingData.length - 1 ? 0 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D1D).withOpacity(active ? 1 : 0.35),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
