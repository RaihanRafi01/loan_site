import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import '../../../../common/appColors.dart';
import '../../../data/api.dart';
import '../../../data/base_client.dart'; // Import your BaseClient

class SettingsController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final descriptionController = TextEditingController();
  final profilePasswordController = TextEditingController();

  // Reactive boolean to manage obscureText state for password fields
  final obscureCurrentPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

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

  // Toggle obscureText for password fields
  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.value = !obscureCurrentPassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Method to change password
  Future<void> changePassword() async {
    // Validate input fields
    if (passwordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      kSnackBar(title: 'Warning', message: 'All fields are required',bgColor: AppColors.snackBarWarning);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      kSnackBar(title: 'Warning', message: 'New password and confirm password do not match',bgColor: AppColors.snackBarWarning);
      return;
    }

    // Prepare the request body
    final body = jsonEncode({
      'old_password': passwordController.text,
      'new_password': newPasswordController.text,
    });

    isLoading.value = true;

    try {
      // Make the API call using BaseClient
      final response = await BaseClient.putRequest(
        api: Api.profileChangePassword, // Replace with your actual API endpoint
        body: body,
        headers: BaseClient.authHeaders(),
      );
      // Handle the response
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.putRequest(
          api: Api.profileChangePassword,
          body: body,
          headers: BaseClient.authHeaders(),
        ),
      );
      if (response.statusCode == 400){
        try {
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['detail'] ?? 'Failed to change password';
          kSnackBar(title: 'Warning', message: errorMessage,bgColor: AppColors.snackBarWarning);
        } catch (e) {
          kSnackBar(title: 'Warning', message: 'Failed to change password',bgColor: AppColors.snackBarWarning);
        }
      }
      kSnackBar(title: 'Success', message: 'Password changed successfully');
      passwordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      // Handle specific error messages
      String errorMessage = e.toString();
      if (e is String && e.contains('detail')) {
        try {
          final errorData = jsonDecode(e.split('detail: ')[1]);
          errorMessage = errorData['detail'] ?? 'Failed to change password';
        } catch (_) {
          errorMessage = 'Failed to change password';
        }
      }
      kSnackBar(title: 'Warning', message: errorMessage,bgColor: AppColors.snackBarWarning);
    }finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    descriptionController.dispose();
    profilePasswordController.dispose();
    super.onClose();
  }
}