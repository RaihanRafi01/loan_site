import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_title_subTitle.dart';
import '../controllers/auth_controller.dart';
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