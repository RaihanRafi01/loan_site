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
  final String role; // Add role parameter
  const SignUpScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Show dialog when showConfirm changes to true
    ever(controller.showConfirm, (bool show) {
      if (show) {
        Get.dialog(
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.7),
          const ConfirmPopupWidget(),
        );
      }
    });

    return Scaffold(
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
                  if(role == 'borrower')
                  CustomTextField(
                    labelText: 'Enter Lender Code',
                    prefixSvgPath: 'assets/images/auth/lock_icon.svg',
                    controller: controller.lender_codeController,
                  ),
                  Obx(() => CustomTextField(
                    obscureText: controller.isPasswordHidden.value,
                    labelText: 'Password',
                    prefixSvgPath: 'assets/images/auth/lock_icon.svg',
                    suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                    onSuffixTap: controller.togglePasswordVisibility,
                    controller: controller.passwordController,
                  )),
                  Obx(() => CustomTextField(
                    obscureText: controller.isConfirmPasswordHidden.value,
                    labelText: 'Confirm Password',
                    prefixSvgPath: 'assets/images/auth/lock_icon.svg',
                    suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                    onSuffixTap: controller.toggleConfirmPasswordVisibility,
                    controller: controller.confirmPasswordController,
                  )),
                  const SizedBox(height: 30),
                  Obx(() => CustomButton(
                    label: 'Register',
                    onPressed: () => controller.signUp(role: role), // Pass role to signUp
                    isLoading: controller.isLoading.value,
                  )),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      const SizedBox(width: 10),
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
      );
  }
}

class ConfirmPopupWidget extends StatelessWidget {
  const ConfirmPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/images/auth/tic_icon.svg'),
            const SizedBox(height: 10),
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
    );
  }
}