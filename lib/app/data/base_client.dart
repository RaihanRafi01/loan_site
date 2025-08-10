import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'api.dart'; // Assuming Api class contains refreshToken endpoint

class BaseClient {
  static const _storage = FlutterSecureStorage();

  // Store tokens in secure storage
  static Future<void> storeTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
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
  }

  static Future<Map<String, String>> authHeaders() async {
    String? token = await getAccessToken();
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

    http.Response response = await http.get(
      Uri.parse(api).replace(queryParameters: params),
      headers: resolvedHeaders,
    );
    return response;
  }

  static Future<http.Response> postRequest({
    required String api,
    required String body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;
    http.Response response = await http.post(
      Uri.parse(api),
      body: body,
      headers: resolvedHeaders,
    );
    debugPrint("<================= response statusCode ====== ${response.statusCode} ==========>");
    debugPrint("<================= response ====== ${response.body} ===========>");

    return response;
  }

  static Future<http.Response> patchRequest({
    required String api,
    required String body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;
    http.Response response = await http.patch(
      Uri.parse(api),
      body: body,
      headers: resolvedHeaders,
    );
    return response;
  }

  static Future<http.Response> putRequest({
    required String api,
    required String body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;
    http.Response response = await http.put(
      Uri.parse(api),
      body: body,
      headers: resolvedHeaders,
    );
    return response;
  }

  static Future<http.Response> deleteRequest({
    required String api,
    String? body,
    Future<Map<String, String>>? headers,
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;
    http.Response response = await http.delete(
      Uri.parse(api),
      headers: resolvedHeaders,
      body: body,
    );
    return response;
  }

  // Handle response with retry logic for 401 errors
  static Future<dynamic> handleResponse(http.Response response, {Future<http.Response> Function()? retryRequest}) async {
    try {
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Code: ${response.statusCode}');
      debugPrint('💥💥💥💥💥💥💥💥💥💥 🚀 ➤➤➤ Response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode <= 210) {

        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      } else if (response.statusCode == 401) {
        if (retryRequest == null) {
          throw _extractErrorMessage(response, "Unauthorized");
        }
        // Attempt to refresh token and retry
        return await _refreshTokenAndRetry(response, retryRequest);
      } else if (response.statusCode == 404) {
        debugPrint('NotFoundResponse: ${response.body}');
        throw "Resource not found";
      } else if (response.statusCode == 400) {
        debugPrint('BadRequestResponse: ${response.body}');
      } else if (response.statusCode == 403) {
        throw "Forbidden";
      } else if (response.statusCode == 406) {
        throw "Not acceptable";
      } else if (response.statusCode == 409) {
        throw "Conflict";
      } else if (response.statusCode == 500) {
        throw "Server Error";
      } else {
        debugPrint('ErrorCode: ${response.statusCode}');
        debugPrint('ErrorResponse: ${response.body}');
        throw _extractErrorMessage(response, "Something went wrong");
      }
    } on SocketException catch (_) {
      throw "noInternetMessage";
    } on FormatException catch (e) {
      debugPrint('FormatException: $e');
      throw "Bad response format";
    } catch (e) {
      debugPrint('Error: $e');
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
        throw "No refresh token available";
      }

      final body = jsonEncode({'refresh_token': refreshToken});


      debugPrint("Refreshing token with API: ${Api.createToken}");
      debugPrint("Refresh token body: $body");

      final response = await http.post(
        Uri.parse(Api.createToken), // Assuming Api.refreshToken is defined
        body: body,
        headers: await basicHeaders,
      );

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
          throw "No access token in refresh response";
        }
      } else {
        debugPrint('Refresh token failed: ${response.statusCode}');
        throw "Failed to refresh token";
      }
    } catch (e) {
      debugPrint('Refresh token error: $e');
      throw "Unable to refresh token please try again later";
    }
  }

  static void logout() {
    clearTokens();
  }
}