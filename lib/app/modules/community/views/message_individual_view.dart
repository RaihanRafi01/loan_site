import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loan_site/app/modules/community/controllers/message_controller.dart';
import 'package:loan_site/app/modules/community/views/create_group_view.dart';
import 'package:loan_site/app/modules/community/views/comments_view.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';

class MessageIndividualView extends GetView<MessageController> {
  final String name;
  final String message;
  final String avatar;
  final int roomId;

  const MessageIndividualView({
    super.key,
    required this.name,
    required this.message,
    required this.avatar,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            // Profile section (fixed at the top)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display Avatar and Name
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset(
                          'assets/images/community/arrow_left.svg',
                        ),
                      ),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(avatar),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  DropdownButton2<String>(
                    underline: Container(),
                    customButton: SvgPicture.asset(
                      'assets/images/community/three_dot_icon.svg',
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'create_group',
                        child: Text(
                          'Create group with',
                          style: h4.copyWith(
                            color: AppColors.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'create_group') {
                        Get.to(() => CreateGroupView());
                      }
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: 170,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      elevation: 8,
                      offset: const Offset(0, -10),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable body content
            Expanded(
              child: Obx(() {
                final roomMessages = controller.messages
                    .where((msg) => msg['chat_room'] == roomId)
                    .toList();
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: roomMessages.length,
                  itemBuilder: (context, index) {
                    final msg = roomMessages[index];
                    final isMe = msg['sender']['id'] == _getCurrentUserId();
                    if (msg['message_type'] == 'post') {
                      return _buildSharedPostBubble(msg['post_id'] ?? 0);
                    }
                    return _buildChatBubble(
                      msg['content'] ?? '',
                      isMe,
                      _formatTime(msg['created_at'] ?? ''),
                    );
                  },
                );
              }),
            ),

            // Input and action buttons (fixed at the bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    // Camera button (placeholder)
                    SvgPicture.asset('assets/images/home/cam_icon.svg'),
                    const SizedBox(width: 8),
                    // Image/Gallery button (placeholder)
                    SvgPicture.asset('assets/images/home/image_icon.svg'),
                    const SizedBox(width: 12),
                    // Text input field with mic icon
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.chatInput,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: 'Type here...',
                                  border: InputBorder.none,
                                  hintStyle: h4.copyWith(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            SvgPicture.asset('assets/images/home/mic_icon.svg'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Send button
                    GestureDetector(
                      onTap: () {
                        if (textController.text.trim().isNotEmpty) {
                          controller.sendMessage(
                            textController.text.trim(),
                            'text',
                          );
                          textController.clear();
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/images/home/send_icon.svg',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String msg, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isMe ? AppColors.appColor2 : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg,
              style: h4.copyWith(
                fontSize: 16,
                color: isMe ? Colors.white : AppColors.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: h4.copyWith(
                fontSize: 12,
                color: isMe ? Colors.white70 : AppColors.textColor8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedPostBubble(int postId) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Get.to(() => CommentsView(postId: postId));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Shared Post: Click to view',
            style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
          ),
        ),
      ),
    );
  }

  String _formatTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return 'Unknown';
    }
  }

  int _getCurrentUserId() {
    // Replace with actual logic to get current user ID
    // Example: return BaseClient.getCurrentUserId();
    return 6; // Placeholder (based on logs, user ID 6 is "holaaa")
  }
}
