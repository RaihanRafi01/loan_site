import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loan_site/app/modules/contractor/controllers/contractor_controller.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customDropDown.dart';

class ScheduleView extends GetView<ContractorController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContractorController());

    final List<String> appBarTitles = [
      'Client Information',
      'Service Details',
      'Contact Details',
      'Your Schedule Summary',
    ];

    return Obx(
          () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.appBc,
            appBar: AppBar(
              title: Obx(
                    () => Text(
                  appBarTitles[controller.currentPage.value],
                  style: h2.copyWith(color: AppColors.textColor, fontSize: 24),
                ),
              ),
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                        () => controller.currentPage.value != 3
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        3,
                            (index) => Expanded(
                          child: Container(
                            height: 5,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            color: index == controller.currentPage.value
                                ? Colors.blue
                                : index < controller.currentPage.value
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    )
                        : SizedBox(),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: (index) =>
                      controller.currentPage.value = index,
                      children: [
                        // PAGE 1
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Details',
                              style: h3.copyWith(
                                fontSize: 16,
                                color: AppColors.textColor,
                              ),
                            ),
                            CustomTextField(
                              labelText: 'Enter full name',
                              prefixSvgPath: 'assets/images/auth/person_icon.svg',
                              controller: controller.nameController,
                            ),
                            CustomTextField(
                              labelText: 'Enter email address',
                              prefixSvgPath: 'assets/images/auth/mail_icon.svg',
                              controller: controller.emailController,
                            ),
                            CustomTextField(
                              labelText: 'Enter phone number',
                              prefixSvgPath: 'assets/images/auth/phone_icon.svg',
                              controller: controller.phoneController,
                            ),
                          ],
                        ),
                        // PAGE 2
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Service Type',
                              style: h3.copyWith(
                                fontSize: 16,
                                color: AppColors.textColor,
                              ),
                            ),
                            Obx(
                                  () => CustomDropdown(
                                labelText: 'Service Type',
                                value: controller.selectedServiceType.value.isEmpty
                                    ? null
                                    : controller.selectedServiceType.value,
                                items: ['Consultation', 'Installation', 'Repair'],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedServiceType.value = value;
                                    controller.serviceTypeController.text = value;
                                  }
                                },
                              ),
                            ),
                            Obx(
                                  () => CustomDropdown(
                                labelText: 'Flooring Type',
                                value:
                                controller.selectedFlooringType.value.isEmpty
                                    ? null
                                    : controller.selectedFlooringType.value,
                                items: ['Hardwood', 'Vinyl', 'Laminate', 'Tile'],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedFlooringType.value = value;
                                    controller.flooringTypeController.text =
                                        value;
                                  }
                                },
                              ),
                            ),
                            Obx(
                                  () => CustomDropdown(
                                labelText: 'Approx. Area',
                                value: controller.selectedApproxArea.value.isEmpty
                                    ? null
                                    : controller.selectedApproxArea.value,
                                items: ['ft', 'cm', 'inch', 'meter'],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedApproxArea.value = value;
                                    controller.approxAreaController.text = value;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        // PAGE 3
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: h3.copyWith(
                                fontSize: 16,
                                color: AppColors.textColor,
                              ),
                            ),
                            CustomTextField(
                              labelText: 'Enter location',
                              controller: controller.addressController,
                              isNoIcon: true,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'City',
                                    controller: controller.cityController,
                                    isNoIcon: true,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'Province',
                                    controller: controller.provinceController,
                                    isNoIcon: true,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Time & Date',
                              style: h3.copyWith(
                                fontSize: 16,
                                color: AppColors.textColor,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'Time',
                                    controller: controller.timeController,
                                    suffixSvgPath:
                                    'assets/images/contractor/clock_icon.svg',
                                    onSuffixTap: () =>
                                        controller.selectTime(context),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'Date',
                                    controller: controller.dateController,
                                    suffixSvgPath:
                                    'assets/images/contractor/date_icon.svg',
                                    onSuffixTap: () =>
                                        controller.selectDate(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // PAGE 4
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Obx(
                                      () => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Client Information Section
                                      _buildSummarySection(
                                        title: 'Client Information',
                                        items: [
                                          _buildSummaryItem(
                                            'Full Name',
                                            controller.nameController.text,
                                          ),
                                          _buildSummaryItem(
                                            'Email address',
                                            controller.emailController.text,
                                          ),
                                          _buildSummaryItem(
                                            'Phone number',
                                            controller.phoneController.text,
                                          ),
                                        ],
                                      ),

                                      // Service Details Section
                                      _buildSummarySection(
                                        title: 'Service Details',
                                        items: [
                                          _buildSummaryItem(
                                            'Service type',
                                            controller.selectedServiceType.value,
                                          ),
                                          _buildSummaryItem(
                                            'Flooring type',
                                            controller.selectedFlooringType.value,
                                          ),
                                          _buildSummaryItem(
                                            'Approx. area',
                                            controller.selectedApproxArea.value,
                                          ),
                                        ],
                                      ),

                                      // Appointment Schedule Section
                                      _buildSummarySection(
                                        title: 'Appointment Schedule',
                                        items: [
                                          _buildSummaryItem(
                                            'Date',
                                            controller.dateController.text,
                                          ),
                                          _buildSummaryItem(
                                            'Time',
                                            controller.timeController.text,
                                          ),
                                        ],
                                      ),

                                      // Location Section
                                      _buildSummarySection(
                                        title: 'Location',
                                        items: [
                                          _buildSummaryItem(
                                            'Address',
                                            controller.addressController.text,
                                          ),
                                          _buildSummaryItem(
                                            'City',
                                            controller.cityController.text,
                                          ),
                                          _buildSummaryItem(
                                            'Province',
                                            controller.provinceController.text,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                        () => CustomButton(
                      label: controller.currentPage.value == 0
                          ? 'Next'
                          : controller.currentPage.value == 1
                          ? 'Next'
                          : controller.currentPage.value == 2
                          ? 'Next'
                          : 'Submit',
                      onPressed: () {
                        if (controller.currentPage.value < 3) {
                          controller.pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          // Open email client with pre-filled form data
                          controller.openEmailClient();
                          // Show confirmation dialog
                          controller.showConfirm.value = true;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (controller.showConfirm.value)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  controller.showConfirm.value = false; // Dismiss card on outside tap
                },
                child: Stack(
                  children: [
                    // Blurred background
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
                      ),
                    ),
                    // Centered card
                    Center(
                      child: GestureDetector(
                        onTap: () {}, // Prevents taps on the card from dismissing it
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/auth/tic_icon.svg',
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Successful!',
                                  style: h4.copyWith(
                                    fontSize: 32,
                                    color: AppColors.textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummarySection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
              SvgPicture.asset('assets/images/contractor/edit_icon.svg'),
            ],
          ),
          SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  // Helper method to build individual summary items
  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: h4.copyWith(fontSize: 18, color: AppColors.blurtext7),
          ),
          SizedBox(width: 10),
          Text(
            value.isEmpty ? 'Not specified' : value,
            style: h3.copyWith(fontSize: 18, color: AppColors.blurtext8),
          ),
        ],
      ),
    );
  }
}