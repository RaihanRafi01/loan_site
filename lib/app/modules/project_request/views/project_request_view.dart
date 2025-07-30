import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customButton.dart';
import '../controllers/project_request_controller.dart';

class ProjectRequestView extends GetView<ProjectRequestController> {
  const ProjectRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appBc,
        scrolledUnderElevation: 0,
        title: Text(
          'Projects Request',
          style: h2.copyWith(
            color: AppColors.textColor,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardSky,
                borderRadius: BorderRadius.circular(48),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.appColor2,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.gray13,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(text: 'Accept'),
                    Tab(text: 'Pending'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Accept Tab
                  _buildAcceptedRequestsList(),
                  // Pending Tab
                  _buildPendingRequestsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptedRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with actual data length
      itemBuilder: (context, index) {
        return _buildAcceptedRequestCard(
          name: "Sarah James",
          lenderName: "Sarah James",
          companyName: "Green Valley Residential Complex",
          location : "Austin, TX",
          companyType: "Residential",
          price: "10M",
          profileImage: "assets/images/profile_placeholder.png", // Replace with actual asset
        );
      },
    );
  }

  Widget _buildPendingRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with actual data length
      itemBuilder: (context, index) {
        return _buildPendingRequestCard(
          name: "Sarah James",
          projectType: "Food Delivery Application",
          date: "24 Jan '25",
          time: "5:30 PM",
          profileImage: "assets/images/profile_placeholder.png", // Replace with actual asset
        );
      },
    );
  }

  Widget _buildAcceptedRequestCard({
    required String name,
    required String lenderName,
    required String companyName,
    required String location,
    required String companyType,
    required String price,
    required String profileImage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardSky,
                  image: DecorationImage(
                    image: AssetImage(profileImage),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                ),
                child: profileImage.isEmpty
                    ? Icon(
                  Icons.person,
                  color: AppColors.gray13,
                  size: 30,
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: h3.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/project/bag_icon.svg'),
                        SizedBox(width: 4),
                        Text(
                          lenderName,
                          style: h4.copyWith(
                            color: AppColors.gray15,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.clrGreen2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Accepted',
                  style: h3.copyWith(
                    color: AppColors.clrGreen2,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            companyName,
            style: h3.copyWith(
              color: AppColors.appColor2,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/project/map_icon.svg'),
                SizedBox(width: 3),
                Text(
                  location,
                  style: h4.copyWith(
                    color: AppColors.blurtext,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/project/building_icon.svg'),
                SizedBox(width: 4),
                Text(
                  companyType,
                  style: h4.copyWith(
                    color: AppColors.blurtext,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/project/dollar_icon.svg'),
                SizedBox(width: 4),
                Text(
                  price,
                  style: h4.copyWith(
                    color: AppColors.blurtext,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildPendingRequestCard({
    required String name,
    required String projectType,
    required String date,
    required String time,
    required String profileImage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardSky,
                  image: DecorationImage(
                    image: AssetImage(profileImage),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                ),
                child: profileImage.isEmpty
                    ? Icon(
                  Icons.person,
                  color: AppColors.gray13,
                  size: 30,
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: h3.copyWith(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      projectType,
                      style: TextStyle(
                        color: AppColors.gray13,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.gray13,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: TextStyle(
                  color: AppColors.gray13,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.gray13,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  color: AppColors.gray13,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Decline',
                  onPressed: () {
                    // Handle decline action
                    _handleDeclineRequest(name);
                  },
                  isWhite: true,
                  txtClr: Colors.red,
                  borderColor: Colors.red,
                  height: 35,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: 'Accept',
                  onPressed: () {
                    // Handle accept action
                    _handleAcceptRequest(name);
                  },
                  height: 35,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAcceptRequest(String name) {
    // Add your accept request logic here
    Get.snackbar(
      'Request Accepted',
      'You have accepted the project request from $name',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleDeclineRequest(String name) {
    // Add your decline request logic here
    Get.snackbar(
      'Request Declined',
      'You have declined the project request from $name',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}