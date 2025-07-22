import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/home_view.dart';
import 'package:loan_site/app/modules/notification/views/notification_chat_view.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(title: Text('Notifications',style: h2.copyWith(fontSize: 24,color: AppColors.textColor),),centerTitle: true,scrolledUnderElevation: 0,elevation: 0,backgroundColor: AppColors.appBc,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: ()=> Get.to(NotificationChatView()),
                child: HomeView().buildUpdateCard(
                  'Milestone Reminder',
                  'Plumbing work deadline is approaching in 3 days',
                  'assets/images/home/info_icon.svg',
                  AppColors.yellowCard,
                  AppColors.textYellow,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: ()=> Get.to(NotificationChatView()),
                child: HomeView().buildUpdateCard(
                  'Milestone Reminder',
                  'Electrical work milestone completed successfully',
                  'assets/images/home/tic_icon.svg',
                  AppColors.greenCard,
                  AppColors.textGreen,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: ()=> Get.to(NotificationChatView()),
                child: HomeView().buildUpdateCard(
                  'Red Flag Alert',
                  'Electrical work milestone completed successfully',
                  'assets/images/settings/red_flag.svg',
                  AppColors.clrRed3,
                  AppColors.clrRed2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
