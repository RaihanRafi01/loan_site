import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/message_view.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class NotificationCommunityView extends GetView {
  const NotificationCommunityView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Notifications',
          style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMessageItem(
                name: 'Jack',
                message: 'react your post',
                time: '6:01 PM',
                avatar:
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
              ),
              _buildMessageItem(
                name: 'Marvin',
                message: 'commend on your post',
                time: '5:30 PM',
                avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
              ),
              _buildMessageItem(
                name: 'Henry',
                message: 'created a new post',
                time: '4:15 PM',
                avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem({
    required String name,
    required String message,
    required String time,
    required String avatar,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Avatar with different styles based on type
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(avatar),
          ),
          const SizedBox(width: 12),

          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: h2.copyWith(
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          message,
                          style: h4.copyWith(
                            fontSize: 16,
                            color: AppColors.textColor,
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
                          value: 'delete_notification',
                          child: Text(
                            'Delete this notifications',
                            style: h4.copyWith(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'turn_off_notification',
                          child: Text(
                            'Turn off notifications about this post',
                            style: h4.copyWith(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == 'delete_notification') {
                          //Get.to(CreateGroupView());
                        }
                        if (value == 'turn_off_notification') {
                          //Get.to(CreateGroupView());
                        }
                      },
                      dropdownStyleData: DropdownStyleData(
                        width: 300,
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
                const SizedBox(height: 4),
                Text(
                  time,
                  style: h4.copyWith(fontSize: 14, color: AppColors.textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
