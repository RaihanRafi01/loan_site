import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loan_site/common/appColors.dart';
import 'package:loan_site/common/customFont.dart';
import 'package:loan_site/common/widgets/customButton.dart';
import '../controllers/project_controller.dart';

// Model to represent a lender
class Lender {
  final String imageUrl;
  final String name;
  final int id; // Added ID field
  RxBool isChecked;

  Lender({required this.imageUrl, required this.name, required this.id, bool isChecked = false})
      : isChecked = isChecked.obs;
}

class SelectLenderController extends GetxController {
  RxList<Lender> lenders = <Lender>[].obs;
  RxInt selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    lenders.addAll([
      Lender(
        imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        name: 'Jack',
        id: 45, // Example ID
      ),
      Lender(
        imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
        name: 'Flores',
        id: 46,
      ),
      Lender(
        imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        name: 'Miles',
        id: 47,
      ),
      Lender(
        imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
        name: 'Arthur',
        id: 48,
      ),
      Lender(
        imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        name: 'Esther',
        id: 49,
      ),
    ]);
  }

  void selectLender(int index) {
    if (selectedIndex.value != -1) {
      lenders[selectedIndex.value].isChecked.value = false;
    }
    lenders[index].isChecked.value = true;
    selectedIndex.value = index;
  }

  void showConfirmationAndNavigate() {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        "Error",
        "Please select a lender before proceeding.",
        backgroundColor: AppColors.snackBarWarning,
        colorText: AppColors.textColor,
      );
      return;
    }

    // Pass the selected lender ID to ProjectController
    final projectController = Get.find<ProjectController>();
    projectController.setSelectedLenderId(lenders[selectedIndex.value].id);

    // Trigger project creation
    projectController.createProject().then((_) {
      // Show confirmation dialog after project creation
      Get.dialog(
        Dialog(
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
                const SizedBox(height: 10),
                Text(
                  'Your project has been created successfully!',
                  style: h4.copyWith(
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: 'OK',
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true, // Allow dismissing by tapping outside
      );
    }).catchError((e) {
      // Handle any errors during project creation
      Get.snackbar(
        'Error',
        'Failed to create project: $e',
        backgroundColor: AppColors.snackBarWarning,
        colorText: AppColors.textColor,
      );
    });
  }
}

class LenderHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final RxBool isChecked;
  final ValueChanged<bool?> onCheckChanged;

  const LenderHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isChecked,
    required this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                backgroundColor: imageUrl.isEmpty
                    ? AppColors.appColor2.withOpacity(0.2)
                    : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: 32, color: AppColors.appColor2)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: h2.copyWith(fontSize: 20, color: AppColors.textColor),
              ),
            ],
          ),
          Obx(
                () => Checkbox(
              value: isChecked.value,
              onChanged: onCheckChanged,
              activeColor: Colors.blue, // Checkbox color
              checkColor: Colors.white, // Checkmark color
            ),
          ),
        ],
      ),
    );
  }
}

class SelectLenderView extends GetView<SelectLenderController> {
  const SelectLenderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SelectLenderController());
    return Scaffold(
      backgroundColor: AppColors.appBc,
      appBar: AppBar(
        title: Text(
          'Select Your Lender',
          style: h2.copyWith(fontSize: 24, color: AppColors.textColor),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.appBc,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.cardSky,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                color: Colors.grey[600], size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search here',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                            () => Column(
                          children: List.generate(
                            controller.lenders.length,
                                (index) => LenderHeaderWidget(
                              imageUrl: controller.lenders[index].imageUrl,
                              title: controller.lenders[index].name,
                              isChecked: controller.lenders[index].isChecked,
                              onCheckChanged: (value) {
                                if (value == true) {
                                  controller.selectLender(index);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80), // Space for the button
                    ],
                  ),
                ),
              ),
            ),
            // Fixed Confirm Button at the bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                label: 'Confirm',
                onPressed: () {
                  controller.showConfirmationAndNavigate();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}