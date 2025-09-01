import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/modules/community/views/message_view.dart';
import '../../../app/modules/community/views/notification_chat_view.dart';
import '../../../app/modules/community/views/own_profile_view.dart';
import '../../appColors.dart';
import '../../customFont.dart';

Widget buildDrawer() {
  return Drawer(
    backgroundColor: Colors.white,
    child: Column(
      children: [
        // Header Section with Profile
        GestureDetector(
          onTap: ()=> Get.to(const OwnProfileView()),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 43,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello Angelo!',
                          style: h2.copyWith(
                            fontSize: 24,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'zanlee@gmail.com',
                          style: h4.copyWith(
                            fontSize: 16,
                            color: AppColors.blurtext4,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Divider(color: AppColors.dividerClr),
        ),

        const SizedBox(height: 20),

        // Menu Items
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _buildDrawerItem(
                  svgPath: 'assets/images/community/home_icon.svg',
                  title: 'Home',
                  isSelected: true,
                  onTap: () => Get.back(),
                ),
                _buildDrawerItem(
                  svgPath: 'assets/images/community/message_icon.svg',
                  title: 'Message',
                  isSelected: false,
                  onTap: () => Get.to(() => const MessageView()),
                ),
                _buildDrawerItem(
                  svgPath: 'assets/images/community/notification_icon.svg',
                  title: 'Notification',
                  isSelected: false,
                  onTap: () => Get.to(() => const NotificationCommunityView()),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(bottom: 80, left: 20),
                  child: Column(
                    children: [
                      _buildContactItem(
                        svgPath: 'assets/images/community/call_icon.svg',
                        text: '+56994562587',
                      ),
                      const SizedBox(height: 12),
                      _buildContactItem(
                        svgPath: 'assets/images/community/mail_icon.svg',
                        text: 'angelo@gmail.com',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem({
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
  required String svgPath,
}) {
  return ListTile(
    leading: SvgPicture.asset(svgPath),
    title: Text(
      title,
      style: h3.copyWith(
        fontSize: 22,
        color: isSelected ? AppColors.appColor2 : AppColors.textColor10,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    ),
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  );
}

Widget _buildContactItem({
  required String svgPath,
  required String text,
}) {
  return Row(
    children: [
      SvgPicture.asset(svgPath),
      const SizedBox(width: 12),
      Text(
        text,
        style: h4.copyWith(
          fontSize: 16,
          color: AppColors.textColor,
        ),
      ),
    ],
  );
}