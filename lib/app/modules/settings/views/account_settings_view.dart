import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/settings/controllers/settings_controller.dart';
import 'package:loan_site/app/modules/settings/views/change_password_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';  // Import CachedNetworkImage

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Obx(
                      () => CircleAvatar(
                    radius: 55,
                    backgroundImage: controller.selectedImage.value != null
                        ? FileImage(controller.selectedImage.value!)
                        : controller.profileImageUrl.value.isNotEmpty
                        ? CachedNetworkImageProvider(
                      controller.profileImageUrl.value,
                      errorListener: (exception) {
                        debugPrint('Image load error: $exception');
                        controller.profileImageUrl.value = '';
                      },
                    ) as ImageProvider
                        : const AssetImage('assets/images/settings/profile_image.png'),
                  ),
                ),
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.appColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
                  () => Text(
                'Hello ${controller.name.value}!',
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontSize: 30,
                  color: AppColors.textColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Obx(
                  () => Text(
                controller.email.value,
                style: h4.copyWith(
                  fontSize: 18,
                  color: AppColors.blurtext4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    labelText: 'Full Name',
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
                    readOnly: true,
                    labelText: 'Email',
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
                    labelText: 'Phone Number',
                    controller: controller.phoneController,
                  ),
                  Text(
                    'Password',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  CustomTextField(
                    radius: 10,
                    readOnly: true,
                    labelText: 'Password',
                    controller: controller.profilePasswordController,
                    obscureText: true,
                    suffixSvgPath: 'assets/images/auth/eye_icon.svg',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(ChangePasswordView()),
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
                  Obx(
                        () => CustomButton(
                      label: controller.isLoading.value ? 'Updating...' : 'Edit Details',
                      onPressed: () {
                        controller.isLoading.value ? null : controller.updateProfile();
                      },
                    ),
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
