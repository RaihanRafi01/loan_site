import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/project/views/project_view.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import 'package:loan_site/common/widgets/customTextField.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/project_controller.dart';

class CreateProjectView extends GetView<ProjectController> {
  const CreateProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProjectController());
    // State to track current step
    final currentStep = controller.currentStep ?? 1.obs;

    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        title: Text(
          'Create New Project',
          style: h2.copyWith(fontSize: 24, color: AppColors.textColor),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.appBc,
        leading: Obx(() => Visibility(
          visible: currentStep.value > 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textColor),
            onPressed: () {
              if (currentStep.value > 1) {
                currentStep.value--;
              }
            },
          ),
        )),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Sticky step progress indicator
              Container(
                color: AppColors.appBc,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      'Step ${currentStep.value} of 3',
                      style: h4.copyWith(fontSize: 16, color: AppColors.textColor),
                    )),
                    const SizedBox(height: 16),
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: currentStep.value == 1 ? AppColors.appColor2 : Colors.white,
                            shape: BoxShape.circle,
                            border:currentStep.value == 1 ? null : Border.all(color: AppColors.gray9),
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: currentStep.value == 1 ? Colors.white : AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: AppColors.gray8,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: currentStep.value == 2 ? AppColors.appColor2 : Colors.white,
                            shape: BoxShape.circle,
                            border:currentStep.value == 2 ? null : Border.all(color: AppColors.gray9),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: currentStep.value == 2 ? Colors.white : AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: AppColors.gray8,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: currentStep.value == 3 ? AppColors.appColor2 : Colors.white,
                            shape: BoxShape.circle,
                            border:currentStep.value == 3 ? null : Border.all(color: AppColors.gray9),
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: currentStep.value == 3 ? Colors.white : AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => _buildStepContent(currentStep.value)),
                        const SizedBox(height: 80), // Add padding for sticky button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Sticky Next/Submit button
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
              color: AppColors.appBc,
              width: double.infinity,
              child: Obx(() => CustomButton(
                label: currentStep.value == 3 ? 'Submit' : 'Next',
                onPressed: () {
                  if (currentStep.value < 3) {
                    currentStep.value++;
                  } else {
                    // Handle submit action
                    Get.to(() => ProjectView());
                  }
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Basic Information',
                style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
            ),
            Text(
              'Project Name',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter project name',
              controller: controller.projectNameController,
            ),
            Text(
              'Project Type',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter project type',
              controller: controller.projectTypeController,
            ),
            Text(
              'Project Budget',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter project budget',
              controller: controller.projectBudgetController,
            ),
            Text(
              'Project Manager Name',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter project manager name',
              controller: controller.projectManagerNameController,
            ),
            Text(
              'Project Location',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter project location',
              controller: controller.projectLocationController,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
                      ),
                      CustomTextField(
                        labelText: 'mm/dd/yy',
                        controller: controller.projectStartDateController,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Date',
                        style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
                      ),
                      CustomTextField(
                        labelText: 'mm/dd/yy',
                        controller: controller.projectEndDateController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              'Project Description',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Write here....',
              controller: controller.projectDescriptionController,
              maxLine: 6,
              radius: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Upload Site Photo',
                style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  dashPattern: [12, 10],
                  strokeWidth: 2,
                  color: AppColors.gray5,
                  padding: EdgeInsets.all(1),
                  radius: Radius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/upload_icon.svg',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Upload site Photo',
                        style: h3.copyWith(
                          color: AppColors.clrBlue1,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Take multiple photos of your construction site',
                          style: h4.copyWith(
                            color: AppColors.gray6,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: CustomButton(
                          txtClr: AppColors.appColor2,
                          bgClr: [AppColors.chatCard, AppColors.chatCard],
                          label: 'Upload',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contractor Details',
                  style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
                ),
                CustomButton(width: 110, height: 40 ,label: 'Add', onPressed: (){})
              ],
            ),
            Text(
              'Contractor Name',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter contractor/company name',
              controller: controller.contractorNameController,
            ),
            Text(
              'Phone Number',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter phone number',
              controller: controller.contractorPhoneController,
            ),
            Text(
              'Email Address',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter email address',
              controller: controller.contractorEmailController,
            ),
            Text(
              'License Number',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter license number',
              controller: controller.contractorLicenseController,
            ),
            Text(
              'Additional Details',
              style: h3.copyWith(fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Write here....',
              controller: controller.contractorDetailsController,
              maxLine: 6,
              radius: 10,
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Additional Information',
                style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}