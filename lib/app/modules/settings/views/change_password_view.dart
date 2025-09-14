import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/customTextField.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/settings_controller.dart';

class ChangePasswordView extends GetView<SettingsController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.find<DashboardController>();
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Change Password',
          style: h2.copyWith(color: AppColors.textColor, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Keep center for avatar and greeting
          children: [
            const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundImage: controller.selectedImage.value != null
                ? FileImage(controller.selectedImage.value!)
                : dashboardController.profileImageUrl.value.isNotEmpty
                ? CachedNetworkImageProvider(
              dashboardController.profileImageUrl.value,
              errorListener: (exception) {
                debugPrint('Image load error: $exception');
                dashboardController.profileImageUrl.value = '';
              },
            ) as ImageProvider
                : const AssetImage('assets/images/settings/profile_image.png'),
          ),
            const SizedBox(height: 16),
            Text(
              'Hello ${dashboardController.name.value}!',
              style: h2.copyWith(fontSize: 30, color: AppColors.textColor),
            ),
            const SizedBox(height: 2),
            Text(
              dashboardController.email.value,
              style: h4.copyWith(fontSize: 18, color: AppColors.blurtext4),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              // Add padding for left-aligned content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text and input field to start
                children: [
                  Text(
                    'Enter Current Password',
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
                  Text(
                    'Enter New Password',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  Obx(
                    () => CustomTextField(
                      radius: 10,
                      labelText: 'Enter password',
                      controller: controller.newPasswordController,
                      obscureText: controller.obscureNewPassword.value,
                      suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                      onSuffixTap: () {
                        controller.toggleNewPasswordVisibility();
                      },
                    ),
                  ),
                  Text(
                    'Confirm Password',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  Obx(
                    () => CustomTextField(
                      radius: 10,
                      labelText: 'Enter password',
                      controller: controller.confirmPasswordController,
                      obscureText: controller.obscureConfirmPassword.value,
                      suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                      onSuffixTap: () {
                        controller.toggleConfirmPasswordVisibility();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => CustomButton(
                      isLoading: controller.isLoading.value,
                      label: 'Done',
                      onPressed: () => controller.changePassword(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
