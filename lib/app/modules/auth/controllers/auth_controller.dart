import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Current screen state
  final currentScreen = AuthScreen.signup.obs;

  // Form controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final verificationCodeControllers = List.generate(4, (_) => TextEditingController());

  // Observable states
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isTermsAccepted = false.obs;
  final isLoading = false.obs;

  // Navigation methods
  void navigateToWelcome() {
    currentScreen.value = AuthScreen.welcome;
    clearForm();
  }

  void navigateToLogin() {
    currentScreen.value = AuthScreen.login;
    clearForm();
  }

  void navigateToSignUp() {
    currentScreen.value = AuthScreen.signup;
    clearForm();
  }

  void navigateToForgotPassword() {
    currentScreen.value = AuthScreen.forgotPassword;
    clearForm();
  }

  void navigateToVerification() {
    currentScreen.value = AuthScreen.verification;
    clearForm();
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

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validateName(String name) {
    return name.trim().isNotEmpty;
  }

  bool _validateVerificationCode() {
    return verificationCodeControllers.every((controller) => controller.text.length == 1);
  }

  // Auth methods
  void signIn() async {
    if (!_validateEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    if (!_validatePassword(passwordController.text)) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters long',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      Get.snackbar(
        'Success',
        'Signed in successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

      // Navigate to home or dashboard
      // Get.offAllNamed('/home');
      clearForm();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signUp() async {
    if (!_validateName(nameController.text)) {
      Get.snackbar(
        'Error',
        'Please enter your full name',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    if (!_validateEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    if (!_validatePassword(passwordController.text)) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters long',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    if (!isTermsAccepted.value) {
      Get.snackbar(
        'Error',
        'Please accept the terms and conditions',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to verification screen
      navigateToVerification();

      Get.snackbar(
        'Success',
        'Account created successfully! Please verify your email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create account. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void sendResetLink() async {
    if (!_validateEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Password reset link sent to your email!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

      // Navigate back to login
      navigateToLogin();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset link. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void verifyEmail() async {
    if (!_validateVerificationCode()) {
      Get.snackbar(
        'Error',
        'Please enter a valid verification code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Email verified successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

      // Navigate to home or dashboard
      // Get.offAllNamed('/home');
      clearForm();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify email. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendCode() async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Verification code resent to your email!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend code. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Social login methods
  void signInWithGoogle() async {
    isLoading.value = true;

    try {
      // Simulate Google sign-in
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Signed in with Google successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

      // Navigate to home or dashboard
      // Get.offAllNamed('/home');
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
      // Simulate Facebook sign-in
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Signed in with Facebook successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

      // Navigate to home or dashboard
      // Get.offAllNamed('/home');
      clearForm();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Facebook. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form data
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
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
    for (var controller in verificationCodeControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}

enum AuthScreen {
  welcome,
  login,
  signup,
  forgotPassword,
  verification,
}