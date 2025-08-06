import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/customTextField.dart';
import '../../../../common/widgets/custom_title_subTitle.dart';
import '../controllers/auth_controller.dart';
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
          Obx(() => CustomButton(
                label: 'Send OTP',
                onPressed: () => controller.sendOtp(),
                isLoading: controller.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }
}