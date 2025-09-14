import 'package:get/get.dart';

import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class MessageController extends GetxController {
  var selectedTabIndex = 0.obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  RxList<Map<String, dynamic>> activeUsers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveUsers(); // Fetch on initialization
  }

  Future<void> fetchActiveUsers() async {
    try {
      final response = await BaseClient.getRequest( // Use getRequest for fetching
        api: Api.getActiveUsers, // Replace with your actual API endpoint for active users
        headers: BaseClient.authHeaders(),
      );
      final List result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getActiveUsers,
          headers: BaseClient.authHeaders(),
        ),
      );
      activeUsers.value = List<Map<String, dynamic>>.from(result);
      // Optional: Show success snackbar
      // kSnackBar(title: 'Success', message: 'Active users loaded');
    } catch (e) {
      // Optional: Handle error
      // kSnackBar(title: 'Warning', message: 'Failed to load active users: $e', bgColor: AppColors.snackBarWarning);
      activeUsers.value = []; // Fallback to empty list
    }
  }
}