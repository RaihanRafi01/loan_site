import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/auth/views/login_view.dart';
import 'package:loan_site/app/modules/project/views/project_list_view.dart';
import 'package:loan_site/app/modules/settings/views/account_settings_view.dart';
import 'package:loan_site/app/modules/settings/views/help_support_view.dart';
import 'package:loan_site/app/modules/settings/views/terms_condition_view.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  final bool isBorrower;
  const SettingsView({super.key, this.isBorrower = false});

  @override
  Widget build(BuildContext context) {
    // Ensure SettingsController is initialized
    Get.put(SettingsController());
    final DashboardController dashboardController = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.appBc,
        elevation: 0,
        title: Text(
          'Settings',
          style: h2.copyWith(
            color: AppColors.textColor,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Obx(
                      () => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.selectedImage.value != null
                        ? FileImage(controller.selectedImage.value!)
                        : dashboardController.profileImageUrl.value.isNotEmpty
                        ? CachedNetworkImageProvider(
                      dashboardController.profileImageUrl.value,
                      errorListener: (exception) {
                        debugPrint('Image load error: $exception');
                        dashboardController.profileImageUrl.value = '';
                      },
                    ) as ImageProvider
                        : const AssetImage('assets/images/settings/profile_image.png'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                            () => Text(
                          dashboardController.name.value.isEmpty
                              ? 'User'
                              : dashboardController.name.value,
                          style: h2.copyWith(
                            fontSize: 30,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                            () => Text(
                          dashboardController.email.value.isEmpty
                              ? 'email@example.com'
                              : dashboardController.email.value,
                          style: h4.copyWith(
                            fontSize: 18,
                            color: AppColors.blurtext4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Settings Options
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSettingsItem(
                    svgPath: 'assets/images/settings/settings_icon.svg',
                    title: 'Account Settings',
                    onTap: () => Get.to(const AccountSettingsView()),
                  ),
                  _buildSettingsItem(
                    svgPath: 'assets/images/settings/noti_icon.svg',
                    title: 'Notification',
                    onTap: () {
                      controller.toggleNotificationPreference();
                    },
                    hasSwitch: true,
                    switchValue: controller.notificationEnabled.value,
                  ),
                  if (isBorrower)
                    _buildSettingsItem(
                      svgPath: 'assets/images/settings/flag_icon.svg',
                      title: 'My Project',
                      onTap: () => Get.to(const ProjectListView()),
                    ),
                  _buildSettingsItem(
                    svgPath: 'assets/images/settings/help_icon.svg',
                    title: 'Help & Support',
                    onTap: () => Get.to(const HelpSupportView()),
                  ),
                  _buildSettingsItem(
                    svgPath: 'assets/images/settings/terms_icon.svg',
                    title: 'Terms & Condition',
                    onTap: () => Get.to(const TermsConditionView()),
                  ),
                ],
              ),
            ),
          ),
          // Log Out Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // Handle log out
                  _showLogoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.clrRed, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.power_settings_new_outlined,
                      color: AppColors.clrRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: h3.copyWith(
                        color: AppColors.clrRed,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String svgPath,
    required String title,
    required VoidCallback onTap,
    bool hasSwitch = false,
    bool switchValue = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: SvgPicture.asset(svgPath),
        title: Text(
          title,
          style: h4.copyWith(
            fontSize: 18,
            color: AppColors.textColor,
          ),
        ),
        trailing: hasSwitch
            ? Obx(
              () => Switch(
            value: Get.find<SettingsController>().notificationEnabled.value,
            onChanged: (value) {
              Get.find<SettingsController>().toggleNotificationPreference();
            },
            activeColor: AppColors.appColor2, // Use consistent color
          ),
        )
            : SvgPicture.asset('assets/images/settings/arrow_right.svg'),
        onTap: hasSwitch ? null : onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: h3.copyWith(color: AppColors.textColor)),
            ),
            TextButton(
              onPressed: controller.logout,
              child: Text('Log Out', style: h3.copyWith(color: AppColors.clrRed)),
            ),
          ],
        );
      },
    );
  }
}