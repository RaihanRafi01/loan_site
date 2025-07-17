import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loan_site/app/modules/contractor/views/contractor_view.dart';
import 'package:loan_site/app/modules/home/views/home_view.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final DashboardController controller = Get.put(DashboardController());

    // List of pages to navigate
    final List<Widget> pages = [
      const HomeView(),
      const ContractorView(),
      const ProfilePage(),
      const SettingsPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]), // Display the current page
      bottomNavigationBar: Obx(() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.nav1, AppColors.nav2], // Gradient colors
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16),
          child: GNav(
            backgroundColor: Colors.transparent, // Set to transparent to show the gradient
            color: Colors.black, // Inactive icon and text color
            activeColor: AppColors.appColor2, // Active text color
            tabBackgroundColor: Colors.white,
            gap: 5, // Reduced gap between icon and text
            padding: const EdgeInsets.all(5), // Reduced padding for smaller buttons
            duration: const Duration(milliseconds: 400),
            iconSize: 20, // Reduced icon size
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: h2.copyWith(fontSize: 16,color: controller.selectedIndex.value == 0 ? AppColors.appColor2 : null),
                leading: SvgPicture.asset(
                  'assets/images/nav/home_icon.svg',
                  color: controller.selectedIndex.value == 0 ? AppColors.appColor2 : null, // Active/inactive color
                ),
                iconActiveColor: Colors.white, // Active icon color
                iconColor: Colors.black, // Inactive icon color
              ),
              GButton(
                icon: Icons.search,
                text: 'Contractor',
                textStyle: h2.copyWith(fontSize: 16,color: controller.selectedIndex.value == 1 ? AppColors.appColor2 : null),
                leading: SvgPicture.asset(
                  'assets/images/nav/contractio_icon.svg',
                  color: controller.selectedIndex.value == 1 ? AppColors.appColor2 : null,
                ),
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
              ),
              GButton(
                icon: Icons.person,
                text: 'Progress',
                textStyle: h2.copyWith(fontSize: 16,color: controller.selectedIndex.value == 2 ? AppColors.appColor2 : null),
                leading: SvgPicture.asset(
                  'assets/images/nav/progress_icon.svg',
                  color: controller.selectedIndex.value == 2 ? AppColors.appColor2 : null,
                ),
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
              ),
              GButton(
                icon: Icons.settings,
                text: 'Community',
                textStyle: h2.copyWith(fontSize: 16,color: controller.selectedIndex.value == 3 ? AppColors.appColor2 : null),
                leading: SvgPicture.asset(
                  'assets/images/nav/community_icon.svg',
                  color: controller.selectedIndex.value == 3 ? AppColors.appColor2 : null,
                ),
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                textStyle: h2.copyWith(fontSize: 16,color: controller.selectedIndex.value == 4 ? AppColors.appColor2 : null),
                leading: SvgPicture.asset(
                  'assets/images/nav/settings_icon.svg',
                  color: controller.selectedIndex.value == 4 ? AppColors.appColor2 : null,
                ),
                iconActiveColor: Colors.white,
                iconColor: Colors.black,
              ),
            ],
            selectedIndex: controller.selectedIndex.value,
            onTabChange: (index) {
              controller.changeTabIndex(index); // Update the selected index
            },
          ),
        ),
      )),
    );
  }
}

// Example page classes (create these in separate files)
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings Page',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}