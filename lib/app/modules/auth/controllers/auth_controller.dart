import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/auth/views/create_password_view.dart';
import 'package:loan_site/app/modules/auth/views/forgot_password_screen.dart';
import 'package:loan_site/app/modules/auth/views/login_view.dart';
import 'package:loan_site/app/modules/auth/views/send_otp_view.dart';
import 'package:loan_site/app/modules/auth/views/signUp_view.dart';
import 'package:loan_site/app/modules/auth/views/verification_screen.dart';
import 'package:loan_site/app/modules/dashboard/views/dashboard_view.dart';
import 'dart:convert';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../data/api.dart';
import '../../../data/base_client.dart';

enum ResetMethod { email, sms }

class AuthController extends GetxController {
  // Current screen state
  final resetMethod = ResetMethod.email.obs;

  // Form controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final verificationCodeControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  // Observable states
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isTermsAccepted = false.obs;
  final isLoading = false.obs;
  final isRememberMe = false.obs;
  var showConfirm = false.obs;

  void showConfirmationAndNavigate() {
    showConfirm.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showConfirm.value = false;
      Get.offAll(VerificationScreen());
      //Get.offAll(() => const OnboardingProjectView(newUser: true));
    });
  }

  void setResetMethod(ResetMethod method) {
    resetMethod.value = method;
  }

  void toggleRememberMe(bool value) {
    isRememberMe.value = value;
  }

  // Navigation methods

  void navigateToCreatePassword() {
    Get.to(CreatePasswordScreen());
    // Do not clear emailController or phoneController to preserve them
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    isTermsAccepted.value = false;
  }

  void navigateToLogin() {
    Get.to(LoginScreen());
    clearForm();
  }

  void navigateToSignUp() {
    Get.to(SignUpScreen());
    clearForm();
  }

  void navigateToForgotPassword() {
    Get.to(ForgotPasswordScreen());
    clearForm();
  }

  void navigateToSendOtp() {
    Get.to(SendOtpScreen());
    clearForm();
  }

  Future<bool> handleBackNavigation() async {
    clearForm();
    return false; // Prevent default back behavior
  }

  // Toggle methods
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void toggleTermsAcceptance() {
    isTermsAccepted.value = !isTermsAccepted.value;
  }

  // Validation methods
  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _validatePhone(String phone) {
    return RegExp(r'^\+?1?\d{9,15}$').hasMatch(phone);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validateName(String name) {
    return name.trim().isNotEmpty;
  }

  bool _validateVerificationCode() {
    return verificationCodeControllers.every(
      (controller) => controller.text.length == 1,
    );
  }

  // Auth methods
  void signUp() async {
    if (!_validateName(nameController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Please enter your full name',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    if (!_validateEmail(emailController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Please enter a valid email address',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    if (!_validatePassword(passwordController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Password must be at least 6 characters long',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      kSnackBar(
        title: 'Warning',
        message: 'Passwords do not match',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    /*if (!isTermsAccepted.value) {
      Get.snackbar(
        'Error',
        'Please accept the terms and conditions',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }*/

    isLoading.value = true;

    try {
      // Prepare the request body
      final body = jsonEncode({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        "user_role": "borrower",
        //"company_name": "Wilson Capital Lending"
      });

      // Make the API call using BaseClient
      final response = await BaseClient.postRequest(
        api: Api.signup,
        body: body,
        headers: BaseClient.basicHeaders,
      );

      // Handle the response manually for specific status codes
      if (response.statusCode == 201) {
        // Successful account creation
        kSnackBar(
          title: 'Success',
          message: 'Account created successfully! Please verify your email.',
        );
        showConfirmationAndNavigate();
      } else if (response.statusCode == 200) {
        // User already exists but is inactive, OTP sent
        final responseData = jsonDecode(response.body);
        final message =
            responseData['message'] ?? 'A new OTP has been sent to your email.';
        kSnackBar(title: 'Info', message: message);
        //navigateToVerification();
      } else {
        // Let BaseClient.handleResponse handle other status codes
        final result = await BaseClient.handleResponse(response);
        // If handleResponse doesn't throw an error, treat as success
        //showConfirmationAndNavigate();
      }
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

  void signIn() async {
    if (!_validateEmail(emailController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Please enter a valid email address',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    if (!_validatePassword(passwordController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Password must be at least 6 characters long',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text,
        //"company_name": "Wilson Capital Lending"
      });

      // Make the API call using BaseClient
      final response = await BaseClient.postRequest(
        api: Api.login,
        body: body,
        headers: BaseClient.basicHeaders,
      );
      // Handle the response manually for specific status codes
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        print(
          '==========access_token=============================>>> ${responseData['access_token']}',
        );
        print(
          '==========refresh_token=============================>>> ${responseData['refresh_token']}',
        );
        // Store tokens in secure storage
        await BaseClient.storeTokens(
          accessToken: responseData['access_token'],
          refreshToken: responseData['refresh_token'],
        );
        kSnackBar(title: 'Success', message: 'Signed in successfully!');
        clearForm();
        Get.offAll(DashboardView());
      } else if (response.statusCode == 400) {
        // User already exists but is inactive, OTP sent
        kSnackBar(
          title: 'Warning',
          message: 'Invalid credentials',
          bgColor: AppColors.snackBarWarning,
        );
        //navigateToVerification();
      } else {
        // Let BaseClient.handleResponse handle other status codes
        final result = await BaseClient.handleResponse(response);
        // If handleResponse doesn't throw an error, treat as success
        //showConfirmationAndNavigate();
      }
    } catch (e) {
      print('error ======>>> $e');
      kSnackBar(
        title: 'Warning',
        message: 'Failed to sign in. Please try again.',
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void sendOtp() async {
    if (resetMethod.value == ResetMethod.email &&
        !_validateEmail(emailController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Please enter a valid email address',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    if (resetMethod.value == ResetMethod.sms &&
        !_validatePhone(phoneController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Please enter a valid phone number',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = jsonEncode({
        if (resetMethod.value == ResetMethod.email)
          'email': emailController.text.trim()
        else
          'phone_number': phoneController.text,
      });

      // Make the API call using BaseClient
      final response = await BaseClient.postRequest(
        api: Api.resetPasswordRequest,
        body: body,
        headers: BaseClient.basicHeaders,
      );
      // Handle the response manually for specific status codes
      if (response.statusCode == 200) {
        kSnackBar(title: 'Success', message: 'Otp Sent Successfully');
        Get.off(VerificationScreen(isForgot: true,));
      } else if (response.statusCode == 400) {
        // User already exists but is inactive, OTP sent
        kSnackBar(
          title: 'Warning',
          message: 'No user found with the provided credentials.',
          bgColor: AppColors.snackBarWarning,
        );
        //navigateToVerification();
      } else {
        // Let BaseClient.handleResponse handle other status codes
        final result = await BaseClient.handleResponse(response);
        // If handleResponse doesn't throw an error, treat as success
        //showConfirmationAndNavigate();
      }


    } catch (e) {
      kSnackBar(
        message: 'Failed to send OTP. Please try again.',
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void verifyOtp(bool isFirstTime, bool? isForgot) async {
    if (!_validateVerificationCode()) {
      kSnackBar(
        title: 'Incorrect OTP',
        message: 'Please enter a valid verification code',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    isLoading.value = true;

    if(isForgot!){
      try {
        final otp = verificationCodeControllers
            .map((controller) => controller.text)
            .join();


        final body = jsonEncode({
          if (resetMethod.value == ResetMethod.email)
            'email': emailController.text.trim()
          else
            'phone_number': phoneController.text,
          'otp': otp,
        });

        // Make the API call using BaseClient
        final response = await BaseClient.postRequest(
          api: Api.resetPasswordActivate,
          body: body,
          headers: BaseClient.basicHeaders,
        );

        // Handle the response manually for specific status codes
        if (response.statusCode >= 200 && response.statusCode <= 210) {
          final responseData = jsonDecode(response.body);
          kSnackBar(
            title: 'Success',
            message: resetMethod.value == ResetMethod.email
                ? 'Email verified successfully!'
                : 'Phone verified successfully!',
          );

          print(
            '==========access_token=============================>>> ${responseData['access_token']}',
          );
          print(
            '==========refresh_token=============================>>> ${responseData['refresh']}',
          );
          // Store tokens in secure storage
          await BaseClient.storeTokens(
            accessToken: responseData['access_token'],
            refreshToken: responseData['refresh'],
          );

          navigateToCreatePassword();

        } else if (response.statusCode == 400) {
          kSnackBar(
            title: 'Invalid OTP',
            message: 'Please provide correct OTP',
            bgColor: AppColors.snackBarWarning,
          );
        } else {
          // Let BaseClient.handleResponse handle other status codes
          await BaseClient.handleResponse(response);
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to verify OTP. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
      } finally {
        isLoading.value = false;
      }
    }

    else{
      try {
        final otp = verificationCodeControllers
            .map((controller) => controller.text)
            .join();

        final body = jsonEncode({
          'email': emailController.text.trim(),
          'otp': otp,
        });

        // Make the API call using BaseClient
        final response = await BaseClient.postRequest(
          api: Api.verifyOtp,
          body: body,
          headers: BaseClient.basicHeaders,
        );

        // Handle the response manually for specific status codes
        if (response.statusCode >= 200 && response.statusCode <= 210) {
          kSnackBar(
            title: 'Success',
            message: resetMethod.value == ResetMethod.email
                ? 'Email verified successfully!'
                : 'Phone verified successfully!',
          );

          if (isFirstTime) {
            Get.offAll(DashboardView());
          } else {
            navigateToLogin();
          }

        } else if (response.statusCode == 400) {
          kSnackBar(
            title: 'Invalid OTP',
            message: 'Please provide correct OTP',
            bgColor: AppColors.snackBarWarning,
          );
        } else {
          // Let BaseClient.handleResponse handle other status codes
          await BaseClient.handleResponse(response);
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to verify OTP. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<bool> resendCode() async {
    isLoading.value = true;

    try {
      // Prepare the request body
      final body = jsonEncode({
        'email': emailController.text,
        "type": 'email',
        //"company_name": "Wilson Capital Lending"
      });

      // Make the API call using BaseClient
      final response = await BaseClient.postRequest(
        api: Api.resendOtp,
        body: body,
        headers: BaseClient.basicHeaders,
      );

      // Handle the response manually for specific status codes
      if (response.statusCode == 200) {
        kSnackBar(
          title: 'Success',
          message: resetMethod.value == ResetMethod.email
              ? 'Verification code resent to your email!'
              : 'Verification code resent to your phone!',
        );
        return true; // Indicate success
      } else if (response.statusCode == 404) {
        kSnackBar(title: 'Warning', message: 'User does not exist');
        return false; // Indicate failure
      } else {
        // Let BaseClient.handleResponse handle other status codes
        await BaseClient.handleResponse(response);
        return false; // Assume failure for other cases
      }
    } catch (e) {
      print('Error: ===============>>>>>>> $e');
      kSnackBar(
        message: 'Failed to resend code. Please try again.',
        bgColor: AppColors.snackBarWarning,
      );
      return false; // Indicate failure on exception
    } finally {
      isLoading.value = false;
    }
  }

  // In AuthController class

  // Add this new method for creating a new password
  void createNewPassword() async {
    // Validate password
    if (!_validatePassword(passwordController.text)) {
      kSnackBar(
        title: 'Warning',
        message: 'Password must be at least 6 characters long',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    // Validate confirm password
    if (passwordController.text != confirmPasswordController.text) {
      kSnackBar(
        title: 'Warning',
        message: 'Passwords do not match',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Prepare the request body
      final body = jsonEncode({'new_password': passwordController.text});

      // Make the API call using BaseClient
      final response = await BaseClient.postRequest(
        api: Api.resetPassword, // Ensure this is defined in your Api class
        body: body,
        headers: BaseClient.authHeaders(),
      );

      // Handle the response
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        kSnackBar(title: 'Success', message: 'Password updated successfully!');
        navigateToLogin(); // Navigate to LoginScreen on success
      } else if (response.statusCode == 404) {
        kSnackBar(
          title: 'Warning',
          message: 'User does not exist',
          bgColor: AppColors.snackBarWarning,
        );
      } else {
        await BaseClient.handleResponse(response);
      }
    } catch (e) {
      print('______________>>>>>>>>>>>> $e');
      kSnackBar(
        title: 'Warning',
        message: 'Failed to update password. Please try again.',
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Modify navigateToCreatePassword to preserve email/phone

  void signInWithGoogle() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));
      kSnackBar(
        title: 'Success',
        message: 'Signed in with Google successfully!',
      );
      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithFacebook() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));
      kSnackBar(
        title: 'Success',
        message: 'Signed in with Facebook successfully!',
      );
      clearForm();
    } catch (e) {
      kSnackBar(message: 'Failed to sign in with Facebook. Please try again.!');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    phoneController.clear();
    for (var controller in verificationCodeControllers) {
      controller.clear();
    }
    isTermsAccepted.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    for (var controller in verificationCodeControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
