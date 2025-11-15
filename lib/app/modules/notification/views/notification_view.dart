import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/home/views/home_view.dart';
import 'package:loan_site/app/modules/notification/views/notification_chat_view.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: h2.copyWith(fontSize: 24, color: AppColors.textColor),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.appBc,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final project = homeController.currentProject.value;
            if (project == null || project.recentUpdates.isEmpty) {
              return Text(
                'No recent updates available',
                style: h4.copyWith(
                  fontSize: 16,
                  color: AppColors.blurtext5,
                ),
              );
            }
            return Column(
              children: project.recentUpdates.map((update) {
                return Column(
                  children: [
                    HomeView().buildUpdateCard(
                      update.milestoneName,
                      update.message,
                      update.status == 'completed'
                          ? 'assets/images/home/tic_icon.svg'
                          : update.status == 'alert'
                          ? 'assets/images/settings/red_flag.svg'
                          : 'assets/images/home/info_icon.svg',
                      update.status == 'completed'
                          ? AppColors.greenCard
                          : update.status == 'alert'
                          ? AppColors.clrRed3
                          : AppColors.yellowCard,
                      update.status == 'completed'
                          ? AppColors.textGreen
                          : update.status == 'alert'
                          ? AppColors.clrRed2
                          : AppColors.textYellow,
                      date: update.date,
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            );
          }),
        ),
      ),
    );
  }
}