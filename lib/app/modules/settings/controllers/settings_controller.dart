import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common/appColors.dart';
import '../../../data/api.dart';
import '../../../data/base_client.dart';
import '../../auth/views/login_view.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../project/controllers/project_controller.dart';

class SettingsController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final descriptionController = TextEditingController();
  final profilePasswordController = TextEditingController();

  // Reactive variables
  final obscureCurrentPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;
  final selectedImage = Rx<File?>(null);
  final profileImageUrl = RxString('');
  final name = RxString('');
  final email = RxString('');
  final phone = RxString('');

  // Reference to DashboardController
  late final DashboardController dashboardController;

  @override
  void onInit() {
    super.onInit();
    profilePasswordController.text = '********';
    // Get the DashboardController instance
    dashboardController = Get.find<DashboardController>();
    // Sync local reactive variables with DashboardController's data
    syncWithDashboard();
  }

  // Sync local variables with DashboardController's profile data
  void syncWithDashboard() {
    name.value = dashboardController.name.value;
    email.value = dashboardController.email.value;
    phone.value = dashboardController.phone.value;
    profileImageUrl.value = dashboardController.profileImageUrl.value;
    // Sync TextEditingController with Rx values
    nameController.text = name.value;
    emailController.text = email.value;
    phoneController.text = phone.value;
  }

  // Pick image from gallery with permission handling
  Future<void> pickImage() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          selectedImage.value = File(pickedFile.path);
        } else {
          kSnackBar(
              title: 'Warning',
              message: 'No image selected',
              bgColor: AppColors.snackBarWarning);
        }
      } catch (e) {
        kSnackBar(
            title: 'Error',
            message: 'Failed to pick image: $e',
            bgColor: AppColors.snackBarWarning);
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      kSnackBar(
          title: 'Warning',
          message: 'Gallery access permission denied. Please enable it in settings.',
          bgColor: AppColors.snackBarWarning);
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  // Update user profile (name, phone, and image)
  Future<void> updateProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      kSnackBar(
          title: 'Warning',
          message: 'Name and phone number are required',
          bgColor: AppColors.snackBarWarning);
      return;
    }

    isLoading.value = true;
    try {
      final fields = {
        'name': nameController.text,
        'phone': phoneController.text,
      };

      var imageFile = selectedImage.value != null ? selectedImage.value : null;

      final response = await BaseClient.multipartRequest(
        api: Api.profileUpdate,
        fields: fields,
        image: imageFile,
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.multipartRequest(
          api: Api.profileUpdate,
          fields: fields,
          image: imageFile,
          headers: BaseClient.authHeaders(),
        ),
      );
      kSnackBar(title: 'Success', message: 'Details updated successfully');
      // Refresh profile data in DashboardController
      await dashboardController.fetchProfile();
      // Sync local variables with updated DashboardController data
      syncWithDashboard();
    } catch (e) {
      kSnackBar(title: 'Warning', message: e.toString(), bgColor: AppColors.snackBarWarning);
    } finally {
      isLoading.value = false;
    }
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
    if (passwordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      kSnackBar(title: 'Warning', message: 'All fields are required', bgColor: AppColors.snackBarWarning);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      kSnackBar(title: 'Warning', message: 'New password and confirm password do not match', bgColor: AppColors.snackBarWarning);
      return;
    }

    isLoading.value = true;

    try {
      final body = jsonEncode({
        'old_password': passwordController.text,
        'new_password': newPasswordController.text,
      });
      final response = await BaseClient.putRequest(
        api: Api.profileChangePassword,
        body: body,
        headers: BaseClient.authHeaders(),
      );
      await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.putRequest(
          api: Api.profileChangePassword,
          body: body,
          headers: BaseClient.authHeaders(),
        ),
      );
      kSnackBar(title: 'Success', message: 'Password changed successfully');
      passwordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      kSnackBar(title: 'Warning', message: e.toString(), bgColor: AppColors.snackBarWarning);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      final refreshToken = await BaseClient.getRefreshToken();
      await ProjectPrefs.clearCurrentProject();

      final projectController = Get.find<ProjectController>();
      projectController.reset();
      Get.delete<ProjectController>();
      Get.delete<HomeController>();

      final body = jsonEncode({
        'refresh_token': refreshToken,
      });

      final response = await BaseClient.postRequest(
        api: Api.logout,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.logout,
          body: body,
          headers: BaseClient.authHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        await BaseClient.clearTokens();
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        final message = responseData['error'] ?? 'Something went wrong please try again later';
        kSnackBar(
          title: 'Warning',
          message: message,
          bgColor: AppColors.snackBarWarning,
        );
      }

      kSnackBar(
        title: 'Success',
        message: 'Logged out successfully',
      );

      Get.offAll(const LoginScreen());
    } catch (e) {
      String errorMessage = 'Failed to log out. Please try again.';
      if (e is Map && e.containsKey('error')) {
        errorMessage = e['error'] ?? errorMessage;
      } else if (e is String) {
        errorMessage = e;
      }

      kSnackBar(
        title: 'Error',
        message: errorMessage,
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
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