import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/onboarding/views/onboarding_steps_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    print('okkk');
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
     Get.offAll(OnboardingStepsView());
    });
  }
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentPage = 0.obs;
  var showRegisterCard = false.obs; // Add this line

  void nextPage() {
    if (currentPage.value < 3) {
      currentPage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to sign up or main app
      Get.offAllNamed('/signup'); // Replace with your route
    }
  }

  void skipOnboarding() {
    Get.offAllNamed('/signup'); // Replace with your route
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
