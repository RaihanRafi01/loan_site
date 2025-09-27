import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import 'package:loan_site/common/widgets/custom_snackbar.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/message_controller.dart';
import 'message_view.dart';

const String mediaBaseUrl = Api.baseUrlPicture;

// Model to represent a user
class User {
  final int id;
  final String imageUrl;
  final String name;
  RxBool isChecked;

  User({
    required this.id,
    required this.imageUrl,
    required this.name,
    bool isChecked = false,
  }) : isChecked = isChecked.obs;
}

class CreateGroupController extends GetxController {
  final int? recipientId;
  RxList<User> users = <User>[].obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  CreateGroupController({this.recipientId});

  int? getCurrentUserId() {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    final userId = dashboardController.userId.value;
    developer.log('CURRENT USER ID: $userId', name: 'CreateGroupController');
    return userId;
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    super.onClose();
  }

  Future<void> fetchUsers() async {
    try {
      developer.log(
        'Fetching users for group creation...',
        name: 'CreateGroupController',
      );
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
      final currentUserId = getCurrentUserId();
      users.value = result
          .asMap()
          .entries
          .where((entry) {
            final u = Map<String, dynamic>.from(entry.value);
            final id = u['id'] as int;
            return id != currentUserId; // Exclude current user
          })
          .map((entry) {
            final u = Map<String, dynamic>.from(entry.value);
            final id = u['id'] as int;
            final checked = recipientId != null && recipientId == id;
            return User(
              id: id,
              name: u['name']?.toString().isNotEmpty == true
                  ? u['name'].toString()
                  : (u['email']?.toString() ?? 'Unknown'),
              imageUrl: u['image'] != null && u['image'].toString().isNotEmpty
                  ? '$mediaBaseUrl${u['image']}'
                  : '',
              isChecked: checked,
            );
          })
          .toList();
      developer.log(
        'Users fetched: ${users.length} users',
        name: 'CreateGroupController',
      );
    } catch (e) {
      developer.log(
        'Failed to fetch users: $e',
        name: 'CreateGroupController',
        error: e,
      );
      kSnackBar(
        title: 'Error',
        message: 'Failed to fetch users: $e',
        bgColor: AppColors.snackBarWarning,
      );
      users.value = [];
    }
  }

  // Method to toggle the checkbox state for a specific user
  void toggleCheck(int index) {
    users[index].isChecked.value = !users[index].isChecked.value;
  }

  Future<void> createGroup() async {
    if (nameController.text.trim().isEmpty) {
      kSnackBar(
        title: 'Warning',
        message: 'Group name is required',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    final currentUserId = getCurrentUserId();
    if (currentUserId == null) {
      kSnackBar(
        title: 'Warning',
        message: 'Unable to retrieve current user ID',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    // Use a Set to ensure unique participant IDs
    final Set<int> participantIds = {currentUserId};
    if (recipientId != null) {
      participantIds.add(recipientId!);
    }
    for (final user in users) {
      if (user.isChecked.value) {
        participantIds.add(user.id);
      }
    }

    if (participantIds.length < 2) {
      kSnackBar(
        title: 'Error',
        message: 'Select at least one participant',
        bgColor: AppColors.snackBarWarning,
      );
      return;
    }

    try {
      final participantIdsList = participantIds.toList();
      developer.log(
        'Creating group with participants: $participantIdsList',
        name: 'CreateGroupController',
      );
      final body = {
        'name': nameController.text.trim(),
        'room_type': 'group',
        'description': 'description',
        'participant_ids': participantIdsList,
      };
      final response = await BaseClient.postRequest(
        api: Api.createGroup,
        headers: BaseClient.authHeaders(),
        body: jsonEncode(body),
      );

      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.postRequest(
          api: Api.createGroup,
          headers: BaseClient.authHeaders(),
          body: jsonEncode(body),
        ),
      );

      // Show success snackbar and delay navigation
      kSnackBar(
        title: 'Success',
        message: 'Group created successfully',
        duration: const Duration(seconds: 2), // Optional: Set duration for snackbar
      );

      final messageController = Get.find<MessageController>();
      await messageController.fetchChatRooms();
      Get.to(MessageView());
    } catch (e) {
      developer.log(
        'Failed to create group: $e',
        name: 'CreateGroupController',
        error: e,
      );
      kSnackBar(
        title: 'Error',
        message: 'Failed to create group: $e',
        bgColor: AppColors.snackBarWarning,
      );
    }
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
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                backgroundColor: imageUrl.isEmpty
                    ? AppColors.appColor2.withOpacity(0.2)
                    : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: 32, color: AppColors.appColor2)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
            ],
          ),
          GestureDetector(
            onTap: onCheckTap,
            child: Obx(
              () => Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChecked.value
                        ? AppColors.appColor2
                        : AppColors.gray11,
                    width: 1,
                  ),
                  color: isChecked.value
                      ? AppColors.appColor2
                      : Colors.transparent,
                ),
                child: isChecked.value
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateGroupView extends GetView<CreateGroupController> {
  final int? recipientId;

  const CreateGroupView({super.key, this.recipientId});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateGroupController(recipientId: recipientId));
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
                    child: SvgPicture.asset(
                      'assets/images/community/arrow_left.svg',
                    ),
                  ),
                  Text(
                    'Create Group',
                    style: h2.copyWith(
                      fontSize: 24,
                      color: AppColors.appColor2,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              Text('Group Name',style: h3.copyWith(color: AppColors.textColor,fontSize: 16),),
              CustomTextField(labelText: 'Provide a group name', controller: controller.nameController),
              const SizedBox(height: 16),
              const Text(
                'Select Participants',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(
                  () => controller.users.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: List.generate(
                            controller.users.length,
                            (index) => GroupHeaderWidget(
                              imageUrl: controller.users[index].imageUrl,
                              title: controller.users[index].name,
                              isChecked: controller.users[index].isChecked,
                              onCheckTap: () => controller.toggleCheck(index),
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.createGroup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor2,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Create Group',
                      style: h2.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
