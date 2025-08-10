import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final descriptionController = TextEditingController();
  final profilePasswordController = TextEditingController();

  // Reactive boolean to manage obscureText state for password field
  final obscureCurrentPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Set default values for the text controllers
    nameController.text = 'Sam Lee';
    emailController.text = 'Samlee@gmail.com';
    phoneController.text = '123 456 785';
    passwordController.text = '';
    profilePasswordController.text = 'testPassword123';
    confirmPasswordController.text = '';
  }

  // Toggle obscureText for password field
  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.value = !obscureCurrentPassword.value;
  }
  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}