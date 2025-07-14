import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/auth_controller.dart';

// Title and Subtitle Widget
class TitleSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle? subtitleStyle;
  final List<TextSpan>? subtitleSpans;

  const TitleSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleStyle,
    this.subtitleSpans,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            style: h3.copyWith(fontSize: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        if (subtitleSpans != null)
          RichText(
            text: TextSpan(
              style: h4.copyWith(fontSize: 18, color: AppColors.textColor2),
              children: subtitleSpans,
            ),
          )
        else
          Text(
            subtitle,
            style:
                subtitleStyle ??
                h4.copyWith(fontSize: 18, color: AppColors.textColor2),
          ),
      ],
    );
  }
}

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await controller.handleBackNavigation();
      },
      child: Obx(() {
        switch (controller.currentScreen.value) {
          case AuthScreen.login:
            return const LoginScreen();
          case AuthScreen.signup:
            return const SignUpScreen();
          case AuthScreen.forgotPassword:
            return const ForgotPasswordScreen();
          case AuthScreen.verification:
            return const VerificationScreen();
          case AuthScreen.sendOtp:
            return const SendOtpScreen();
          case AuthScreen.createPassword:
            return const CreatePasswordScreen();
          default:
            return const SignUpScreen();
        }
      }),
    );
  }
}

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
              CustomTextField(
                obscureText: true,
                labelText: 'Password',
                prefixSvgPath: 'assets/images/auth/lock_icon.svg',
                suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                controller: controller.passwordController,
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
              CustomButton(label: 'Log In', onPressed: () {}),
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
    );
  }
}

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
                      CustomButton(label: 'Register', onPressed: () {
                        controller.showConfirm.value = true;
                      }),
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
                  controller.showConfirm.value =
                      false; // Dismiss card on outside tap
                },
                child: Stack(
                  children: [
                    // Blurred background
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withOpacity(
                          0.2,
                        ), // Semi-transparent overlay
                      ),
                    ),
                    // Centered card
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        // Prevents taps on the card from dismissing it
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

                                // Buttons in a column
                                SvgPicture.asset('assets/images/auth/tic_icon.svg'),
                                SizedBox(height: 10,),
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

class CreatePasswordScreen extends GetView<AuthController> {
  const CreatePasswordScreen({super.key});

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
                  title: 'Create a new password',
                  subtitle: 'Please enter a new password for next time Log In',
                ),
                const SizedBox(height: 40),
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
                SizedBox(height: 20),
                CustomButton(label: 'Done', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TitleSubtitle(
                title: 'Forgot Password',
                subtitle:
                    'Select which contact details should we use to reset your password',
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  controller.setResetMethod(ResetMethod.email);
                  controller.navigateToSendOtp();
                },
                child: SvgPicture.asset('assets/images/auth/via_email.svg'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  controller.setResetMethod(ResetMethod.sms);
                  controller.navigateToSendOtp();
                },
                child: SvgPicture.asset('assets/images/auth/via_sms.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendOtpScreen extends GetView<AuthController> {
  const SendOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TitleSubtitle(
                title: 'Forgot Password',
                subtitle: 'Provide details',
              ),
              const SizedBox(height: 40),
              Obx(
                () => CustomTextField(
                  labelText: controller.resetMethod.value == ResetMethod.email
                      ? 'Enter email address'
                      : 'Enter phone number',
                  prefixSvgPath:
                      controller.resetMethod.value == ResetMethod.email
                      ? 'assets/images/auth/mail_icon.svg'
                      : 'assets/images/auth/phone_icon.svg',
                  controller: controller.resetMethod.value == ResetMethod.email
                      ? controller.emailController
                      : controller.phoneController,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Send OTP',
                onPressed: () => controller.sendOtp(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationScreen extends GetView<AuthController> {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Obx(
                () => TitleSubtitle(
                  title: controller.resetMethod.value == ResetMethod.email
                      ? 'Verify Your Email'
                      : 'Verify Your Phone',
                  subtitle: '',
                  subtitleSpans: [
                    TextSpan(
                      text: 'Please enter the 4-digit OTP that sent at ',
                      style: h4.copyWith(
                        fontSize: 18,
                        color: AppColors.textColor2,
                      ),
                    ),
                    TextSpan(
                      text: controller.resetMethod.value == ResetMethod.email
                          ? controller.emailController.text.isNotEmpty
                                ? controller.emailController.text
                                : 'your email'
                          : controller.phoneController.text.isNotEmpty
                          ? controller.phoneController.text
                          : 'your phone number',
                      style: h4.copyWith(
                        fontSize: 18,
                        color: AppColors.appColor2,
                        // Colored text for email/phone
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: controller.verificationCodeControllers[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: controller.resetMethod.value == ResetMethod.email
                    ? 'Verify Email'
                    : 'Verify Phone',
                onPressed: controller.navigateToCreatePassword,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: h3.copyWith(color: AppColors.textColor),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: controller.resendCode,
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
