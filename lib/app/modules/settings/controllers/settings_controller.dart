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

  @override
  void onInit() {
    super.onInit();
    profilePasswordController.text = '********';
    fetchProfile();
  }

  // Pick image from gallery with permission handling
  Future<void> pickImage() async {
    // Request permission based on Android version
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

  // Fetch user profile data from API
  Future<void> fetchProfile() async {
    try {
      final response = await BaseClient.getRequest(
        api: Api.getProfile,
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getProfile,
          headers: BaseClient.authHeaders(),
        ),
      );
      name.value = result['name'] ?? '';
      email.value = result['email'] ?? '';
      phoneController.text = result['phone'] ?? '';
      // Prepend base URL to image if it's a relative path
      final imageUrl = result['image'] ?? '';
      profileImageUrl.value = imageUrl.startsWith('http') ? imageUrl : imageUrl.isNotEmpty ? '${Api.baseUrlPicture}$imageUrl' : '';
      // Sync TextEditingController with Rx values
      nameController.text = name.value;
      emailController.text = email.value;
    } catch (e) {
      kSnackBar(title: 'Warning', message: e.toString(), bgColor: AppColors.snackBarWarning);
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

      // If there's a selected image, include it in the update request
      var imageFile = selectedImage.value != null ? selectedImage.value : null;

      final response = await BaseClient.multipartRequest(
        api: Api.profileUpdate,
        fields: fields,
        image: imageFile, // Send null if no image is selected
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.multipartRequest(
          api: Api.profileUpdate,
          fields: fields,
          image: imageFile, // Retry with the same image condition
          headers: BaseClient.authHeaders(),
        ),
      );
      kSnackBar(title: 'Success', message: 'Details updated successfully');
      fetchProfile();
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
      isLoading.value = true; // Show loading state

      // Retrieve refresh token from secure storage
      final refreshToken = await BaseClient.getRefreshToken();


      // Prepare the request body with refresh token
      final body = jsonEncode({
        'refresh_token': refreshToken,
      });

      // Make the logout API call
      final response = await BaseClient.postRequest(
        api: Api.logout,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      // Handle the response
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.logout,
          body: body,
          headers: BaseClient.authHeaders(),
        ),
      );

      if (response.statusCode == 200){
        await BaseClient.clearTokens();
      }
      else if (response.statusCode == 400){
        final responseData = jsonDecode(response.body);
        final message = responseData['error'] ?? 'Something went wrong please try again later';
        kSnackBar(
          title: 'Warning',
          message: message,
          bgColor: AppColors.snackBarWarning
        );
      }


      // Clear tokens from secure storage on successful logout


      // Show success snackbar
      kSnackBar(
        title: 'Success',
        message: 'Logged out successfully',
      );

      // Navigate to LoginView and clear the navigation stack
      Get.offAll(const LoginScreen());
    } catch (e) {
      // Handle errors with specific feedback
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
      isLoading.value = false; // Hide loading state
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