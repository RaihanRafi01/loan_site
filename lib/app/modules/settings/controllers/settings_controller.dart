import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common/appColors.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
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
  final notificationEnabled = true.obs;

  // Reference to DashboardController
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  void onInit() {
    super.onInit();
    profilePasswordController.text = '********';
    // Sync local reactive variables with DashboardController's data
    syncWithDashboard();
    // Fetch initial notification preference
    //fetchNotificationPreference();
  }

  // Sync local variables with DashboardController's profile data
  void syncWithDashboard() {
    nameController.text = dashboardController.name.value;
    emailController.text = dashboardController.email.value;
    phoneController.text = dashboardController.phone.value;
  }

  Future<void> sendHelpSupport() async {
    var body = jsonEncode({
      'email': emailController.text,
      'description': descriptionController.text,
    });
    isLoading.value = true;
    try {
      final response = await BaseClient.postRequest(
        api: Api.sendHelp,
        // Assuming profile API includes notification settings
        headers: BaseClient.authHeaders(),
        body: body,
      );
      await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.sendHelp,
          headers: BaseClient.authHeaders(), body: body,
        ),
      );
      if(response.statusCode == 201){
        descriptionController.clear();
        kSnackBar(
          title: 'Success',
          message: 'Successfully Send',
        );
      }
      true;
    } catch (e) {
      kSnackBar(
        title: 'Warning',
        message: 'Failed to Send',
        bgColor: AppColors.snackBarWarning,
      );
    }finally {
      isLoading.value = false;
    }
  }

  // Fetch initial notification preference from API
  Future<void> fetchNotificationPreference() async {
    try {
      final response = await BaseClient.getRequest(
        api: Api.getProfile,
        // Assuming profile API includes notification settings
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getProfile,
          headers: BaseClient.authHeaders(),
        ),
      );
      notificationEnabled.value =
          result['email_notifications'] ??
          result['push_notifications'] ??
          result['sms_notifications'] ??
          true;
    } catch (e) {
      kSnackBar(
        title: 'Warning',
        message: 'Failed to fetch notification preference: $e',
        bgColor: AppColors.snackBarWarning,
      );
    }
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
            bgColor: AppColors.snackBarWarning,
          );
        }
      } catch (e) {
        kSnackBar(
          title: 'Error',
          message: 'Failed to pick image: $e',
          bgColor: AppColors.snackBarWarning,
        );
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      kSnackBar(
        title: 'Warning',
        message:
            'Gallery access permission denied. Please enable it in settings.',
        bgColor: AppColors.snackBarWarning,
      );
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
        bgColor: AppColors.snackBarWarning,
      );
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
      kSnackBar(
        title: 'Warning',
        message: e.toString(),
        bgColor: AppColors.snackBarWarning,
      );
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
      kSnackBar(
        title: 'Warning',
        message: 'All fields are required',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      kSnackBar(
        title: 'Warning',
        message: 'New password and confirm password do not match',
        bgColor: AppColors.snackBarWarning,
      );
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
      kSnackBar(
        title: 'Warning',
        message: e.toString(),
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      final refreshToken = await BaseClient.getRefreshToken();
      await ProjectPrefs.clearCurrentProject();

      if (Get.isRegistered<ProjectController>()) {
        final projectController = Get.find<ProjectController>();
        projectController
            .reset(); // Assumes reset() is defined in ProjectController
        Get.delete<ProjectController>();
      }

      // Delete HomeController if it exists
      if (Get.isRegistered<HomeController>()) {
        Get.delete<HomeController>();
      }

      final body = jsonEncode({'refresh_token': refreshToken});

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
        final DashboardController dashboardController =
            Get.find<DashboardController>();
        dashboardController.selectedIndex.value = 0;
        await BaseClient.clearTokens();
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        final message =
            responseData['error'] ??
            'Something went wrong please try again later';
        kSnackBar(
          title: 'Warning',
          message: message,
          bgColor: AppColors.snackBarWarning,
        );
      }

      kSnackBar(title: 'Success', message: 'Logged out successfully');

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

  // Toggle notification preference via API
  Future<void> toggleNotificationPreference() async {
    final bodyEnable = jsonEncode({
      "email_notifications": true,
      "push_notifications": true,
      "sms_notifications": true,
    });
    final bodyDisable = jsonEncode({
      "email_notifications": false,
      "push_notifications": false,
      "sms_notifications": false,
    });

    try {
      final response = await BaseClient.patchRequest(
        api: Api.updateNotificationPreference,
        headers: BaseClient.authHeaders(),
        body: notificationEnabled.value ? bodyDisable : bodyEnable,
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.patchRequest(
          api: Api.updateNotificationPreference,
          headers: BaseClient.authHeaders(),
          body: notificationEnabled.value ? bodyDisable : bodyEnable,
        ),
      );
      notificationEnabled.value =
          result['email_notifications'] ??
          result['push_notifications'] ??
          result['sms_notifications'] ??
          !notificationEnabled.value;
      kSnackBar(title: 'Success', message: 'Notification preference updated');
    } catch (e) {
      kSnackBar(
        title: 'Warning',
        message: 'Failed to update notification preference: $e',
        bgColor: AppColors.snackBarWarning,
      );
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
