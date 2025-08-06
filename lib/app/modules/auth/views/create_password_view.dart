import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../../../../common/widgets/customTextField.dart';
import '../../../../common/widgets/custom_title_subTitle.dart';
import '../controllers/auth_controller.dart';
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
                CustomButton(label: 'Done', onPressed: ()=> controller.createNewPassword()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}