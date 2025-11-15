import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import 'package:loan_site/common/appColors.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import 'package:http/http.dart' as http;

class DashboardLenderController extends GetxController {
  var selectedIndex = 0.obs;

  // Reactive variables to store profile data
  /*final name = RxString('');
  final email = RxString('');
  final phone = RxString('');
  final profileImageUrl = RxString('');*/

  // Reactive variables for pagination
  final projectList = <Map<String, dynamic>>[].obs;
  final nextUrl = RxString('');
  final isLoadingMore = false.obs;
  final hasMoreProjects = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjectsData(); // Fetch initial projects
  }

  Future<Map<String, dynamic>> fetchOverviewData() async {
    try {
      Future<http.Response> makeRequest() async {
        return await BaseClient.getRequest(
          api: Api.getLenderDashboardData,
          headers: BaseClient.authHeaders(),
        );
      }
      final response = await makeRequest();
      final result = await BaseClient.handleResponse(response, retryRequest: makeRequest);
      return result is Map<String, dynamic> ? result : {};
    } catch (e) {
      print('Fetch overview error: $e');
      kSnackBar(
        title: 'Warning',
        message: 'Failed to load overview: $e',
        bgColor: AppColors.snackBarWarning,
      );
      return {};
    }
  }

  Future<void> fetchProjectsData({bool isLoadMore = false}) async {
    if (isLoadMore && (!hasMoreProjects.value || isLoadingMore.value)) return;

    try {
      isLoadingMore.value = true;

      // Dynamic closure: Uses fresh state each retry, forces HTTPS
      Future<http.Response> makeRequest() async {
        String url = isLoadMore ? nextUrl.value : Api.getLenderProjects;
        return await BaseClient.getRequest(
          api: url,
          headers: BaseClient.authHeaders(),  // Fresh headers each time
        );
      }

      final response = await makeRequest();
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: makeRequest,  // Will retry with fresh URL/headers
      );

      // Ensure result is a Map
      if (result is Map<String, dynamic>) {
        final List<dynamic> results = result['results'] ?? [];
        final newProjects = results.cast<Map<String, dynamic>>();  // Safe cast

        if (isLoadMore) {
          projectList.addAll(newProjects);
        } else {
          projectList.assignAll(newProjects);
        }

        // Normalize next URL to HTTPS
        String newNextUrl = result['next'] ?? '';
        nextUrl.value = newNextUrl;
        hasMoreProjects.value = result['next'] != null;
      } else {
        kSnackBar(
          title: 'Warning',
          message: 'Unexpected response format. Data is not a Map.',
          bgColor: AppColors.snackBarWarning,
        );
      }
    } catch (e) {
      print('Fetch projects error: $e');  // For debugging
      /*kSnackBar(
        title: 'Warning',
        message: 'Failed to load projects: $e',
        bgColor: AppColors.snackBarWarning,
      );*/
      if (!isLoadMore) {
        projectList.clear();
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  String formatLoanValue(dynamic value) {
    if (value == null) return '0';
    double loanValue = value is int ? value.toDouble() : value;
    if (loanValue >= 1000000) {
      return '${(loanValue / 1000000).toStringAsFixed(1)}M';
    } else if (loanValue >= 1000) {
      return '${(loanValue / 1000).toStringAsFixed(1)}K';
    }
    return loanValue.toStringAsFixed(0);
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'On Going':
        return AppColors.textYellow;
      case 'Delayed':
        return AppColors.lenderRed;
      case 'Completed':
        return AppColors.clrGreen;
      default:
        return AppColors.textYellow;
    }
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}