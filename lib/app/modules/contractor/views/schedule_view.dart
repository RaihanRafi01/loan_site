import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/contractor/controllers/contractor_controller.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

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
                        'Loan Information',
                        style: h3.copyWith(
                            fontSize: 16, color: AppColors.textColor),
                      ),
                      CustomTextField(
                        labelText: 'Loan Amount',
                        prefixSvgPath: 'assets/images/auth/dollar_icon.svg',
                        controller: controller.loanAmountController,
                      ),
                      CustomTextField(
                        labelText: 'Loan Term (months)',
                        prefixSvgPath: 'assets/images/auth/calendar_icon.svg',
                        controller: controller.loanTermController,
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
                            fontSize: 16, color: AppColors.textColor),
                      ),
                      CustomTextField(
                        labelText: 'Enter address',
                        controller: controller.loanAmountController,
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
                        controller: controller.loanAmountController,
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
                  // Handle submit action here
                  // You might want to add validation before submission
                  print('Submitted:');
                  print('Name: ${controller.nameController.text}');
                  print('Email: ${controller.emailController.text}');
                  print('Phone: ${controller.phoneController.text}');
                  print('Loan Amount: ${controller.loanAmountController.text}');
                  print('Loan Term: ${controller.loanTermController.text}');
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