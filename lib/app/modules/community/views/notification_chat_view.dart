import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/community/views/comments_view.dart';
import 'package:loan_site/app/modules/community/views/message_view.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../common/widgets/custom_snackbar.dart';
import '../../../core/constants/api.dart';
import '../../../core/services/base_client.dart';

// Base URL for API
const String baseUrl = 'http://10.10.13.73:7000';

// Model for Notification
class NotificationModel {
  final int id;
  final String notificationType;
  final int targetId;
  final String targetType;
  final bool isRead;
  final DateTime createdAt;
  final UserInfo userInfo;

  NotificationModel({
    required this.id,
    required this.notificationType,
    required this.targetId,
    required this.targetType,
    required this.isRead,
    required this.createdAt,
    required this.userInfo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      notificationType: json['notification_type'],
      targetId: json['target_id'],
      targetType: json['target_type'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      userInfo: UserInfo.fromJson(json['user_info']),
    );
  }
}

class UserInfo {
  final int id;
  final String name;
  final String email;
  final String image;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: '$baseUrl${json['image']}', // Prepend base URL to image path
    );
  }
}

// Controller for handling notifications
class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final response = await BaseClient.getRequest(
        api: Api.getNotifications, // Assume this is the API endpoint
        headers: BaseClient.authHeaders(),
      );
      final result = await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.getRequest(
          api: Api.getNotifications,
          headers: BaseClient.authHeaders(),
        ),
      );

      final List<dynamic> notificationJson = result['notifications'];
      notifications.value = notificationJson
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      kSnackBar(
        title: 'Warning',
        message: e.toString(),
        bgColor: AppColors.snackBarWarning,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final response = await BaseClient.putRequest(
        api: Api.markNotificationRead(notificationId),
        headers: BaseClient.authHeaders(), body: '',

      );
      await BaseClient.handleResponse(
        response,
        retryRequest: () => BaseClient.putRequest(
          api: Api.markNotificationRead(notificationId),
          headers: BaseClient.authHeaders(),
          body: '',
        ),
      );
      // Update local notification state
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          notificationType: notifications[index].notificationType,
          targetId: notifications[index].targetId,
          targetType: notifications[index].targetType,
          isRead: true,
          createdAt: notifications[index].createdAt,
          userInfo: notifications[index].userInfo,
        );
        notifications.refresh();
      }
    } catch (e) {
      kSnackBar(
        title: 'Warning',
        message: 'Failed to mark notification as read: $e',
        bgColor: AppColors.snackBarWarning,
      );
    }
  }
}


class NotificationCommunityView extends GetView<NotificationController> {
  const NotificationCommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController()); // Initialize controller
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
          child: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.notifications.isEmpty
              ? const Center(child: Text('No notifications found'))
              : ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return GestureDetector(
                onTap: () {
                  // Mark notification as read
                  if (!notification.isRead) {
                    controller.markNotificationAsRead(notification.id);
                  }
                  print('POST ID ---------------> ${notification.targetId}');
                  // Navigate to post details
                  Get.to(() => CommentsView(postId: notification.targetId));
                },

                child: _buildMessageItem(
                  name: notification.userInfo.name,
                  message: _getNotificationMessage(notification.notificationType),
                  time: _formatTime(notification.createdAt),
                  avatar: notification.userInfo.image,
                  isRead: notification.isRead,
                ),
              );
            },
          )),
        ),
      ),
    );
  }

  String _getNotificationMessage(String type) {
    switch (type) {
      case 'comment_like':
        return 'liked your comment';
      case 'comment':
        return 'commented on your post';
      case 'shared':
        return 'shared your post';
      default:
        return 'interacted with your post';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
    return DateFormat('h:mm a').format(dateTime);
  }

  Widget _buildMessageItem({
    required String name,
    required String message,
    required String time,
    required String avatar,
    required bool isRead,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: isRead ? Colors.transparent : AppColors.appBc.withOpacity(0.1),
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
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          message,
                          style: h4.copyWith(
                            fontSize: 16,
                            color: AppColors.textColor,
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
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
                            'Delete this notification',
                            style: h4.copyWith(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == 'delete_notification') {
                          // Implement delete functionality
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
                  style: h4.copyWith(
                    fontSize: 14,
                    color: AppColors.textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}