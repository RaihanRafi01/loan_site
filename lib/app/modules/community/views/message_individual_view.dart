import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/create_group_view.dart';
import 'package:loan_site/app/modules/community/views/comments_view.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class MessageIndividualView extends GetView {
  final String name;
  final String message;
  final String avatar;

  const MessageIndividualView({
    super.key,
    required this.name,
    required this.message,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
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
                          onTap: ()=> Get.back(),
                          child: SvgPicture.asset('assets/images/community/arrow_left.svg')),
                      SizedBox(width: 16),
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(avatar),
                      ),
                      SizedBox(width: 16),
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
                        value: 'not_interested',
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
                      if (value == 'not_interested') {
                        Get.to(CreateGroupView());
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildChatBubble('Hi there', false),
                  _buildChatBubble('Hello', true),
                  _buildSharedPostBubble(7), // Mock shared post with postId 1 (replace with dynamic if needed)
                  _buildChatBubble(message, false), // The passed last message
                ],
              ),
            ),

            // Input and action buttons (fixed at the bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    // Camera button
                    SvgPicture.asset('assets/images/home/cam_icon.svg'),
                    const SizedBox(width: 8),
                    // Image/Gallery button
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
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: 'Type here...',
                                  border: InputBorder.none,
                                  hintStyle: h4.copyWith(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
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
                    SvgPicture.asset('assets/images/home/send_icon.svg'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isMe ? AppColors.appColor2 : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(msg),
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
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('Shared Post: Click to view'),
        ),
      ),
    );
  }
}