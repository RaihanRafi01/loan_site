import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/customTextField.dart';
import '../../../../common/widgets/custom_title_subTitle.dart';
import '../controllers/auth_controller.dart';
class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      TitleSubtitle(
                        title: 'Create an Account',
                        subtitle: 'Please register to start browsing',
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        labelText: 'Enter full name',
                        prefixSvgPath: 'assets/images/auth/person_icon.svg',
                        controller: controller.nameController,
                      ),
                      CustomTextField(
                        labelText: 'Enter email address',
                        prefixSvgPath: 'assets/images/auth/mail_icon.svg',
                        controller: controller.emailController,
                      ),
                      CustomTextField(
                        labelText: 'Enter phone number',
                        prefixSvgPath: 'assets/images/auth/phone_icon.svg',
                        controller: controller.phoneController,
                      ),
                      CustomTextField(
                        obscureText: true,
                        labelText: 'Password',
                        prefixSvgPath: 'assets/images/auth/lock_icon.svg',
                        suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                        controller: controller.passwordController,
                      ),
                      CustomTextField(
                        obscureText: true,
                        labelText: 'Confirm Password',
                        prefixSvgPath: 'assets/images/auth/lock_icon.svg',
                        suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                        controller: controller.confirmPasswordController,
                      ),
                      SizedBox(height: 30),
                      CustomButton(
                        label: 'Register',
                        onPressed: () => controller.showConfirmationAndNavigate(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or Login with',
                              style: h4.copyWith(
                                fontSize: 16,
                                color: AppColors.blurtext3,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/auth/google_icon.svg',
                          ),
                          const SizedBox(width: 24),
                          SvgPicture.asset('assets/images/auth/apple_icon.svg'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: h4.copyWith(
                              color: AppColors.textColor,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => controller.navigateToLogin(),
                            child: Text(
                              'Sign In',
                              style: h4.copyWith(
                                color: AppColors.appColor2,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (controller.showConfirm.value)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  controller.showConfirm.value = false; // Dismiss card on outside tap
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
                                SvgPicture.asset('assets/images/auth/tic_icon.svg'),
                                SizedBox(height: 10),
                                Text(
                                  'Your account has been created successfully!',
                                  style: h4.copyWith(
                                    fontSize: 20,
                                    color: AppColors.textColor,
                                  ),
                                  textAlign: TextAlign.center,
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
      ),
    );
  }
}