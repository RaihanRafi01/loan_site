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

const String mediaBaseUrl = Api.baseUrlPicture; // e.g., https://your.domain

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
                        Get.to(() => const CreateGroupView());
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

            /*// Debug count
            Obx(() {
              final roomMessages = controller.messages
                  .where((msg) => msg['chat_room'] == roomId)
                  .toList();
              developer.log(
                'Rendering messages for roomId=$roomId: ${roomMessages.length} messages',
                name: 'MessageIndividualView',
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Messages: ${roomMessages.length}',
                  style: h4.copyWith(color: AppColors.textColor8, fontSize: 12),
                ),
              );
            }),*/

            // Messages
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
                    final createdAt = msg['created_at'] ?? '';
                    final time = _formatTime(createdAt);
                    final type = (msg['message_type'] ?? '').toString();

                    if (type == 'post') {
                      return _buildSharedPostBubble(msg['post_id'] ?? 0);
                    }

                    if (type == 'file' || type == 'image') {
                      // Prefer base64 in `file`; fallback to server `image` path
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
                      );
                    }

                    // default text
                    return _buildChatBubble(
                      msg['content'] ?? '',
                      isMe,
                      time,
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
                    // Camera button (placeholder)
                    GestureDetector(
                      onTap: () {
                        developer.log('Camera button tapped', name: 'MessageIndividualView');
                        Get.snackbar('Info', 'Camera functionality not implemented yet');
                      },
                      child: SvgPicture.asset('assets/images/home/cam_icon.svg'),
                    ),
                    const SizedBox(width: 8),
                    // File picker
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

                              // Validate file size (< 10MB)
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

                              // MIME + message type
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
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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

  // New media bubble that supports base64 (data URI) and server path images
  Widget _buildMediaBubble({
    required String payload,   // data URI OR server path
    required String label,
    required bool isMe,
    required String time,
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
      // Network url or server path
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
        // Fallback for non-image files
        body = GestureDetector(
          onTap: () {
            Get.snackbar('Open', 'Opening file: $label');
            // TODO: implement a viewer if desired
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
      // Unknown data URI
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
          //crossAxisAlignment: isMe ? Alignment.centerRight.crossAxisAlignment : Alignment.centerLeft.crossAxisAlignment,
          children: [
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

  String _resolveMediaUrl(String input) {
    if (input.startsWith('http://') || input.startsWith('https://') || input.startsWith('data:')) {
      return input;
    }
    // Treat as server-relative path
    return '$mediaBaseUrl$input';
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
    return 6; // Placeholder
  }
}
