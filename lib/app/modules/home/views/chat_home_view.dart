import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/chat_controller.dart';

class ChatHomeView extends GetView<ChatController> {
  const ChatHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ChatController>()) {
      Get.put(ChatController());
    }

    final scrollController = ScrollController();

    return Scaffold(
      backgroundColor: AppColors.appBc,
      body: SafeArea(
        child: Column(
          children: [
            // Header with project/milestone from SharedPreferences via controller
            Obx(() => _header(
              projectName: controller.projectName.value,
              currentMilestone: controller.currentMilestone.value,
            )),

            // Messages
            Expanded(
              child: Obx(() {
                final isLoadingInitial = (!controller.isContextLoaded.value && controller.messages.isEmpty) ||
                    (controller.isHistoryLoading.value && controller.messages.isEmpty);

                if (isLoadingInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Auto-scroll to bottom after build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final m = controller.messages[i];
                    return m.isUser
                        ? buildUserMessage(context, m.text)
                        : buildAIMessage(context, m.text);
                  },
                );
              }),
            ),

            // Input
            _inputBar(context),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _header({required String projectName, required String currentMilestone}) {
    final subtitle = [
      if (projectName.isNotEmpty) 'Project: $projectName',
      if (currentMilestone.isNotEmpty) 'Milestone: $currentMilestone',
    ].join('  •  ');

    return Container(
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
              Text('AI Assistant', style: h3.copyWith(color: AppColors.textColor, fontSize: 20)),
              Text(
                subtitle.isEmpty ? 'Construction Guide' : subtitle,
                style: h4.copyWith(color: AppColors.gray2, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            SvgPicture.asset('assets/images/home/cam_icon.svg'),
            const SizedBox(width: 8),
            SvgPicture.asset('assets/images/home/image_icon.svg'),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: AppColors.chatInput, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.textController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Type here...',
                          border: InputBorder.none,
                          hintStyle: h4.copyWith(color: Colors.grey, fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                    SvgPicture.asset('assets/images/home/mic_icon.svg'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Obx(() {
              return GestureDetector(
                onTap: controller.isSending.value ? null : () => controller.sendMessage(),
                child: controller.isSending.value
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : SvgPicture.asset('assets/images/home/send_icon.svg'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildAIMessage(BuildContext context, String message, {bool isHeader = false}) {
    final maxW = MediaQuery.of(context).size.width * 0.7;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/images/home/chat_bot.svg'),
        const SizedBox(width: 12),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
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
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: isHeader ? 16 : 14,
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.black87,
                  height: 1.4,
                ),
                softWrap: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 50),
      ],
    );
  }

  Widget buildUserMessage(BuildContext context, String message, {bool isHeader = false}) {
    final maxW = MediaQuery.of(context).size.width * 0.7;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 50),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.chatCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: isHeader ? 16 : 14,
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.black87,
                  height: 1.4,
                ),
                softWrap: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Image.asset('assets/images/home/user_image.png', width: 40, height: 40),
      ],
    );
  }
}
