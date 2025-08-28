import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../common/appColors.dart';
import '../../common/widgets/custom_snackbar.dart';
import 'api.dart';

class BaseClient {
  static const _storage = FlutterSecureStorage();

  // Store tokens in secure storage
  static Future<void> storeTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    print('access =======================>>>>>>>>>>>>> $accessToken  \n refresh =======================>>>>>>>>>>>>> refreshToken ');
  }

  // Retrieve access token from secure storage
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Retrieve refresh token from secure storage
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // Clear tokens from secure storage (e.g., on logout)
  static Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    print('DELETE=======================>>>>>>>>>>>>>');
  }

  static Future<Map<String, String>> authHeaders() async {
    String? token = await getAccessToken();
    print('getAccessToken =======================>>>>>>>>>>>>> $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  static Future<Map<String, String>> get basicHeaders async => {
    'Content-Type': 'application/json',
  };

  static Future<http.Response> getRequest({
    required String api,
    Map<String, String>? params,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    final resolvedHeaders = headers != null ? await headers : null;
    debugPrint("Header: $resolvedHeaders");

    try {
      http.Response response = await http.get(
        Uri.parse(api).replace(queryParameters: params),
        headers: resolvedHeaders,
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        kSnackBar(
          title: "Request Timeout",
          message: "The request took too long. Please check your connection and try again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw TimeoutException("Request timed out");
      });
      return response;
    } on SocketException {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    } catch (e) {
      kSnackBar(
        title: "Network Error",
        message: "A network error occurred. Please try again later.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    }
  }

  static Future<http.Response> postRequest({
    required String api,
    required String body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;

    try {
      http.Response response = await http.post(
        Uri.parse(api),
        body: body,
        headers: resolvedHeaders,
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        kSnackBar(
          title: "Request Timeout",
          message: "The request took too long. Please check your connection and try again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw TimeoutException("Request timed out");
      });
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Code: ${response.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Response: ${response.body}');
      return response;
    } on SocketException {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    } catch (e) {
      kSnackBar(
        title: "Network Error",
        message: "A network error occurred. Please try again later.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    }
  }

  static Future<http.Response> patchRequest({
    required String api,
    required String body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;

    try {
      http.Response response = await http.patch(
        Uri.parse(api),
        body: body,
        headers: resolvedHeaders,
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        kSnackBar(
          title: "Request Timeout",
          message: "The request took too long. Please check your connection and try again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw TimeoutException("Request timed out");
      });
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Code: ${response.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Response: ${response.body}');
      return response;
    } on SocketException {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    } catch (e) {
      kSnackBar(
        title: "Network Error",
        message: "A network error occurred. Please try again later.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    }
  }

  static Future<http.Response> putRequest({
    required String api,
    required String body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;

    try {
      http.Response response = await http.put(
        Uri.parse(api),
        body: body,
        headers: resolvedHeaders,
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        kSnackBar(
          title: "Request Timeout",
          message: "The request took too long. Please check your connection and try again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw TimeoutException("Request timed out");
      });
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Code: ${response.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Response: ${response.body}');
      return response;
    } on SocketException {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    } catch (e) {
      kSnackBar(
        title: "Network Error",
        message: "A network error occurred. Please try again later.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    }
  }

  static Future<http.Response> multipartRequest({
    required String api,
    required Map<String, String> fields,
    File? image,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit (Multipart): $api");
    debugPrint("Fields: $fields");
    final resolvedHeaders = headers != null ? await headers : <String, String>{};

    try {
      var request = http.MultipartRequest('PUT', Uri.parse(api));
      request.headers.addAll(resolvedHeaders);
      request.fields.addAll(fields);
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }
      final response = await request.send().timeout(const Duration(seconds: 30), onTimeout: () {
        kSnackBar(
          title: "Request Timeout",
          message: "The request took too long. Please check your connection and try again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw TimeoutException("Request timed out");
      });
      final responseBody = await http.Response.fromStream(response);
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Code: ${responseBody.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Response: ${responseBody.body}');
      return responseBody;
    } on SocketException {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    } catch (e) {
      kSnackBar(
        title: "Network Error",
        message: "A network error occurred. Please try again later.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    }
  }

  static Future<http.Response> deleteRequest({
    required String api,
    String? body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;

    try {
      http.Response response = await http.delete(
        Uri.parse(api),
        headers: resolvedHeaders,
        body: body,
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        kSnackBar(
          title: "Request Timeout",
          message: "The request took too long. Please check your connection and try again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw TimeoutException("Request timed out");
      });
      return response;
    } on SocketException {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    } catch (e) {
      kSnackBar(
        title: "Network Error",
        message: "A network error occurred. Please try again later.",
        bgColor: AppColors.snackBarWarning,
      );
      rethrow;
    }
  }

  // Handle response with retry logic for 401 errors
  static Future<dynamic> handleResponse(http.Response response, {Future<http.Response> Function()? retryRequest}) async {
    try {
      debugPrint('💥💥💥💥💥💥💥💥💥💥 handleResponse 🚀 ➤➤➤ Code: ${response.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 handleResponse 🚀 ➤➤➤ Response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      } else if (response.statusCode == 401) {
        if (retryRequest == null) {
          kSnackBar(
            title: "Unauthorized",
            message: "Your session has expired. Please log in again.",
            bgColor: AppColors.snackBarWarning,
          );
          throw _extractErrorMessage(response, "Unauthorized");
        }
        // Attempt to refresh token and retry
        return await _refreshTokenAndRetry(response, retryRequest);
      } else if (response.statusCode == 404) {
        debugPrint('NotFoundResponse: ${response.body}');
        kSnackBar(
          title: "Not Found",
          message: "The requested resource was not found.",
          bgColor: AppColors.snackBarWarning,
        );
        throw "Resource not found";
      } else if (response.statusCode == 400) {
        debugPrint('BadRequestResponse: ${response.body}');
        kSnackBar(
          title: "Bad Request",
          message: _extractErrorMessage(response, "Invalid request data"),
          bgColor: AppColors.snackBarWarning,
        );
      } else if (response.statusCode == 403) {
        kSnackBar(
          title: "Forbidden",
          message: "You do not have permission to access this resource.",
          bgColor: AppColors.snackBarWarning,
        );
        throw "Forbidden";
      } else if (response.statusCode == 406) {
        kSnackBar(
          title: "Not Acceptable",
          message: "The request is not acceptable.",
          bgColor: AppColors.snackBarWarning,
        );
        throw "Not acceptable";
      } else if (response.statusCode == 409) {
        kSnackBar(
          title: "Conflict",
          message: "There was a conflict with the request.",
          bgColor: AppColors.snackBarWarning,
        );
        throw "Conflict";
      } else if (response.statusCode == 500) {
        kSnackBar(
          title: "Server Error",
          message: "A server error occurred. Please try again later.",
          bgColor: AppColors.snackBarWarning,
        );
        throw "Server Error";
      } else {
        debugPrint('ErrorCode: ${response.statusCode}');
        debugPrint('ErrorResponse: ${response.body}');
        kSnackBar(
          title: "Error",
          message: _extractErrorMessage(response, "Something went wrong"),
          bgColor: AppColors.snackBarWarning,
        );
        throw _extractErrorMessage(response, "Something went wrong");
      }
    } on SocketException catch (_) {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      throw "noInternetMessage";
    } on FormatException catch (e) {
      debugPrint('FormatException: $e');
      kSnackBar(
        title: "Bad Response",
        message: "The server response was not in the expected format.",
        bgColor: AppColors.snackBarWarning,
      );
      throw "Bad response format";
    } catch (e) {
      debugPrint('Error: $e');
      kSnackBar(
        title: "Error",
        message: "An unexpected error occurred. Please try again.",
        bgColor: AppColors.snackBarWarning,
      );
      throw e.toString();
    }
  }

  // Extract error message from response
  static String _extractErrorMessage(http.Response response, String defaultMessage) {
    if (response.body.isNotEmpty) {
      try {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          return data['errors'] is String ? data['errors'] : data['errors']['email']?[0] ?? defaultMessage;
        } else if (data['detail'] != null) {
          return data['detail'];
        }
        return data['message'] ?? defaultMessage;
      } catch (_) {
        return defaultMessage;
      }
    }
    return defaultMessage;
  }

  // Refresh token and retry the original request
  static Future<dynamic> _refreshTokenAndRetry(
      http.Response originalResponse,
      Future<http.Response> Function() retryRequest,
      ) async {
    try {
      final refreshToken = await getRefreshToken();
      final accessToken = await getAccessToken();

      if (refreshToken == null || accessToken == null) {
        kSnackBar(
          title: "Session Expired",
          message: "Please log in again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw "No refresh token available";
      }

      final body = jsonEncode({'refresh_token': refreshToken});

      debugPrint("Refreshing token with API: ${Api.createToken}");
      debugPrint("Refresh token body: $body");

      final response = await http.post(
        Uri.parse(Api.createToken),
        body: body,
        headers: await basicHeaders,
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        kSnackBar(
          title: "Request Timeout",
          message: "The request took too long. Please check your connection and try again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw TimeoutException("Request timed out");
      });

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        final responseData = jsonDecode(response.body);
        final newAccessToken = responseData['access_token'];
        if (newAccessToken != null) {
          await _storage.write(key: 'access_token', value: newAccessToken);
          debugPrint('New access token stored: $newAccessToken');
          // Retry the original request
          final retryResponse = await retryRequest();
          return await handleResponse(retryResponse, retryRequest: retryRequest);
        } else {
          kSnackBar(
            title: "Authentication Error",
            message: "Failed to obtain new access token.",
            bgColor: AppColors.snackBarWarning,
          );
          throw "No access token in refresh response";
        }
      } else {
        debugPrint('Refresh token failed: ${response.statusCode}');
        kSnackBar(
          title: "Authentication Error",
          message: "Failed to refresh token. Please log in again.",
          bgColor: AppColors.snackBarWarning,
        );
        throw "Failed to refresh token";
      }
    } on SocketException {
      kSnackBar(
        title: "No Internet",
        message: "Please check your internet connection and try again.",
        bgColor: AppColors.snackBarWarning,
      );
      throw "Unable to refresh token please try again later";
    } catch (e) {
      debugPrint('Refresh token error: $e');
      kSnackBar(
        title: "Authentication Error",
        message: "Unable to refresh token. Please try again later.",
        bgColor: AppColors.snackBarWarning,
      );
      throw "Unable to refresh token please try again later";
    }
  }

  static void logout() {
    clearTokens();
  }
}