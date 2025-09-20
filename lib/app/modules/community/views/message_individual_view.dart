import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loan_site/app/modules/community/controllers/message_controller.dart';
import 'package:loan_site/app/modules/community/views/create_group_view.dart';
import 'package:loan_site/app/modules/community/views/comments_view.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import 'dart:developer' as developer;
import '../../../core/constants/api.dart';

const String mediaBaseUrl = Api.baseUrlPicture;

class MessageIndividualView extends GetView<MessageController> {
  final String name;
  final String message;
  final String avatar;
  final int roomId;
  final int recipientId;

  MessageIndividualView({
    super.key,
    required this.name,
    required this.message,
    required this.avatar,
    required this.roomId,
    required this.recipientId,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    Get.put(scrollController); // Register ScrollController for MessageController
    final TextEditingController textController = TextEditingController();

    // Set room ID, fetch chat history, and mark messages as read
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.currentRoomId.value = roomId;
      controller.fetchChatHistory(roomId);
      controller.markMessagesAsRead(roomId); // Mark messages as read
    });

    // Listen for scroll triggers to bottom
    ever(controller.shouldScrollToBottom, (shouldScroll) {
      if (shouldScroll && scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          controller.shouldScrollToBottom.value = false; // Reset trigger
          developer.log('Scrolled to bottom, offset: ${scrollController.offset}', name: 'MessageIndividualView');
        });
      }
    });

    // Listen for scroll to top to load more messages
    scrollController.addListener(() {
      if (scrollController.hasClients &&
          scrollController.offset <= scrollController.position.minScrollExtent + 200 &&
          !scrollController.position.outOfRange &&
          !controller.isLoadingMoreMessages.value &&
          controller.hasMoreMessages.value) {
        developer.log(
          'Near top, fetching more messages, nextPageUrl: ${controller.nextPageUrl.value}',
          name: 'MessageIndividualView',
        );
        controller.fetchMoreMessages();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            // Profile section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Active', // You might want to fetch actual status
                            style: h4.copyWith(
                              fontSize: 14,
                              color: AppColors.textColor8,
                            ),
                          ),
                        ],
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
                        Get.to(() => CreateGroupView(recipientId: recipientId));
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

            // Messages
            Expanded(
              child: Obx(() {
                if (controller.isLoadingMessages.value) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
                final roomMessages = controller.messages
                    .where((msg) => msg['chat_room'] == roomId)
                    .toList();
                return ListView.builder(
                  controller: scrollController,
                  reverse: true, // Newest messages at the bottom
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: roomMessages.length + (controller.isLoadingMoreMessages.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == roomMessages.length && controller.isLoadingMoreMessages.value) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor2),
                          ),
                        ),
                      );
                    }
                    final msg = roomMessages[index];
                    final isMe = msg['sender']['id'] == controller.getCurrentUserId();
                    final createdAt = msg['created_at'] ?? '';
                    final time = _formatTime(createdAt);
                    final type = (msg['message_type'] ?? '').toString();
                    final senderId = msg['sender']['id'] as int;
                    final senderName = senderId == controller.getCurrentUserId() ? 'You' : name;
                    final senderAvatar = senderId == controller.getCurrentUserId()
                        ? (controller.getCurrentUserId() == recipientId ? avatar : '') // Adjust based on your user data
                        : avatar;

                    if (type == 'post') {
                      return _buildSharedPostBubble(msg['post_id'] ?? 0, senderName, senderAvatar);
                    }

                    if (type == 'file' || type == 'image') {
                      final raw = (msg['file'] ?? '').toString().trim();
                      final serverPath = (msg['image'] ?? '').toString().trim();
                      final payload = raw.isNotEmpty ? raw : serverPath;

                      return _buildMediaBubble(
                        payload: payload,
                        label: (type == 'image')
                            ? (msg['content'] ?? 'Image')
                            : (msg['content'] ?? 'File Attachment'),
                        isMe: isMe,
                        time: time,
                        senderName: senderName,
                        senderAvatar: senderAvatar,
                      );
                    }

                    return _buildChatBubble(
                      msg['content'] ?? '',
                      isMe,
                      time,
                      senderName,
                      senderAvatar,
                    );
                  },
                );
              }),
            ),

            // Input
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
                    GestureDetector(
                      onTap: () {
                        developer.log('Camera button tapped', name: 'MessageIndividualView');
                        Get.snackbar('Info', 'Camera functionality not implemented yet');
                      },
                      child: SvgPicture.asset('assets/images/home/cam_icon.svg'),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        developer.log('File picker button tapped', name: 'MessageIndividualView');
                        PermissionStatus permissionStatus = await Permission.photos.request();

                        if (permissionStatus.isGranted) {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                              allowMultiple: false,
                            );
                            if (result != null && result.files.isNotEmpty) {
                              final file = result.files.single;
                              String? base64File;
                              String fileName = file.name;

                              if (file.size > 10 * 1024 * 1024) {
                                developer.log(
                                  'File too large: $fileName, size: ${file.size} bytes',
                                  name: 'MessageIndividualView',
                                );
                                Get.snackbar('Error', 'File size exceeds 10MB limit');
                                return;
                              }

                              if (file.bytes != null) {
                                base64File = base64Encode(file.bytes!);
                              } else if (file.path != null) {
                                try {
                                  final fileContent = await File(file.path!).readAsBytes();
                                  base64File = base64Encode(fileContent);
                                } catch (e) {
                                  developer.log('Failed to read file from path: $fileName, error: $e',
                                      name: 'MessageIndividualView', error: e);
                                  Get.snackbar('Error', 'Failed to read file: $e');
                                  return;
                                }
                              } else {
                                Get.snackbar('Error', 'Unable to read file content');
                                return;
                              }

                              final ext = (file.extension ?? '').toLowerCase();
                              String mime;
                              String messageType;
                              if (ext == 'jpg' || ext == 'jpeg') {
                                mime = 'image/jpeg';
                                messageType = 'image';
                              } else if (ext == 'png') {
                                mime = 'image/png';
                                messageType = 'image';
                              } else if (ext == 'pdf') {
                                mime = 'application/pdf';
                                messageType = 'file';
                              } else {
                                mime = 'application/octet-stream';
                                messageType = 'file';
                              }

                              final dataUri = 'data:$mime;base64,$base64File';

                              controller.sendMessage(
                                '',
                                messageType,
                                file: dataUri,
                              );
                            } else {
                              Get.snackbar('Info', 'No file selected');
                            }
                          } catch (e) {
                            developer.log('File picker error: $e',
                                name: 'MessageIndividualView', error: e);
                            Get.snackbar('Error', 'Failed to pick file: $e');
                          }
                        } else if (permissionStatus.isPermanentlyDenied) {
                          Get.snackbar('Error', 'Please enable storage permission in settings');
                          await openAppSettings();
                        } else {
                          Get.snackbar('Error', 'Storage permission denied');
                        }
                      },
                      child: SvgPicture.asset('assets/images/home/image_icon.svg'),
                    ),
                    const SizedBox(width: 12),
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

  Widget _buildChatBubble(
      String msg,
      bool isMe,
      String time,
      String senderName,
      String senderAvatar,
      ) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isMe ? AppColors.appColor2 : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: senderAvatar.isNotEmpty ? NetworkImage(senderAvatar) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    senderName,
                    style: h4.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
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

  Widget _buildMediaBubble({
    required String payload,
    required String label,
    required bool isMe,
    required String time,
    required String senderName,
    required String senderAvatar,
  }) {
    final isDataUri = payload.startsWith('data:');
    final isImageData = payload.startsWith('data:image');
    final resolved = isDataUri ? payload : _resolveMediaUrl(payload);

    Widget body;

    if (isDataUri && isImageData) {
      try {
        final bytesBase64 = payload.split(',').last;
        body = Image.memory(
          base64Decode(bytesBase64),
          width: 160,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Text('Failed to load image'),
        );
      } catch (e) {
        body = const Text('Failed to decode image');
      }
    } else if (!isDataUri) {
      final lower = resolved.toLowerCase();
      final looksLikeImage = lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.png') ||
          lower.endsWith('.webp') ||
          lower.contains('/media/chat_images/');

      if (looksLikeImage) {
        body = Image.network(
          resolved,
          width: 160,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Text('Failed to load image'),
        );
      } else {
        body = GestureDetector(
          onTap: () {
            Get.snackbar('Open', 'Opening file: $label');
          },
          child: Text(
            'Tap to view file',
            style: h4.copyWith(
              fontSize: 14,
              color: isMe ? Colors.white70 : AppColors.textColor8,
            ),
          ),
        );
      }
    } else {
      body = Text(
        'Tap to view file',
        style: h4.copyWith(
          fontSize: 14,
          color: isMe ? Colors.white70 : AppColors.textColor8,
        ),
      );
    }

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
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: senderAvatar.isNotEmpty ? NetworkImage(senderAvatar) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    senderName,
                    style: h4.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            Text(
              label,
              style: h4.copyWith(
                fontSize: 16,
                color: isMe ? Colors.white : AppColors.textColor,
              ),
            ),
            const SizedBox(height: 6),
            body,
            const SizedBox(height: 6),
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

  Widget _buildSharedPostBubble(int postId, String senderName, String senderAvatar) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: senderAvatar.isNotEmpty ? NetworkImage(senderAvatar) : null,
                ),
                const SizedBox(width: 8),
                Text(
                  senderName,
                  style: h4.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                Get.to(() => CommentsView(postId: postId));
              },
              child: Text(
                'Shared Post: Click to view',
                style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveMediaUrl(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }
    if (input.startsWith('http://') || input.startsWith('https://') || input.startsWith('data:')) {
      return input;
    }
    return '$mediaBaseUrl$input';
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