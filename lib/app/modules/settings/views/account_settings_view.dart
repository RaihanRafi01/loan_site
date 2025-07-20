import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/settings/controllers/settings_controller.dart';
import 'package:loan_site/app/modules/settings/views/change_password_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class AccountSettingsView extends GetView<SettingsController> {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Account Settings',
          style: h2.copyWith(
            color: AppColors.textColor,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Keep center for avatar and greeting
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage('assets/images/settings/profile_image.png'), // Replace with your image path
            ),
            const SizedBox(height: 16),
            Text(
              'Hello Angelo!',
              style: h2.copyWith(
                fontSize: 30,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'angelo@gmail.com',
              style: h4.copyWith(
                fontSize: 18,
                color: AppColors.blurtext4,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding for left-aligned content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text and input field to start
                children: [
                  Text(
                    'Full Name',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  CustomTextField(
                    radius: 10,
                    labelText: 'Sam Lee',
                    controller: controller.nameController,
                  ),
                  Text(
                    'Email',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  CustomTextField(
                    radius: 10,
                    labelText: 'Samlee@gmail.com',
                    controller: controller.emailController,
                  ),
                  Text(
                    'Phone Number',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  CustomTextField(
                    radius: 10,
                    labelText: '123 456 785',
                    controller: controller.phoneController,
                  ),
                  Text(
                    'Password',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  Obx(
                        () => CustomTextField(
                          radius: 10,
                      labelText: 'Enter password',
                      controller: controller.passwordController,
                      obscureText: controller.obscureCurrentPassword.value,
                      suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                      onSuffixTap: () {
                        controller.toggleCurrentPasswordVisibility();
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: ()=> Get.to(ChangePasswordView()),
                        child: Text(
                          'Change Password',
                          style: h4.copyWith(
                            fontSize: 15,
                            color: AppColors.cardGradient2,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.cardGradient2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Edit Details',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}