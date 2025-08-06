import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
    Future<Map<String, String>>? headers, // Updated to accept Future
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
    Future<Map<String, String>>? headers, // Updated to accept Future
  }) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    final resolvedHeaders = headers != null ? await headers : null;
    http.Response response = await http.post(
      Uri.parse(api),
      body: body,
      headers: resolvedHeaders,
    );
    debugPrint("<================= response statusCode ====== ${response.statusCode} ===========>");
    debugPrint("<================= response ====== ${response.body} ===========>");

    return response;
  }

  static Future<http.Response> patchRequest({
    required String api,
    required String body,
    Future<Map<String, String>>? headers, // Updated to accept Future
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
    Future<Map<String, String>>? headers, // Updated to accept Future
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
    Future<Map<String, String>>? headers, // Updated to accept Future
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

  // Rest of the class (handleResponse, logout) remains unchanged
  static Future<dynamic> handleResponse(http.Response response) async {
    try {
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        debugPrint('SuccessCode: ${response.statusCode}');
        debugPrint('SuccessResponse: ${response.body}');

        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      } else if (response.statusCode == 401) {
        String msg = "Unauthorized";
        if (response.body.isNotEmpty) {
          if (json.decode(response.body)['errors'] != null) {
            msg = json.decode(response.body)['errors'];
          }
        }
        throw msg;
      } else if (response.statusCode == 404) {
        print(response.body);
      } else if (response.statusCode == 400) {
        debugPrint('Response: ${response.body}');
      } else if (response.statusCode == 403) {
      } else if (response.statusCode == 406) {
      } else if (response.statusCode == 409) {
      } else if (response.statusCode == 500) {
        throw "Server Error";
      } else {
        debugPrint('ErrorCode: ${response.statusCode}');
        debugPrint('ErrorResponse: ${response.body}');

        String msg = "Something went wrong";
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body)['errors'];
          if (data == null) {
            msg = jsonDecode(response.body)['message'] ?? msg;
          } else if (data is String) {
            msg = data;
          } else if (data is Map) {
            msg = data['email'][0];
          }
        }
        throw msg;
      }
    } on SocketException catch (_) {
      throw "noInternetMessage";
    } on FormatException catch (e) {
      print(e);
      throw "Bad response format";
    } catch (e) {
      throw e.toString();
    }
  }

  static void logout() {
    clearTokens();
  }
}