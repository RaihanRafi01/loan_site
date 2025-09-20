import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import 'create_group_view.dart';
import 'message_view.dart';

// Model to represent a user
class User {
  final int? id; // Added for API compatibility
  final String imageUrl;
  final String name;
  RxBool isChecked;

  User({
    this.id,
    required this.imageUrl,
    required this.name,
    bool isChecked = false,
  }) : isChecked = isChecked.obs;
}

class SharePostController extends GetxController {
  // List of users with their checkbox states
  RxList<User> users = <User>[].obs;
  // Filtered list for search functionality
  RxList<User> filteredUsers = <User>[].obs;
  // Search controller for the text field
  final TextEditingController searchController = TextEditingController();

  // Initialize users and set up search listener
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    // Initialize filteredUsers with all users
    filteredUsers.assignAll(users);
    // Update filteredUsers when search input changes
    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      filteredUsers.assignAll(
        users.where((u) => u.name.toLowerCase().contains(query)).toList(),
      );
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fetch users from API (similar to CreateGroupView)
  Future<void> fetchUsers() async {
    try {
      final response = await BaseClient.getRequest(
        api: Api.getAllUsers,
        headers: BaseClient.authHeaders(),
      );
      final List result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getAllUsers,
          headers: BaseClient.authHeaders(),
        ),
      );
      users.value = result.map((u) => User(
        id: u['id'],
        name: u['name']?.toString().isNotEmpty == true
            ? u['name'].toString()
            : (u['email']?.toString() ?? 'Unknown'),
        imageUrl: u['image'] != null && u['image'].toString().isNotEmpty
            ? '$mediaBaseUrl${u['image']}'
            : '',
      )).toList();
      filteredUsers.assignAll(users); // Update filtered list after fetching
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch users: $e',
        backgroundColor: AppColors.snackBarWarning,
      );
      users.clear();
      filteredUsers.clear();
    }
  }

  // Method to toggle the checkbox state for a specific user
  void toggleCheck(int index) {
    users[index].isChecked.value = !users[index].isChecked.value;
    // Update filteredUsers to reflect the change
    filteredUsers.assignAll(users.where((u) => u.name.toLowerCase().contains(searchController.text.toLowerCase())).toList());
  }
}

class GroupHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final RxBool isChecked;
  final VoidCallback onCheckTap;

  const GroupHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isChecked,
    required this.onCheckTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                backgroundColor: imageUrl.isEmpty ? AppColors.appColor2.withOpacity(0.2) : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: 32, color: AppColors.appColor2)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: h2.copyWith(
                  fontSize: 20,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onCheckTap,
            child: Obx(() => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isChecked.value ? AppColors.appColor2 : AppColors.gray11,
                  width: 1,
                ),
                color: isChecked.value ? AppColors.appColor2 : Colors.transparent,
              ),
              child: isChecked.value
                  ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
                  : null,
            )),
          ),
        ],
      ),
    );
  }
}

class SharePostView extends GetView<SharePostController> {
  final int postId;

  const SharePostView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    Get.put(SharePostController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset('assets/images/community/arrow_left.svg'),
                  ),
                  Text(
                    'Share Post',
                    style: h2.copyWith(fontSize: 24, color: AppColors.appColor2),
                  ),
                  GestureDetector(
                    onTap: () {
                      List<User> selected = controller.users.where((u) => u.isChecked.value).toList();
                      if (selected.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Select at least one user to share with',
                          backgroundColor: AppColors.snackBarWarning,
                        );
                        return;
                      }
                      Get.snackbar(
                        'Post Shared',
                        'Shared with ${selected.map((u) => u.name).join(', ')}',
                      );
                    },
                    child: Text(
                      'Send',
                      style: h2.copyWith(fontSize: 24, color: AppColors.appColor2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Search users',
                controller: controller.searchController,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() => controller.filteredUsers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  children: List.generate(
                    controller.filteredUsers.length,
                        (index) => GroupHeaderWidget(
                      imageUrl: controller.filteredUsers[index].imageUrl,
                      title: controller.filteredUsers[index].name,
                      isChecked: controller.filteredUsers[index].isChecked,
                      onCheckTap: () => controller.toggleCheck(
                        controller.users.indexOf(controller.filteredUsers[index]),
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}