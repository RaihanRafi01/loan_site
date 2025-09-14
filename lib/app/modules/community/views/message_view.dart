import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../core/constants/api.dart';
import '../controllers/message_controller.dart';
import 'message_individual_view.dart';

// Define baseUrl here or import it from a constants file
const String baseUrl = Api.baseUrlPicture; // Replace with your actual base URL

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MessageController());

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
                    decoration: InputDecoration(
                      hintText: 'Search here',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: Obx(() => _buildMessagesForTab(_getTabName(controller.selectedTabIndex.value))),
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
          )),
      ),
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

  Widget _buildMessagesForTab(String tab) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: _getMessagesForTab(tab),
    );
  }

  List<Widget> _getMessagesForTab(String tab) {
    switch (tab) {
      case 'All':
        return [
          _buildMessageItem(
            name: 'Jack',
            message: 'New Message',
            time: '6:01 PM',
            avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
            type: 'individual',
          ),
          _buildMessageItem(
            name: 'Development Team',
            message: 'John: Let\'s schedule the meeting',
            time: '5:45 PM',
            avatar: 'https://images.unsplash.com/photo-1494790108755-2616b2fb69ec?w=150&h=150&fit=crop&crop=face',
            type: 'group',
            groupAvatars: [
              'https://images.unsplash.com/photo-1494790108755-2616b2fb69ec?w=150&h=150&fit=crop&crop=face',
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
            ],
          ),
          _buildMessageItem(
            name: 'Marvin',
            message: 'Hey there!',
            time: '5:30 PM',
            avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
            type: 'active',
          ),
          _buildMessageItem(
            name: 'Henry',
            message: 'How are you doing?',
            time: '4:15 PM',
            avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
            type: 'individual',
          ),
          _buildMessageItem(
            name: 'Design Team',
            message: 'Sarah: New mockups ready',
            time: '3:45 PM',
            avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
            type: 'group',
            groupAvatars: [
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face',
            ],
          ),
          _buildMessageItem(
            name: 'Arthur',
            message: 'See you tomorrow',
            time: '2:20 PM',
            avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
            type: 'active',
          ),
        ];
      case 'Group':
        return [
          _buildMessageItem(
            name: 'Development Team',
            message: 'John: Let\'s schedule the meeting',
            time: '5:45 PM',
            avatar: 'https://images.unsplash.com/photo-1494790108755-2616b2fb69ec?w=150&h=150&fit=crop&crop=face',
            type: 'group',
            groupAvatars: [
              'https://images.unsplash.com/photo-1494790108755-2616b2fb69ec?w=150&h=150&fit=crop&crop=face',
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
            ],
          ),
          _buildMessageItem(
            name: 'Design Team',
            message: 'Sarah: New mockups ready',
            time: '3:45 PM',
            avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
            type: 'group',
            groupAvatars: [
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face',
            ],
          ),
          _buildMessageItem(
            name: 'Marketing Team',
            message: 'Mike: Campaign results are in',
            time: '1:30 PM',
            avatar: 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=150&h=150&fit=crop&crop=face',
            type: 'group',
            groupAvatars: [
              'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=150&h=150&fit=crop&crop=face',
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
            ],
          ),
        ];
      case 'Active':
        return controller.activeUsers.map<Widget>((userData) {
          final user = userData['user'];
          final name = user['name'] as String;
          final avatar = '$baseUrl${user['image']}' as String;
          final lastSeen = userData['last_seen'] as String;
          final time = _formatTime(lastSeen);
          final message = 'Active now'; // Placeholder
          return _buildMessageItem(
            name: name,
            message: message,
            time: time,
            avatar: avatar,
            type: 'active',
          );
        }).toList();
      default:
        return [];
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

  Widget _buildMessageItem({
    required String name,
    required String message,
    required String time,
    required String avatar,
    required String type,
    List<String>? groupAvatars,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MessageIndividualView(
          name: name,
          message: message,
          avatar: avatar,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar with different styles based on type
            buildAvatar(type, avatar, groupAvatars),
            const SizedBox(width: 12),

            // Message Content
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
                backgroundImage: NetworkImage(avatar),
              ),
              Positioned(
                bottom: -3,
                right: -3,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
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
                  backgroundImage: NetworkImage(groupAvatars?[0] ?? avatar),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(groupAvatars?[1] ?? avatar),
                ),
              ),
            ],
          ),
        );
      default:
        return CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          backgroundImage: NetworkImage(avatar),
        );
    }
  }
}