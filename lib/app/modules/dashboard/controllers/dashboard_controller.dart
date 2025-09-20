import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/controllers/message_controller.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import 'package:loan_site/common/appColors.dart';

import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  // Reactive variables to store profile data
  final userId = RxnInt();
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
      userId.value = result['id'] ?? '';
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

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}