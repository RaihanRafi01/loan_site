import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/Get.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';
import '../controllers/message_controller.dart';
import 'create_group_view.dart';
import 'message_view.dart';

// Model to represent a room
class Room {
  final int id;
  final String imageUrl;
  final String name;
  RxBool isChecked;

  Room({
    required this.id,
    required this.imageUrl,
    required this.name,
    bool isChecked = false,
  }) : isChecked = isChecked.obs;
}

class SharePostController extends GetxController {
  // List of rooms with their checkbox states
  RxList<Room> rooms = <Room>[].obs;
  // Filtered list for search functionality
  RxList<Room> filteredRooms = <Room>[].obs;
  // Search controller for the text field
  final TextEditingController searchController = TextEditingController();

  // Initialize rooms and set up search listener
  @override
  void onInit() {
    super.onInit();
    fetchRooms();
    // Initialize filteredRooms with all rooms
    filteredRooms.assignAll(rooms);
    // Update filteredRooms when search input changes
    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      filteredRooms.assignAll(
        rooms.where((r) => r.name.toLowerCase().contains(query)).toList(),
      );
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fetch rooms from MessageController
  Future<void> fetchRooms() async {
    final messageController = Get.find<MessageController>();
    await messageController.fetchChatRooms();
    final currentUserId = messageController.getCurrentUserId();
    if (currentUserId == null) {
      Get.snackbar(
        'Error',
        'Failed to get current user ID',
        backgroundColor: AppColors.snackBarWarning,
      );
      return;
    }
    rooms.value = messageController.allChatRooms.map((room) {
      final roomType = room['room_type'] as String;
      final roomId = room['id'] as int;
      String name = '';
      String imageUrl = '';
      if (roomType == 'direct') {
        final participants = room['participants'] as List? ?? [];
        final otherParticipant = participants.firstWhere(
              (p) => p['id'] != currentUserId,
          orElse: () => <String, dynamic>{},
        );
        name = otherParticipant['name'] as String? ?? 'Unknown';
        imageUrl = otherParticipant['image'] != null && otherParticipant['image'].toString().isNotEmpty
            ? '${otherParticipant['image']}'
            : '';
      } else if (roomType == 'group') {
        name = room['name'] as String? ?? 'Unnamed Group';
        imageUrl = room['image'] != null && room['image'].toString().isNotEmpty
            ? '$baseUrl${room['image']}'
            : '';
      }
      return Room(
        id: roomId,
        name: name,
        imageUrl: imageUrl,
      );
    }).toList();
    filteredRooms.assignAll(rooms); // Update filtered list after fetching
  }

  // Method to toggle the checkbox state for a specific room
  void toggleCheck(int index) {
    rooms[index].isChecked.value = !rooms[index].isChecked.value;
    // Update filteredRooms to reflect the change
    filteredRooms.assignAll(
      rooms.where((r) => r.name.toLowerCase().contains(searchController.text.toLowerCase())).toList(),
    );
  }

  Future<void> sharePost(int postId) async {
    final selected = rooms.where((r) => r.isChecked.value).toList();
    if (selected.isEmpty) {
      Get.snackbar(
        'Error',
        'Select at least one room to share with',
        backgroundColor: AppColors.snackBarWarning,
      );
      return;
    }
    final messageController = Get.find<MessageController>();
    for (var room in selected) {
      messageController.currentRoomId.value = room.id;
      messageController.sendMessage('postShareUniqueKey001 $postId', 'text');
    }
    Get.snackbar(
      'Success',
      'Post shared with selected rooms',
    );
    // Reset checks
    for (var r in selected) {
      r.isChecked.value = false;
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
                      controller.sharePost(postId);
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
                labelText: 'Search rooms',
                controller: controller.searchController,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() => controller.filteredRooms.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  children: List.generate(
                    controller.filteredRooms.length,
                        (index) => GroupHeaderWidget(
                      imageUrl: controller.filteredRooms[index].imageUrl,
                      title: controller.filteredRooms[index].name,
                      isChecked: controller.filteredRooms[index].isChecked,
                      onCheckTap: () => controller.toggleCheck(
                        controller.rooms.indexOf(controller.filteredRooms[index]),
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