import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/customTextField.dart';
import '../controllers/settings_controller.dart';

class HelpSupportView extends GetView<SettingsController> {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.appBc,
        elevation: 0,
        title: Text(
          'Help & Support',
          style: h2.copyWith(color: AppColors.textColor, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Keep center for avatar and greeting
          children: [
            SvgPicture.asset('assets/images/settings/help_page_icon.svg'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              // Add padding for left-aligned content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text and input field to start
                children: [
                  Text(
                    'Email',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  CustomTextField(
                    radius: 10,
                    labelText: 'Sam Lee',
                    controller: controller.emailController,
                  ),
                  Text(
                    'Description',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  CustomTextField(
                    labelText: 'Write here...',
                    maxLine: 5,
                    radius: 10,
                    controller: controller.descriptionController,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: CustomButton(label: 'Send', onPressed: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
