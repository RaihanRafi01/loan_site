import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/auth/views/auth_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/onboarding_controller.dart';
import 'dart:ui'; // Required for BackdropFilter

class OnboardingStepsView extends GetView<OnboardingController> {
  const OnboardingStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());

    return Obx(() => Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Skip button (hidden on page 4)
                controller.currentPage.value != 3
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      controller.currentPage.value = 3; // Page 4 (0-based index)
                      controller.pageController.jumpToPage(3); // Ensure page view updates
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Skip',
                          style: h4.copyWith(
                              color: AppColors.textColor, fontSize: 20),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.arrow_forward_rounded,
                            color: AppColors.textColor),
                      ],
                    ),
                  ),
                )
                    : const SizedBox.shrink(),

                // PageView
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    children: const [
                      OnboardingPage(
                        title: 'Welcome to Your LoanSite - Assistant',
                        description:
                        'Smart, AI-driven support for real estate borrowers and private lenders',
                        svgPath: 'assets/images/onboarding/page_1.svg',
                      ),
                      OnboardingPage(
                        title: 'Track Your Project Progress',
                        description:
                        'AI guides you through every step with real-time updates and cost estimates.',
                        svgPath: 'assets/images/onboarding/page_2.svg',
                      ),
                      OnboardingPage(
                        title: 'Seamless Communication with Your Lender',
                        description:
                        'Real-time updates keep you and your lender in sync.',
                        svgPath: 'assets/images/onboarding/page_3.svg',
                      ),
                      OnboardingPage(
                        title: 'Start managing your construction projects with AI-powered support',
                        description:
                        'Real-time updates keep you and your lender in sync.',
                        svgPath: 'assets/images/onboarding/page_4.svg',
                      ),
                    ],
                  ),
                ),

                // Bottom section with dots and buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Register and Login buttons on page 4, otherwise Continue/Get Started
                      controller.currentPage.value == 3
                          ? Column(
                        children: [
                          CustomButton(
                            label: 'Register',
                            onPressed: () {
                              controller.showRegisterCard.value = true; // Show the card
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            isWhite: true,
                            label: 'Login',
                            onPressed: () {
                             Get.offAll(AuthView());
                            },
                          ),
                        ],
                      )
                          : CustomButton(
                        label: controller.currentPage.value == 0
                            ? 'Get Started'
                            : 'Continue',
                        onPressed: () => controller.nextPage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Popup card with blurred background
        if (controller.showRegisterCard.value)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                controller.showRegisterCard.value = false; // Dismiss card on outside tap
              },
              child: Stack(
                children: [
                  // Blurred background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
                    ),
                  ),
                  // Centered card
                  Center(
                    child: GestureDetector(
                      onTap: () {}, // Prevents taps on the card from dismissing it
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Text in the card
                              Text(
                                'Choose your role first',
                                style: h2.copyWith(fontSize: 24, color: AppColors.textColor),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              // Buttons in a column
                              CustomButton(
                                label: 'Private Lender',
                                onPressed: () {
                                  controller.showRegisterCard.value = false; // Hide card
                                  Get.toNamed('/register?role=lender'); // Navigate with role
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                label: 'Borrower',
                                onPressed: () {
                                  controller.showRegisterCard.value = false; // Hide card
                                  Get.toNamed('/register?role=borrower'); // Navigate with role
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ));
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String svgPath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title with gradient
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [AppColors.textColor3, AppColors.textColor4],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: Text(
              title,
              style: h3.copyWith(fontSize: 30, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            description,
            style: h4.copyWith(fontSize: 18, color: AppColors.textColor2),
          ),
          const SizedBox(height: 40),
          // SVG Illustration
          SvgPicture.asset(svgPath, height: 300, width: 300),
        ],
      ),
    );
  }
}