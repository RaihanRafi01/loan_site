import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/onboarding/logo.svg'),
            Text(
              'Angelo',
              style: h1.copyWith(fontSize: 36,color: AppColors.appColor2),
            ),
          ],
        ),
      ),
    );
  }
}
