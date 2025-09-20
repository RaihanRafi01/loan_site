import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../core/constants/api.dart';
import '../controllers/message_controller.dart';
import 'groupChat_view.dart';
import 'message_individual_view.dart';

// Define baseUrl for images
const String baseUrl = Api.baseUrlPicture;

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        backgroundColor: AppColors.appBc,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Message',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab Navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTabItem('All', 0),
                _buildTabItem('Group', 1),
                _buildTabItem('Active', 2),
              ],
            ),
          ),

          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardSky,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search here',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Trigger UI rebuild by updating an observable
                      controller.selectedTabIndex.refresh();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: Obx(() => _buildMessagesForTab(
                _getTabName(controller.selectedTabIndex.value), searchController.text)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return Expanded(
      child: Obx(() => GestureDetector(
        onTap: () => controller.selectTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: controller.selectedTabIndex.value == index
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: controller.selectedTabIndex.value == index
                      ? AppColors.textColor
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: controller.selectedTabIndex.value == index
                      ? Colors.blue
                      : Colors.grey[300],
                  borderRadius: BorderRadius.horizontal(
                    left: index == 0 ? const Radius.circular(4) : Radius.zero,
                    right: index == 2 ? const Radius.circular(4) : Radius.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'All';
      case 1:
        return 'Group';
      case 2:
        return 'Active';
      default:
        return 'All';
    }
  }

  Widget _buildMessagesForTab(String tab, String searchQuery) {
    return Obx(() {
      final int? currentUserId = controller.getCurrentUserId();
      if (currentUserId == null) {
        return const Center(child: Text('Unable to load user ID'));
      }

      List<Widget> items = _getMessagesForTab(tab, searchQuery);
      if (items.isEmpty) {
        return const Center(child: Text('No chats available'));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      );
    });
  }

  List<Widget> _getMessagesForTab(String tab, String searchQuery) {
    final int? currentUserId = controller.getCurrentUserId();
    if (currentUserId == null) {
      return [const Text('Unable to load user ID')];
    }

    final query = searchQuery.toLowerCase().trim();

    switch (tab) {
      case 'All':
        return controller.allChatRooms
            .where((room) {
          if (query.isEmpty) return true;
          final name = room['room_type'] == 'group'
              ? (room['name'] as String? ?? '').toLowerCase()
              : (room['participants'] as List? ?? [])
              .firstWhere((p) => p['id'] != currentUserId,
              orElse: () => <String, dynamic>{})['name']
              ?.toLowerCase() ??
              '';
          return name.contains(query);
        })
            .map<Widget>((room) => _buildMessageItem(room, currentUserId))
            .toList();
      case 'Group':
        return controller.allChatRooms
            .where((room) =>
        room['room_type'] == 'group' &&
            (query.isEmpty || (room['name'] as String? ?? '').toLowerCase().contains(query)))
            .map<Widget>((room) => _buildMessageItem(room, currentUserId))
            .toList();
      case 'Active':
        return controller.activeUsers
            .where((userData) => query.isEmpty ||
            (userData['user']['name'] as String? ?? '').toLowerCase().contains(query))
            .map<Widget>((userData) {
          final user = userData['user'];
          final name = user['name'] as String? ?? 'Unknown';
          final userId = user['id'] as int;
          final avatar = _resolveImageUrl(user['image'] as String?);
          final lastSeen = userData['last_seen'] as String;
          final time = _formatTime(lastSeen);
          final unreadCount = _getUnreadCountForUser(userId);
          return _buildMessageItemForActive(
            name: name,
            unreadCount: unreadCount,
            time: time,
            avatar: avatar,
            type: 'active',
            userId: userId,
          );
        })
            .toList();
      default:
        return [];
    }
  }

  int _getUnreadCountForUser(int userId) {
    final room = controller.allChatRooms.firstWhere(
          (room) {
        final participants = room['participants'] as List? ?? [];
        return room['room_type'] == 'direct' &&
            participants.any((p) => p['id'] == userId);
      },
      orElse: () => {},
    );
    if (room.isEmpty) return 0;
    return room['unread_count'] as int? ?? 0;
  }

  String _resolveImageUrl(String? image) {
    if (image == null || image.isEmpty) {
      return '';
    }
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }
    return '$baseUrl$image';
  }

  Widget _buildMessageItem(Map<String, dynamic> room, int currentUserId) {
    final String roomType = room['room_type'] as String;
    final int roomId = room['id'] as int;
    final List participants = room['participants'] as List? ?? [];
    final int unreadCount = room['unread_count'] as int? ?? 0;
    String name = '';
    String avatar = '';
    List<String>? groupAvatars;
    String message = unreadCount > 0 ? '$unreadCount unread messages' : 'No unread messages';
    String time = _formatTime(room['updated_at'] as String? ?? '');
    int recipientId = 0;

    if (roomType == 'direct') {
      final otherParticipant = participants.firstWhere(
            (p) => p['id'] != currentUserId,
        orElse: () => <String, dynamic>{},
      );
      name = otherParticipant['name'] as String? ?? 'Unknown';
      avatar = _resolveImageUrl(otherParticipant['image'] as String?);
      recipientId = otherParticipant['id'] as int? ?? 0;
    } else if (roomType == 'group') {
      name = room['name'] as String? ?? 'Unnamed Group';
      avatar = _resolveImageUrl(room['image'] as String?);
      groupAvatars = participants.take(2).map<String>((p) {
        return _resolveImageUrl(p['image'] as String?);
      }).toList();
    }

    return GestureDetector(
      onTap: () async {
        if (roomType == 'group') {
          Get.to(() => GroupChatView(
            groupName: name,
            roomId: roomId,
            participants: List<Map<String, dynamic>>.from(participants),
          ));
        } else {
          Get.to(() => MessageIndividualView(
            name: name,
            message: message,
            avatar: avatar,
            roomId: roomId,
            recipientId: recipientId,
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAvatar(roomType, avatar, groupAvatars),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: h2.copyWith(
                          fontSize: 20,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        time,
                        style: h4.copyWith(
                          fontSize: 14,
                          color: AppColors.textColor8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItemForActive({
    required String name,
    required int unreadCount,
    required String time,
    required String avatar,
    required String type,
    required int userId,
  }) {
    return GestureDetector(
      onTap: () async {
        final createdRoomId = await controller.createChatRoom(userId);
        if (createdRoomId != null) {
          Get.to(() => MessageIndividualView(
            name: name,
            message: unreadCount > 0 ? '$unreadCount unread messages' : 'No unread messages',
            avatar: avatar,
            roomId: createdRoomId,
            recipientId: userId,
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAvatar(type, avatar, null),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: h2.copyWith(
                          fontSize: 20,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        time,
                        style: h4.copyWith(
                          fontSize: 14,
                          color: AppColors.textColor8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    unreadCount > 0 ? '$unreadCount unread messages' : 'No unread messages',
                    style: h3.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAvatar(String type, String avatar, List<String>? groupAvatars) {
    switch (type) {
      case 'active':
        return Padding(
          padding: const EdgeInsets.only(bottom: 6, right: 6),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
              ),
              const Positioned(
                bottom: -3,
                right: -3,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'group':
        return SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: (groupAvatars?.isNotEmpty ?? false) && groupAvatars![0].isNotEmpty
                      ? NetworkImage(groupAvatars![0])
                      : null,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: (groupAvatars?.length ?? 0) > 1 && groupAvatars![1].isNotEmpty
                      ? NetworkImage(groupAvatars![1])
                      : null,
                ),
              ),
            ],
          ),
        );
      default:
        return CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
        );
    }
  }

  String _formatTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return 'Unknown';
    }
  }
}