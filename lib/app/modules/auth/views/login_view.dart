import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/customTextField.dart';
import '../../../../common/widgets/custom_title_subTitle.dart';
import '../../project/views/onboarding_project_view.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  title: 'Welcome Back!',
                  subtitle: 'Please login to continue',
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  labelText: 'Enter full name',
                  prefixSvgPath: 'assets/images/auth/mail_icon.svg',
                  controller: controller.emailController,
                ),
                Obx(
                  () => CustomTextField(
                    obscureText: controller.isPasswordHidden.value,
                    // Use reactive value
                    labelText: 'Password',
                    prefixSvgPath: 'assets/images/auth/lock_icon.svg',
                    suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                    onSuffixTap: controller.togglePasswordVisibility,
                    controller: controller.passwordController,
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppColors.appColor,
                        checkColor: Colors.white,
                        value: controller.isRememberMe.value,
                        onChanged: (bool? value) {
                          controller.toggleRememberMe(value ?? false);
                        },
                      ),
                    ),
                    Text(
                      'Remember me',
                      style: h4.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => CustomButton(
                    label: 'Log In',
                    onPressed: () {
                      controller.signIn();
                      //Get.offAll(OnboardingProjectView());
                    },
                    isLoading: controller.isLoading.value,
                  ),
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
                    SvgPicture.asset('assets/images/auth/google_icon.svg'),
                    const SizedBox(width: 24),
                    SvgPicture.asset('assets/images/auth/apple_icon.svg'),
                  ],
                ),
                const SizedBox(height: 50),
                Center(
                  child: GestureDetector(
                    onTap: () => controller.navigateToForgotPassword(),
                    child: Text(
                      'Forgot Password?',
                      style: h3.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account?",
                      style: h4.copyWith(
                        color: AppColors.textColor,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => controller.navigateToSignUp(),
                      child: Text(
                        'Register',
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
