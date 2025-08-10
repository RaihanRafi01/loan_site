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
  // Constants
  static const int _otpLength = 4;
  static const int _minPasswordLength = 6;
  static const int _successStatusLower = 200;
  static const int _successStatusUpper = 210;
  static const Duration _confirmationDelay = Duration(seconds: 3);

  // Form controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final verificationCodeControllers = List.generate(
    _otpLength,
        (_) => TextEditingController(),
    growable: false,
  );

  // Observable states
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isTermsAccepted = false.obs;
  final isLoading = false.obs;
  final isRememberMe = false.obs;
  final showConfirm = false.obs;
  final resetMethod = ResetMethod.email.obs;

  // Navigation Methods
  void navigateToCreatePassword() {
    Get.to(() => CreatePasswordScreen());
  }

  void navigateToLogin() {
    Get.to(() => LoginScreen());
    clearForm();
  }

  void navigateToSignUp() {
    Get.to(() => SignUpScreen());
    clearForm();
  }

  void navigateToForgotPassword() {
    Get.to(() => ForgotPasswordScreen());
    clearForm();
  }

  void navigateToSendOtp() {
    Get.to(() => SendOtpScreen());
    clearForm();
  }

  Future<bool> handleBackNavigation() async {
    clearForm();
    return false;
  }

  // UI State Management
  void setResetMethod(ResetMethod method) => resetMethod.value = method;

  void toggleRememberMe(bool value) => isRememberMe.value = value;

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();

  void toggleTermsAcceptance() => isTermsAccepted.toggle();

  void showConfirmationAndNavigate() {
    showConfirm.value = true;
    Future.delayed(_confirmationDelay, () {
      showConfirm.value = false;
      Get.offAll(() => VerificationScreen());
    });
  }

  // Validation Methods
  bool _validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  bool _validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return false;
    return RegExp(r'^\+?1?\d{9,15}$').hasMatch(phone.trim());
  }

  bool _validatePassword(String? password) {
    return password != null && password.length >= _minPasswordLength;
  }

  bool _validateName(String? name) {
    return name != null && name.trim().isNotEmpty;
  }

  bool _validateVerificationCode() {
    return verificationCodeControllers.every((controller) =>
    controller.text.isNotEmpty && controller.text.length == 1);
  }

  // Helper Methods
  String _sanitizeInput(String? input) => input?.trim() ?? '';

  Map<String, String> _getBasicAuthBody({
    String? email,
    String? phone,
    String? password,
    String? name,
    String? otp,
  }) {
    final body = <String, String>{};
    if (email != null) body['email'] = _sanitizeInput(email);
    if (phone != null) body['phone_number'] = _sanitizeInput(phone);
    if (password != null) body['password'] = password;
    if (name != null) body['name'] = _sanitizeInput(name);
    if (otp != null) body['otp'] = otp;
    return body;
  }

  // Auth Methods
  Future<void> signUp() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final name = nameController.text;

    if (!_validateName(name)) {
      return _showWarning('Please enter your full name');
    }

    if (!_validateEmail(email)) {
      return _showWarning('Please enter a valid email address');
    }

    if (!_validatePassword(password)) {
      return _showWarning('Password must be at least $_minPasswordLength characters long');
    }

    if (password != confirmPassword) {
      return _showWarning('Passwords do not match');
    }

    isLoading.value = true;
    try {
      final body = jsonEncode({
        ..._getBasicAuthBody(
          name: name,
          email: email,
          phone: phoneController.text,
          password: password,
        ),
        'user_role': 'borrower',
      });

      final response = await BaseClient.postRequest(
        api: Api.signup,
        body: body,
        headers: BaseClient.basicHeaders,
      );

      await _handleSignUpResponse(response);
    } catch (e) {
      print('Sign-up error: $e');
      _showWarning(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleSignUpResponse(dynamic response) async {
    if (response.statusCode == 201) {
      kSnackBar(
        title: 'Success',
        message: 'Account created successfully! Please verify your email.',
      );
      showConfirmationAndNavigate();
    } else if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final message = responseData['message'] ?? 'A new OTP has been sent to your email.';
      kSnackBar(title: 'Info', message: message);
    } else {
      //await BaseClient.handleResponse(response);
    }
  }

  Future<void> signIn() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (!_validateEmail(email)) {
      return _showWarning('Please enter a valid email address');
    }

    if (!_validatePassword(password)) {
      return _showWarning('Password must be at least $_minPasswordLength characters long');
    }

    isLoading.value = true;
    try {
      final body = jsonEncode(_getBasicAuthBody(email: email, password: password));
      final response = await BaseClient.postRequest(
        api: Api.login,
        body: body,
        headers: BaseClient.basicHeaders,
      );

      await _handleSignInResponse(response);
    } catch (e) {
      print('Sign-in error: $e');
      _showWarning('Failed to sign in. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleSignInResponse(dynamic response) async {
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await BaseClient.storeTokens(
        accessToken: responseData['access_token'],
        refreshToken: responseData['refresh_token'],
      );
      kSnackBar(title: 'Success', message: 'Signed in successfully!');
      clearForm();
      Get.offAll(() => DashboardView());
    } else if (response.statusCode == 400) {
      _showWarning('Invalid credentials');
    } else {
      //await BaseClient.handleResponse(response);
    }
  }

  Future<void> sendOtp() async {
    final email = emailController.text;
    final phone = phoneController.text;

    if (resetMethod.value == ResetMethod.email && !_validateEmail(email)) {
      return _showWarning('Please enter a valid email address');
    }

   /* if (resetMethod.value == ResetMethod.sms && !_validatePhone(phone)) {
      return _showWarning('Please enter a valid phone number');
    }*/

    isLoading.value = true;
    try {
      final body = jsonEncode(_getBasicAuthBody(
        email: resetMethod.value == ResetMethod.email ? email : null,
        phone: resetMethod.value == ResetMethod.sms ? phone : null,
      ));

      final response = await BaseClient.postRequest(
        api: Api.resetPasswordRequest,
        body: body,
        headers: BaseClient.basicHeaders,
      );

      await _handleSendOtpResponse(response);
    } catch (e) {
      print('Send OTP error: $e');
      _showWarning('Failed to send OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleSendOtpResponse(dynamic response) async {
    if (response.statusCode == 200) {
      kSnackBar(title: 'Success', message: 'OTP Sent Successfully');
      Get.off(() => VerificationScreen(isForgot: true));
    } else if (response.statusCode == 400) {
      _showWarning('No user found with the provided credentials.');
    } else {
     // await BaseClient.handleResponse(response);
    }
  }

  Future<void> verifyOtp(bool isFirstTime, bool? isForgot) async {
    if (!_validateVerificationCode()) {
      return _showWarning('Please enter a valid verification code', title: 'Incorrect OTP');
    }

    isLoading.value = true;
    try {
      final otp = verificationCodeControllers.map((c) => c.text).join();
      final api = isForgot == true ? Api.resetPasswordActivate : Api.verifyOtp;
      final body = jsonEncode(_getBasicAuthBody(
        email: resetMethod.value == ResetMethod.email ? emailController.text : null,
        phone: resetMethod.value == ResetMethod.sms ? phoneController.text : null,
        otp: otp,
      ));

      final response = await BaseClient.postRequest(
        api: api,
        body: body,
        headers: BaseClient.basicHeaders,
      );

      await _handleVerifyOtpResponse(response, isFirstTime, isForgot);
    } catch (e) {
      print('Verify OTP error: $e');
      _showWarning('Failed to verify OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleVerifyOtpResponse(dynamic response, bool isFirstTime, bool? isForgot) async {
    if (response.statusCode >= _successStatusLower && response.statusCode <= _successStatusUpper) {
      final message = resetMethod.value == ResetMethod.email
          ? 'Email verified successfully!'
          : 'Phone verified successfully!';
      kSnackBar(title: 'Success', message: message);

      if (isForgot == true) {
        final responseData = jsonDecode(response.body);
        await BaseClient.storeTokens(
          accessToken: responseData['access_token'],
          refreshToken: responseData['refresh'],
        );
        navigateToCreatePassword();
      } else {
        isFirstTime ? Get.offAll(() => DashboardView()) : navigateToLogin();
      }
    } else if (response.statusCode == 400) {
      _showWarning('Please provide correct OTP', title: 'Invalid OTP');
    } else {
      //await BaseClient.handleResponse(response);
    }
  }

  Future<bool> resendCode() async {
    isLoading.value = true;
    try {
      final body = jsonEncode({
        ..._getBasicAuthBody(email: emailController.text),
        'type': 'email',
      });

      final response = await BaseClient.postRequest(
        api: Api.resendOtp,
        body: body,
        headers: BaseClient.basicHeaders,
      );

      return await _handleResendCodeResponse(response);
    } catch (e) {
      print('Resend code error: $e');
      _showWarning('Failed to resend code. Please try again.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _handleResendCodeResponse(dynamic response) async {
    if (response.statusCode == 200) {
      kSnackBar(
        title: 'Success',
        message: resetMethod.value == ResetMethod.email
            ? 'Verification code resent to your email!'
            : 'Verification code resent to your phone!',
      );
      return true;
    } else if (response.statusCode == 404) {
      _showWarning('User does not exist');
      return false;
    } else {
      //await BaseClient.handleResponse(response);
      return false;
    }
  }

  Future<void> createNewPassword() async {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (!_validatePassword(password)) {
      return _showWarning('Password must be at least $_minPasswordLength characters long');
    }

    if (password != confirmPassword) {
      return _showWarning('Passwords do not match');
    }

    isLoading.value = true;
    try {
      final body = jsonEncode({'new_password': password});
      final response = await BaseClient.postRequest(
        api: Api.resetPassword,
        body: body,
        headers: BaseClient.authHeaders(),
      );

      await _handleCreateNewPasswordResponse(response, password);
    } catch (e) {
      print('Create password error: $e');
      _showWarning('Failed to update password. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleCreateNewPasswordResponse(dynamic response, String password) async {
    if (response.statusCode >= _successStatusLower && response.statusCode <= _successStatusUpper) {
      kSnackBar(title: 'Success', message: 'Password updated successfully!');
      navigateToLogin();
    } else if (response.statusCode == 404) {
      _showWarning('User does not exist');
    } else {
      final body = jsonEncode({'new_password': password});
      await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.resetPassword,
          body: body,
          headers: BaseClient.authHeaders(),
        ),
      );

      // If handleResponse succeeds (e.g., after token refresh and retry), treat as success
      kSnackBar(title: 'Success', message: 'Password updated successfully!');
      navigateToLogin();
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      kSnackBar(title: 'Success', message: 'Signed in with Google successfully!');
      clearForm();
    } catch (e) {
      print('Google sign-in error: $e');
      _showWarning('Failed to sign in with Google. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithFacebook() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      kSnackBar(title: 'Success', message: 'Signed in with Facebook successfully!');
      clearForm();
    } catch (e) {
      print('Facebook sign-in error: $e');
      _showWarning('Failed to sign in with Facebook. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // UI Feedback
  void _showWarning(String message, {String title = 'Warning'}) {
    kSnackBar(
      title: title,
      message: message,
      bgColor: AppColors.snackBarWarning,
    );
  }

  // Cleanup
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    phoneController.clear();
    verificationCodeControllers.forEach((controller) => controller.clear());
    isTermsAccepted.value = false;
    isRememberMe.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    verificationCodeControllers.forEach((controller) => controller.dispose());
    super.onClose();
  }
}