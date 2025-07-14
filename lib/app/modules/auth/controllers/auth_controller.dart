import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuthScreen {
  login,
  signup,
  forgotPassword,
  verification,
  sendOtp,
  createPassword,
}

enum ResetMethod {
  email,
  sms,
}

class AuthController extends GetxController {
  // Current screen state
  final currentScreen = AuthScreen.signup.obs;
  final resetMethod = ResetMethod.email.obs;

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
  final isRememberMe = false.obs;
  var showConfirm = false.obs;

  // Navigation stack to track history
  final navigationStack = <AuthScreen>[AuthScreen.signup].obs;

  void setResetMethod(ResetMethod method) {
    resetMethod.value = method;
  }

  void toggleRememberMe(bool value) {
    isRememberMe.value = value;
  }

  // Navigation methods

  void navigateToCreatePassword() {
    _addToNavigationStack(AuthScreen.createPassword);
    currentScreen.value = AuthScreen.createPassword;
    clearForm();
  }

  void navigateToLogin() {
    _addToNavigationStack(AuthScreen.login);
    currentScreen.value = AuthScreen.login;
    clearForm();
  }

  void navigateToSignUp() {
    _addToNavigationStack(AuthScreen.signup);
    currentScreen.value = AuthScreen.signup;
    clearForm();
  }

  void navigateToForgotPassword() {
    _addToNavigationStack(AuthScreen.forgotPassword);
    currentScreen.value = AuthScreen.forgotPassword;
    clearForm();
  }

  void navigateToVerification() {
    _addToNavigationStack(AuthScreen.verification);
    currentScreen.value = AuthScreen.verification;
    //clearForm();
  }

  void navigateToSendOtp() {
    _addToNavigationStack(AuthScreen.sendOtp);
    currentScreen.value = AuthScreen.sendOtp;
    clearForm();
  }

  Future<bool> handleBackNavigation() async {
    if (navigationStack.length <= 1) {
      return true; // Allow app to close if at root screen
    }

    navigationStack.removeLast();
    currentScreen.value = navigationStack.last;
    clearForm();
    return false; // Prevent default back behavior
  }

  void _addToNavigationStack(AuthScreen screen) {
    navigationStack.add(screen);
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
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar(
        'Success',
        'Signed in successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
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
      await Future.delayed(const Duration(seconds: 2));
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

  void sendOtp() async {
    if (resetMethod.value == ResetMethod.email && !_validateEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    if (resetMethod.value == ResetMethod.sms && !_validatePhone(phoneController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));
      navigateToVerification();
      Get.snackbar(
        'Success',
        resetMethod.value == ResetMethod.email
            ? 'OTP sent to your email!'
            : 'OTP sent to your phone!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void verifyOtp() async {
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
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar(
        'Success',
        resetMethod.value == ResetMethod.email
            ? 'Email verified successfully!'
            : 'Phone verified successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
      navigateToLogin();
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

  void resendCode() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar(
        'Success',
        resetMethod.value == ResetMethod.email
            ? 'Verification code resent to your email!'
            : 'Verification code resent to your phone!',
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

  void signInWithGoogle() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar(
        'Success',
        'Signed in with Google successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
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
      Get.snackbar(
        'Success',
        'Signed in with Facebook successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
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