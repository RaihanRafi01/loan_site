import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/chat_home_view.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class NotificationChatView extends GetView {
  const NotificationChatView({super.key});
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
                  ChatHomeView().buildAIMessage(context,
                    "Hey Angelo, good to see you! You are currently in plumbing. Your Plumbing Work Milestone is approaching its deadline in 3 days",
                  ),
                  const SizedBox(height: 16),
                  // Second AI message
                  ChatHomeView().buildAIMessage(context,
                    "Now’s a great time to review progress, coordinate with contractors, or make any final adjustments. Let me know if you need any help.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
