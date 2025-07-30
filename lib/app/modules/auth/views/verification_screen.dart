import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/custom_title_subTitle.dart';
import '../controllers/auth_controller.dart';
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