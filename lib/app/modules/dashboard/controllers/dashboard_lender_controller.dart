import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import 'package:loan_site/common/appColors.dart';

import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class DashboardLenderController extends GetxController {
  var selectedIndex = 0.obs;

  // Reactive variables to store profile data
  final name = RxString('');
  final email = RxString('');
  final phone = RxString('');
  final profileImageUrl = RxString('');


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
      phone.value = result['phone'] ?? '';
      // Prepend base URL to image if it's a relative path
      final imageUrl = result['image'] ?? '';
      profileImageUrl.value = imageUrl.startsWith('http')
          ? imageUrl
          : imageUrl.isNotEmpty
          ? '${Api.baseUrlPicture}$imageUrl'
          : '';
    } catch (e) {
      kSnackBar(
        title: 'Warning',
        message: e.toString(),
        bgColor: AppColors.snackBarWarning,
      );
    }
  }


  Future<Map<String, dynamic>> fetchOverviewData() async {
    try {
      final response = await BaseClient.getRequest(
        api: Api.getLenderDashboardData, // Assuming an API constant for overview endpoint
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getLenderDashboardData,
          headers: BaseClient.authHeaders(),
        ),
      );
      return result;
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchProjectsData() async {
    try {
      final response = await BaseClient.getRequest(
        api: Api.getLenderProjects, // Assuming an API constant for projects endpoint
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getLenderProjects,
          headers: BaseClient.authHeaders(),
        ),
      );
      return result;
    } catch (e) {
      return {'results': []};
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