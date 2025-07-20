import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class ChatHomeView extends GetView {
  const ChatHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.maxFinite,
              color: AppColors.chatCard,
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/home/chat_bot.svg'),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: h3.copyWith(
                            color: AppColors.textColor, fontSize: 20),
                      ),
                      Text(
                        'Construction Guide',
                        style: h4.copyWith(
                            color: AppColors.gray2, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Chat messages area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // First AI message
                  buildAIMessage(
                    "Hi there! I'm your AI assistant, here to help you manage and track your flooring or construction project — every step of the way. This is a very long message to test text wrapping behavior in the chat bubble, ensuring it wraps to the next line properly without overflowing the container boundaries.",
                    "",
                  ),
                  const SizedBox(height: 16),
                  // User message
                  buildUserMessage(
                    "The plumbing already finished. Now moving for next step. This is a very long user message to test the text wrapping behavior for user messages, ensuring the text wraps correctly and stays within the bounds of the chat bubble without causing overflow issues.",
                    "",
                  ),
                  const SizedBox(height: 16),
                  // Second AI message
                  buildAIMessage(
                    "Do you need any help? I am here to assist you.",
                    "",
                  ),
                  const SizedBox(height: 16),
                  // User message
                  buildUserMessage(
                    "Yes, They have already visited the site",
                    "",
                  ),
                  const SizedBox(height: 16),
                  // Second AI message
                  buildAIMessage(
                    "Has the installation date been scheduled",
                    "",
                  ),
                ],
              ),
            ),
            // Input area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget buildAIMessage(
      String message,
      String subtitle, {
        bool isHeader = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Avatar
        SvgPicture.asset('assets/images/home/chat_bot.svg'),
        const SizedBox(width: 12),
        // Message content
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * 0.7, // Limit to 70% of screen width
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.botChatBc,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                  bottomLeft: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isHeader) ...[
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      softWrap: true, // Ensure text wraps
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        softWrap: true, // Ensure text wraps
                      ),
                    ],
                  ] else ...[
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      softWrap: true, // Ensure text wraps
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 50), // Space for alignment
      ],
    );
  }

  Widget buildUserMessage(
      String message,
      String subtitle, {
        bool isHeader = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 50), // Space for alignment
        // Message content
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * 0.7, // Limit to 70% of screen width
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.chatCard, // Different color for user message
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isHeader) ...[
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      softWrap: true, // Ensure text wraps
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        softWrap: true, // Ensure text wraps
                      ),
                    ],
                  ] else ...[
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      softWrap: true, // Ensure text wraps
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // User Avatar (PNG)
        Image.asset(
          'assets/images/home/user_image.png',
          width: 40,
          height: 40,
        ),
      ],
    );
  }
}