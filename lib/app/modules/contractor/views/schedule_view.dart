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
      'Your Schedule Summary'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(() => Text(
          appBarTitles[controller.currentPage.value],
          style: h2.copyWith(color: AppColors.textColor, fontSize: 24),
        )),
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
            Obx(() => controller.currentPage.value != 3
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
                : SizedBox()),
            SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  // PAGE 1
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Details',
                        style: h3.copyWith(
                            fontSize: 16, color: AppColors.textColor),
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
                            fontSize: 16, color: AppColors.textColor),
                      ),
                      Obx(() => CustomDropdown(
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
                      )),
                      Obx(() => CustomDropdown(
                        labelText: 'Flooring Type',
                        value: controller.selectedFlooringType.value.isEmpty
                            ? null
                            : controller.selectedFlooringType.value,
                        items: ['Hardwood', 'Vinyl', 'Laminate', 'Tile'],
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedFlooringType.value = value;
                            controller.flooringTypeController.text = value;
                          }
                        },
                      )),
                      Obx(() => CustomDropdown(
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
                      )),
                    ],
                  ),
                  // PAGE 3
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: h3.copyWith(
                            fontSize: 16, color: AppColors.textColor),
                      ),
                      CustomTextField(
                        labelText: 'Enter address',
                        controller: controller.emailController,
                        isNoIcon: true,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              labelText: 'City',
                              controller: controller.nameController,
                              isNoIcon: true,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              labelText: 'Province',
                              controller: controller.emailController,
                              isNoIcon: true,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Time & Date',
                        style: h3.copyWith(
                            fontSize: 16, color: AppColors.textColor),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              labelText: 'Time',
                              controller: controller.timeController,
                              suffixSvgPath:
                              'assets/images/contractor/clock_icon.svg',
                              onSuffixTap: () => controller.selectTime(context),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              labelText: 'Date',
                              controller: controller.dateController,
                              suffixSvgPath:
                              'assets/images/contractor/date_icon.svg',
                              onSuffixTap: () => controller.selectDate(context),
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
                      Text(
                        'Client Information',
                        style: h3.copyWith(
                            fontSize: 16, color: AppColors.textColor),
                      ),
                      CustomTextField(
                        labelText: 'Confirm Full Name',
                        prefixSvgPath: 'assets/images/auth/person_icon.svg',
                        controller: controller.nameController,
                      ),
                      CustomTextField(
                        labelText: 'Confirm Email',
                        prefixSvgPath: 'assets/images/auth/mail_icon.svg',
                        controller: controller.emailController,
                      ),
                      CustomTextField(
                        labelText: 'Confirm Loan Amount',
                        prefixSvgPath: 'assets/images/auth/dollar_icon.svg',
                        controller: controller.serviceTypeController,
                      ),
                      CustomTextField(
                        labelText: 'Confirm Time',
                        prefixSvgPath: 'assets/images/contractor/clock_icon.svg',
                        controller: controller.timeController,
                      ),
                      CustomTextField(
                        labelText: 'Confirm Date',
                        prefixSvgPath: 'assets/images/contractor/date_icon.svg',
                        controller: controller.dateController,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Obx(() => CustomButton(
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
                  print('Submitted:');
                  print('Name: ${controller.nameController.text}');
                  print('Email: ${controller.emailController.text}');
                  print('Phone: ${controller.phoneController.text}');
                  print('Loan Amount: ${controller.serviceTypeController.text}');
                  print('Loan Term: ${controller.approxAreaController.text}');
                  print('Time: ${controller.timeController.text}');
                  print('Date: ${controller.dateController.text}');
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}