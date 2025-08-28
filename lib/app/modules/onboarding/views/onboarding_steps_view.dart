import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/auth/views/login_view.dart';
import 'package:loan_site/app/modules/auth/views/signUp_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/chooseRolePopupWidget.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingStepsView extends GetView<OnboardingController> {
  const OnboardingStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());

    return Obx(() => Scaffold(
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
                          Get.dialog(
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.7),
                            const ChooseRolePopupWidget(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        isWhite: true,
                        txtClr: AppColors.textColor3,
                        label: 'Login',
                        onPressed: () {
                          Get.offAll(const LoginScreen());
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
    ));
  }
}

// New widget for the popup dialog content


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