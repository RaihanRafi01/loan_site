import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/app/modules/project/views/project_view.dart';
import 'package:loan_site/app/modules/project/views/select_lender_view.dart';
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
          visible: controller.currentStep.value > 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textColor),
            onPressed: () {
              if (controller.currentStep.value == 25) {
                controller.currentStep.value = 2;
              } else if (controller.currentStep.value > 1) {
                controller.currentStep.value--;
              }
            },
          ),
        )),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: AppColors.appBc,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      'Step ${_getDisplayStep(controller.currentStep.value)} of 3',
                      style: h4.copyWith(
                          fontSize: 16, color: AppColors.textColor),
                    )),
                    const SizedBox(height: 16),
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: controller.currentStep.value == 1
                                ? AppColors.appColor2
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: controller.currentStep.value == 1
                                ? null
                                : Border.all(color: AppColors.gray9),
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: controller.currentStep.value == 1
                                    ? Colors.white
                                    : AppColors.textColor,
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
                            color: (controller.currentStep.value == 2 || controller.currentStep.value == 25)
                                ? AppColors.appColor2
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: (controller.currentStep.value == 2 || controller.currentStep.value == 25)
                                ? null
                                : Border.all(color: AppColors.gray9),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: (controller.currentStep.value == 2 || controller.currentStep.value == 25)
                                    ? Colors.white
                                    : AppColors.textColor,
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
                            color: controller.currentStep.value == 3
                                ? AppColors.appColor2
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: controller.currentStep.value == 3
                                ? null
                                : Border.all(color: AppColors.gray9),
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: controller.currentStep.value == 3
                                    ? Colors.white
                                    : AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              Obx(() => Visibility(
                visible: controller.currentStep.value == 2,
                child: Container(
                  color: AppColors.appBc,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contractor Details',
                        style: h3.copyWith(
                            fontSize: 20, color: AppColors.textColor),
                      ),
                      CustomButton(
                        width: 110,
                        height: 40,
                        label: 'Add',
                        onPressed: () {
                          controller.addContractor();
                        },
                      ),
                    ],
                  ),
                ),
              )),
              Obx(() => Visibility(
                visible: controller.currentStep.value == 25,
                child: Container(
                  color: AppColors.appBc,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Review Contractor',
                        style: h3.copyWith(
                            fontSize: 20, color: AppColors.textColor),
                      ),
                    ],
                  ),
                ),
              )),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => _buildStepContent(controller.currentStep.value, context)),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Obx(() => CustomButton(
              isLoading: controller.isImageUploading.value,
              label: controller.isImageUploading.value
                  ? 'Uploading...'
                  : _getButtonText(controller.currentStep.value),
              onPressed: () {
                if (controller.currentStep.value == 1) {
                  controller.currentStep.value = 2;
                } else if (controller.currentStep.value == 2) {
                  controller.currentStep.value = 25;
                } else if (controller.currentStep.value == 25) {
                  controller.currentStep.value = 3;
                } else if (controller.currentStep.value == 3) {
                  controller.createProject();
                }
              },
            )),
          ),
          // Image Overlay Viewer
          Obx(
                () => controller.showImageOverlay.value &&
                controller.selectedImages.isNotEmpty
                ? Container(
              color: Colors.black.withOpacity(0.9),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 80,
                      ),
                      child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: (index) =>
                        controller.currentImageIndex.value = index,
                        itemCount: controller.selectedImages.length,
                        itemBuilder: (context, index) {
                          return InteractiveViewer(
                            maxScale: 4.0,
                            minScale: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  controller.selectedImages[index],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.removeImage(
                              controller.currentImageIndex.value,
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/images/home/delete_icon.svg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => controller.closeImageViewer(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.selectedImages.length > 1)
                    Positioned(
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => controller.previousImage(),
                          child: SvgPicture.asset(
                            'assets/images/home/left_icon.svg',
                          ),
                        ),
                      ),
                    ),
                  if (controller.selectedImages.length > 1)
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => controller.nextImage(),
                          child: SvgPicture.asset(
                            'assets/images/home/right_icon.svg',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  int _getDisplayStep(int currentStep) {
    if (currentStep == 25) return 2;
    return currentStep;
  }

  String _getButtonText(int currentStep) {
    if (currentStep == 3) return 'Submit';
    return 'Next';
  }

  Widget _buildStepContent(int step, BuildContext context) {
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
                        style: h3.copyWith(
                            fontSize: 14, color: AppColors.textColor8),
                      ),
                      CustomTextField(
                        labelText: 'yyyy-mm-dd',
                        readOnly: true,
                        controller: controller.projectStartDateController,
                        suffixSvgPath:
                        'assets/images/contractor/date_icon.svg',
                        onSuffixTap: () =>
                            controller.selectDate(context, controller.projectStartDateController),
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
                        style: h3.copyWith(
                            fontSize: 14, color: AppColors.textColor8),
                      ),
                      CustomTextField(
                        labelText: 'yyyy-mm-dd',
                        readOnly: true,
                        controller: controller.projectEndDateController,
                        suffixSvgPath:
                        'assets/images/contractor/date_icon.svg',
                        onSuffixTap: () =>
                            controller.selectDate(context, controller.projectEndDateController),
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
                          onPressed: () => controller.showUploadOptions(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
                  () => controller.selectedImages.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Container(
                  height: 170,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.chatCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: controller.selectedImages.length > 6
                        ? 6
                        : controller.selectedImages.length,
                    itemBuilder: (context, index) {
                      if (index == 5 &&
                          controller.selectedImages.length > 6) {
                        return GestureDetector(
                          onTap: () =>
                              controller.showImageViewer(index),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(
                                      controller.selectedImages[index],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: Center(
                                  child: Text(
                                    '${controller.selectedImages.length - 5}+',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () => controller.showImageViewer(index),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(
                                    controller.selectedImages[index],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.chatCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      case 2:
        return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...controller.contractorControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controllers = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Contractor ${index + 1}',
                    style: h3.copyWith(
                        fontSize: 16, color: AppColors.textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contractor Name',
                    style: h3.copyWith(
                        fontSize: 14, color: AppColors.textColor8),
                  ),
                  CustomTextField(
                    labelText: 'Enter contractor/company name',
                    controller: controllers['name']!,
                  ),
                  Text(
                    'Phone Number',
                    style: h3.copyWith(
                        fontSize: 14, color: AppColors.textColor8),
                  ),
                  CustomTextField(
                    labelText: 'Enter phone number',
                    controller: controllers['phone']!,
                  ),
                  Text(
                    'Email Address',
                    style: h3.copyWith(
                        fontSize: 14, color: AppColors.textColor8),
                  ),
                  CustomTextField(
                    labelText: 'Enter email address',
                    controller: controllers['email']!,
                  ),
                  Text(
                    'License Number',
                    style: h3.copyWith(
                        fontSize: 14, color: AppColors.textColor8),
                  ),
                  CustomTextField(
                    labelText: 'Enter license number',
                    controller: controllers['license']!,
                  ),
                  Text(
                    'Additional Details',
                    style: h3.copyWith(
                        fontSize: 14, color: AppColors.textColor8),
                  ),
                  CustomTextField(
                    labelText: 'Write here....',
                    controller: controllers['details']!,
                    maxLine: 6,
                    radius: 10,
                  ),
                ],
              );
            }).toList(),
          ],
        ));
      case 25:
        return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ...controller.contractorControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controllers = entry.value;

              final titleStyle = h4.copyWith(
                fontSize: 16,
                color: AppColors.textColor2,
              );

              final valueStyle = h3.copyWith(
                fontSize: 16,
                color: AppColors.textColor,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controllers['name']?.text ?? 'Acme Construction INC.',
                          style: h3.copyWith(
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.removeContractor(index);
                          },
                          child: Text(
                            'Remove',
                            style: h3.copyWith(
                              fontSize: 16,
                              color: AppColors.clrRed4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Phone: ',
                          style: titleStyle,
                        ),
                        Text(
                          controllers['phone']?.text ?? '123-456-789',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Email: ',
                          style: titleStyle,
                        ),
                        Text(
                          controllers['email']?.text ?? 'company@acme@gmail.com',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'License: ',
                          style: titleStyle,
                        ),
                        Text(
                          controllers['license']?.text ?? '12354 892',
                          style: valueStyle,
                        ),
                      ],
                    ),
                    if (controllers['details']?.text.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Additional Details:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controllers['details']?.text ?? '',
                        style: valueStyle,
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
            if (controller.contractorControllers.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No contractors added yet',
                    style: h4.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor8,
                    ),
                  ),
                ),
              ),
          ],
        ));
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Permit Information',
                style: h3.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
            ),
            Text(
              'Permit Number',
              style: h3.copyWith(
                  fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter permit number',
              controller: controller.permitNumberController,
            ),
            Text(
              'Permit Type',
              style: h3.copyWith(
                  fontSize: 14, color: AppColors.textColor8),
            ),
            CustomTextField(
              labelText: 'Enter permit type',
              controller: controller.permitTypeController,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Issue Date',
                        style: h3.copyWith(
                            fontSize: 14, color: AppColors.textColor8),
                      ),
                      CustomTextField(
                        labelText: 'yyyy-mm-dd',
                        readOnly: true,
                        controller: controller.permitIssueDateController,
                        suffixSvgPath:
                        'assets/images/contractor/date_icon.svg',
                        onSuffixTap: () =>
                            controller.selectDate(context, controller.permitIssueDateController),
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
                        'Expiry Date',
                        style: h3.copyWith(
                            fontSize: 14, color: AppColors.textColor8),
                      ),
                      CustomTextField(
                        labelText: 'yyyy-mm-dd',
                        readOnly: true,
                        controller: controller.permitExpireDateController,
                        suffixSvgPath:
                        'assets/images/contractor/date_icon.svg',
                        onSuffixTap: () =>
                            controller.selectDate(context, controller.permitExpireDateController),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return Container();
    }
  }
}